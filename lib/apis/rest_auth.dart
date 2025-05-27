// ignore_for_file: non_constant_identifier_names, unused_import

import 'dart:convert';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:http/http.dart' as http;
import 'package:referaly/models/model_accept_list.dart';
import 'package:referaly/models/model_active_goal.dart';
import 'package:referaly/models/model_archeive_receive_recover.dart';
import 'package:referaly/models/model_archive_list_receive.dart';
import 'package:referaly/models/model_busniess_referral_lead.dart';
import 'package:referaly/models/model_common.dart';
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
import 'package:referaly/resources/app_log.dart';
import 'package:referaly/resources/app_preference.dart';

import '../models/model_company_type.dart';
import '../models/model_error.dart';
import '../models/model_how_it_works_list.dart';
import '../models/model_login.dart';

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
          body: jsonEncode({'company_type': companyType}), headers: headers);
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
    File? image,
    String? imageUrl,
    required String job,
    required String city,
    required String language,
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
      request.fields['country_code'] = "2";
      request.fields['industry'] = job;
      request.fields['country'] = "country";
      request.fields['city'] = city;
      request.fields['company_type'] = "individual";
      request.fields['lang'] = language;
      request.fields['job'] = job;

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

  static Future<ApiResult> getArchiveList({String order = "asc"}) async {
    const String tag = 'getArchiveList';

    if (!(await _object.hasInternet() ?? false)) {
      return ApiFailure(ModelError(message: AppString.strNoInternetConnection));
    }

    _object.apiLog('$tag baseurl: ${ApiPath.baseUrl}');
    final url =
        Uri.parse('${ApiPath.baseUrl}${ApiPath.getArchiveList}?order=$order');
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

    if (!(await _object.hasInternet() ?? false)) {
      return ApiFailure(ModelError(message: AppString.strNoInternetConnection));
    }

    _object.apiLog('$tag baseurl: ${ApiPath.baseUrl}');
    final url = Uri.parse('${ApiPath.baseUrl}${ApiPath.deleteReceivedLead}');
    _object.apiLog('$tag URL: $url');

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

  static Future<ApiResult> recoverArchiveLead({required String leadId}) async {
    const String tag = 'recoverArchiveLead';

    if (!(await _object.hasInternet() ?? false)) {
      return ApiFailure(ModelError(message: AppString.strNoInternetConnection));
    }

    _object.apiLog('$tag baseurl: ${ApiPath.baseUrl}');
    final url = Uri.parse('${ApiPath.baseUrl}${ApiPath.recoverReceivedLead}');
    _object.apiLog('$tag URL: $url');

    try {
      final headers = await _object.getHeaderWithToken();
      final response = await http.post(url, headers: headers, body: {
        'id': leadId,
      });
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

  static Future<ApiResult> createDeal(
    String dealName,
    String commissionType,
    String description,
    List<String> trackName,
  ) async {
    const String tag = 'createDeal';

    if (!(await _object.hasInternet() ?? false)) {
      return ApiFailure(ModelError(message: AppString.strNoInternetConnection));
    }

    // Map commission type display values to API values
    String getCommissionTypeValue(String displayValue) {
      switch (displayValue.toLowerCase()) {
        case 'no commission':
          return 'no_commission';
        case 'fix commission':
          return 'fix_commission';
        default:
          return displayValue.toLowerCase().replaceAll(' ', '_');
      }
    }

    _object.apiLog('$tag baseurl: ${ApiPath.baseUrl}');
    final url = Uri.parse('${ApiPath.baseUrl}${ApiPath.createDeal}');
    _object.apiLog('$tag URL: $url');
    _object.apiLog('$tag deal_name: $dealName');
    _object.apiLog(
        '$tag commission_type: $getCommissionTypeValue(commissionType)');
    _object.apiLog('$tag description: $description');
    _object.apiLog('$tag track_name: $trackName');

    try {
      final headers = await _object.getHeaderWithToken();
      headers['Content-Type'] = 'application/json';
      final response = await http.post(url,
          headers: headers,
          body: jsonEncode({
            'deal_name': dealName,
            'commission_type': getCommissionTypeValue(commissionType),
            'description': description,
            'track_name': trackName.map((name) => name.trim()).toList(),
            'deal_commission_type': 1,
            'document_uploaded_manually': 0,
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
    List<String> trackName,
    String id,
  ) async {
    const String tag = 'updateDeal';

    if (!(await _object.hasInternet() ?? false)) {
      return ApiFailure(ModelError(message: AppString.strNoInternetConnection));
    }

    // Map commission type display values to API values
    String getCommissionTypeValue(String displayValue) {
      switch (displayValue.toLowerCase()) {
        case 'no commission':
          return 'no_commission';
        case 'fix commission':
          return 'fix_commission';
        default:
          return displayValue.toLowerCase().replaceAll(' ', '_');
      }
    }

    _object.apiLog('$tag baseurl: ${ApiPath.baseUrl}');
    final url = Uri.parse('${ApiPath.baseUrl}${ApiPath.updateDeal}');
    _object.apiLog('$tag URL: $url');
    _object.apiLog('$tag deal_name: $dealName');
    _object.apiLog(
        '$tag commission_type: $getCommissionTypeValue(commissionType)');
    _object.apiLog('$tag description: $description');
    _object.apiLog('$tag track_name: $trackName');
    _object.apiLog('updateDeal: ${jsonEncode({
          'deal_name': dealName,
          'commission_type': getCommissionTypeValue(commissionType),
          'description': description,
          'track_name': trackName.map((name) => name.trim()).toList(),
          'deal_commission_type': 1,
          'document_uploaded_manually': 0,
          'id': id,
        })}');

    try {
      final headers = await _object.getHeaderWithToken();
      headers['Content-Type'] = 'application/json';
      final response = await http.post(url,
          headers: headers,
          body: jsonEncode({
            'deal_name': dealName,
            'commission_type': getCommissionTypeValue(commissionType),
            'description': description,
            'track_name': trackName.map((name) => name.trim()).toList(),
            'deal_commission_type': 1,
            'document_uploaded_manually': 0,
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
    String businessReferrerId,
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
          'business_referrer_id': businessReferrerId,
          'business_deal_id': dealId,
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
            "business_referrer_id": businessReferrerId,
            "business_deal_id": dealId,
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
    String track_name,
  ) async {
    const String tag = 'createLeadOutofRaferaly';

    if (!(await _object.hasInternet() ?? false)) {
      return ApiFailure(ModelError(message: AppString.strNoInternetConnection));
    }

    _object.apiLog('$tag baseurl: ${ApiPath.baseUrl}');
    final url =
        Uri.parse('${ApiPath.baseUrl}${ApiPath.createLeadOutofRaferaly}');
    _object.apiLog('$tag URL: $url');

    int getCommissionValue(String? type) {
      if (type == 'no commission') {
        return 0;
      } else if (type == 'fix commission') {
        return 1;
      } else {
        return 2;
      }
    }

    String getCommissionTypeValue(String displayValue) {
      switch (displayValue.toLowerCase()) {
        case 'no commission':
          return 'no_commission';
        case 'fix commission':
          return 'fix_commission';
        default:
          return displayValue.toLowerCase().replaceAll(' ', '_');
      }
    }

    // Convert track_name string to array by splitting on commas and trimming whitespace
    List<String> trackNameArray =
        track_name.split(',').map((name) => name.trim()).toList();

    _object.apiLog('$tag Body: ${jsonEncode({
          "first_name": firstName,
          "last_name": lastName,
          "phone_number": phoneNumber,
          "email": email,
          "description": description,
          "commission_type": getCommissionTypeValue(commission_type),
          "commission_value": getCommissionValue(commission_value),
          "track_name": trackNameArray,
        })}');
    try {
      final headers = await _object.getHeaderWithToken();
      headers['Content-Type'] = 'application/json';
      final response = await http.post(url,
          headers: headers,
          body: jsonEncode({
            "first_name": firstName,
            "last_name": lastName,
            "phone_number": phoneNumber,
            "email": email,
            "description": description,
            "commission_type": getCommissionTypeValue(commission_type),
            "commission_value": getCommissionValue(commission_value),
            "track_name": trackNameArray,
          }));
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

  static Future<ApiResult> readNotification() async {
    const String tag = 'readNotification';

    if (!(await _object.hasInternet() ?? false)) {
      return ApiFailure(ModelError(message: AppString.strNoInternetConnection));
    }

    _object.apiLog('$tag baseurl: ${ApiPath.baseUrl}');
    final url = Uri.parse('${ApiPath.baseUrl}${ApiPath.readNotification}');
    _object.apiLog('$tag URL: $url');

    try {
      final headers = await _object.getHeaderWithToken();
      headers['Content-Type'] = 'application/json';
      final response = await http.post(
        url,
        headers: headers,
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
}
