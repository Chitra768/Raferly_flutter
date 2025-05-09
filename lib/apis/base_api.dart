import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
    var header = {
      // 'Accept': 'application/json',
      'Content-Type': 'application/json',
      //HttpHeaders.contentTypeHeader: 'application/json',
      // 'token': await AppPreference.readString('verify_token') ?? '',
    };
    return header;
  }

  Future<Map<String, String>> getHeaderWithToken() async {
    String? accessToken =
        await AppPreference.readString(AppPreference.accessToken);

    var headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $accessToken',
    };
    return headers;
  }

  Future<Map<String, String>> getHeaderWithoutType() async {
    String? accessToken =
        await AppPreference.readString(AppPreference.accessToken);

    print('accessToken: $accessToken');

    var headers = {
      'Accept': 'application/json',
      'Authorization': 'Bearer $accessToken',
    };
    return headers;
  }

  Future<bool?> hasInternet() async {
    final connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult.contains(ConnectivityResult.none)) {
      ScaffoldMessenger.of(Get.context!).showSnackBar(
        const SnackBar(
          content: Text('No Internet Connection'),
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
    apiLog('$tag ${AppString.strNoInternetConnection}');
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
}
