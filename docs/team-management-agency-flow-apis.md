# Team management — API reference (agency & independent flow)

This document describes the **REST endpoints** the Referaly Flutter app uses for the **team management** feature (hub, co-user settings, independent profile, member content tabs, invite colleague, switch collaboration mode).

> **Base URL** is defined in `lib/apis/api_path.dart` as `ApiPath.baseUrl` (e.g. development: `https://refearly-back.developmentlabs.co/api/`). All paths below are **relative** to that base (no leading slash in code concatenation).

---

## Client data layer

| Concern | Location |
|---------|----------|
| HTTP | `lib/apis/rest_team_management.dart` (`RESTTeamManagement`) |
| Models | `lib/models/model_team_member.dart`, `lib/models/model_team_member_invite.dart` |
| Controllers | Call `RESTTeamManagement.*()` and handle `ApiSuccess` / `ApiFailure` (same pattern as `RESTAuth`) |

---

## App routing (agency vs independent)

After **list team members** (`GET deal/teamMembers`), each row’s `member_type` drives navigation:

| `member_type` (string, case-insensitive) | Typical UI flow |
|----------------------------------------|-----------------|
| `agency` (or contains `agency`) | **Co-user settings** — shared visibility toggles for agency colleague. |
| `independent` (or contains `independent`) | **Member profile** → **Member content** (Leads / Contracts / Referrers tabs). |

Invite flow sends `member_type`: **`agency`** or **`independent`** (`add_colleague_controller.dart`).

---

## Authentication

All calls use the same authenticated headers as the rest of the app: `RESTAuth` → `getHeaderWithToken()` on `GET`/`POST`/`PUT`. JSON bodies set `Content-Type: application/json`.

---

## 1. List team members

| | |
|--|--|
| **Method** | `GET` |
| **Path** | `deal/teamMembers` |
| **Constant** | `ApiPath.getTeamMembers` |
| **Client** | `RESTTeamManagement.getTeamMembers()` |

**Success:** HTTP `200`, body decoded as `TeamMemberListModel`.

**Example response:**

```json
{
  "code": 200,
  "status": true,
  "message": "Team members fetched successfully",
  "data": {
    "members": [
      {
        "id": 4,
        "user_id": 1968,
        "full_name": "Vedant Rathavi",
        "email": "vedant@test.com",
        "phone_number": "123132132",
        "avatar_url": "https://...",
        "member_type": "agency",
        "status": "active",
        "created_at": "2026-05-20T09:24:53+00:00"
      }
    ],
    "billing": {
      "max_agency_colleagues": 10,
      "agency_colleagues_count": 0,
      "agency_colleagues_remaining": 10,
      "independent_colleagues_count": 0,
      "independent_colleagues_suspended": 1,
      "independent_seats_subscription_status": "canceled",
      "independent_seats_payment_issue": true,
      "independent_seat_plan_id": 9,
      "independent_seat_amount": 29.9,
      "independent_seat_currency": "eur",
      "independent_monthly_total": 0,
      "independent_seat_requires_web_checkout": true,
      "web_checkout_base_url": "https://referaly-app.developmentlabs.co/team-management"
    }
  },
  "pagination": []
}
```

**Client parsing:**

| Dart | Source |
|------|--------|
| `TeamMemberListModel.members` | `data.members[]` → `TeamMemberData` |
| `TeamMemberListModel.billing` | `data.billing` → `TeamMemberBilling` |
| `TeamManagementController.billing` | Exposed after `loadTeamMembers()` for UI (seat limits, payment issue, checkout URL) |

`TeamMemberData` fields: `id`, `user_id`, `full_name`, `email`, `phone_number`, `avatar_url`, `member_type`, `status`, `created_at` (plus flexible aliases in `fromJson`). Legacy flat `data: [...]` array is still parsed if returned.

---

## 2. Get co-user settings (agency colleague)

