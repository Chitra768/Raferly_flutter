# Referaly Mobile API — Agency Account, Team Members & Colleague Access

API backend: **referaly-admin** (`routes/api.php`).  
This document is for mobile developers implementing the same behaviour as the web app.

---

## Base URL & authentication

| Item | Value |
|------|--------|
| Base URL | `{API_HOST}/api/` (e.g. `https://api.referaly.com/api/`) |
| Auth | JWT Bearer token from login |
| Header | `Authorization: Bearer {access_token}` |
| Language | `App-Language: en` \| `fr` \| `es` (recommended on all authenticated calls) |
| Middleware (authenticated group) | `auth:api`, `IsActive`, `agency.context` |

---

## Standard response envelope

All JSON responses use the same shape:

```json
{
  "code": 200,
  "status": true,
  "message": "Human-readable message",
  "data": {},
  "pagination": {},
  "errors": "optional — string or object on failure"
}
```

| Field | Type | Notes |
|-------|------|--------|
| `code` | int | HTTP-style status (200, 403, 404, 422, etc.) |
| `status` | bool | `true` = success, `false` = failure |
| `message` | string | Localized success/error summary |
| `data` | mixed | Payload (object, array, or empty on some successes) |
| `pagination` | object | Present on paginated list endpoints |
| `errors` | mixed | Validation details or error code string |

---

## Account types (mobile UI logic)

| Role | Who | `can_manage_team` | Data scope |
|------|-----|-------------------|------------|
| **Agency owner** | Pays for Agency plan (`agency-user`, `is_paid = 3`, or `subscription_type = agency`) | `true` | Own user id |
| **Agency colleague** | Invited as `member_type: agency` | `false` | **Owner’s** data (`agency_owner_id` set; API uses acting owner) |
| **Independent colleague** | Invited as `member_type: independent` | `false` | **Own** data; subscription sponsored (`is_paid = 2`) |
| **Regular user** | Not in team | `false` | Own data |

### Header label (mobile)

| Condition | Suggested label |
|-----------|-----------------|
| `is_agency_colleague === true` | Agency Colleague |
| `is_independent_colleague === true` | Independent Colleague |
| `subscription_type === 'agency'` | Agency |
| `subscription_type === 'independent'` | Independent |
| else / free | Free |

---

## Login & profile — colleague flags

Returned on **`POST /api/login`** and **`GET /api/my-profile`** inside `data.user` (via `UserResource`).

### Login request

**`POST /api/login`**

```json
{
  "email": "colleague@example.com",
  "password": "secret123"
}
```

Optional (existing app behaviour): `device_type`, `device_id`, `fcm_token`, header `appData`.

### Login success response (excerpt)

```json
{
  "code": 200,
  "status": true,
  "message": "Successful login",
  "data": {
    "access_token": "eyJ0eXAiOiJKV1QiLCJhbGc...",
    "user": {
      "id": 42,
      "first_name": "Vedant",
      "last_name": "Shah",
      "email": "colleague@example.com",
      "agency_owner_id": 10,
      "is_paid": 0,
      "subscription_type": null,
      "company_type": "professional",
      "role_names": ["user", "agency-colleague"],

      "is_agency_colleague": true,
      "is_independent_colleague": false,
      "can_manage_team": false,
      "content_access": {
        "business_referrers": { "visibility": true, "edition": false },
        "leads_sent": { "visibility": true, "edition": true },
        "leads_received": { "visibility": true, "edition": false },
        "referral_contracts": { "visibility": true, "edition": false },
        "i_am_referrer": true
      },
      "sponsoring_agency_owner_id": 10,
      "subscription_sponsored_by_agency": false
    }
  },
  "pagination": []
}
```

### Independent colleague user excerpt

```json
{
  "is_agency_colleague": false,
  "is_independent_colleague": true,
  "can_manage_team": false,
  "agency_owner_id": null,
  "content_access": null,
  "sponsoring_agency_owner_id": 15,
  "subscription_sponsored_by_agency": true,
  "subscription_type": "independent",
  "is_paid": 2
}
```

