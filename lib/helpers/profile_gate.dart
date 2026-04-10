import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:referaly/apis/api_result.dart';
import 'package:referaly/apis/rest_auth.dart';
import 'package:referaly/helpers/premium_helper.dart';
import 'package:referaly/models/model_profile.dart';
import 'package:referaly/resources/app_preference.dart';
import 'package:referaly/screens/home/screen_main.dart';
import 'package:referaly/screens/onboarding/referral_onboarding_business_screen.dart';
import 'package:referaly/screens/onboarding/referral_onboarding_personal_screen.dart';
import 'package:referaly/screens/onboarding/referral_onboarding_welcome_screen.dart';

/// Premium users must complete personal + company profile before using the app.
/// Also forces `company_type` to professional when the user is premium but still individual.
class ProfileGate {
  ProfileGate._();

  static const String _onboardingRoutePrefix = '/referralOnboarding';

  static bool _isBlank(String? v) => v == null || v.trim().isEmpty;

  static bool _isPersonalInfoMissing(Data d) {
    return _isBlank(d.firstName) ||
        _isBlank(d.lastName) ||
        _isBlank(d.email) ||
        _isBlank(d.phoneNumber) ||
        _isBlank(d.city);
  }

  static bool _isCompanyInfoMissing(Data d) {
    return _isBlank(d.companyName) ||
        _isBlank(d.companyDescription) ||
        _isBlank(d.companyAddress);
  }

  static Future<void> _writePrefsFromData(Data? d) async {
    if (d == null) return;
    if (d.isPaid != null) {
      await AppPreference.writeString(AppPreference.isPaid, d.isPaid.toString());
    }
    if (d.productId != null && d.productId!.isNotEmpty) {
      await AppPreference.writeString(AppPreference.productId, d.productId!);
    }
  }

  static bool needsMandatoryPremiumOnboarding(Data? d) {
    if (d == null) return false;
    if (!PremiumHelper.isPremiumUser(d)) return false;
    // Prefer actual required fields to avoid stale flags while onboarding.
    return _isPersonalInfoMissing(d) || _isCompanyInfoMissing(d);
  }

  static String _mandatoryOnboardingDestination(Data? d) {
    if (d == null) return ReferralOnboardingWelcomeScreen.pageId;
    final personalMissing = _isPersonalInfoMissing(d);
    final companyMissing = _isCompanyInfoMissing(d);
    if (personalMissing && !companyMissing) {
      return ReferralOnboardingPersonalScreen.pageId;
    }
    if (!personalMissing && companyMissing) {
      return ReferralOnboardingBusinessScreen.pageId;
    }
    return ReferralOnboardingWelcomeScreen.pageId;
  }

  /// Calls [RESTAuth.updateCompanyType] when premium user is not yet professional.
  /// Returns true when an API update was performed (caller should refetch profile).
  static Future<bool> maybeForcePremiumProfessional(Data? d) async {
    if (d == null) return false;
    if (!PremiumHelper.isPremiumUser(d)) return false;
    final ct = (d.companyType ?? '').toLowerCase();
    if (ct == 'professional') return false;
    final res = await RESTAuth.updateCompanyType(companyType: 'professional');
    return res is ApiSuccess;
  }

  /// After login / cold start: fetch profile, force professional if needed, return route name.
  static Future<String> resolvePostLoginDestination() async {
    final r = await RESTAuth.getProfile();
    if (r is! ApiSuccess<ModelProfile> || r.data.status != true) {
      return ScreenMain.pageId;
    }

    Data? d = r.data.data;
    await _writePrefsFromData(d);

    if (d != null) {
      if (await maybeForcePremiumProfessional(d)) {
        final r2 = await RESTAuth.getProfile();
        if (r2 is ApiSuccess<ModelProfile> && r2.data.status == true) {
          d = r2.data.data;
          await _writePrefsFromData(d);
        }
      }
    }

    if (needsMandatoryPremiumOnboarding(d)) {
      return _mandatoryOnboardingDestination(d);
    }
    return ScreenMain.pageId;
  }

  /// After IAP purchase or server-side premium activation: re-check gate.
  static Future<void> afterPremiumStatusMayHaveChanged() async {
    final r = await RESTAuth.getProfile();
    if (r is! ApiSuccess<ModelProfile> || r.data.status != true) return;
    await syncPrefsAndApplyGatesFromModel(r.data);
  }

  /// Uses an existing [getProfile] response to avoid an extra round-trip when possible.
  static Future<void> syncPrefsAndApplyGatesFromModel(ModelProfile profile) async {
    if (profile.status != true) return;
    Data? d = profile.data;
    await _writePrefsFromData(d);

    if (d != null) {
      if (await maybeForcePremiumProfessional(d)) {
        final r2 = await RESTAuth.getProfile();
        if (r2 is ApiSuccess<ModelProfile> && r2.data.status == true) {
          d = r2.data.data;
          await _writePrefsFromData(d);
        }
      }
    }

    navigateToMandatoryOnboardingIfNeeded(d);
  }

  static void navigateToMandatoryOnboardingIfNeeded(Data? d) {
    if (!needsMandatoryPremiumOnboarding(d)) return;
    SchedulerBinding.instance.addPostFrameCallback((_) {
      // If user is already inside referral onboarding, never bounce them.
      final currentRoute = Get.currentRoute;
      if (currentRoute.startsWith(_onboardingRoutePrefix)) {
        return;
      }

      final destination = _mandatoryOnboardingDestination(d);
      if (currentRoute != destination) {
        Get.offAllNamed(destination);
      }
    });
  }
}

