import 'dart:convert';

import 'package:get/get.dart';
import 'package:referaly/apis/api_result.dart';
import 'package:referaly/languages/languagekeys.dart';
import 'package:referaly/models/model_login.dart' show UserData;
import 'package:referaly/models/model_profile.dart';
import 'package:referaly/models/model_team_member.dart';
import 'package:referaly/resources/app_preference.dart';
import 'package:referaly/utils/translations.dart';

import '../resources/app_colors.dart';

/// Client-side mirror of backend agency colleague rules ([docs/MOBILE_API_AGENCY_TEAM.md]).
///
/// - **Agency owner** (`can_manage_team`): full access; may open Team Management.
/// - **Agency colleague** (`is_agency_colleague` + `content_access`): restricted modules.
/// - **Independent colleague**: no `content_access` restrictions (normal app).
/// - **Everyone else**: unrestricted here; premium/subscription uses [PremiumHelper].
class AgencyColleagueAccessHelper {
  AgencyColleagueAccessHelper._();

  /// Matches API `role_names` when explicit colleague flags are missing.
  static const String roleAgencyColleague = 'agency-colleague';
  static const String roleIndependentColleague = 'independent-colleague';

  // ---------------------------------------------------------------------------
  // Persistence (login / GET my-profile → SharedPreferences for cold start)
  // ---------------------------------------------------------------------------

  /// Saves colleague flags after [Data] is loaded from profile (or equivalent).
  static Future<void> persistFromData(Data? d) async {
    if (d == null) {
      await _clearColleaguePrefs();
      return;
    }
    await AppPreference.writeString(
      AppPreference.isAgencyColleague,
      isAgencyColleague(d) ? '1' : '0',
    );
    await AppPreference.writeString(
      AppPreference.isIndependentColleague,
      isIndependentColleague(d) ? '1' : '0',
    );
    await AppPreference.writeString(
      AppPreference.canManageTeam,
      canManageTeam(d) ? '1' : '0',
    );
    if (d.contentAccess != null) {
      await AppPreference.writeString(
        AppPreference.contentAccessJson,
        jsonEncode(d.contentAccess!.toJson()),
      );
    } else {
      await AppPreference.remove(AppPreference.contentAccessJson);
    }
  }

  /// Same as [persistFromData] but for the login response `user` object.
  static Future<void> persistFromLoginUser(UserData? user) async {
    if (user == null) {
      await _clearColleaguePrefs();
      return;
    }
    await AppPreference.writeString(
      AppPreference.isAgencyColleague,
      _loginIsAgencyColleague(user) ? '1' : '0',
    );
    await AppPreference.writeString(
      AppPreference.isIndependentColleague,
      _loginIsIndependentColleague(user) ? '1' : '0',
    );
    await AppPreference.writeString(
      AppPreference.canManageTeam,
      user.canManageTeam == true ? '1' : '0',
    );
    if (user.contentAccess != null) {
      await AppPreference.writeString(
        AppPreference.contentAccessJson,
        jsonEncode(user.contentAccess!.toJson()),
      );
    } else {
      await AppPreference.remove(AppPreference.contentAccessJson);
    }
  }

  static Future<void> _clearColleaguePrefs() async {
    await AppPreference.remove(AppPreference.isAgencyColleague);
    await AppPreference.remove(AppPreference.isIndependentColleague);
    await AppPreference.remove(AppPreference.canManageTeam);
    await AppPreference.remove(AppPreference.contentAccessJson);
  }

  // ---------------------------------------------------------------------------
  // Cold start: rebuild minimal [Data] from prefs when profile is not in memory
  // ---------------------------------------------------------------------------

  static Data? fromPrefs() {
    final isAgency = _readBoolPref(AppPreference.isAgencyColleague);
    final isIndependent = _readBoolPref(AppPreference.isIndependentColleague);
    final canTeam = _readBoolPref(AppPreference.canManageTeam);
    if (isAgency == null && isIndependent == null && canTeam == null) {
      return null;
    }
    return Data(
      isAgencyColleague: isAgency ?? false,
      isIndependentColleague: isIndependent ?? false,
      canManageTeam: canTeam ?? false,
      contentAccess: _readContentAccessFromPrefs(),
      roleNames: _readRoleNamesFromPrefs(),
    );
  }