| | |
|--|--|
| **Method** | `GET` |
| **Path** | `deal/teamMembers/{id}/settings` |
| **Constant** | `ApiPath.teamMemberSettings(memberId)` |
| **Client** | `RESTTeamManagement.getTeamMemberSettings(memberId)` |

**Success:** HTTP `200`, `TeamMemberSettingsResponse` with `data` containing:

- `id`, `user_id`, `full_name`, `email`, `avatar_url`, `member_type`, `collaboration_label`
- `content_access` — see **Content access JSON** below
- `can_switch_to_independent` — boolean

**Example `content_access` from BE:**

```json
{
  "business_referrers": { "visibility": true, "edition": false },
  "leads_sent": { "visibility": true, "edition": true },
  "leads_received": { "visibility": true, "edition": false },
  "referral_contracts": { "visibility": true, "edition": false },
  "i_am_referrer": true
}
```

**Note:** The app also sends/reads `my_network` on PUT; it is not always present in BE GET samples (defaults to visible when absent).

---

## 3. Save co-user settings (agency)

| | |
|--|--|
| **Method** | `PUT` |
| **Path** | `deal/teamMembers/{id}/settings` |
| **Constant** | `ApiPath.teamMemberSettings(memberId)` |
| **Client** | `RESTTeamManagement.saveTeamMemberSettings(...)` |

**Request body (permissions save):**

```json
{
  "content_access": {
    "business_referrers": { "visibility": false, "edition": false },
    "leads_sent": { "visibility": false, "edition": false },
    "leads_received": { "visibility": false, "edition": false },
    "referral_contracts": { "visibility": false, "edition": false },
    "my_network": true,
    "i_am_referrer": true
  },
  "switch_to_independent": false
}
```

**Request body (switch to independent only):**

```json
{
  "switch_to_independent": true,
  "success_url": "https://app.referaly.fr/team-management/independent-seat/success?session_id={CHECKOUT_SESSION_ID}",
  "cancel_url": "https://app.referaly.fr/team-management",
  "notify_owner_by_email": true
}
```

When `switch_to_independent` is `true`, the client:

- **omits** `content_access`,
- attaches the Stripe checkout redirects (`RESTTeamManagement.teamSeatSuccessUrl` / `teamSeatCancelUrl`), and
- requests an email confirmation to the owner via `notify_owner_by_email: true`.

**Success:** HTTP `200`, parsed as `TeamMemberSettingsResponse` (full `data` object returned; UI syncs from server after save).

---

## 4. Get independent member profile

| | |
|--|--|
| **Method** | `GET` |
| **Path** | `deal/teamMembers/{id}/profile` |
| **Constant** | `ApiPath.teamMemberProfile(memberId)` |
| **Client** | `RESTTeamManagement.getTeamMemberProfile(memberId)` |

**Success:** HTTP `200`, `TeamMemberProfileResponse`.

**Key fields:**

- `about` — independent account description (client also accepts `about_independent` alias)
- `performance` — KPIs including `total_turnover_generated`, `pending_leads`, `successful_leads`, etc.
- `can_switch_to_agency` — boolean

---

## 5. Switch member to agency collaboration

| | |
|--|--|
| **Method** | `POST` |
| **Path** | `deal/teamMembers/{id}/switch-to-agency` |
| **Constant** | `ApiPath.teamMemberSwitchToAgency(memberId)` |
| **Client** | `RESTTeamManagement.switchTeamMemberToAgency(memberId)` |

**Request body:**

```json
{ "confirm": true }
```

**Success:** HTTP `200`, optional `message` in response map.

---

## 6. Get member content (tabs: Leads / Contracts / Referrers)

| | |
|--|--|
| **Method** | `GET` |
| **Path** | `deal/teamMembers/{id}/content` |
| **Constant** | `ApiPath.teamMemberContent(memberId)` |
| **Client** | `RESTTeamManagement.getTeamMemberContent(memberId, tab, page, limit)` |

**Query parameters:**

