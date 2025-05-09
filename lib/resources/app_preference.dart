import 'package:shared_preferences/shared_preferences.dart';

// import '../models/model_daily_reminder.dart';
// import '../models/model_intro.dart';
// import '../models/model_user.dart';

class AppPreference {
  static const String accessToken = 'accessToken';
  static const String fcmToken = 'fcmToken';
  static const String usrEmail = 'userEmail';
  static const String usrPassword = 'userPassword';
  static const String isLoggedIn = 'isLoggedIn';
  static const String isFirstTime = 'isFirstTime';

  static late SharedPreferences preferences;

  static Future<void> init() async {
    preferences = await SharedPreferences.getInstance();
  }

  static String? readString(String key) {
    return preferences.getString(key);
  }

  static Future<bool> writeString(String key, String value) async {
    return preferences.setString(key, value);
  }

  static bool readBool(String key) {
    return preferences.getBool(key) ?? false;
  }

  static Future<bool> writeBool(String key, bool value) async {
    return preferences.setBool(key, value);
  }

  static int readInt(String key) {
    return preferences.getInt(key) ?? 0;
  }

  static Future<bool> writeInt(String key, int value) async {
    return preferences.setInt(key, value);
  }

  static Future<bool> clearPreferences() async {
    return preferences.clear();
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
}