  static List<String>? _readRoleNamesFromPrefs() {
    final jsonStr = AppPreference.readString(AppPreference.roleNamesJson);
    if (jsonStr == null || jsonStr.isEmpty) return null;
    try {
      final decoded = jsonDecode(jsonStr);
      if (decoded is List) {
        return decoded.map((e) => e.toString()).toList();
      }
    } catch (_) {}
    return null;
  }

  static TeamMemberContentAccess? _readContentAccessFromPrefs() {
    final jsonStr = AppPreference.readString(AppPreference.contentAccessJson);
    if (jsonStr == null || jsonStr.isEmpty) return null;
    try {
      final decoded = jsonDecode(jsonStr);
      if (decoded is Map<String, dynamic>) {
        return TeamMemberContentAccess.fromJson(decoded);
      }
    } catch (_) {}
    return null;
  }

  static bool? _readBoolPref(String key) {
    final v = AppPreference.readString(key);
    if (v == null || v.isEmpty) return null;
    return v == '1' || v.toLowerCase() == 'true';
  }

  /// In-memory profile from controller, or last persisted snapshot.
  static Data? resolveProfile(Data? profile) => profile ?? fromPrefs();

  // ---------------------------------------------------------------------------
  // Who is the current user? (flags + role_names fallback)
  // ---------------------------------------------------------------------------

  static bool isAgencyColleague(Data? profile) {
    final d = resolveProfile(profile);
    if (d == null) return false;
    if (d.isAgencyColleague == true) return true;
    return d.roleNames?.any((r) => r.trim() == roleAgencyColleague) ?? false;
  }

  static bool isIndependentColleague(Data? profile) {
    final d = resolveProfile(profile);
    if (d == null) return false;
    if (d.isIndependentColleague == true) return true;
    return d.roleNames?.any((r) => r.trim() == roleIndependentColleague) ?? false;
  }

  static bool _loginIsAgencyColleague(UserData user) {
    if (user.isAgencyColleague == true) return true;
    return user.roleNames?.any((r) => r.trim() == roleAgencyColleague) ?? false;
  }

  static bool _loginIsIndependentColleague(UserData user) {
    if (user.isIndependentColleague == true) return true;
    return user.roleNames?.any((r) => r.trim() == roleIndependentColleague) ??
        false;
  }

  /// Agency subscription owner only — not the same as premium ([PremiumHelper]).
  static bool canManageTeam(Data? profile) {
    final d = resolveProfile(profile);
    return d?.canManageTeam == true;
  }

  // ---------------------------------------------------------------------------
  // Module permissions (agency colleagues only)
  // ---------------------------------------------------------------------------

  /// Core check aligned with BE `can(permission, mode)`:
  /// - Non–agency-colleague users → always allowed.
  /// - Independent colleagues → always allowed.
  /// - Agency colleagues → read [TeamMemberContentAccess] (deny if null).
  static bool can(Data? profile, AgencyPermission permission, AccessMode mode) {
    if (!isAgencyColleague(profile)) return true;
    if (isIndependentColleague(profile)) return true;
    if (permission == AgencyPermission.teamManagement) return false;

    final access = resolveProfile(profile)?.contentAccess;
    if (access == null) return false;

    switch (permission) {
      case AgencyPermission.businessReferrers:
        return _moduleAllows(access.businessReferrers, mode);
      case AgencyPermission.leadsSent:
        return _moduleAllows(access.leadsSent, mode);
      case AgencyPermission.leadsReceived:
        return _moduleAllows(access.leadsReceived, mode);
      case AgencyPermission.leads:
        return _moduleAllows(access.leadsSent, mode) ||
            _moduleAllows(access.leadsReceived, mode);
      case AgencyPermission.referralContracts:
        return _moduleAllows(access.referralContracts, mode);
      case AgencyPermission.iAmReferrer:
        return access.iAmReferrerVisible;
      case AgencyPermission.teamManagement:
        return false;
    }
  }

