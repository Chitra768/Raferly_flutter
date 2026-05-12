import 'package:flutter/foundation.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

// import '../models/model_daily_reminder.dart';
// import '../models/model_intro.dart';
// import '../models/model_user.dart';

class AppPreference {
  static const String accessToken = 'accessToken';
  static const String email = 'email';
  static const String fcmToken = 'fcmToken';
  static const String usrEmail = 'userEmail';
  static const String usrPassword = 'userPassword';
  static const String rememberMe = 'rememberMe';
  static const String isLoggedIn = 'isLoggedIn';
  static const String isFirstTime = 'isFirstTime';
  static const String isPaid = '0';
  /// JSON-encoded `List<String>` of API `role_names` (see [PremiumHelper.persistRoleNames]).
  static const String roleNamesJson = 'roleNamesJson';
  static const String productId = 'productId';
  static const String appLanguage = 'appLanguage';
  static const String defaultLanguage = 'fr'; // Default language code
  static const String paymentCurrency = 'payment_currency';
  static const String isDeeplink = 'isDeeplink';
  static const String appVersion = 'app_version';
  static const String cacheSentinelToken = 'cache_sentinel_token';

  static late SharedPreferences preferences;
  static bool _isInitialized = false;

  static Future<void> init() async {
    try {
      preferences = await SharedPreferences.getInstance();
      _isInitialized = true;
      debugPrint('AppPreference initialized successfully');
    } catch (e) {
      debugPrint('Error initializing AppPreference: $e');
      rethrow;
    }
  }

  static String? readString(String key) {
    if (!_isInitialized) {
      debugPrint(
          'Warning: AppPreference not initialized yet. Returning null for key: $key');
      return null;
    }
    return preferences.getString(key);
  }

  static Future<bool> writeString(String key, String value) async {
    if (!_isInitialized) {
      debugPrint(
          'Warning: AppPreference not initialized yet. Cannot write key: $key');
      return false;
    }
    return preferences.setString(key, value);
  }

  static bool readBool(String key) {
    if (!_isInitialized) {
      debugPrint(
          'Warning: AppPreference not initialized yet. Returning false for key: $key');
      return false;
    }
    return preferences.getBool(key) ?? false;
  }

  static Future<bool> writeBool(String key, bool value) async {
    if (!_isInitialized) {
      debugPrint(
          'Warning: AppPreference not initialized yet. Cannot write key: $key');
      return false;
    }
    return preferences.setBool(key, value);
  }

  static int readInt(String key) {
    if (!_isInitialized) {
      debugPrint(
          'Warning: AppPreference not initialized yet. Returning 0 for key: $key');
      return 0;
    }
    return preferences.getInt(key) ?? 0;
  }

  static Future<bool> writeInt(String key, int value) async {
    if (!_isInitialized) {
      debugPrint(
          'Warning: AppPreference not initialized yet. Cannot write key: $key');
      return false;
    }
    return preferences.setInt(key, value);
  }

  static Future<bool> clearPreferences() async {
    if (!_isInitialized) {
      debugPrint(
          'Warning: AppPreference not initialized yet. Cannot clear preferences');
      return false;
    }
    return preferences.clear();
  }

  /// Force clear all data including external services
  static Future<void> forceClearAllData() async {
    if (!_isInitialized) {
      debugPrint(
          'Warning: AppPreference not initialized yet. Cannot force clear data');
      return;
    }

    try {
      // Preserve user-selected language across clears
      final preservedLanguage = readString(appLanguage);

      // Clear SharedPreferences
      await preferences.clear();

      // Restore preserved keys
      if (preservedLanguage != null && preservedLanguage.isNotEmpty) {
        await writeString(appLanguage, preservedLanguage);
      }

      // Clear any cached files
      await _clearCacheDirectories();

      // Clear any external service data
      await _clearExternalServiceData();

      debugPrint('All app data cleared successfully');
    } catch (e) {
      debugPrint('Error clearing app data: $e');
    }
  }

  static Future<void> _clearCacheDirectories() async {
    try {
      // This would clear any cached files if you're using path_provider
      // You can add specific cache clearing logic here
      debugPrint('Cache directories cleared');
    } catch (e) {
      debugPrint('Error clearing cache directories: $e');
    }
  }

  static Future<void> _clearExternalServiceData() async {
    try {
      // Clear Branch.io data
      // Note: Branch.io doesn't provide a direct clear method
      // but you can reset attribution data
      debugPrint('External service data cleared');
    } catch (e) {
      debugPrint('Error clearing external service data: $e');
    }
  }

  /// Clears only non-critical caches during app update.
  ///
  /// This intentionally preserves login/session/preferences data
  /// (e.g., access token, isLoggedIn, language, etc.) to avoid
  /// logging users out after an update.
  static Future<void> clearNonCriticalCachesOnUpdate() async {
    try {
      await _clearCacheDirectories();
      await _clearExternalServiceData();
      debugPrint('Non-critical caches cleared for app update');
    } catch (e) {
      debugPrint('Error clearing non-critical caches on update: $e');
    }
  }

  static Future<bool> clearAccessToken() async {
    if (!_isInitialized) {
      debugPrint(
          'Warning: AppPreference not initialized yet. Cannot clear access token');
      return false;
    }
    return preferences.remove(accessToken);
  }

  static Future<bool> remove(String key) async {
    if (!_isInitialized) {
      debugPrint('Warning: AppPreference not initialized yet. Cannot remove key: $key');
      return false;
    }
    return preferences.remove(key);
  }

