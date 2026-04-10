# Referaly (Flutter) — Project flow & structure

This document captures the current app structure and user-facing navigation flows, based on routing in
[`lib/get/get_routes.dart`](../lib/get/get_routes.dart) and the key controllers/services that navigate between screens.

## High-level architecture

- **Framework**: Flutter + GetX (`get`)
- **Routing**: Named routes via `GetMaterialApp(getPages: AppPages.pages)` in [`lib/main.dart`](../lib/main.dart)
- **State**:
  - Controllers extend `GetxController` (e.g. [`ControllerSplash`](../lib/controller/controller_splash.dart),
    [`ControllerLogin`](../lib/controller/controller_login.dart), [`ControllerMainProfessional`](../lib/controller/controller_main_professional.dart))
  - Persistent session + flags in [`AppPreference`](../lib/resources/app_preference.dart)
- **Backend API**: `RESTAuth.*` in [`lib/apis/rest_auth.dart`](../lib/apis/rest_auth.dart)
- **Key user model**: `ModelProfile.Data` in [`lib/models/model_profile.dart`](../lib/models/model_profile.dart)
  - Completion flags:
    - `isProfileCompleted` ⇐ `is_profile_completed` (bool or 1)
    - `isCompanyCompleted` ⇐ `is_company_completed` (bool or 1)
  - Account type:
    - `companyType` ⇐ `company_type` (e.g. `"individual"` / `"professional"`)
  - Premium:
    - `isPaid` ⇐ `is_paid` (int)

## App entrypoint & initial navigation

### `main()` → `MyApp` → `SplashScreen`

- App boots in [`lib/main.dart`](../lib/main.dart), creates `GetMaterialApp`.
- `home` is **`SplashScreen()`** (`lib/screens/splash.dart`).
- Named routes are registered via `AppPages.pages` in [`lib/get/get_routes.dart`](../lib/get/get_routes.dart).

### Splash controller (`ControllerSplash`)

Primary file: [`lib/controller/controller_splash.dart`](../lib/controller/controller_splash.dart)

Core responsibilities:

- **Version update check** via `RESTAuth.versionUpdate()` and forced update dialog (platform specific).
- **Branch deep links**:
  - Email verification link handling (og title `Sign In | Admin`) → calls `RESTAuth.verifyEmailToken()` and then navigates to `ScreenProfileType`.
  - Referral/deal links: if logged in with token and `send_lead_out != 1` then it preps `ControllerMainProfessional.handleDealId(...)` and navigates to `ScreenMain`.
  - Otherwise it stores pending deal context in `AppPreference` and navigates to `ScreenLogin`.
- **Standard init** (`_initializeApp()`):
  - If first run (`isFirstTime == 0`) → `ScreenInitialLanguage`
  - Else if logged in + has access token → `ScreenMain`
  - Else → `ScreenLogin`

## Auth + onboarding flows

### Login (email/password)

Primary controller: [`lib/controller/controller_login.dart`](../lib/controller/controller_login.dart)

- Calls `RESTAuth.login(...)`, stores:
  - `AppPreference.accessToken`
  - `AppPreference.isLoggedIn = 1`
  - `AppPreference.isPaid`
  - `AppPreference.productId`
- **Pending deep link flow**:
  - If `pending_deal_id` exists, it fetches `RESTAuth.getProfile()` and checks:
    - `data.isProfileCompleted == true`
    - `data.isCompanyCompleted == true`
  - If both completed:
    - Clears pending deal prefs
    - Calls `ControllerMainProfessional.handleDealId(...)`
    - Navigates to `ScreenMain` with `dealId` in arguments
  - If incomplete:
    - Navigates to `ReferralOnboardingWelcomeScreen` (keeps pending deal id)

### Registration (email/password)

Primary screen: [`lib/screens/auth/screen_registration.dart`](../lib/screens/auth/screen_registration.dart)

- Includes social login buttons, plus a full registration form.
- **Privacy policy UX** (important for plan):
  - The outer acceptance row navigates **in-app** to `WebViewScreen` via `Get.toNamed(WebViewScreen.pageId, ...)`
  - The underlined `privacyPolicy` link currently uses `launchUrl(..., externalApplication)` (no in-app back)

### Social login (Google/Facebook/Apple)

Primary service: [`lib/social_logins/google_sign_in_service.dart`](../lib/social_logins/google_sign_in_service.dart)

- On `RESTAuth.socialSignUpLogin(...)` success:
  - Saves session prefs (token, isPaid, productId)
  - Currently navigates to `CompleteProfileOnboardingScreen.pageId`

### Profile type selection

Primary screen/controller:

- [`lib/screens/auth/screen_profile_type.dart`](../lib/screens/auth/screen_profile_type.dart)
- [`lib/controller/controller_profile_type.dart`](../lib/controller/controller_profile_type.dart)

Behavior:

- Calls `RESTAuth.updateCompanyType(companyType: ...)`
- If pending deep link exists, it handles deal via `ControllerMainProfessional.handleDealId(...)`
- Navigates to `ScreenMain`

