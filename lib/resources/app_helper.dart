import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AppHelper {
  static String dateTimeToString(DateTime? dateTime, {String format = 'MMM d, yyyy'}) {
    if (dateTime == null) return "";
    DateFormat dateFormat = DateFormat(format);
    return dateFormat.format(dateTime);
  }

  static String formatDate(String rawDate, {String format = 'MMM d, yyyy'}) {
    final DateTime parsedDate = DateTime.parse(rawDate);
    final DateFormat formatter = DateFormat(format);
    return formatter.format(parsedDate);
  }

  static void hideKeyboard(BuildContext context) {
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (Platform.isIOS) {
      if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
        FocusManager.instance.primaryFocus!.unfocus();
      }
    } else if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
  }

  static Map<String, String> parseValueAndUnit(String input) {
    input = input.trim();

    // Split based on the last space character
    final lastSpace = input.lastIndexOf(' ');
    if (lastSpace == -1) {
      return {'value': input, 'unit': ''};
    }

    final value = input.substring(0, lastSpace).trim();
    final unit = input.substring(lastSpace + 1).trim();

    return {'value': value, 'unit': unit};
  }
}
