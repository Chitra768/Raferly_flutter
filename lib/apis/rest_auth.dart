// ignore_for_file: non_constant_identifier_names, unused_import

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:referaly/controller/business_referrer_contract_controller.dart';
import 'package:referaly/languages/languagekeys.dart';
import 'package:referaly/models/model_accept_list.dart';
import 'package:referaly/models/model_active_goal.dart';
import 'package:referaly/models/model_alreadyhave_card.dart';
import 'package:referaly/models/model_archeive_receive_recover.dart';
import 'package:referaly/models/model_archive_list_receive.dart';
import 'package:referaly/models/model_busniess_referral_lead.dart';
import 'package:referaly/models/model_collaboratorList.dart';
import 'package:referaly/models/model_common.dart';
import 'package:referaly/models/model_company_detail.dart';
import 'package:referaly/models/model_contact_response.dart';
import 'package:referaly/models/model_coworkerlist_deal.dart';
import 'package:referaly/models/model_create_deal.dart';
import 'package:referaly/models/model_dashboard.dart';
import 'package:referaly/models/model_document_list.dart';
import 'package:referaly/models/model_feedback.dart';
import 'package:referaly/models/model_lead_create.dart';
import 'package:referaly/models/model_network_response.dart';
import 'package:referaly/models/model_outofraferaly.dart';
import 'package:referaly/models/model_read_otification.dart';
import 'package:referaly/models/model_receive_lead_delete.dart';
import 'package:referaly/models/model_received_lead.dart';
import 'package:referaly/models/model_redeive_lead_deal.dart';
import 'package:referaly/models/model_register.dart';
import 'package:referaly/models/model_profile.dart';
import 'package:referaly/models/model_send_lead.dart';
import 'package:referaly/models/model_subscription.dart' show SubscriptionModel;
import 'package:referaly/models/model_upload_document.dart';
import 'package:referaly/models/model_version_update.dart';
import 'package:referaly/resources/app_log.dart';
import 'package:referaly/resources/app_preference.dart';
import 'package:referaly/utils/translations.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/model_company_type.dart';
import '../models/model_error.dart';
import '../models/model_how_it_works_list.dart';
import '../models/model_login.dart';