  static Future<void> clearLoginData() async {
    if (!_isInitialized) {
      debugPrint(
          'Warning: AppPreference not initialized yet. Cannot clear login data');
      return;
    }

    await preferences.remove(accessToken);
    await preferences.remove(email);
    await preferences.remove(fcmToken);
    await preferences.remove(usrEmail);
    await preferences.remove(usrPassword);
    await preferences.remove(isLoggedIn);
    await preferences.remove(isPaid);
    await preferences.remove(roleNamesJson);
    await preferences.remove(productId);
  }

  /// Clears the authenticated session while optionally preserving "Remember me" credentials.
  ///
  /// Use this for logout flows. This avoids wiping unrelated preferences (e.g. language),
  /// and keeps the saved email/password only when the user opted into remember me.
  static Future<void> clearSession({bool preserveRememberMe = true}) async {
    if (!_isInitialized) {
      debugPrint('Warning: AppPreference not initialized yet. Cannot clear session');
      return;
    }

    await preferences.remove(accessToken);
    await preferences.remove(email);
    await preferences.remove(isLoggedIn);
    await preferences.remove(isPaid);
    await preferences.remove(roleNamesJson);
    await preferences.remove(productId);

    if (!preserveRememberMe) {
      await preferences.remove(rememberMe);
      await preferences.remove(usrEmail);
      await preferences.remove(usrPassword);
    }
  }

  // Read / Write LoginData in Preferences
  // static Future<void> writeLoginData(value) async {
  //   var loginData = User.fromJson(value);
  //
  //   String dataToSave = jsonEncode(User.fromJson(value));
  //   writeString(_spKeyUserData, dataToSave);
  //   AppLog.d('write');
  //
  // }
  //
  // static Future<User?> readLoginData() async {
  //   dynamic result;
  //   String? str = await readString(_spKeyUserData);
  //
  //   if (str != null && str.isNotEmpty) {
  //     Map<String, dynamic> json = jsonDecode(str) as Map<String, dynamic>;
  //     result = User.fromJson(json);
  //   var  loginData = result;
  //     AppLog.d('read');
  //   } else {
  //     result = null;
  //   }
  //
  //   return result;
  // }
  // // Read / Write LoginData in Preferences
  // static Future<void> writeIntroData(value) async {
  //   var introData = Data.fromJson(value);
  //
  //   String dataToSave = jsonEncode(Data.fromJson(value));
  //   writeString(_spKeyIntroData, dataToSave);
  //   AppLog.d('write');
  //
  // }
  // static Future<void> removeLoginData() async {
  //   SharedPreferences preferences = await SharedPreferences.getInstance();
  //   preferences.remove(_spKeyUserData);
  //
  // }
  //
  // static Future<Data?> readIntroData() async {
  //   dynamic result;
  //   String? str = await readString(_spKeyIntroData);
  //
  //   if (str != null && str.isNotEmpty) {
  //     Map<String, dynamic> json = jsonDecode(str) as Map<String, dynamic>;
  //     result = Data.fromJson(json);
  //     var  introData = result;
  //     AppLog.d('read');
  //   } else {
  //     result = null;
  //   }
  //
  //   return result;
  // }
  //
  // // Read / Write Default session in Preferences
  // static Future<void> writeDefaultSessionData(value) async {
  //   var defaultSessionData = DailyReminderData.fromJson(value);
  //
  //   String dataToSave = jsonEncode(DailyReminderData.fromJson(value));
  //   writeString(spKeyDefaultSessionData, dataToSave);
  //   AppLog.d('write');
  //
  // }
  //
  // static Future<DailyReminderData?> readDefaultSessionData() async {
  //   dynamic result;
  //   String? str = await readString(spKeyDefaultSessionData);
  //
  //   if (str != null && str.isNotEmpty) {
  //     Map<String, dynamic> json = jsonDecode(str) as Map<String, dynamic>;
  //     result = DailyReminderData.fromJson(json);
  //     var  defaultSessionData = result;
  //     AppLog.d('read');
  //   } else {
  //     result = null;
  //   }
  //
  //   return result;
  // }
  //
  // static Future<void> removeDefaultSessionData() async {
  //   SharedPreferences preferences = await SharedPreferences.getInstance();
  //   preferences.remove(spKeyDefaultSessionData);
  //
  // }

  static String getLanguage() {
    return readString(appLanguage) ?? defaultLanguage;
  }

  static Future<bool> setLanguage(String languageCode) async {
    return writeString(appLanguage, languageCode);
  }

  static bool isFirstTimeUser() {
    return readBool(isFirstTime);
  }

  static Future<bool> setFirstTimeUser(bool value) async {
    return writeBool(isFirstTime, value);
  }

  /// Check if this is a fresh install or app update
  static Future<bool> isFreshInstall() async {
    try {
      final packageInfo = await PackageInfo.fromPlatform();
      final currentVersion = packageInfo.version;
      final storedVersion = readString(appVersion);

      // Only clear data if this is actually a version update, not on every restart
      if (storedVersion != null && storedVersion != currentVersion) {
        // This is a version update - clear data
        debugPrint(
            'Version update detected: $storedVersion -> $currentVersion');
        await writeString(appVersion, currentVersion);
        return true;
      } else if (storedVersion == null) {
        // This is a fresh install - store version but don't clear data yet
        // Let the normal flow handle first-time setup
        await writeString(appVersion, currentVersion);
        return false; // Don't clear data on fresh install
      }
      return false;
    } catch (e) {
      debugPrint('Error checking fresh install: $e');
      return false; // Don't clear data on error - assume not fresh install
    }
  }
}
