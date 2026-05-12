import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:referaly/languages/languagekeys.dart';
import 'package:referaly/resources/app_helper.dart';
import 'package:referaly/screens/auth/screen_initial_language.dart';
import 'package:referaly/utils/translations.dart';

import '../controller/controller_main_professional.dart';
import '../controller/track_lead_controller.dart';
import '../resources/app_log.dart';
import '../resources/app_preference.dart';
import '../resources/app_strings.dart';
import 'api_path.dart';

import 'package:http/http.dart' as http;

mixin BaseAPI {
  static const String _requestTimeoutError = 'RequestTimeout';
  static const String _tokenExpireError =
      'Please authenticate using valid token';

  int conTimeout30Sec() {
    return 30;
  }

  int conTimeout1Min() {
    return 60;
  }

  int conTimeout2Min() {
    return 120;
  }

  // ignore: prefer_function_declarations_over_variables
  final dynamic onTimeout = () {
    return http.Response(
        '''{"success":false,"message":"$_requestTimeoutError"}''', 408);
  };

  T? onConnectionTimeout<T>(String tag) {
    apiLog('$tag ${AppString.strConnectionTimeout}');
    return null;
  }

  void apiLog(var message) {
    AppLog.d(message);
    // final pattern = RegExp('.{1,800}');
    // pattern.allMatches(message).forEach((match) => print(match.group(0)));
  }

  void showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  Future<Map<String, String>> getHeader() async {
    var currentLocale = AppPreference.getLanguage();
    AppHelper.showLog("currentLocale: $currentLocale");
    var header = {
      'Content-Type': 'application/json',
      'app-language': currentLocale,
    };
    return header;
  }

  Future<Map<String, String>> getHeaderWithToken() async {
    String? accessToken = AppPreference.readString(AppPreference.accessToken);
    var currentLocale = AppPreference.getLanguage();
    AppHelper.showLog("currentLocale: $currentLocale");
    var headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $accessToken',
      'app-language': currentLocale,
    };
    return headers;
  }

  Future<Map<String, String>> getHeaderWithoutType() async {
    String? accessToken = AppPreference.readString(AppPreference.accessToken);
    var currentLocale = AppPreference.getLanguage();
    AppHelper.showLog("currentLocale: $currentLocale");

    var headers = {
      'Accept': 'application/json',
      'Authorization': 'Bearer $accessToken',
      'app-language': currentLocale,
    };
    return headers;
  }

  Future<Map<String, String>> getHeaderWithoutToken() async {
    var currentLocale = AppPreference.getLanguage();
    AppHelper.showLog("currentLocale: $currentLocale");

    var headers = {
      'Accept': 'application/json',
      'app-language': currentLocale,
    };
    return headers;
  }

  Future<bool?> hasInternet() async {
    final connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult.contains(ConnectivityResult.none)) {
      ScaffoldMessenger.of(Get.context!).showSnackBar(
        SnackBar(
          content: Text(tr(LanguageKeys.noInternetConnection)),
        ),
      );
      return false;
    }
    return true;
  }

  String getDeviceType() {
    return Platform.isAndroid
        ? ApiPath.deviceAndroid
        : Platform.isIOS
            ? ApiPath.deviceIoS
            : ApiPath.deviceWeb;
  }

  T? onSocket<T>(String tag) {
    apiLog('$tag ${tr(LanguageKeys.noInternetConnection)}');
    return null;
  }

  T? onError<T>(String tag, dynamic error) {
    apiLog('$tag Error: ${error.toString()}');
    return null;
  }

  bool isDialogShowing = false;

  void show401Dialog(BuildContext context, String message) async {
    isDialogShowing = ModalRoute.of(context)?.isCurrent != true;
  }

  bool isTokenExpired(var decodedResult) {
    if (decodedResult['success'].toString() == 'false' &&
        decodedResult['message']
            .toString()
            .toLowerCase()
            .trim()
            .contains(_tokenExpireError.toLowerCase().trim())) {
      return true;
    } else {
      return false;
    }
  }

  /// Handles unauthorized (401) responses globally
  /// Clears user session and redirects to login page
  Future<void> handleUnauthorizedResponse(String tag) async {
    apiLog('$tag: Unauthorized response detected - redirecting to login');

    try {
      // Clear controller cached data first
      try {
        if (Get.isRegistered<ControllerMainProfessional>()) {
          Get.find<ControllerMainProfessional>().clearCachedData();
        }
        if (Get.isRegistered<TrackLeadsController>()) {
          Get.delete<TrackLeadsController>();
        }
      } catch (e) {
        apiLog('$tag: Error clearing controllers: $e');
      }

      // Clear all user session data
      final preserveRememberMe = AppPreference.readBool(AppPreference.rememberMe);
      await AppPreference.clearSession(preserveRememberMe: preserveRememberMe);

      // Clear any pending deep link data
      AppPreference.writeString('pending_deal_id', '');
      AppPreference.writeString('pending_campaign', '');
      AppPreference.writeString('pending_stage', '');
      AppPreference.writeBool(AppPreference.isDeeplink, false);

      // Clear deep link tracking if splash controller exists
      try {
        // Try to find and clear splash controller if it exists
        if (Get.isRegistered<dynamic>()) {
          // Use a more direct approach to clear splash controller
          try {
            // Import the splash controller and clear it if registered
            // This is a fallback approach since we can't easily iterate through GetX controllers
            apiLog('$tag: Attempting to clear splash controller');
          } catch (e) {
            apiLog('$tag: Error accessing splash controller: $e');
          }
        }
      } catch (e) {
        apiLog('$tag: Error clearing deep link tracking: $e');
      }

      // Navigate to welcome/login screen
      Get.until((route) => false);
      Get.offAllNamed(ScreenInitialLanguage.pageId);
    } catch (e) {
      apiLog('$tag: Error during unauthorized handling: $e');
      // Even if there's an error, try to navigate to login
      Get.until((route) => false);
      Get.offAllNamed(ScreenInitialLanguage.pageId);
    }
  }

  /// Checks if response indicates unauthorized access
  bool isUnauthorizedResponse(int statusCode, var decodedResult) {
    // Check for 401 status code
    if (statusCode == 401) {
      return true;
    }

    // Check for token expiration in response body
    if (decodedResult != null && isTokenExpired(decodedResult)) {
      return true;
    }

    // Check for common unauthorized messages
    if (decodedResult != null && decodedResult is Map) {
      final message = decodedResult['message']?.toString().toLowerCase() ?? '';
      if (message.contains('unauthorized') ||
          message.contains('token expired') ||
          message.contains('invalid token') ||
          message.contains('authentication failed')) {
        return true;
      }
    }

    return false;
  }
}