import '../models/model_referral_list.dart';
import '../resources/app_helper.dart';
import '../resources/app_strings.dart';
import 'api_path.dart';
import 'api_result.dart';
import 'base_api.dart';
import 'package:referaly/models/model_company_profile_update.dart';
import 'package:referaly/models/model_api_response.dart';

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
    debugPrint('Register body: $body');
    final headers = await _object.getHeaderWithoutToken();
    debugPrint('Register headers: $headers');

    try {
      final response = await http.post(url, body: body, headers: headers);
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

  // Suman : Register Api
  static Future<ApiResult> updateCompanyType({
    required String companyType,
  }) async {
    const String tag = 'updateCompanyType';

    if (!(await _object.hasInternet() ?? false)) {
      return ApiFailure(ModelError(message: AppString.strNoInternetConnection));
    }

    String? deviceId = await _object.getDeviceID();

    _object.apiLog('$tag baseurl: ${ApiPath.baseUrl}');
    var url = Uri.parse(ApiPath.baseUrl + ApiPath.updateCompanyType);
    _object.apiLog('$tag URL: $url');

    var body = {
      'company_type': companyType,
    };

    _object.apiLog('$tag body: $body');

    try {
      final headers = await _object.getHeaderWithToken();
      headers['Content-Type'] = 'application/json';
      final response = await http.post(url,
          headers: headers, body: jsonEncode({'company_type': companyType}));
      _object.apiLog('$tag Response: Status Code: ${response.statusCode}');
      _object.apiLog('$tag Response: ${response.body}');

      var decodedResult = jsonDecode(response.body);
      _object.apiLog('$tag decodedResult: $decodedResult');
      if (response.statusCode == 200) {
        return ApiSuccess(ModelCompanyType.fromJson(decodedResult));
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
    debugPrint('Login body: $body');

    final headers = await _object.getHeaderWithoutToken();
    debugPrint('Login headers: $headers');

    try {
      final response = await http.post(url, body: body, headers: headers);
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

  // Suman : Get Dashboard Api
  static Future<ApiResult> getDashboard() async {
    const String tag = 'getDashboard';

    if (!(await _object.hasInternet() ?? false)) {
      return ApiFailure(ModelError(message: AppString.strNoInternetConnection));
    }

    _object.apiLog('$tag baseurl: ${ApiPath.baseUrl}');
    final url = Uri.parse(ApiPath.baseUrl + ApiPath.dashboard);
    _object.apiLog('$tag URL: $url');

    try {
      final headers = await _object.getHeaderWithToken();
      _object.apiLog('$tag headers: $headers');
      final response = await http.get(url, headers: headers);
      _object.apiLog('$tag Response: Status Code: ${response.statusCode}');
      _object.apiLog('$tag Response: ${response.body}');

      var decodedResult = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return ApiSuccess(ModelDashboardResponse.fromJson(decodedResult));
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

  // Suman : Get Profile Api
  static Future<ApiResult> getProfile() async {
    const String tag = 'getProfile';

    if (!(await _object.hasInternet() ?? false)) {
      return ApiFailure(ModelError(message: AppString.strNoInternetConnection));
    }

    _object.apiLog('$tag baseurl: ${ApiPath.baseUrl}');
    final url = Uri.parse(ApiPath.baseUrl + ApiPath.profile);
    _object.apiLog('$tag URL: $url');

    try {
      final headers = await _object.getHeaderWithToken();
      final response = await http.get(url, headers: headers);
      _object.apiLog('$tag Response: Status Code: ${response.statusCode}');
      _object.apiLog('$tag Response: ${response.body}');

      var decodedResult = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return ApiSuccess(ModelProfile.fromJson(decodedResult));
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

  static Future<ModelApiResponse<ModelCompanyProfileUpdate>>
      updateCompanyProfile({
    required String name,
    required String description,
    required String address,
    required String businessCode,
    File? image,
    String? imageUrl,
  }) async {
    const String tag = 'updateCompanyProfile';

    if (!(await _object.hasInternet() ?? false)) {
      return ModelApiResponse(
        code: 0,
        status: false,
        message: AppString.strNoInternetConnection,
        pagination: [],
        error: AppString.strNoInternetConnection,
      );
    }

    _object.apiLog('$tag baseurl: ${ApiPath.baseUrl}');
    final uri = Uri.parse(ApiPath.baseUrl + ApiPath.updateCompanyProfile);
    _object.apiLog('$tag URL: $uri');

    try {
      var request = http.MultipartRequest('POST', uri);

      request.fields['company_name'] = name;
      request.fields['company_description'] = description;
      request.fields['company_address'] = address;
      request.fields['company_number'] = businessCode;
      request.fields['company_country_code'] = "2";

      if (image != null) {
        request.files.add(
          await http.MultipartFile.fromPath(
            'company_logo',
            image.path,
          ),
        );
      } else {
        request.fields['company_logo'] = imageUrl!; // <-- Add this line
      }

      final headers = await _object.getHeaderWithToken();
      request.headers.addAll(headers);

      _object.apiLog('$tag Request Headers: ${request.headers}');
      _object.apiLog('$tag Request Fields: ${request.fields}');
      if (image != null) {
        _object.apiLog('$tag Image Path: ${image.path}');
      }

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      _object.apiLog('$tag Response Status Code: ${response.statusCode}');
      _object.apiLog('$tag Response Body: ${response.body}');

      var decodedResult = jsonDecode(response.body);
      return ModelApiResponse.fromJson(
        decodedResult,
        (json) => ModelCompanyProfileUpdate.fromJson(json),
      );
    } on SocketException {
      _object.onSocket(tag);
      return ModelApiResponse(
        code: 0,
        status: false,
        message: 'Unexpected error occurred',
        pagination: [],
        error: 'Unexpected error occurred',
      );
    } catch (error) {
      _object.onError(tag, error);
      return ModelApiResponse(
        code: 0,
        status: false,
        message: error.toString(),
        pagination: [],
        error: error.toString(),
      );
    }
  }

  static Future<ModelApiResponse<ModelCompanyProfileUpdate>> updateProfile({
    required String firstName,
    required String lastName,
    required String email,
    required String phone,
    required String countryCode,
    required String country,
    File? image,
    String? imageUrl,
    required String job,
    required String city,
    required String language,
    required String userType,
  }) async {
    const String tag = 'updateProfile';

    if (!(await _object.hasInternet() ?? false)) {
      return ModelApiResponse(
        code: 0,
        status: false,
        message: AppString.strNoInternetConnection,
        pagination: [],
        error: AppString.strNoInternetConnection,
      );
    }

    _object.apiLog('$tag baseurl: ${ApiPath.baseUrl}');
    final uri = Uri.parse(ApiPath.baseUrl + ApiPath.updateProfile);
    _object.apiLog('$tag URL: $uri');

    try {
      var request = http.MultipartRequest('POST', uri);

      request.fields['first_name'] = firstName;
      request.fields['last_name'] = lastName;
      request.fields['email'] = email;
      request.fields['phone_number'] = phone;
      request.fields['country_code'] = countryCode;
      request.fields['industry'] = job;
      request.fields['country'] = country;
      request.fields['city'] = city;
      request.fields['lang'] = language;
      request.fields['job'] = job;
      request.fields['company_type'] = userType;

      if (image != null) {
        request.files.add(
          await http.MultipartFile.fromPath(
            'avatar',
            image.path,
          ),
        );
      } else {
        request.fields['avatar'] = imageUrl!; // <-- Add this line
      }

      final headers = await _object.getHeaderWithToken();
      request.headers.addAll(headers);

      _object.apiLog('$tag Request Headers: ${request.headers}');
      _object.apiLog('$tag Request Fields: ${request.fields}');
      if (image != null) {
        _object.apiLog('$tag Image Path: ${image.path}');
      }

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      _object.apiLog('$tag Response Status Code: ${response.statusCode}');
      _object.apiLog('$tag Response Body: ${response.body}');
      print("response.body: ${response.body}");

      var decodedResult = jsonDecode(response.body);
      return ModelApiResponse.fromJson(
        decodedResult,
        (json) => ModelCompanyProfileUpdate.fromJson(json),
      );
    } on SocketException {
      _object.onSocket(tag);
      return ModelApiResponse(
        code: 0,
        status: false,
        message: 'Unexpected error occurred',
        pagination: [],
        error: 'Unexpected error occurred',
      );
    } catch (error) {
      _object.onError(tag, error);
      print("error: $error");
      return ModelApiResponse(
        code: 0,
        status: false,
        message: error.toString(),
        pagination: [],
        error: error.toString(),
      );
    }
  }

  static Future<SubscriptionModel> updateSubscription({
    required String amount,
    required String receipt,
    required String device_type,
    required String currency,
    required String product_id,
  }) async {
    const String tag = 'updateSubscription';

    if (!(await _object.hasInternet() ?? false)) {
      return SubscriptionModel(
        code: 0,
        status: false,
        message: AppString.strNoInternetConnection,
      );
    }

    _object.apiLog('$tag baseurl: ${ApiPath.baseUrl}');
    final uri = Uri.parse(ApiPath.baseUrl + ApiPath.updateSubscription);
    _object.apiLog('$tag URL: $uri');

    try {
      var request = http.MultipartRequest('POST', uri);

      request.fields['amount'] = amount;
      request.fields['receipt'] = receipt;
      request.fields['device_type'] = device_type;
      request.fields['currency'] = currency;
      request.fields['product_id'] = product_id;

      final headers = await _object.getHeaderWithToken();
      request.headers.addAll(headers);

      _object.apiLog('$tag Request Headers: ${request.headers}');
      _object.apiLog('$tag Request Fields: ${request.fields}');

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      _object.apiLog('$tag Response Status Code: ${response.statusCode}');
      _object.apiLog('$tag Response Body: ${response.body}');

      var decodedResult = jsonDecode(response.body);
      return SubscriptionModel.fromJson(
        decodedResult,
      );
    } on SocketException {
      _object.onSocket(tag);
      return SubscriptionModel(
        code: 0,
        status: false,
        message: 'Unexpected error occurred',
      );
    } catch (error) {
      _object.onError(tag, error);
      return SubscriptionModel(
        code: 0,
        status: false,
        message: error.toString(),
      );
    }
  }

  static Future<FeedbackModel> submitFeedback({
    required String type,
    required String description,
    required String email,
  }) async {
    const String tag = 'submitFeedback';

    if (!(await _object.hasInternet() ?? false)) {
      return FeedbackModel(
        code: 0,
        status: false,
        message: AppString.strNoInternetConnection,
      );
    }

    _object.apiLog('$tag baseurl: ${ApiPath.baseUrl}');
    final uri = Uri.parse(ApiPath.baseUrl + ApiPath.submitFeedback);
    _object.apiLog('$tag URL: $uri');

    try {
      var request = http.MultipartRequest('POST', uri);

      request.fields['type'] = type == "Feature idea" ? "feature_idea" : "bug";
      request.fields['description'] = description;
      request.fields['email'] = email;

      final headers = await _object.getHeaderWithToken();
      request.headers.addAll(headers);

      _object.apiLog('$tag Request Headers: ${request.headers}');
      _object.apiLog('$tag Request Fields: ${request.fields}');

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      _object.apiLog('$tag Response Status Code: ${response.statusCode}');
      _object.apiLog('$tag Response Body: ${response.body}');

      var decodedResult = jsonDecode(response.body);
      return FeedbackModel.fromJson(
        decodedResult,
      );
    } on SocketException {
      _object.onSocket(tag);
      return FeedbackModel(
        code: 0,
        status: false,
        message: 'Unexpected error occurred',
      );
    } catch (error) {
      _object.onError(tag, error);
      return FeedbackModel(
        code: 0,
        status: false,
        message: error.toString(),
      );
    }
  }

  static Future<ApiResult> getLeads(
      {int limit = 10, int page = 1, String order = "desc"}) async {
    const String tag = 'getLeads';

    if (!(await _object.hasInternet() ?? false)) {
      return ApiFailure(ModelError(message: AppString.strNoInternetConnection));
    }

    _object.apiLog('$tag baseurl: ${ApiPath.baseUrl}');
    final url = Uri.parse(
        '${ApiPath.baseUrl}${ApiPath.getLeads}?limit=${limit.toString()}&page=${page.toString()}&order=$order');
    _object.apiLog('$tag URL: $url');

    try {
      final headers = await _object.getHeaderWithToken();
      final response = await http.get(url, headers: headers);
      _object.apiLog('$tag Response: Status Code: ${response.statusCode}');
      _object.apiLog('$tag Response: ${response.body}');

      var decodedResult = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return ApiSuccess(ModelReceivedLead.fromJson(decodedResult));
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

  static Future<ApiResult> getSendLeads({int limit = 10, int page = 1}) async {
    const String tag = 'getSendLeads';

    if (!(await _object.hasInternet() ?? false)) {
      return ApiFailure(ModelError(message: AppString.strNoInternetConnection));
    }

    _object.apiLog('$tag baseurl: ${ApiPath.baseUrl}');
    final url = Uri.parse(
        '${ApiPath.baseUrl}${ApiPath.getSendLeads}?limit=${limit.toString()}&page=${page.toString()}');
    _object.apiLog('$tag URL: $url');

    try {
      final headers = await _object.getHeaderWithToken();
      final response = await http.get(url, headers: headers);
      _object.apiLog('$tag Response: Status Code: ${response.statusCode}');
      _object.apiLog('$tag Response: ${response.body}');

      var decodedResult = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return ApiSuccess(ModelSendLead.fromJson(decodedResult));
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

  static Future<ApiResult> getArchiveList(
      {String order = "asc", String type = "receive"}) async {
    const String tag = 'getArchiveList';

    if (!(await _object.hasInternet() ?? false)) {
      return ApiFailure(ModelError(message: AppString.strNoInternetConnection));
    }

    _object.apiLog('$tag baseurl: ${ApiPath.baseUrl}');
    final url = Uri.parse(
        '${ApiPath.baseUrl}${type == "receive" ? ApiPath.getArchiveList : ApiPath.getArchiveSendList}?order=$order');
    _object.apiLog('$tag URL: $url');

    try {
      final headers = await _object.getHeaderWithToken();
      final response = await http.get(url, headers: headers);
      _object.apiLog('$tag Response: Status Code: ${response.statusCode}');
      _object.apiLog('$tag Response: ${response.body}');

      var decodedResult = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return ApiSuccess(ModelArchiveListReceive.fromJson(decodedResult));
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

  static Future<ApiResult> deleteReceivedLead(
      {int? leadId, required List<Map<String, Object?>> lostReasons}) async {
    const String tag = 'deleteReceivedLead';
    AppHelper.showLog("lostReasons: ${lostReasons.toString()}");
    AppHelper.showLog("leadId: $leadId");

    if (!(await _object.hasInternet() ?? false)) {
      return ApiFailure(ModelError(message: AppString.strNoInternetConnection));
    }

    _object.apiLog('$tag baseurl: ${ApiPath.baseUrl}');
    final url = Uri.parse('${ApiPath.baseUrl}${ApiPath.deleteReceivedLead}');
    _object.apiLog('$tag URL: $url');

    _object.apiLog(
        '$tag Body: ${jsonEncode({"id": leadId, "lost_reason": lostReasons})}');
    try {
      final headers = await _object.getHeaderWithToken();
      final response = await http.post(url,
          headers: headers,
          body: jsonEncode({"id": leadId, "lost_reason": lostReasons}));
      _object.apiLog('$tag Response: Status Code: ${response.statusCode}');
      _object.apiLog('$tag Response: ${response.body}');

      var decodedResult = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return ApiSuccess(ModelReceiveLeadDelete.fromJson(decodedResult));
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

  static Future<ApiResult> requestToUpdateLead(
      {int? leadId, }) async {
    const String tag = 'requestToUpdateLead';
    AppHelper.showLog("leadId: $leadId");

    if (!(await _object.hasInternet() ?? false)) {
      return ApiFailure(ModelError(message: AppString.strNoInternetConnection));
    }

    _object.apiLog('$tag baseurl: ${ApiPath.baseUrl}');
    final url = Uri.parse('${ApiPath.baseUrl}${ApiPath.requestToUpdateLead}');
    _object.apiLog('$tag URL: $url');

    _object.apiLog('$tag Body: ${jsonEncode({"lead_id": leadId})}');
    try {
      final headers = await _object.getHeaderWithToken();
      final response = await http.post(url,
          headers: headers,
          body: jsonEncode({"lead_id": leadId}));
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
  static Future<ApiResult> recoverArchiveLead({required String leadId}) async {
    const String tag = 'recoverArchiveLead';

    if (!(await _object.hasInternet() ?? false)) {
      return ApiFailure(ModelError(message: AppString.strNoInternetConnection));
    }

    _object.apiLog('$tag baseurl: ${ApiPath.baseUrl}');
    final url = Uri.parse('${ApiPath.baseUrl}${ApiPath.recoverReceivedLead}');
    _object.apiLog('$tag URL: $url');
    _object.apiLog('$tag leadId: $leadId');

    try {
      final headers = await _object.getHeaderWithToken();
      headers['app-language'] = AppPreference.getLanguage();
      final response = await http.post(url,
          headers: headers, body: jsonEncode({"id": leadId}));
      _object.apiLog('$tag Response: Status Code: ${response.statusCode}');
      _object.apiLog('$tag Response: ${response.body}');

      var decodedResult = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return ApiSuccess(ModelArcheiveReceiveRecover.fromJson(decodedResult));
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

  static Future<ApiResult> getAcceptList() async {
    const String tag = 'getAcceptList';

    if (!(await _object.hasInternet() ?? false)) {
      return ApiFailure(ModelError(message: AppString.strNoInternetConnection));
    }

    _object.apiLog('$tag baseurl: ${ApiPath.baseUrl}');
    final url = Uri.parse('${ApiPath.baseUrl}${ApiPath.getAcceptList}');
    _object.apiLog('$tag URL: $url');

    try {
      final headers = await _object.getHeaderWithToken();
      final response = await http.get(url, headers: headers);
      _object.apiLog('$tag Response: Status Code: ${response.statusCode}');
      _object.apiLog('$tag Response: ${response.body}');

      var decodedResult = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return ApiSuccess(ModelAcceptList.fromJson(decodedResult));
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

  static Future<ApiResult> getNetworkList() async {
    const String tag = 'getNetworkList';

    if (!(await _object.hasInternet() ?? false)) {
      return ApiFailure(ModelError(message: AppString.strNoInternetConnection));
    }

    _object.apiLog('$tag baseurl: ${ApiPath.baseUrl}');
    final url = Uri.parse('${ApiPath.baseUrl}${ApiPath.getNetworkList}');
    _object.apiLog('$tag URL: $url');

    try {
      final headers = await _object.getHeaderWithToken();
      final response = await http.get(url, headers: headers);
      _object.apiLog('$tag Response: Status Code: ${response.statusCode}');
      _object.apiLog('$tag Response: ${response.body}');

      var decodedResult = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return ApiSuccess(ModelNetworkResponse.fromJson(decodedResult));
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

  static Future<ApiResult> getContactList() async {
    const String tag = 'getContactList';

    if (!(await _object.hasInternet() ?? false)) {
      return ApiFailure(ModelError(message: AppString.strNoInternetConnection));
    }

    _object.apiLog('$tag baseurl: ${ApiPath.baseUrl}');
    final url = Uri.parse('${ApiPath.baseUrl}${ApiPath.getContactList}');
    _object.apiLog('$tag URL: $url');

    try {
      final headers = await _object.getHeaderWithToken();
      final response = await http.get(url, headers: headers);
      _object.apiLog('$tag Response: Status Code: ${response.statusCode}');
      _object.apiLog('$tag Response: ${response.body}');

      var decodedResult = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return ApiSuccess(ModelContactResponse.fromJson(decodedResult));
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

  static Future<ApiResult> createDeal(String dealName, String commissionType,
      String description, List<String> trackName, String commissionValue,
      {File? pdfFile,
      bool isUniqueCommission = false,
      List<Map<String, String>> cases = const []}) async {
    const String tag = 'createDeal';

    if (!(await _object.hasInternet() ?? false)) {
      return ApiFailure(ModelError(message: AppString.strNoInternetConnection));
    }

    // Map commission type display values to API values
    String getCommissionTypeValue(String displayValue) {
      switch (displayValue.toLowerCase()) {
        case 'no_commission':
          return 'no_commission';
        case 'fix_commission':
          return 'fix_commission';
        case 'percentage_commission':
          return 'percentage_commission';
        default:
          return displayValue.toLowerCase().replaceAll(' ', '_');
      }
    }

    String getCommissionTypeValue1(String? value) {
      if (value == "no_commission") {
        return 'no_commission';
      } else if (value == "percentage_commission") {
        return 'percentage_commission';
      } else if (value == "fix_commission") {
        return 'fix_commission';
      }
      return 'no_commission'; // default fallback
    }

    _object.apiLog('$tag baseurl: ${ApiPath.baseUrl}');
    final url = Uri.parse('${ApiPath.baseUrl}${ApiPath.createDeal}');
    _object.apiLog('$tag URL: $url');
    _object.apiLog('$tag deal_name: $dealName');
    _object.apiLog('$tag commissionType: $commissionType');
    _object.apiLog('$tag commissionValue: $commissionValue');
    _object.apiLog(
        '$tag commission_type: $getCommissionTypeValue(commissionType)');
    _object.apiLog('$tag description: $description');
    _object.apiLog('$tag track_name: $trackName');
    _object.apiLog('$tag pdfFile: $pdfFile');
    List<Map<String, dynamic>> convertedCases = cases.map((caseItem) {
      return {
        'id': caseItem['id'] ?? "0",
        'lead_type': caseItem['lead_type'] ?? "",
        'commission_type': getCommissionTypeValue1(caseItem['commission_type']),
        'commission_value': caseItem['commission_value']!.isNotEmpty
            ? caseItem['commission_value']
            : "0"
      };
    }).toList();

    AppHelper.showLog("convertedCases: $convertedCases");

    try {
      final headers = await _object.getHeaderWithToken();
      headers['Content-Type'] = 'application/json';
      headers['app-language'] = AppPreference.getLanguage();
      if (pdfFile != null) {
        // Use multipart request for file upload
        var request = http.MultipartRequest('POST', url);
        request.headers.addAll(headers);

        request.fields['deal_name'] = dealName;
        request.fields['commission_type'] =
            getCommissionTypeValue(commissionType);
        if (getCommissionTypeValue(commissionType) != 'no_commission') {
          request.fields['commission_value'] = commissionValue;
        }
        request.fields['description'] = description;
        for (var name in trackName) {
          request.fields['track_name[]'] = name.trim();
        }
        request.fields['deal_commission_type'] = isUniqueCommission ? '1' : '2';
        request.fields['document_uploaded_manually'] = '1';
        if (!isUniqueCommission && cases.isNotEmpty) {
          request.fields['cases'] = jsonEncode(cases);
        }

        request.files.add(
          await http.MultipartFile.fromPath(
            'document',
            pdfFile.path,
          ),
        );

        final streamedResponse = await request.send();
        final response = await http.Response.fromStream(streamedResponse);

        _object.apiLog('$tag Response: Status Code: ${response.statusCode}');
        _object.apiLog('$tag Response: ${response.body}');

        var decodedResult = jsonDecode(response.body);
        if (response.statusCode == 200) {
          return ApiSuccess(ModelCreateDeal.fromJson(decodedResult));
        }

        if (response.statusCode == 422) {
          return ApiFailure(ModelError.fromJson(decodedResult));
        }

        return ApiFailure(ModelError(
          message: decodedResult['message'] ?? 'Something went wrong',
        ));
      } else {
        // Use regular JSON request if no file
        headers['Content-Type'] = 'application/json';
        final Map<String, dynamic> requestBody = {
          'deal_name': dealName,
          if (isUniqueCommission)
            'commission_type': getCommissionTypeValue(commissionType),
          if (isUniqueCommission)
            if (getCommissionTypeValue(commissionType) != 'no_commission')
              'commission_value': commissionValue,
          'description': description,
          'track_name': trackName.map((name) => name.trim()).toList(),
          'document_uploaded_manually': 0,
          'deal_commission_type': isUniqueCommission ? 1 : 2,
          if (!isUniqueCommission && cases.isNotEmpty) 'cases': convertedCases,
        };

        final response = await http.post(
          url,
          headers: headers,
          body: jsonEncode(requestBody),
        );

        _object.apiLog('$tag Response: Status Code: ${response.statusCode}');
        _object.apiLog('$tag Response: ${response.body}');

        var decodedResult = jsonDecode(response.body);
        if (response.statusCode == 200) {
          return ApiSuccess(ModelCreateDeal.fromJson(decodedResult));
        }

        if (response.statusCode == 422) {
          return ApiFailure(ModelError.fromJson(decodedResult));
        }

        return ApiFailure(ModelError(
          message: decodedResult['message'] ?? 'Something went wrong',
        ));
      }
    } on SocketException {
      _object.onSocket(tag);
      return ApiFailure(ModelError(message: 'Unexpected error occurred'));
    } catch (error) {
      _object.onError(tag, error);
      return ApiFailure(ModelError(message: error.toString()));
    }
  }

  static Future<ApiResult> updateDeal(
      String dealName,
      String commissionType,
      String description,
      String id,
      String commissionValue,
      List<BusinessDealSteps> dealSteps,
      {File? pdfFile,
      bool isUniqueCommission = false,
      List<Map<String, String>> cases = const []}) async {
    const String tag = 'updateDeal';

    if (!(await _object.hasInternet() ?? false)) {
      return ApiFailure(ModelError(message: AppString.strNoInternetConnection));
    }

    // Map commission type display values to API values
    String getCommissionTypeValue(String displayValue) {
      switch (displayValue.toLowerCase()) {
        case 'no_commission':
          return 'no_commission';
        case 'fix_commission':
          return 'fix_commission';
        case 'percentage_commission':
          return 'percentage_commission';
        default:
          return displayValue.toLowerCase().replaceAll(' ', '_');
      }
    }

    String getCommissionTypeValue1(String? value) {
      if (value == "no_commission") {
        return 'no_commission';
      } else if (value == "percentage_commission") {
        return 'percentage_commission';
      } else if (value == "fix_commission") {
        return 'fix_commission';
      }
      return 'no_commission'; // default fallback
    }

    List<Map<String, dynamic>> convertedCases = cases.map((caseItem) {
      return {
        'id': caseItem['id'] ?? "0",
        'lead_type': caseItem['lead_type'] ?? "",
        'commission_type': getCommissionTypeValue1(caseItem['commission_type']),
        'commission_value': caseItem['commission_value']!.isNotEmpty
            ? caseItem['commission_value']
            : "0"
      };
    }).toList();
    _object.apiLog('$tag baseurl: ${ApiPath.baseUrl}');
    final url = Uri.parse('${ApiPath.baseUrl}${ApiPath.updateDeal}');
    _object.apiLog('$tag URL: $url');
    _object.apiLog('$tag deal_name: $dealName');
    _object.apiLog(
        '$tag commission_type: $getCommissionTypeValue(commissionType)');
    _object.apiLog('$tag description: $description');
    _object.apiLog('$tag track_name: $dealSteps');
    _object.apiLog('updateDeal: ${jsonEncode({
          'deal_name': dealName,
          'commission_type': getCommissionTypeValue(commissionType),
          'description': description,
          if (getCommissionTypeValue(commissionType) != 'no_commission')
            'commission_value': commissionValue,
          'track_name': dealSteps,
          'deal_commission_type': 1,
          'document_uploaded_manually': 0,
          'id': id,
        })}');

    try {
      final headers = await _object.getHeaderWithToken();
      _object.apiLog('$tag headers: $headers');

      if (pdfFile != null) {
        // Use multipart request for file upload
        var request = http.MultipartRequest('POST', url);
        request.headers.addAll(headers);

        request.fields['deal_name'] = dealName;
        request.fields['commission_type'] =
            getCommissionTypeValue(commissionType);
        request.fields['commission_value'] = commissionValue;
        request.fields['description'] = description;
        request.fields['track_name'] = jsonEncode(dealSteps);
        request.fields['deal_commission_type'] = '1';
        request.fields['document_uploaded_manually'] = '1';
        request.fields['id'] = id;

        request.files.add(
          await http.MultipartFile.fromPath(
            'document',
            pdfFile.path,
          ),
        );

        final streamedResponse = await request.send();
        final response = await http.Response.fromStream(streamedResponse);

        _object.apiLog('$tag Response: Status Code: ${response.statusCode}');
        _object.apiLog('$tag Response: ${response.body}');

        var decodedResult = jsonDecode(response.body);
        if (response.statusCode == 200) {
          return ApiSuccess(ModelCreateDeal.fromJson(decodedResult));
        }

        if (response.statusCode == 422) {
          return ApiFailure(ModelError.fromJson(decodedResult));
        }

        return ApiFailure(ModelError(
          message: decodedResult['message'] ?? 'Something went wrong',
        ));
      } else {
        // Use regular JSON request if no file
        headers['Content-Type'] = 'application/json';
        final Map<String, dynamic> requestBody = {
          'deal_name': dealName,
          if (isUniqueCommission)
            'commission_type': getCommissionTypeValue(commissionType),
          if (isUniqueCommission)
            if (getCommissionTypeValue(commissionType) != 'no_commission')
              'commission_value': commissionValue,
          'description': description,
          'track_name': dealSteps,
          'document_uploaded_manually': 0,
          'deal_commission_type': isUniqueCommission ? 1 : 2,
          if (!isUniqueCommission && cases.isNotEmpty) 'cases': convertedCases,
          'id': id,
        };
        final response = await http.post(url,
            headers: headers,
            body: jsonEncode({
              'deal_name': dealName,
              if (isUniqueCommission)
                'commission_type': getCommissionTypeValue(commissionType),
              if (isUniqueCommission)
                if (getCommissionTypeValue(commissionType) != 'no_commission')
                  'commission_value': commissionValue,
              'description': description,
              'track_name': dealSteps,
              'deal_commission_type': isUniqueCommission ? 1 : 2,
              'document_uploaded_manually': 0,
              if (!isUniqueCommission && cases.isNotEmpty)
                'cases': convertedCases,
              'id': id,
            }));
        _object.apiLog('$tag Response: Status Code: ${response.statusCode}');
        _object.apiLog('$tag Response: ${response.body}');

        var decodedResult = jsonDecode(response.body);
        if (response.statusCode == 200) {
          return ApiSuccess(ModelCreateDeal.fromJson(decodedResult));
        }

        if (response.statusCode == 422) {
          return ApiFailure(ModelError.fromJson(decodedResult));
        }

        return ApiFailure(ModelError(
          message: decodedResult['message'] ?? 'Something went wrong',
        ));
      }
    } on SocketException {
      _object.onSocket(tag);
      return ApiFailure(ModelError(message: 'Unexpected error occurred'));
    } catch (error) {
      _object.onError(tag, error);
      return ApiFailure(ModelError(message: error.toString()));
    }
  }

  static Future<ApiResult> createLead(
    String firstName,
    String lastName,
    String phoneNumber,
    String email,
    String description,
    String leadAssignType,
    String dealId,
    String businessDealId,
    String businessReferrerId,
    String createdBy,
  ) async {
    const String tag = 'createLead';

    if (!(await _object.hasInternet() ?? false)) {
      return ApiFailure(ModelError(message: AppString.strNoInternetConnection));
    }

    _object.apiLog('$tag baseurl: ${ApiPath.baseUrl}');
    final url = Uri.parse('${ApiPath.baseUrl}${ApiPath.createLead}');
    _object.apiLog('$tag URL: $url');
    _object.apiLog('$tag first_name: $firstName');
    _object.apiLog('$tag leadAssignType: $leadAssignType');
    _object.apiLog('$tag dealId: $dealId');
    _object.apiLog('$tag business_referral_id: $businessReferrerId');
    _object.apiLog('$tag business_deal_id: $businessDealId');

    int getDisplayText(String? type) {
      if (type == tr(LanguageKeys.mySelf)) {
        return 3;
      } else if (type == tr(LanguageKeys.businessReferrer)) {
        return 2;
      } else {
        return 4;
      }
    }

    _object.apiLog('$tag Body: ${jsonEncode({
          "first_name": firstName,
          "last_name": lastName,
          "email": email,
          "description": description,
          "phone_number": phoneNumber,
          "lead_assign_type": getDisplayText(leadAssignType),
          'deal_id': dealId,
          "business_referral_id": businessReferrerId,
          "business_deal_id": businessDealId,
          "created_by": createdBy
        })}');
    try {
      final headers = await _object.getHeaderWithToken();
      headers['Content-Type'] = 'application/json';
      final response = await http.post(url,
          headers: headers,
          body: jsonEncode({
            "first_name": firstName,
            "last_name": lastName,
            "email": email,
            "description": description,
            "phone_number": phoneNumber,
            "lead_assign_type": getDisplayText(leadAssignType),
            'deal_id': dealId,
            "business_referral_id": businessReferrerId,
            "business_deal_id": businessDealId,
            "created_by": createdBy
          }));
      _object.apiLog('$tag Response: Status Code: ${response.statusCode}');
      _object.apiLog('$tag Response: ${response.body}');

      var decodedResult = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return ApiSuccess(ModelLeadCreate.fromJson(decodedResult));
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

  static Future<ApiResult> createLeadOutofRaferaly(
    String firstName,
    String lastName,
    String phoneNumber,
    String email,
    String description,
    String commission_type,
    String commission_value,
    List<String> track_name,
  ) async {
    const String tag = 'createLeadOutofRaferaly';

    if (!(await _object.hasInternet() ?? false)) {
      return ApiFailure(ModelError(message: AppString.strNoInternetConnection));
    }

    _object.apiLog('$tag baseurl: ${ApiPath.baseUrl}');
    final url =
        Uri.parse('${ApiPath.baseUrl}${ApiPath.createLeadOutofRaferaly}');
    _object.apiLog('$tag URL: $url');

    Object getCommissionTypeValue(String displayValue) {
      final lowerValue = displayValue.toLowerCase();
      if (lowerValue == tr(LanguageKeys.no_commission).toLowerCase()) {
        return 'no_commission';
      } else if (lowerValue == tr(LanguageKeys.fix_commission).toLowerCase()) {
        return 'fix_commission';
      } else if (lowerValue ==
          tr(LanguageKeys.percentage_commission).toLowerCase()) {
        return 'percentage_commission';
      }
      return 'no_commission';
    }

    // Prepare request body, only include commission_value if not no_commission
    final commissionTypeValue = getCommissionTypeValue(commission_type);
    final Map<String, dynamic> requestBody = {
      "first_name": firstName,
      "last_name": lastName,
      "phone_number": phoneNumber,
      "email": email,
      "description": description,
      "commission_type": commissionTypeValue,
      "track_name": track_name,
    };
    if (commissionTypeValue != 'no_commission') {
      requestBody["commission_value"] = commission_value;
    }

    _object.apiLog('	$tag Body: 	' + jsonEncode(requestBody));
    try {
      final headers = await _object.getHeaderWithToken();
      headers['Content-Type'] = 'application/json';
      final response =
          await http.post(url, headers: headers, body: jsonEncode(requestBody));
      _object.apiLog('$tag Response: Status Code: ${response.statusCode}');
      _object.apiLog('$tag Response: ${response.body}');

      var decodedResult = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return ApiSuccess(ModelOutofraferaly.fromJson(decodedResult));
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
    final url = Uri.parse(ApiPath.baseUrl + ApiPath.verifyOtp);
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

  static Future<ApiResult> resetPassword({
    required String email,
    required String newPassword,
  }) async {
    const String tag = 'resetPassword';

    if (!(await _object.hasInternet() ?? false)) {
      return ApiFailure(ModelError(message: AppString.strNoInternetConnection));
    }

    _object.apiLog('$tag baseurl: ${ApiPath.baseUrl}');
    final url = Uri.parse(ApiPath.baseUrl + ApiPath.resetPassword);
    _object.apiLog('$tag URL: $url');

    final body = {
      "email": email,
      "password": newPassword,
      "password_confirmation": newPassword,
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

  // Suman :socialSignUpLogin API
  static Future<ApiResult> socialSignUpLogin({
    required String deviceId,
    required String deviceType,
    required String fcmToken,
    required String firstName,
    required String lastName,
    required String socialType,
    required String tokenId,
  }) async {
    const String tag = 'socialSignUpLogin';

    if (!(await _object.hasInternet() ?? false)) {
      return ApiFailure(ModelError(message: AppString.strNoInternetConnection));
    }

    _object.apiLog('$tag baseurl: ${ApiPath.baseUrl}');
    final url = Uri.parse(ApiPath.baseUrl + ApiPath.socialSignInSignUp);
    _object.apiLog('$tag URL: $url');

    final Map<String, dynamic> body = {
      "device_id": deviceId,
      "device_type": deviceType,
      "fcm_token": fcmToken,
      "first_name": firstName,
      "last_name": lastName,
      "social_type": socialType,
      "token_id": tokenId,
    };

    _object.apiLog('$tag body: ${jsonEncode(body)}');

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(body),
      );

      _object.apiLog('$tag Response: Status Code: ${response.statusCode}');
      _object.apiLog('$tag Response: ${response.body}');

      final decodedResult = jsonDecode(response.body);

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

  static Future<ApiResult> businessReferralDealList() async {
    const String tag = 'businessReferralDealList';

    if (!(await _object.hasInternet() ?? false)) {
      return ApiFailure(ModelError(message: AppString.strNoInternetConnection));
    }

    _object.apiLog('$tag baseurl: ${ApiPath.baseUrl}');
    final url =
        Uri.parse('${ApiPath.baseUrl}${ApiPath.businessReferralDealList}');
    _object.apiLog('$tag URL: $url');

    try {
      final headers = await _object.getHeaderWithToken();
      headers['Content-Type'] = 'application/json';
      final response = await http.get(
        url,
        headers: headers,
      );
      _object.apiLog('$tag Response: Status Code: ${response.statusCode}');
      _object.apiLog('$tag Response: ${response.body}');

      var decodedResult = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return ApiSuccess(ModelRedeiveLeadDeal.fromJson(decodedResult));
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

  static Future<ApiResult> businessReferralLead(
    String search,
    String id,
  ) async {
    const String tag = 'businessReferralLead';

    if (!(await _object.hasInternet() ?? false)) {
      return ApiFailure(ModelError(message: AppString.strNoInternetConnection));
    }

    _object.apiLog('$tag baseurl: ${ApiPath.baseUrl}');
    final url = Uri.parse('${ApiPath.baseUrl}${ApiPath.businessReferralLead}');
    _object.apiLog('$tag URL: $url');

    _object.apiLog('$tag Body: ${jsonEncode({
          'search': search,
          'id': id,
        })}');
    try {
      final headers = await _object.getHeaderWithToken();
      headers['Content-Type'] = 'application/json';
      final response = await http.post(url,
          headers: headers,
          body: jsonEncode({
            "search": search,
            "id": id,
          }));
      _object.apiLog('$tag Response: Status Code: ${response.statusCode}');
      _object.apiLog('$tag Response: ${response.body}');

      var decodedResult = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return ApiSuccess(ModelBusinessReferralLead.fromJson(decodedResult));
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

  static Future<ApiResult> deleteDeal({
    required String id,
  }) async {
    const String tag = 'deleteDeal';

    if (!(await _object.hasInternet() ?? false)) {
      return ApiFailure(ModelError(message: AppString.strNoInternetConnection));
    }

    _object.apiLog('$tag baseurl: ${ApiPath.baseUrl}');
    final url = Uri.parse('${ApiPath.baseUrl}${ApiPath.deleteDeal}');
    _object.apiLog('$tag URL: $url');

    try {
      final headers = await _object.getHeaderWithToken();
      headers['Content-Type'] = 'application/json';
      final response =
          await http.post(url, headers: headers, body: jsonEncode({"id": id}));
      _object.apiLog('$tag Response: Status Code: ${response.statusCode}');
      _object.apiLog('$tag Response: ${response.body}');

      var decodedResult = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return ApiSuccess(ModelReceiveLeadDelete.fromJson(decodedResult));
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

// cowokrer list user list
  static Future<ApiResult> getUserDealList() async {
    const String tag = 'getUserDealList';

    if (!(await _object.hasInternet() ?? false)) {
      return ApiFailure(ModelError(message: AppString.strNoInternetConnection));
    }

    _object.apiLog('$tag baseurl: ${ApiPath.baseUrl}');
    final url = Uri.parse('${ApiPath.baseUrl}${ApiPath.getUserDealList}');
    _object.apiLog('$tag URL: $url');

    try {
      final headers = await _object.getHeaderWithToken();
      final response = await http.get(url, headers: headers);
      _object.apiLog('$tag Response: Status Code: ${response.statusCode}');
      _object.apiLog('$tag Response: ${response.body}');

      var decodedResult = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return ApiSuccess(ModelCoworkerlistDeal.fromJson(decodedResult));
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

  // active goal user list
  static Future<ApiResult> getActiveGoal(
    int limit,
    int page,
  ) async {
    const String tag = 'getActiveGoal';

    if (!(await _object.hasInternet() ?? false)) {
      return ApiFailure(ModelError(message: AppString.strNoInternetConnection));
    }

    _object.apiLog('$tag baseurl: ${ApiPath.baseUrl}');
    final url = Uri.parse('${ApiPath.baseUrl}${ApiPath.getActiveGoal}');
    _object.apiLog('$tag URL: $url');

    try {
      final headers = await _object.getHeaderWithToken();
      final response = await http.post(
        url,
        headers: headers,
        body: jsonEncode(
          {
            "limit": limit,
            "page": page,
          },
        ),
      );
      _object.apiLog('$tag Response: Status Code: ${response.statusCode}');
      _object.apiLog('$tag Response: ${response.body}');

      var decodedResult = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return ApiSuccess(ModelActiveGoal.fromJson(decodedResult));
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

  static Future<ApiResult> updateLead(
    String firstName,
    String lastName,
    String phoneNumber,
    String email,
    String description,
    String leadAssignType,
    String dealId,
    String id,
    String createdBy,
  ) async {
    const String tag = 'updateLead';

    if (!(await _object.hasInternet() ?? false)) {
      return ApiFailure(ModelError(message: AppString.strNoInternetConnection));
    }

    _object.apiLog('$tag baseurl: ${ApiPath.baseUrl}');
    final url = Uri.parse('${ApiPath.baseUrl}${ApiPath.updateLead}');
    _object.apiLog('$tag URL: $url');
    _object.apiLog('$tag first_name: $firstName');
    _object.apiLog('$tag leadAssignType: $leadAssignType');

    int getDisplayText(String? type) {
      if (type == "3") {
        return 3;
      } else if (type == "4") {
        return 4;
      } else {
        return 3;
      }
    }

    _object.apiLog('$tag Body: ${jsonEncode({
          'first_name': firstName,
          'last_name': lastName,
          'phone_number': phoneNumber,
          'email': email,
          'description': description,
          'lead_assign_type': getDisplayText(leadAssignType),
          'deal_id': dealId,
          'id': id,
        })}');
    try {
      final headers = await _object.getHeaderWithToken();
      headers['Content-Type'] = 'application/json';
      final response = await http.post(url,
          headers: headers,
          body: jsonEncode({
            "first_name": firstName,
            "last_name": lastName,
            "deal_id": dealId,
            "email": email,
            "description": description,
            "phone_number": phoneNumber,
            "lead_assign_type": getDisplayText(leadAssignType),
            "id": id,
            "created_by": createdBy,
          }));
      _object.apiLog('$tag Response: Status Code: ${response.statusCode}');
      _object.apiLog('$tag Response: ${response.body}');

      var decodedResult = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return ApiSuccess(ModelLeadCreate.fromJson(decodedResult));
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

  static Future<ApiResult> getDocumentList(
    String id,
  ) async {
    const String tag = 'getDocumentList';

    if (!(await _object.hasInternet() ?? false)) {
      return ApiFailure(ModelError(message: AppString.strNoInternetConnection));
    }

    _object.apiLog('$tag baseurl: ${ApiPath.baseUrl}');
    final url = Uri.parse('${ApiPath.baseUrl}${ApiPath.getDocumentsList}');
    _object.apiLog('$tag URL: $url');

    try {
      final headers = await _object.getHeaderWithToken();

      final response = await http.post(url,
          headers: headers,
          body: jsonEncode({
            "id": id,
          }));
      _object.apiLog('$tag Response: Status Code: ${response.statusCode}');
      _object.apiLog('$tag Response: ${response.body}');

      var decodedResult = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return ApiSuccess(ModelDocumentList.fromJson(decodedResult));
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

  static Future<ApiResult> getHowItWorksList(
    String type,
    String id,
  ) async {
    const String tag = 'getHowItWorksList';

    if (!(await _object.hasInternet() ?? false)) {
      return ApiFailure(ModelError(message: AppString.strNoInternetConnection));
    }

    _object.apiLog('$tag baseurl: ${ApiPath.baseUrl}');
    final url = Uri.parse('${ApiPath.baseUrl}${ApiPath.getHowItWorks}');
    _object.apiLog('$tag URL: $url');

    try {
      final headers = await _object.getHeaderWithToken();
      headers['Content-Type'] = 'application/json';
      final uri = url.replace(
        queryParameters: {
          'type': type, // converted from JSON to query param
        },
      );
      _object.apiLog('$tag URL: $uri');
      final response = await http.get(
        uri,
        headers: headers,
      );
      _object.apiLog('$tag Response: Status Code: ${response.statusCode}');
      _object.apiLog('$tag Response: ${response.body}');

      var decodedResult = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return ApiSuccess(ModelHowItWorksList.fromJson(decodedResult));
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

  static Future<ApiResult> readNotification({required String type}) async {
    const String tag = 'readNotification';

    if (!(await _object.hasInternet() ?? false)) {
      return ApiFailure(ModelError(message: AppString.strNoInternetConnection));
    }

    _object.apiLog('$tag baseurl: ${ApiPath.baseUrl}');
    final url = Uri.parse('${ApiPath.baseUrl}${ApiPath.readNotification}');
    _object.apiLog('$tag URL: $url');
    _object.apiLog('$tag type: $type');

    try {
      final headers = await _object.getHeaderWithToken();
      headers['Content-Type'] = 'application/json';
      final response = await http.post(
        url,
        headers: headers,
        body: jsonEncode({"type": type}),
      );
      _object.apiLog('$tag Response: Status Code: ${response.statusCode}');
      _object.apiLog('$tag Response: ${response.body}');

      var decodedResult = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return ApiSuccess(ModelReadNotification.fromJson(decodedResult));
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

  static Future<ApiResult> sendLeadComment({
    required int id,
    required String comment,
    required int leadId,
    String? name,
  }) async {
    const String tag = 'sendLeadComment';

    if (!(await _object.hasInternet() ?? false)) {
      return ApiFailure(ModelError(message: AppString.strNoInternetConnection));
    }

    _object.apiLog('$tag baseurl: ${ApiPath.baseUrl}');
    _object.apiLog('$tag id: $id');
    _object.apiLog('$tag comment: $comment');
    _object.apiLog('$tag leadId: $leadId');
    if (name != null) {
      _object.apiLog('$tag name: $name');
    }
    final url = Uri.parse('${ApiPath.baseUrl}${ApiPath.leadComment}');
    _object.apiLog('$tag URL: $url');

    final body = {
      "id": id,
      "comment": comment,
      "lead_id": leadId,
      if (name != null) "name": name,
    };
    _object.apiLog('$tag Body: $body');
    try {
      final headers = await _object.getHeaderWithToken();
      headers['Content-Type'] = 'application/json';
      final response = await http.post(url,
          headers: headers,
          body: jsonEncode({
            "id": id,
            "comment": comment,
            "lead_id": leadId,
            if (name != null) "name": name,
          }));
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

  static Future<ApiResult> updateLeadStatus({
    required int leadId,
    required int currentStep,
  }) async {
    const String tag = 'updateLeadStatus';

    if (!(await _object.hasInternet() ?? false)) {
      return ApiFailure(ModelError(message: AppString.strNoInternetConnection));
    }

    _object.apiLog('$tag baseurl: ${ApiPath.baseUrl}');
    final url = Uri.parse('${ApiPath.baseUrl}${ApiPath.updateLeadStatus}');
    _object.apiLog('$tag URL: $url');

    try {
      final headers = await _object.getHeaderWithToken();
      headers['Content-Type'] = 'application/json';
      final response = await http.post(url,
          headers: headers,
          body: jsonEncode({
            "lead_id": leadId,
            "current_step": currentStep,
          }));
      _object.apiLog('$tag Response: Status Code: ${response.statusCode}');
      _object.apiLog('$tag Response: ${response.body}');

      var decodedResult = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return ApiSuccess(ModelLeadCreate.fromJson(decodedResult));
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

  static Future<ApiResult> sendReferralRequest({
    required String clientLocation,
    required String firstName,
    required List<String> refereeEmails,
    required List<String> referrerEmails,
    required String sharesCommission,
    required String city,
  }) async {
    const String tag = 'sendReferralRequest';

    if (!(await _object.hasInternet() ?? false)) {
      return ApiFailure(ModelError(message: AppString.strNoInternetConnection));
    }

    _object.apiLog('$tag baseurl: ${ApiPath.baseUrl}');
    final url = Uri.parse('${ApiPath.baseUrl}${ApiPath.sendReferral}');
    _object.apiLog('$tag URL: $url');

    // Transform clientLocation value to ensure it sends 'in_person' when needed
    String transformedLocation = clientLocation.toLowerCase() ==
            tr(LanguageKeys.inPerson).toLowerCase()
        ? 'in_person'
        : clientLocation.toLowerCase() == tr(LanguageKeys.online).toLowerCase()
            ? 'online'
            : '';

    final body = {
      'client_location': transformedLocation,
      'first_name': firstName,
      'referee_emails': refereeEmails,
      'referrer_emails': referrerEmails,
      'shares_commission': sharesCommission,
      'city': city,
    };

    _object.apiLog('$tag body: ${jsonEncode(body)}');

    try {
      final headers = await _object.getHeaderWithToken();
      headers['Content-Type'] = 'application/json';
      final response = await http.post(
        url,
        headers: headers,
        body: jsonEncode(body),
      );
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
// Deal detail Api for show dialog Fix commission

  static Future<ApiResult> dealDetail(
      {String? id, String? leadId, String? sendLeadOut}) async {
    const String tag = 'deal_detail';

    if (!(await _object.hasInternet() ?? false)) {
      return ApiFailure(ModelError(message: AppString.strNoInternetConnection));
    }

    _object
        .apiLog('[32m$tag baseurl: [0m[36m[1m[4m${ApiPath.baseUrl}[0m');
    // Build query parameters conditionally
    final Map<String, String?> queryParameters = {
      'id': id,
    };
    if (leadId != null && leadId.isNotEmpty) {
      queryParameters['lead_created_by'] = leadId;
    }
    if (sendLeadOut != null && sendLeadOut.isNotEmpty) {
      queryParameters['send_lead_out'] = sendLeadOut;
    }
    final url = Uri.parse('${ApiPath.baseUrl}${ApiPath.dealDetail}').replace(
      queryParameters: queryParameters,
    );
    _object.apiLog('[32m$tag URL: [0m[36m[1m[4m$url[0m');

    try {
      final headers = await _object.getHeaderWithToken();
      headers['Content-Type'] = 'application/json';

      final response = await http.get(
        url,
        headers: headers,
      );
      _object.apiLog('$tag Response: Status Code: ${response.statusCode}');
      _object.apiLog('$tag Response: ${response.body}');

      var decodedResult = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return ApiSuccess(ModelDealDetail.fromJson(decodedResult));
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

  // Api Accept deal
  static Future<ApiResult> acceptDeal({
    required String? id,
    required String? dealId,
    required String? sendLeadOut,
    required String? createdBy,
  }) async {
    const String tag = 'accept_deal';

    if (!(await _object.hasInternet() ?? false)) {
      return ApiFailure(ModelError(message: AppString.strNoInternetConnection));
    }

    var url = Uri.parse(ApiPath.baseUrl + ApiPath.dealAccept);
    _object.apiLog('$tag URL: $url');

    var body = {
      'id': id,
      'deal_id': dealId,
      'send_lead_out': sendLeadOut,
      'lead_created_by': sendLeadOut == "1" ? createdBy : null,
    };

    _object.apiLog('$tag body: $body');

    try {
      final headers = await _object.getHeaderWithToken();
      headers['Content-Type'] = 'application/json';

      final response =
          await http.post(url, body: jsonEncode(body), headers: headers);
      _object.apiLog('$tag Response: Status Code: ${response.statusCode}');
      _object.apiLog('$tag Response: ${response.body}');

      var decodedResult = jsonDecode(response.body);
      _object.apiLog('$tag decodedResult: $decodedResult');

      if (response.statusCode == 200) {
        return ApiSuccess(ModelCommon.fromJson(decodedResult));
      } else if (response.statusCode == 422) {
        return ApiFailure(ModelError.fromJson(decodedResult));
      } else {
        return ApiFailure(
          ModelError(
              message: decodedResult['message'] ?? 'Something went wrong'),
        );
      }
    } on SocketException {
      _object.onSocket(tag);
      return ApiFailure(ModelError(message: 'Unexpected error occurred'));
    } catch (error) {
      _object.onError(tag, error);
      return ApiFailure(ModelError(message: error.toString()));
    }
  }

  static Future<ApiResult> getIndividualHomeType(String companyType) async {
    const String tag = 'getIndividualHome';

    if (!(await _object.hasInternet() ?? false)) {
      return ApiFailure(ModelError(message: AppString.strNoInternetConnection));
    }

    _object.apiLog('$tag baseurl: ${ApiPath.baseUrl}');
    final url = Uri.parse('${ApiPath.baseUrl}${ApiPath.getIndividualHome}');
    _object.apiLog('$tag URL: $url');

    try {
      final headers = await _object.getHeaderWithToken();
      headers['Content-Type'] = 'application/json';
      final response = await http.post(url,
          headers: headers,
          body: jsonEncode({
            'company_type': companyType,
          }));
      _object.apiLog('$tag Response: Status Code: ${response.statusCode}');
      _object.apiLog('$tag Response: ${response.body}');

      var decodedResult = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return ApiSuccess(ModelCommon.fromJson(decodedResult));
      } else {
        return ApiFailure(ModelError(
            message: decodedResult['message'] ?? 'Something went wrong'));
      }
    } on SocketException {
      _object.onSocket(tag);
      return ApiFailure(ModelError(message: 'Unexpected error occurred'));
    } catch (error) {
      _object.onError(tag, error);
      return ApiFailure(ModelError(message: error.toString()));
    }
  }

  static Future<ApiResult> alreadyHaveCard(
      String email, String firstName, String lastName) async {
    const String tag = 'alreadyHaveCard';

    if (!(await _object.hasInternet() ?? false)) {
      return ApiFailure(ModelError(message: AppString.strNoInternetConnection));
    }

    _object.apiLog('$tag baseurl: ${ApiPath.baseUrl}');
    final url = Uri.parse('${ApiPath.baseUrl}${ApiPath.alreadyHaveCard}');
    _object.apiLog('$tag URL: $url');

    try {
      final headers = await _object.getHeaderWithToken();
      headers['Content-Type'] = 'application/json';
      final response = await http.post(url,
          headers: headers,
          body: jsonEncode({
            'email': email,
            'first_name': firstName,
            'last_name': lastName,
          }));
      _object.apiLog('$tag Response: Status Code: ${response.statusCode}');
      _object.apiLog('$tag Response: ${response.body}');

      var decodedResult = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return ApiSuccess(ModelAlreadyHaveCard.fromJson(decodedResult));
      } else {
        return ApiFailure(ModelError(
            message: decodedResult['message'] ?? 'Something went wrong'));
      }
    } on SocketException {
      _object.onSocket(tag);
      return ApiFailure(ModelError(message: 'Unexpected error occurred'));
    } catch (error) {
      _object.onError(tag, error);
      return ApiFailure(ModelError(message: error.toString()));
    }
  }

  static Future<ApiResult> uploadDocument(
      String id, String uploadNotify, List<File> files,
      {Map<String, String>? renamedFiles}) async {
    const String tag = 'uploadDocument';

    if (!(await _object.hasInternet() ?? false)) {
      return ApiFailure(ModelError(message: AppString.strNoInternetConnection));
    }

    _object.apiLog('$tag baseurl: ${ApiPath.baseUrl}');
    var url = Uri.parse(ApiPath.baseUrl + ApiPath.uploadDocument);
    _object.apiLog('$tag URL: $url');

    try {
      final headers = await _object.getHeaderWithToken();
      var request = http.MultipartRequest('POST', url);
      request.headers.addAll(headers);

      request.fields['id'] = id;
      request.fields['upload_notify'] = uploadNotify;

      for (var file in files) {
        final filePath = file.path;
        String? customName =
            renamedFiles != null ? renamedFiles[filePath] : null;
        request.files.add(await http.MultipartFile.fromPath(
          'document[]',
          filePath,
          filename: customName ?? file.uri.pathSegments.last,
        ));
      }

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      _object.apiLog('$tag Response: Status Code: ${response.statusCode}');
      _object.apiLog('$tag Response: ${response.body}');

      var decodedResult = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return ApiSuccess(ModelUploadDocument.fromJson(decodedResult));
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

  static Future<ApiResult> deleteDocument(String documentId) async {
    const String tag = 'deleteDocument';

    if (!(await _object.hasInternet() ?? false)) {
      return ApiFailure(ModelError(message: AppString.strNoInternetConnection));
    }

    _object.apiLog('$tag baseurl: ${ApiPath.baseUrl}');
    var url = Uri.parse('${ApiPath.baseUrl}${ApiPath.deleteDocument}');
    _object.apiLog('$tag URL: $url');

    try {
      final headers = await _object.getHeaderWithToken();
      final response = await http.post(url,
          headers: headers,
          body: jsonEncode({
            'id': documentId,
          }));

      _object.apiLog('$tag Response: Status Code: ${response.statusCode}');
      _object.apiLog('$tag Response: ${response.body}');

      var decodedResult = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return ApiSuccess(ModelCommon.fromJson(decodedResult));
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

  static Future<ApiResult> getDealLeave(String dealId) async {
    const String tag = 'getDealLeave';

    if (!(await _object.hasInternet() ?? false)) {
      return ApiFailure(ModelError(message: AppString.strNoInternetConnection));
    }

    _object.apiLog('$tag baseurl: ${ApiPath.baseUrl}');
    var url = Uri.parse('${ApiPath.baseUrl}${ApiPath.getDealLeave}');
    _object.apiLog('$tag URL: $url');

    try {
      final headers = await _object.getHeaderWithToken();
      final response = await http.post(url,
          headers: headers,
          body: jsonEncode({
            'id': dealId,
          }));

      _object.apiLog('$tag Response: Status Code: ${response.statusCode}');
      _object.apiLog('$tag Response: ${response.body}');

      var decodedResult = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return ApiSuccess(ModelCommon.fromJson(decodedResult));
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

  static Future<ApiResult> sendNotificationInDeals(
      String title, String description, List<String> id) async {
    const String tag = 'sendNotificationInDeals';

    if (!(await _object.hasInternet() ?? false)) {
      return ApiFailure(ModelError(message: AppString.strNoInternetConnection));
    }

    _object.apiLog('$tag baseurl: ${ApiPath.baseUrl}');
    var url = Uri.parse('${ApiPath.baseUrl}${ApiPath.sendNotificationInDeals}');
    _object.apiLog('$tag URL: $url');

    try {
      final headers = await _object.getHeaderWithToken();
      final response = await http.post(url,
          headers: headers,
          body: jsonEncode({"title": "Test", "description": "Test", "id": id}));

      _object.apiLog('$tag Response: Status Code: ${response.statusCode}');
      _object.apiLog('$tag Response: ${response.body}');

      var decodedResult = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return ApiSuccess(ModelCommon.fromJson(decodedResult));
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

  static Future<ApiResult> editLeadComment({
    required int id,
    required String comment,
    required int leadId,
    String? name,
  }) async {
    const String tag = 'editLeadComment';

    if (!(await _object.hasInternet() ?? false)) {
      return ApiFailure(ModelError(message: AppString.strNoInternetConnection));
    }

    _object.apiLog('$tag baseurl: ${ApiPath.baseUrl}');
    _object.apiLog('$tag id: $id');
    _object.apiLog('$tag comment: $comment');
    _object.apiLog('$tag leadId: $leadId');
    if (name != null) {
      _object.apiLog('$tag name: $name');
    }
    final url = Uri.parse('${ApiPath.baseUrl}${ApiPath.trackStepComment}');
    _object.apiLog('$tag URL: $url');

    final body = {
      "id": id,
      "comment": comment,
      "lead_id": leadId,
    };
    _object.apiLog('$tag Body: $body');
    try {
      final headers = await _object.getHeaderWithToken();
      headers['Content-Type'] = 'application/json';
      final response = await http.post(url,
          headers: headers,
          body: jsonEncode({
            "id": id,
            "comment": comment,
            "lead_id": leadId,
            if (name != null) "name": name,
          }));
      _object.apiLog('$tag Response: Status Code: ${response.statusCode}');
      _object.apiLog('$tag Response: ${response.body}');

      var decodedResult = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return ApiSuccess(ModelLeadCreate.fromJson(decodedResult));
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

  static Future<ApiResult> addCommisionAmount({
    required int id,
    required String amount,
    required int leadId,
    required String revenue,
    String? name,
  }) async {
    const String tag = 'addCommisionAmount';

    if (!(await _object.hasInternet() ?? false)) {
      return ApiFailure(ModelError(message: AppString.strNoInternetConnection));
    }

    _object.apiLog('$tag baseurl: ${ApiPath.baseUrl}');
    _object.apiLog('$tag id: $id');
    _object.apiLog('$tag amount: $amount');
    _object.apiLog('$tag leadId: $leadId');
    _object.apiLog('$tag revenue: $revenue');
    if (name != null) {
      _object.apiLog('$tag name: $name');
    }
    final url = Uri.parse('${ApiPath.baseUrl}${ApiPath.leadComment}');
    _object.apiLog('$tag URL: $url');

    final body = {
      "id": id,
      "comment": "null",
      "lead_id": leadId,
      "name": "Payment received",
      "revenue": revenue,
      "commission_amount": amount.replaceAll(",", "")
    };
    _object.apiLog('$tag Body: $body');
    try {
      final headers = await _object.getHeaderWithToken();
      headers['Content-Type'] = 'application/json';
      final response = await http.post(url,
          headers: headers,
          body: jsonEncode({
            "id": id,
            "comment": "null",
            "lead_id": leadId,
            "name": "Payment received",
            "commission_amount": amount.replaceAll(",", "")
          }));
      _object.apiLog('$tag Response: Status Code: ${response.statusCode}');
      _object.apiLog('$tag Response: ${response.body}');

      var decodedResult = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return ApiSuccess(ModelLeadCreate.fromJson(decodedResult));
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

  static Future<ApiResult> deleteAccount() async {
    const String tag = 'deleteAccount';

    if (!(await _object.hasInternet() ?? false)) {
      return ApiFailure(ModelError(message: AppString.strNoInternetConnection));
    }

    _object.apiLog('$tag baseurl: ${ApiPath.baseUrl}');

    final url = Uri.parse('${ApiPath.baseUrl}${ApiPath.deleteAccount}');
    _object.apiLog('$tag URL: $url');

    try {
      final headers = await _object.getHeaderWithToken();
      headers['Content-Type'] = 'application/json';
      final response = await http.delete(url, headers: headers);
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

  static Future<ApiResult> getAgencyCoworkerList(List<String> ids) async {
    const String tag = 'getAgencyCoworkerList';

    if (!(await _object.hasInternet() ?? false)) {
      return ApiFailure(ModelError(message: AppString.strNoInternetConnection));
    }

    _object.apiLog('$tag baseurl: ${ApiPath.baseUrl}');
    var url = Uri.parse('${ApiPath.baseUrl}${ApiPath.AgencyCoworkerList}');
    _object.apiLog('$tag URL: $url');
    _object.apiLog('$tag ids: $ids');

    try {
      final headers = await _object.getHeaderWithToken();
      final response =
          await http.post(url, headers: headers, body: jsonEncode({"id": ids}));

      _object.apiLog('$tag Response: Status Code: ${response.statusCode}');
      _object.apiLog('$tag Response: ${response.body}');

      var decodedResult = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return ApiSuccess(CollaboratorListModel.fromJson(decodedResult));
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

  static Future<ModelReferralList?> getCoworkerSearchList(
    String search,
    List<String> id,
  ) async {
    const String tag = 'getCoworkerSearchList';

    // if (!(await _object.hasInternet() ?? false)) {
    //   return ApiFailure(ModelError(message: AppString.strNoInternetConnection));
    // }

    _object.apiLog('$tag baseurl: ${ApiPath.baseUrl}');
    final url = Uri.parse('${ApiPath.baseUrl}${ApiPath.getCoworkerSearchList}');
    _object.apiLog('$tag URL: $url');

    _object.apiLog('$tag Body: ${jsonEncode({
          'search': search,
          'id': id,
        })}');
    try {
      final headers = await _object.getHeaderWithToken();
      headers['Content-Type'] = 'application/json';
      final response = await http.post(url,
          headers: headers,
          body: jsonEncode({
            "search": search,
            "id": id,
          }));
      _object.apiLog('$tag Response: Status Code: ${response.statusCode}');
      _object.apiLog('$tag Response: ${response.body}');

      var decodedResult = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return ModelReferralList.fromJson(decodedResult);
      }

      if (response.statusCode == 422) {
        return ModelReferralList.fromJson(decodedResult);
      }
    } catch (e) {
      throw Exception('Failed to get coworker search list: ${e.toString()}');
    }
  }

  static Future<ApiResult> addCoworker(
    String user_id,
    List<String> id,
  ) async {
    const String tag = 'addCoworker';

    if (!(await _object.hasInternet() ?? false)) {
      return ApiFailure(ModelError(message: AppString.strNoInternetConnection));
    }

    _object.apiLog('$tag baseurl: ${ApiPath.baseUrl}');
    final url = Uri.parse('${ApiPath.baseUrl}${ApiPath.collaboratorAdd}');
    _object.apiLog('$tag URL: $url');

    _object.apiLog('$tag Body: ${jsonEncode({
          'user_id': user_id,
          'id': id,
        })}');
    try {
      final headers = await _object.getHeaderWithToken();
      headers['Content-Type'] = 'application/json';
      final response = await http.post(url,
          headers: headers,
          body: jsonEncode({
            "user_id": user_id,
            "id": id,
          }));
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

  static Future<ApiResult> deleteCoworker(
    String id,
  ) async {
    const String tag = 'deleteCoworker';

    if (!(await _object.hasInternet() ?? false)) {
      return ApiFailure(ModelError(message: AppString.strNoInternetConnection));
    }

    _object.apiLog('$tag baseurl: ${ApiPath.baseUrl}');
    final url = Uri.parse('${ApiPath.baseUrl}${ApiPath.collaboratorDelete}');
    _object.apiLog('$tag URL: $url');

    _object.apiLog('$tag Body: ${jsonEncode({
          'id': id,
        })}');
    try {
      final headers = await _object.getHeaderWithToken();
      headers['Content-Type'] = 'application/json';
      final response = await http.post(url,
          headers: headers,
          body: jsonEncode({
            "id": id,
          }));
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

  // Chitra : VersionUpdate API
  static Future<ModelVersionUpdate?> versionUpdate() async {
    AppLog.d("+++++++++++++Check");

    const String tag = 'get_version_update';
    ModelVersionUpdate? data;
    // var baseurl = await _object.getBaseUrl();
    var baseurl = "https://app.referaly.fr/api/";
    // var baseurl = "https://refearly-back.developmentlabs.co/api/";
    _object.apiLog('$tag baseurl: $baseurl');
    var url = Uri.parse(baseurl + ApiPath.appVersion);
    _object.apiLog('$tag URL: $url');

    try {
      // Add timeout to prevent hanging
      final response = await http.get(url).timeout(
        const Duration(seconds: 15),
        onTimeout: () {
          AppLog.d('Version update API timeout');
          throw TimeoutException(
              'Request timeout', const Duration(seconds: 15));
        },
      );

      _object.apiLog('$tag Response: Status Code: ${response.statusCode}');
      _object.apiLog('$tag Response: ${response.body}');

      var decodedResult = jsonDecode(response.body);
      data = ModelVersionUpdate.fromJson(decodedResult);
      AppLog.d("+++++++++++++Check2");
      return data;
    } on SocketException {
      _object.onSocket(tag);
      return null;
    } on TimeoutException {
      AppLog.d('Version update API timeout - returning null');
      return null;
    } catch (error) {
      _object.onError(tag, error);
      return null;
    }
  }
}
