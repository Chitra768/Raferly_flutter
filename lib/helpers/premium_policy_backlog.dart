// Premium / free-tier policy — items not fully enforceable in Flutter alone.
//
// In-app premium flag: [PremiumHelper] — `role_names` includes `agency-user` or
// `independent-user`, or legacy `is_paid != 0` when roles do not grant premium.
//
// Backend or product TBD
// - Lead email notifications: after 5 received leads on free tier, API/mailer should
//   suppress full lead detail emails (app blurs leads after index 5 in track leads).
// - Paying commissions only inside Referaly vs “outside the app” — payment rails /
//   enforcement on server.
// - “Agency features” vs `subscription_type` vs `agency-user` role — confirm whether
//   agency-only APIs require subscription_type `agency` in addition to roles.
// - Referral agreement limit (“create 1”) — enforce count server-side; optionally show
//   remaining count in UI.
// - Tracking comments on free tier — identify route/widget when product defines it.
