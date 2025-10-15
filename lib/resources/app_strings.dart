// ignore_for_file: constant_identifier_names

import 'package:get/get_rx/src/rx_types/rx_types.dart';

class AppString {
  static const String regexEmail = r'^[^\s@]+@[^\s@]+\.[^\s@]+$';
  static const String strNoInternetConnection = 'No Internet Connection';
  static const String strConnectionTimeout = 'Connection Timeout';
  static const String strNoData = 'No Data';
  static const String strDot = '.';

  static const String dfIso8601String = 'yyyy-MM-ddTHH:mm:ss.mmmZ';
  static const String dfYMD = 'yyyy-MM-dd';

  static const String strAppName = 'Referaly';

  static RxString appVersion = '0'.obs;
}
