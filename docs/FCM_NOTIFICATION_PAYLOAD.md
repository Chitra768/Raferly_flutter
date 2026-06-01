# FCM notification `data` payload (mobile)

All values in the FCM **`data`** map must be **strings** (e.g. `"123"`, not `123`).

The app routes on tap using `data.type` (case-insensitive). Title/body localization is handled by the backend in the `notification` block.

## Routing summary

| `type` | Screen | Required `data` fields |
|--------|--------|------------------------|
| `LEAD_RECEIVE` | Track → Leads received | — |
| `LEAD_RECOVERED_NOTIFICATION` | Track → Leads received | `lead_id` recommended |
| `REQUEST_TO_UPDATE_LEAD` | Track → Leads received + expand row | **`lead_id`** required |
| `LEAD_COMMENT_UPDATE_NOTIFICATION` | Track → Leads sent | `lead_id` recommended |
| `LEAD_NEXT_STEP_NOTIFICATION` | Track → Leads sent | `lead_id` recommended |
| `LEAD_COMMENT_NOTIFICATION` | Track → Leads sent | `lead_id` recommended |
| `LEAD_DELETE_NOTIFICATION` | Archive (sent) | — |
| `LEAD_COMPLETED_NOTIFICATION` | Archive (sent) | — |
| `LEAD_COMMISSION_NOTIFICATION` | Archive (sent) | — |
| `DEAL_ACCEPT_OUT_OF_REFERALY` | I am a referrer (`/invitedDeals`) | use **`deal_id`**, not `lead_id` |
| `DEAL_UPDATE` | I am a referrer | `deal_id` optional |
| `DEAL_DOCUMENT_UPLOADED` | I am a referrer | `deal_id` optional |
| `DEAL_ACCEPT` | My Network (My Activity tab 1) | **`deal_id`** for deal filter |
| `DEAL_LEAVE` | My Network | **`deal_id`** for deal filter |
| `FINDER_REQUEST_NOTIFICATION` | Referaly Finder (matchmaking tab) | `finder_request_id` optional (v1: opens tab only) |
| `FINDER_REQUEST_ACCEPTED` | Referaly Finder | `finder_request_id` optional |
| `DEAL_CREATE` | — | Do not send FCM (in-app only) |
| `YOU_DEAL_ACCEPT` | — | No navigation on tap |

## Example payloads

```json
{
  "type": "LEAD_RECEIVE",
  "lead_id": "123",
  "deal_id": "456"
}
```

```json
{
  "type": "REQUEST_TO_UPDATE_LEAD",
  "lead_id": "123"
}
```

```json
{
  "type": "DEAL_ACCEPT",
  "deal_id": "456"
}
```

```json
{
  "type": "FINDER_REQUEST_NOTIFICATION",
  "finder_request_id": "789"
}
```

## Backend fixes

1. **`DEAL_ACCEPT_OUT_OF_REFERALY`**: send `deal_id`, not `lead_id`.
2. **`DEAL_CREATE`**: do not push; save to DB only.
3. **`YOU_DEAL_ACCEPT`**: optional payload; app does not navigate on tap.
4. Ensure every key in `data` is a string.

## Legacy types (still supported)

| `type` | Maps to |
|--------|---------|
| `lead_received` | Leads received tab |
| `lead_sent` | Leads sent tab |
