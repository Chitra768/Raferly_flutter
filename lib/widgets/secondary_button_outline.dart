import 'package:flutter/material.dart';

import '../resources/app_colors.dart';

class SecondaryButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color? textColor;
  final Color? borderColor;
  final Color? backgroundColor;
  final double? fontSize;
  final FontWeight? fontWeight;

  const SecondaryButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.textColor,
    this.borderColor,
    this.backgroundColor,
    this.fontSize,
    this.fontWeight,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      width: double.infinity,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          backgroundColor: backgroundColor,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          side: BorderSide(color: borderColor ?? AppColors.primary),
          shape: RoundedRectangleBorder(
            // side: BorderSide(color: borderColor ?? AppColors.buttonBlue),
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Text(text,
            style: TextStyle(
                fontSize: fontSize ?? 16,
                fontWeight: fontWeight ?? FontWeight.w700,
                color: textColor ?? AppColors.primary)),
      ),
    );
  }
}