### Agency owner user excerpt

```json
{
  "is_agency_colleague": false,
  "is_independent_colleague": false,
  "can_manage_team": true,
  "agency_owner_id": null,
  "content_access": null
}
```

**Mobile:** Persist `content_access` and colleague flags after login; refresh on `GET /api/my-profile` when owner changes permissions.

---

## `content_access` model (agency colleagues only)

Each module (except *I am a Referrer*) has:

| Field | Type | Meaning |
|-------|------|---------|
| `visibility` | bool | Can view lists / read data |
| `edition` | bool | Can create, update, delete, track steps |

| Key | Product area |
|-----|----------------|
| `business_referrers` | My Network, business referrers, search |
| `leads_sent` | Leads sent by the business |
| `leads_received` | Leads received from referrers |
| `referral_contracts` | My Deals / referral contracts |
| `i_am_referrer` | bool — deals accepted as referrer (`deal/accept`, `acceptList`, etc.) |

### Default values (new agency colleague)

```json
{
  "business_referrers": { "visibility": true, "edition": false },
  "leads_sent": { "visibility": true, "edition": true },
  "leads_received": { "visibility": true, "edition": false },
  "referral_contracts": { "visibility": true, "edition": false },
  "i_am_referrer": true
}
```

### Client-side permission helper (mirror API)

```text
can(permission, mode):
  if NOT is_agency_colleague → true
  if is_independent_colleague → true
  if content_access empty → false

  business_referrers / my_network → content_access.business_referrers[mode]
  leads_sent → content_access.leads_sent[mode]
  leads_received → content_access.leads_received[mode]
  leads → leads_sent OR leads_received (mode)
  referral_contracts → content_access.referral_contracts[mode]
  i_am_referrer → content_access.i_am_referrer (boolean)
  team_management → false
```

`mode` = `"visibility"` | `"edition"`.

---

## Agency colleague — existing API behaviour

- Colleague calls APIs with **their** JWT.
- Server resolves **acting user** to the **agency owner** for deals/leads/dashboard counts.
- Routes with middleware `agency.access:{permission},{mode}` return **403** if not allowed.
- `errors` / message often: `"You do not have permission to access this feature."` (`agency_colleague_access_denied`).

### Permission → example routes

| Permission | Mode | Example endpoints |
|------------|------|-------------------|
| `referral_contracts` | visibility | `GET deal/dealist`, `GET deal/detail`, `GET deal/list` |
| `referral_contracts` | edition | `POST deal/create`, `POST deal/update`, `POST deal/delete` |
| `business_referrers` | visibility | `GET deal/networks`, `POST deal/referrers`, `POST search` |
| `business_referrers` | edition | `POST deal/deleteNetwork`, `POST addBusinessReferrer` |
| `leads_sent` | visibility | `GET lead/sentLead`, `GET lead/list` |
| `leads_sent` | edition | `POST lead/create`, `POST lead/createSendOutLead` |
| `leads_received` | visibility | `GET lead/receivedLead`, `GET lead/archivedLead` |
| `leads` | visibility / edition | `GET lead/detail`, `POST lead/update`, `POST lead/trackStep` (either stream) |
| `i_am_referrer` | visibility | `GET deal/acceptList`, `GET deal/invitedList`, `POST deal/accept` |
| — | — | `GET dashboard` — metrics zeroed/hidden per permission |

### Team management blocked for colleagues

Middleware `agency.owner` on all `deal/teamMembers/*` routes → **403** with `agency_colleague_cannot_manage_team`.

---

## Team management APIs (agency owner only)

Requires **`can_manage_team === true`** (agency subscription owner).  
Prefix: **`/api/deal/teamMembers`**

---

### 1. List team members

**`GET /api/deal/teamMembers`**

**Auth:** Bearer (agency owner)

**Response `data`:** array of members

