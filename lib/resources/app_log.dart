// ignore_for_file: prefer_interpolation_to_compose_strings

import 'dart:developer' as developer;

/// Component: Log (in Debug Console)
/// Author : Suman Mishra
/// Use : To Show logs in different color in Debug Console

/// Usage:
/// 1. AppLog.d(message);
/// 2. AppLog.d(message,tag: 'Your custom tag');

/// Reset:   \x1B[0m
/// Black:   \x1B[30m
/// White:   \x1B[37m
/// Red:     \x1B[31m
/// Green:   \x1B[32m
/// Yellow:  \x1B[33m
/// Blue:    \x1B[34m
/// Cyan:    \x1B[36m

class AppLog {
  static const String _defaultTagPrefix = "Suman";

  ///Print info logs
  static i(String message, {String tag = _defaultTagPrefix}) {
    developer.log(
      "INFO ⓘ |" + tag + ": " + '\x1B[34m$message\x1B[0m', // Blue Color
    );
  }

  ///Print debug logs
  static d(String message, {String tag = _defaultTagPrefix}) {
    developer.log(
      "DEBUG | " + tag + ": " + '\x1B[32m$message\x1B[0m', // Green Color
    );
  }

  ///Print warning logs
  static w(String message, {String tag = _defaultTagPrefix}) {
    developer.log(
      "WARN⚠️ | " + tag + ": " + '\x1B[33m$message\x1B[0m', //Yellow Color
    );
  }

  ///Print error logs
  static e(String message, {String tag = _defaultTagPrefix}) {
    developer.log(
      "ERROR⚠️ |️ " + tag + ": " + '\x1B[31m$message\x1B[0m', //Red Color
    );
  }

  ///Print failure logs (WTF = What a Terrible Failure)
  static wtf(String message, {String tag = _defaultTagPrefix}) {
    developer.log(
      "WTF¯\\_(ツ)_/¯|" + tag + ": " + '\x1B[36m$message\x1B[0m', //Cyan Color
    );
  }

  ///Print debug log
  /* static debugPrint(var message, {String tag = _defaultTagPrefix}) {
    debugPrint(tag + '' + message);
  } */

  ///Print entire debug log
  /* static debugPrintLarge(var message) {
    final pattern = RegExp('.{1,800}');
    pattern.allMatches(message).forEach((match) => debugPrint(match.group(0)));
  } */
}