| Parameter | Values |
|-----------|--------|
| `tab` | `leads` \| `contracts` \| `referrers` |
| `page` | integer, default `1` |
| `limit` | integer, default `20` |

Example: `deal/teamMembers/5/content?tab=leads&page=1&limit=20`

**Success:** HTTP `200`, `TeamMemberContentResponse` → `data` with `member_name`, `member_email`, `avatar_url`, `summary`, `tab`, `items`, and nested `pagination`.

---

## 7. Invite colleague (agency or independent)

| | |
|--|--|
| **Method** | `POST` |
| **Path** | `deal/teamMembers/invite` |
| **Constant** | `ApiPath.teamMembersInvite` |
| **Client** | `RESTTeamManagement.inviteTeamMember(TeamMemberInviteRequest)` |

**Request body (agency colleague):**

```json
{
  "first_name": "Charlie",
  "last_name": "Brown",
  "email": "charlie@agency.com",
  "phone_number": "+447700900333",
  "position": "Sales Manager",
  "job_id": "12",
  "city": "London",
  "member_type": "agency"
}
```

**Request body (independent colleague — team seat checkout):**

```json
{
  "first_name": "Charlie",
  "last_name": "Brown",
  "email": "charlie@agency.com",
  "phone_number": "+447700900333",
  "city": "London",
  "member_type": "independent",
  "success_url": "myapp://team-seat-success?session_id={CHECKOUT_SESSION_ID}",
  "cancel_url": "myapp://team-seat-cancel",
  "notify_owner_by_email": true
}
```

| JSON key | Dart field (`TeamMemberInviteRequest`) | When sent |
|----------|----------------------------------------|-----------|
| `first_name` | `firstName` | always |
| `last_name` | `lastName` | always |
| `email` | `email` | always |
| `phone_number` | `phone` | always |
| `position` | `jobTitle` | agency (from job picker title) |
| `job_id` | `jobId` | agency (from job picker) |
| `city` | `city` | always |
| `member_type` | `memberType` (`agency` \| `independent`) | always |
| `success_url` | `successUrl` | independent |
| `cancel_url` | `cancelUrl` | independent |
| `notify_owner_by_email` | `notifyOwnerByEmail` | independent (`true`) |

**Success:** HTTP `200`, optional `message`.

---

## Content access JSON (GET settings / PUT body)

```json
{
  "business_referrers": { "visibility": true, "edition": false },
  "leads_sent": { "visibility": true, "edition": true },
  "leads_received": { "visibility": true, "edition": false },
  "referral_contracts": { "visibility": false, "edition": false },
  "my_network": true,
  "i_am_referrer": true
}
```

**GET parsing:** `TeamMemberContentAccess.fromJson` supports flat keys, nested `leads.sent` / `leads.received`, and camelCase aliases.

---

## HTTP errors

Shared pattern in `RESTTeamManagement`:

- **422** → `ApiFailure` with `ModelError.fromJson(decodedResult)`
- **Other non-200** → failure with `decodedResult['message']` or generic copy
- **No network** → failure before HTTP

---

## Source file map

| Concern | File |
|---------|------|
| Path strings | `lib/apis/api_path.dart` |
| HTTP implementation | `lib/apis/rest_team_management.dart` |
| Models / DTOs | `lib/models/model_team_member.dart`, `lib/models/model_team_member_invite.dart` |
| Controllers | `lib/controller/team_management_controller.dart`, `co_user_settings_controller.dart`, `add_colleague_controller.dart`, `team_member_profile_controller.dart`, `team_member_content_controller.dart` |

---

## Endpoint summary (UI mapping)

| Endpoint | Primary use in current UI |
|----------|---------------------------|
| List members | Hub for everyone |
| Settings GET/PUT | **Agency** co-user |
| Profile GET | **Independent** member |
| Content GET | **Independent** member tabs |
| Switch to agency POST | **Independent** → agency |
| Invite POST | Add **agency** or **independent** colleague |