### Referral onboarding (mandatory info)

Registered screens in routes:

- `ReferralOnboardingWelcomeScreen` → [`lib/screens/onboarding/referral_onboarding_welcome_screen.dart`](../lib/screens/onboarding/referral_onboarding_welcome_screen.dart)
- `ReferralOnboardingPersonalScreen` → [`lib/screens/onboarding/referral_onboarding_personal_screen.dart`](../lib/screens/onboarding/referral_onboarding_personal_screen.dart)
- `ReferralOnboardingBusinessScreen` → [`lib/screens/onboarding/referral_onboarding_business_screen.dart`](../lib/screens/onboarding/referral_onboarding_business_screen.dart)

The login controller uses `ReferralOnboardingWelcomeScreen` when profile/company is incomplete *and* a pending deal exists.

## Main app shell flow

Primary screen: [`lib/screens/home/screen_main.dart`](../lib/screens/home/screen_main.dart)

- `ScreenMain` is a `GetView<ControllerMainProfessional>`.
- Tab index `pageIndex` determines which main section is shown:
  - index 0: chooses home UI based on `profile.data.companyType`:
    - `individual`/empty/null → `IndividualHome` (`lib/screens/dashboard/home_without_primum.dart`)
    - otherwise → `ProfessionalHome` (`lib/screens/home/professional_home.dart`)
  - index 1: `TrackLeadsScreen` (`lib/screens/dashboard/track_leads_screen.dart`)

## All registered routes (GetX pages)

Source: [`lib/get/get_routes.dart`](../lib/get/get_routes.dart)

### Auth & first-run

- `ScreenLogin.pageId` → `ScreenLogin` (`lib/screens/auth/login.dart`)
- `ScreenForgotPassword.pageId` → `ScreenForgotPassword` (`lib/screens/auth/forgot_password.dart`)
- `ScreenRegistration.pageId` → `ScreenRegistration` (`lib/screens/auth/screen_registration.dart`)
- `ScreenChooseLanguage.pageId` → `ScreenChooseLanguage` (`lib/screens/auth/screen_choose_language.dart`)
- `ScreenInitialLanguage.pageId` → `ScreenInitialLanguage` (`lib/screens/auth/screen_initial_language.dart`)
- `ScreenWelcome.pageId` → `ScreenWelcome` (`lib/screens/auth/screen_welcome.dart`)
- `ScreenVerification.pageId` → `ScreenVerification` (`lib/screens/auth/screen_verification.dart`)
- `ScreenCreateNewPassword.pageId` → `ScreenCreateNewPassword` (`lib/screens/auth/create_new_password.dart`)
- `ScreenPasswordChangedSuccess.pageId` → `ScreenPasswordChangedSuccess` (`lib/screens/auth/screen_password_changed_success.dart`)
- `ScreenProfileType.pageId` → `ScreenProfileType` (`lib/screens/auth/screen_profile_type.dart`)

### Main shell + core features

- `ScreenMain.pageId` → `ScreenMain` (`lib/screens/home/screen_main.dart`)
- `TrackLeadsScreen.pageId` → `TrackLeadsScreen` (`lib/screens/dashboard/track_leads_screen.dart`)
- `InvitedDealsScreen.pageId` → `InvitedDealsScreen` (`lib/screens/deals/invited_deals_screen.dart`)
- `BusinessReferrerContractScreen.pageId` → `BusinessReferrerContractScreen` (`lib/screens/deals/business_referrer_contract_screen.dart`)
- `OutOfReferalyScreen.pageId` → `OutOfReferalyScreen` (`lib/screens/deals/out_of_referaly_dialog.dart`)
- `ReferralTrackingScreen.pageId` → `ReferralTrackingScreen` (`lib/screens/deals/referral_tracking_screen.dart`)

### Profile & settings

- `EditProfileScreen.pageId` → `EditProfileScreen` (`lib/screens/edit_profile_screen.dart`)
- `EditCompanyProfileScreen.pageId` → `EditCompanyProfileScreen` (`lib/screens/company_profile/edit_company_profile.dart`)
- `CompanyProfileScreen.pageId` → `CompanyProfileScreen` (`lib/screens/profile/company_profile_screen.dart`)
- `/myProfile` → `MyProfileScreen` (`lib/screens/profile/my_profile_screen.dart`)
- `/newProfile` → `ProfileViewScreen` (`lib/screens/profile/profile_view_screen.dart`)
- `/membership` → `MembershipScreen` (`lib/screens/dashboard/membership_screen.dart`)

### Activity / stats / misc