```json
[
  {
    "id": 3,
    "user_id": 42,
    "full_name": "Vedant Shah",
    "first_name": "Vedant",
    "last_name": "Shah",
    "email": "vedant@example.com",
    "phone_number": "+33600000000",
    "avatar_url": "https://...",
    "member_type": "agency",
    "status": "active",
    "created_at": "2026-05-20T10:00:00+00:00"
  }
]
```

| `member_type` | Values |
|---------------|--------|
| `agency` | Shared workspace colleague |
| `independent` | Own account, agency-sponsored |

| `status` | Values |
|----------|--------|
| `pending` | Invited, not yet active |
| `active` | Accepted |

**Errors**

| HTTP | `errors` / condition |
|------|---------------------|
| 403 | `agency_subscription_required` — not agency owner |

---

### 2. Invite colleague

**`POST /api/deal/teamMembers/invite`**

**Request body**

```json
{
  "first_name": "Vedant",
  "last_name": "Shah",
  "email": "vedant@example.com",
  "phone_number": "+33600000000",
  "position": "Sales Manager",
  "city": "Paris",
  "member_type": "agency"
}
```

| Field | Required | Rules |
|-------|----------|--------|
| `first_name` | yes | string, max 255 |
| `last_name` | yes | string, max 255 |
| `email` | yes | valid email |
| `phone_number` | no | string, max 50 |
| `position` | no | string, max 255 |
| `city` | no | string, max 255 |
| `member_type` | yes | `agency` \| `independent` |

**Success response**

```json
{
  "code": 200,
  "status": true,
  "message": "Invitation sent successfully",
  "data": []
}
```

**Error responses**

| HTTP | Runtime code | Meaning |
|------|----------------|---------|
| 403 | `agency_subscription_required` | Caller is not agency owner |
| 409 | `colleague_already_invited` | Email already invited (pending/active) |
| 422 | `cannot_invite_self` | Owner’s own email |
| 409 | `colleague_belongs_to_another_agency` | User tied to another agency |
| 422 | validation | Missing/invalid fields in `errors` object |

---

### 3. Get agency colleague settings

**`GET /api/deal/teamMembers/{id}/settings`**

Only for **`member_type = agency`**.

**Response `data`**

```json
{
  "id": 3,
  "user_id": 42,
  "full_name": "Vedant Shah",
  "email": "vedant@example.com",
  "avatar_url": "https://...",
  "member_type": "agency",
  "collaboration_label": "Agency Collaboration",
  "content_access": {
    "business_referrers": { "visibility": true, "edition": false },
    "leads_sent": { "visibility": true, "edition": true },
    "leads_received": { "visibility": true, "edition": false },
    "referral_contracts": { "visibility": true, "edition": false },
    "i_am_referrer": true
  },
  "can_switch_to_independent": true
}
```

**Errors:** 404 `team_member_not_found`, 422 `team_member_not_agency_colleague`

---

### 4. Update agency colleague settings

**`PUT /api/deal/teamMembers/{id}/settings`**

#### A) Update content access only

```json
{
  "content_access": {
    "business_referrers": { "visibility": true, "edition": false },
    "leads_sent": { "visibility": false, "edition": false },
    "leads_received": { "visibility": true, "edition": false },
    "referral_contracts": { "visibility": true, "edition": false },
    "i_am_referrer": false
  }
}
```

`content_access` is **required** unless switching to independent.

#### B) Switch agency → independent

```json
{
  "switch_to_independent": true,
  "success_url": "https://app.referaly.fr/team-management/independent-seat/success?session_id={CHECKOUT_SESSION_ID}",
  "cancel_url": "https://app.referaly.fr/team-management",
  "notify_owner_by_email": true
}
```

No `content_access` required when `switch_to_independent` is `true`. The
client always attaches the Stripe checkout `success_url` / `cancel_url` and
sets `notify_owner_by_email: true` so the owner receives an email
confirmation.

**Success:** same shape as **Get settings**; message varies (`settings saved` / `switched to independent`).

---

### 5. Independent colleague profile (owner read-only)

**`GET /api/deal/teamMembers/{id}/profile`**