  /// Edition requires visibility (cannot edit a hidden module).
  static bool _moduleAllows(ModulePermission module, AccessMode mode) {
    switch (mode) {
      case AccessMode.visibility:
        return module.visibility;
      case AccessMode.edition:
        return module.visibility && module.edition;
    }
  }

  static bool canView(Data? profile, AgencyPermission permission) =>
      can(profile, permission, AccessMode.visibility);

  static bool canEdit(Data? profile, AgencyPermission permission) =>
      can(profile, permission, AccessMode.edition);

  // ---------------------------------------------------------------------------
  // UI copy
  // ---------------------------------------------------------------------------

  /// Drawer/profile badge: Agency Colleague, Independent, Agency, Free, etc.
  static String accountHeaderLabel(Data? profile) {
    final d = resolveProfile(profile);
    if (d == null) return tr(LanguageKeys.accountLabelFree);
    if (isAgencyColleague(d)) {
      return tr(LanguageKeys.accountLabelAgencyColleague);
    }
    if (isIndependentColleague(d)) {
      return tr(LanguageKeys.accountLabelIndependentColleague);
    }
    final sub = (d.subscriptionType ?? '').toLowerCase();
    if (sub == 'agency') return tr(LanguageKeys.accountLabelAgency);
    if (sub == 'independent') return tr(LanguageKeys.accountLabelIndependent);
    return '';
    // return tr(LanguageKeys.accountLabelFree);
  }

  // ---------------------------------------------------------------------------
  // HTTP 403 from `agency.access` middleware (server is source of truth)
  // ---------------------------------------------------------------------------

  /// Detects the `agency.access` middleware response from BE:
  /// `code: 403`, `errors: "<module>"`, message: "You do not have permission…".
  static bool isAgencyAccessDenied(ApiFailure failure) {
    if (failure.error.statusCode == 403) return true;
    final code = failure.error.errorCode ??
        failure.error.errors?.errorMap['errors']?.first ??
        failure.error.errors?.firstError;
    if (code != null &&
        (code.contains('agency_colleague_access_denied') ||
            code.contains('agency_colleague_cannot_manage_team'))) {
      return true;
    }
    final msg = (failure.error.message ?? '').toLowerCase();
    return msg.contains('do not have permission') ||
        msg.contains("don't have permission");
  }

  static String accessDeniedMessage(ApiFailure failure) {
    if (isAgencyAccessDenied(failure)) {
      return tr(LanguageKeys.agencyColleagueAccessDenied);
    }
    return failure.error.message ?? tr(LanguageKeys.somethingWentWrong);
  }

  // ---------------------------------------------------------------------------
  // UI guards (snackbar + one-line tap guards)
  // ---------------------------------------------------------------------------

  /// Shared "no permission" snackbar used by every edit gate.
  static void showAccessDeniedSnackbar({String? message}) {
    Get.snackbar(
      tr(LanguageKeys.error),
      message ?? tr(LanguageKeys.agencyColleagueAccessDenied),
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: AppColors.error300,
      colorText: AppColors.whiteColor,
    );
  }

  /// Returns `true` when the user is allowed to edit; otherwise shows the
  /// snackbar and returns `false`. Use as a one-liner gate at button taps
  /// and controller entry points.
  static bool guardEdit(Data? profile, AgencyPermission permission) {
    if (canEdit(profile, permission)) return true;
    showAccessDeniedSnackbar();
    return false;
  }
}

/// Product areas gated for agency colleagues (maps to `content_access` keys).
enum AgencyPermission {
  /// My Network, business referrers, search.
  businessReferrers,
  leadsSent,
  leadsReceived,
  /// Either sent or received stream (e.g. lead detail / track step).
  leads,
  /// My Deals / referral contracts.
  referralContracts,
  /// Deals accepted as referrer (`acceptList`, etc.).
  iAmReferrer,
  /// Always false for colleagues; use [AgencyColleagueAccessHelper.canManageTeam].
  teamManagement,
}

enum AccessMode {
  /// Can open lists / read data.
  visibility,
  /// Can create, update, delete (requires visibility).
  edition,
}
