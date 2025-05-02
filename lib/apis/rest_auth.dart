// ignore_for_file: non_constant_identifier_names

import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../models/model_error.dart';
import '../models/model_login.dart';

import '../resources/app_strings.dart';
import 'api_path.dart';
import 'api_result.dart';
import 'base_api.dart';

class RESTAuth with BaseAPI {
  static final RESTAuth _object = RESTAuth();

  // Suman : login API
  static Future<ApiResult> login({
    String? email,
    String? phoneNo,
  }) async {
    const String tag = 'login';

    if (!(await _object.hasInternet() ?? false)) {
      return ApiFailure(ModelError(message: AppString.strNoInternetConnection));
    }

    _object.apiLog('$tag baseurl: ${ApiPath.baseUrl}');
    var url = Uri.parse(ApiPath.baseUrl + ApiPath.login);
    _object.apiLog('$tag URL: $url');

    var body = {
      'is_app': "true",
      if (email != null) 'email': email,
      if (phoneNo != null) 'phone_no': phoneNo,
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
}
