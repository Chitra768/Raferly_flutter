import 'package:flutter/material.dart';

TextStyle stylePoppins({
  Color? color,
  Color? backgroundColor,
  double? fontSize,
  FontWeight? fontWeight,
  FontStyle? fontStyle,
}) {
  return TextStyle(
      fontFamily: "Poppins",
      fontSize: fontSize,
      backgroundColor: backgroundColor,
      color: color,
      fontWeight: fontWeight);
}
