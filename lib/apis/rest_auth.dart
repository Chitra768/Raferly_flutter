// ignore_for_file: non_constant_identifier_names

import 'dart:convert';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:http/http.dart' as http;
import 'package:referaly/models/model_common.dart';
import 'package:referaly/models/model_register.dart';
import 'package:referaly/resources/app_log.dart';

import '../models/model_error.dart';
import '../models/model_login.dart';

import '../resources/app_helper.dart';
import '../resources/app_strings.dart';
import 'api_path.dart';
import 'api_result.dart';
import 'base_api.dart';

class RESTAuth with BaseAPI {
  static final RESTAuth _object = RESTAuth();

  Future<String?> getDeviceID() async {
    try {
      final deviceInfo = DeviceInfoPlugin();
      if (Platform.isAndroid) {
        final androidInfo = await deviceInfo.androidInfo;
        return androidInfo.id;
      } else if (Platform.isIOS) {
        final iosInfo = await deviceInfo.iosInfo;
        return iosInfo.identifierForVendor;
      }
    } catch (e) {
      AppLog.e('Failed to get device ID: $e');
    }
    return null;
  }

  // Suman : Register Api
  static Future<ApiResult> register({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required String phoneNumber,
    required String companyType,
    required String city,
    required String countryCode,
    String? deviceId,
    String? deviceType,
    required String fcmToken,
    required String lang,
    required String job,
    String? jobId,
    String? sendLeadOut,
  }) async {
    const String tag = 'register';

    if (!(await _object.hasInternet() ?? false)) {
      return ApiFailure(ModelError(message: AppString.strNoInternetConnection));
    }

    String? deviceId = await _object.getDeviceID();

    _object.apiLog('$tag baseurl: ${ApiPath.baseUrl}');
    var url = Uri.parse(ApiPath.baseUrl + ApiPath.register);
    _object.apiLog('$tag URL: $url');

    var body = {
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'password': password,
      'phone_number': phoneNumber,
      'company_type': companyType,
      'city': city,
      'country_code': countryCode,
      'device_id': deviceId,
      'device_type': _object.getDeviceType(),
      'fcm_token': fcmToken,
      'lang': lang,
      'job': job,
      'is_app': "true",
      if (jobId != null) 'job_id': jobId,
      if (sendLeadOut != null) 'send_lead_out': sendLeadOut,
    };

    _object.apiLog('$tag body: $body');

    try {
      final response = await http.post(url, body: body);
      _object.apiLog('$tag Response: Status Code: ${response.statusCode}');
      _object.apiLog('$tag Response: ${response.body}');

      var decodedResult = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return ApiSuccess(ModelRegister.fromJson(decodedResult));
      }

      if (response.statusCode == 422) {
        return ApiFailure(ModelError.fromJson(decodedResult));
      }

      return ApiFailure(
        ModelError(message: decodedResult['message'] ?? 'Something went wrong'),
      );
    } on SocketException {
      _object.onSocket(tag);
      return ApiFailure(ModelError(message: 'Unexpected error occurred'));
    } catch (error) {
      _object.onError(tag, error);
      return ApiFailure(ModelError(message: error.toString()));
    }
  }

  // Suman : Login Api
  static Future<ApiResult> login({
    required String email,
    required String password,
    required String fcmToken,
    String? deviceId,
    String? deviceType,
  }) async {
    const String tag = 'login';

    if (!(await _object.hasInternet() ?? false)) {
      return ApiFailure(ModelError(message: AppString.strNoInternetConnection));
    }

    String? deviceId = await _object.getDeviceID();

    _object.apiLog('$tag baseurl: ${ApiPath.baseUrl}');
    final url = Uri.parse(ApiPath.baseUrl + ApiPath.login);
    _object.apiLog('$tag URL: $url');

    final body = {
      "email": email,
      "password": password,
      "fcm_token": fcmToken,
      "device_id": deviceId,
      'device_type': _object.getDeviceType(),
      "is_app": "true",
    };

    _object.apiLog('$tag body: $body');

    try {
      final response = await http.post(url, body: body);
      _object.apiLog('$tag Response: Status Code: ${response.statusCode}');
      _object.apiLog('$tag Response: ${response.body}');

      var decodedResult = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return ApiSuccess(ModelLogin.fromJson(decodedResult));
      }

      if (response.statusCode == 422) {
        return ApiFailure(ModelError.fromJson(decodedResult));
      }

      return ApiFailure(ModelError(
        message: decodedResult['message'] ?? 'Something went wrong',
      ));
    } on SocketException {
      _object.onSocket(tag);
      return ApiFailure(ModelError(message: 'Unexpected error occurred'));
    } catch (error) {
      _object.onError(tag, error);
      return ApiFailure(ModelError(message: error.toString()));
    }
  }

  // Suman : Forgot Password API
  static Future<ApiResult> forgotPassword({
    required String email,
    String resend = "0",
  }) async {
    const String tag = 'forgotPassword';

    if (!(await _object.hasInternet() ?? false)) {
      return ApiFailure(ModelError(message: AppString.strNoInternetConnection));
    }

    _object.apiLog('$tag baseurl: ${ApiPath.baseUrl}');
    final url = Uri.parse(ApiPath.baseUrl +
        ApiPath.forgotPassword); // Define this path in ApiPath
    _object.apiLog('$tag URL: $url');

    final body = {
      "email": email,
      "resend": resend,
    };

    _object.apiLog('$tag body: $body');

    try {
      final response = await http.post(url, body: body);
      _object.apiLog('$tag Response: Status Code: ${response.statusCode}');
      _object.apiLog('$tag Response: ${response.body}');

      var decodedResult = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return ApiSuccess(ModelCommon.fromJson(decodedResult));
      }

      if (response.statusCode == 422) {
        return ApiFailure(ModelError.fromJson(decodedResult));
      }

      return ApiFailure(ModelError(
        message: decodedResult['message'] ?? 'Something went wrong',
      ));
    } on SocketException {
      _object.onSocket(tag);
      return ApiFailure(ModelError(message: 'Unexpected error occurred'));
    } catch (error) {
      _object.onError(tag, error);
      return ApiFailure(ModelError(message: error.toString()));
    }
  }

  // Suman : Verify OTP API
  static Future<ApiResult> verifyOtp({
    required String email,
    required String otp,
  }) async {
    const String tag = 'verifyOtp';

    if (!(await _object.hasInternet() ?? false)) {
      return ApiFailure(ModelError(message: AppString.strNoInternetConnection));
    }

    _object.apiLog('$tag baseurl: ${ApiPath.baseUrl}');
    final url =
        Uri.parse(ApiPath.baseUrl + ApiPath.verifyOtp);
    _object.apiLog('$tag URL: $url');

    final body = {
      "email": email,
      "otp": otp,
    };

    _object.apiLog('$tag body: $body');

    try {
      final response = await http.post(url, body: body);
      _object.apiLog('$tag Response: Status Code: ${response.statusCode}');
      _object.apiLog('$tag Response: ${response.body}');

      final decodedResult = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return ApiSuccess(ModelCommon.fromJson(decodedResult));
      }

      if (response.statusCode == 422) {
        return ApiFailure(ModelError.fromJson(decodedResult));
      }

      return ApiFailure(ModelError(
        message: decodedResult['message'] ?? 'Something went wrong',
      ));
    } on SocketException {
      _object.onSocket(tag);
      return ApiFailure(ModelError(message: 'Unexpected error occurred'));
    } catch (error) {
      _object.onError(tag, error);
      return ApiFailure(ModelError(message: error.toString()));
    }
  }
}
