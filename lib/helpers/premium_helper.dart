import 'dart:convert';

import 'package:referaly/models/model_profile.dart';
import 'package:referaly/resources/app_preference.dart';

/// Premium access: first [Data.roleNames] (agency / independent roles), then
/// legacy paid flag [Data.is_paid] (non-zero). Missing fields fall back to prefs.
///
/// Backend-only / TBD items: see `lib/helpers/premium_policy_backlog.dart`.
class PremiumHelper {
  PremiumHelper._();

  /// API role names that grant premium feature access (everyone may still have `user`).
  static const String roleAgencyUser = 'agency-user';
  static const String roleIndependentUser = 'independent-user';

  /// Legacy / parallel rule: non-zero `is_paid` counts as premium when roles do not.
  static bool isPremiumFromPaid(int? isPaid) => (isPaid ?? 0) != 0;

  static int? _readIsPaidFromPrefs() {
    final s = AppPreference.readString(AppPreference.isPaid);
    if (s == null || s.isEmpty) return null;
    return int.tryParse(s);
  }

  static bool hasPremiumRole(List<String>? roleNames) {
    if (roleNames == null || roleNames.isEmpty) return false;
    for (final raw in roleNames) {
      final name = raw.trim();
      if (name == roleAgencyUser || name == roleIndependentUser) {
        return true;
      }
    }
    return false;
  }

  /// Deserializes [AppPreference.roleNamesJson] (JSON array string).
  static List<String>? readRoleNamesFromPrefs() {
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

  /// Cold start / no in-memory profile: roles from prefs, then `is_paid` from prefs.
  static bool isPremiumUserFromPrefs() {
    return isPremiumUser(null);
  }

  /// Resolves roles: in-memory [profileData.roleNames] when set, else prefs.
  /// Resolves paid: in-memory [profileData.isPaid] when set, else prefs.
  /// Premium if role match **or** [isPremiumFromPaid] on resolved `is_paid`.
  static bool isPremiumUser(Data? profileData) {
    final roleNames =
        profileData?.roleNames ?? readRoleNamesFromPrefs();
    if (hasPremiumRole(roleNames)) return true;

    final isPaid = profileData?.isPaid ?? _readIsPaidFromPrefs();
    return isPremiumFromPaid(isPaid);
  }

  /// Persists roles for cold start / gates before profile is loaded.
  static Future<void> persistRoleNames(List<String>? roleNames) async {
    if (roleNames == null || roleNames.isEmpty) {
      await AppPreference.remove(AppPreference.roleNamesJson);
      return;
    }
    await AppPreference.writeString(
      AppPreference.roleNamesJson,
      jsonEncode(roleNames),
    );
  }
}