Only for **`member_type = independent`**.

**Response `data`**

```json
{
  "id": 4,
  "user_id": 55,
  "full_name": "Jane Doe",
  "email": "jane@example.com",
  "avatar_url": "https://...",
  "member_type": "independent",
  "collaboration_label": "Independent Account",
  "about": "Localized description string",
  "performance": {
    "total_leads": 12,
    "pending_leads": 3,
    "successful_leads": 7,
    "lost_leads": 2,
    "business_referrers": 5,
    "referral_contracts": 2,
    "conversion_rate": 77.8,
    "total_turnover_generated": 15000,
    "total_commission_paid": 1200,
    "total_net_income": 13800
  },
  "can_switch_to_agency": true
}
```

---

### 6. Switch independent → agency

**`POST /api/deal/teamMembers/{id}/switch_to_agency`**

**Request body**

```json
{
  "confirm": true
}
```

`confirm` must be boolean `true` (Laravel `accepted` rule).

**Success `data`:** same as **Get settings** (member becomes agency with default `content_access`).

---

### 7. Independent colleague content (owner read-only)

**`GET /api/deal/teamMembers/{id}/content`**

**Query parameters**

| Param | Default | Values |
|-------|---------|--------|
| `tab` | `leads` | `leads`, `contracts`, `referrers` |
| `page` | `1` | int ≥ 1 |
| `limit` | `20` | int 1–100 |

**Response `data`**

```json
{
  "member_name": "Jane Doe",
  "member_email": "jane@example.com",
  "avatar_url": "https://...",
  "summary": {
    "leads_count": 12,
    "contracts_count": 2,
    "referrers_count": 5
  },
  "tab": "leads",
  "items": [
    {
      "id": 101,
      "type": "lead",
      "title": "John Smith",
      "subtitle": "DEAL NAME",
      "status": "Pending",
      "logo_url": null,
      "deal_id": 8
    }
  ],
  "pagination": {
    "current_page": 1,
    "last_page": 1,
    "per_page": 20,
    "total": 3
  }
}
```

**Item `type` values:** `lead` | `contract` | `referrer`  
**Lead `status`:** `Pending` | `Success` | `Lost`

Top-level response also includes `pagination` duplicated at root (API convention).

---

## Dashboard (agency colleague)

**`GET /api/dashboard`**

For agency colleagues, numeric fields are **filtered** when access is off, for example:

| Denied permission | Zeroed / cleared fields |
|-------------------|-------------------------|
| `referral_contracts` | `my_deals`, `activeDeals`, `dealDocuments` |
| `leads` | `total_leads`, sent/received counts, income fields, tracking notifications |
| `business_referrers` | `number_of_partner`, referrer notifications |
| `i_am_referrer` | `invited_deals_count`, my-activity notifications |

Regular users and owners receive full metrics (unchanged).

---

## Mobile implementation checklist

1. After login, read `is_agency_colleague`, `is_independent_colleague`, `can_manage_team`, `content_access`.
2. Show **Team Management** only if `can_manage_team === true`.
3. For agency colleagues, hide menu items using `content_access` (same keys as web).
4. On **403** with access denied message, show “You don’t have permission” and do not retry blindly.
5. Do not call `deal/teamMembers/*` as a colleague — always 403.
6. Independent colleagues use normal APIs on **their** account; no `content_access` restrictions.
7. Refresh profile after owner may have changed settings (`GET my-profile`).

---

## Related source files (backend)

| File | Purpose |
|------|---------|
| `routes/api.php` | Route definitions & middleware |
| `app/Http/Controllers/API/TeamMemberController.php` | Team endpoints |
| `app/Services/TeamMemberService.php` | Business logic & payloads |
| `app/Services/AgencyColleagueAccessService.php` | Permission checks |
| `app/Support/TeamMemberContentAccess.php` | Defaults & normalization |
| `app/Http/Resources/UserResource.php` | Login/profile colleague fields |

---

*Document version: 2026-05-21 — matches referaly-admin team member & agency colleague implementation.*