- `ArchiveList.pageId` → `ArchiveList` (`lib/screens/archeive/archeive_list.dart`)
- `MyActivityScreen.pageId` → `MyActivityScreen` (`lib/screens/dashboard/my_activity_screen.dart`)
- `MyActivityInfoScreen.pageId` → `MyActivityInfoScreen` (`lib/screens/dashboard/my_activity_info_screen.dart`)
- `ActivityCategoryScreen.pageId` → `ActivityCategoryScreen` (`lib/screens/activity/activity_category_screen.dart`)
- `YourActivityScreen.pageId` → `YourActivityScreen` (`lib/screens/activity/your_activity_screen.dart`)
- `BusinessReferrerFeaturesScreen.pageId` → `BusinessReferrerFeaturesScreen` (`lib/screens/activity/business_referrer_features_screen.dart`)
- `SendLeadInfoScreen.pageId` → `SendLeadInfoScreen` (`lib/screens/activity/send_lead_info_screen.dart`)
- `ActiveGoalScreen.pageId` → `ActiveGoalScreen` (`lib/screens/active_goal_screen.dart`)
- `ReferrersScreen.pageId` → `ReferrersScreen` (`lib/screens/referrers_screen.dart`)
- `DetailedStatisticsScreen.pageId` → `DetailedStatisticsScreen` (`lib/screens/statistics/detailed_statistics_screen.dart`)
- `OverallStatisticsScreen.pageId` → `OverallStatisticsScreen` (`lib/screens/statistics/overall_statistics_screen.dart`)
- `FeedbacksScreen.pageId` → `FeedbacksScreen` (`lib/screens/feedbacks/feedbacks_screen.dart`)
- `SearchProfessionalsScreen.pageId` → `SearchProfessionalsScreen` (`lib/screens/search/search_professionals_screen.dart`)
- `SendNotificationScreen.pageId` → `SendNotificationScreen` (`lib/screens/send_notification_screen.dart`)
- `NotificationPermissionsScreen.pageId` → `NotificationPermissionsScreen` (`lib/screens/permissions/notification_permissions_screen.dart`)

### Story / onboarding extras

- `StoryScreen.pageId` → `StoryScreen` (`lib/screens/story/screen_story.dart`)
- `ScreenConnectedCard.pageId` → `ScreenConnectedCard` (`lib/screens/story/screen_connected_card.dart`)
- `OnboardingPager.pageId` → `OnboardingPager` (`lib/screens/onboarding/onboarding_story.dart`)
- `OnboardingBusinessNetworkScreen.pageId` → `OnboardingBusinessNetworkScreen` (`lib/screens/onboarding/onboarding_business_network.dart`)
- `OnboardingConsultationSuccessScreen.pageId` → `OnboardingConsultationSuccessScreen` (`lib/screens/onboarding/onboarding_consultation_success.dart`)
- `WelcomeFinderScreen.pageId` → `WelcomeFinderScreen` (`lib/screens/onboarding/welcome_finder_screen.dart`)
- `CompleteProfileScreen.pageId` → `CompleteProfileScreen` (`lib/screens/onboarding/complete_profile_screen.dart`)
- `CompleteProfileOnboardingScreen.pageId` → `CompleteProfileOnboardingScreen` (`lib/screens/onboarding/complete_profile_onboarding_screen.dart`)
- `ReferralOnboardingWelcomeScreen.pageId` → `ReferralOnboardingWelcomeScreen` (`lib/screens/onboarding/referral_onboarding_welcome_screen.dart`)
- `ReferralOnboardingPersonalScreen.pageId` → `ReferralOnboardingPersonalScreen` (`lib/screens/onboarding/referral_onboarding_personal_screen.dart`)
- `ReferralOnboardingBusinessScreen.pageId` → `ReferralOnboardingBusinessScreen` (`lib/screens/onboarding/referral_onboarding_business_screen.dart`)
- `SelectJobsScreen.pageId` → `SelectJobsScreen` (`lib/screens/onboarding/select_jobs_screen.dart`)

### WebView / documents / lead submission

- `WebViewScreen.pageId` → `WebViewScreen` (`lib/screens/webview/webview_screen.dart`)
- `DocumentScreen.pageId` → `DocumentScreen` (`lib/screens/document_screen.dart`)
- `LeadSubmissionScreen.pageId` → `LeadSubmissionScreen` (`lib/screens/lead_submission_screen.dart`)
- `AddLeadSourceScreen.pageId` → `AddLeadSourceScreen` (`lib/screens/dashboard/add_lead_source_screen.dart`)
- `AddBusinessReferrerScreen.pageId` → `AddBusinessReferrerScreen` (`lib/screens/dashboard/add_business_referrer_screen.dart`)

## `lib/changes_3/` reference set (implementation prototypes)

The `lib/changes_3/` folder contains draft/alternative implementations for the premium/profile gate work, including:

- `profile_gate.dart`
- `controller_splash.dart`
- `controller_main_professional.dart`
- `in_app_purchase_service.dart`
- `screen_registration.dart`
- `edit_profile_screen.dart`
- `referral_onboarding_*_screen.dart`
- `login.dart`
- plus localized strings under `languages/`

When implementing the requested plan, treat these as the **reference** for file selection and intended behavior, but reconcile with the active production files under `lib/`.

