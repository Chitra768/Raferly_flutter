import 'package:flutter/material.dart';
import '../resources/app_colors.dart';

class SecondaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final Color? textColor;
  final Color? borderColor;
  final Color? backgroundColor;
  final double? fontSize;
  final FontWeight? fontWeight;
  final double? borderRadius;
  final double? height;

  const SecondaryButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.textColor,
    this.borderColor,
    this.backgroundColor,
    this.fontSize,
    this.fontWeight,
    this.borderRadius,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height ?? 55,
      width: double.infinity,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          backgroundColor: backgroundColor,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          side: BorderSide(color: borderColor ?? AppColors.primary),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius ?? 8),
          ),
        ),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: fontSize ?? 16,
            fontWeight: fontWeight ?? FontWeight.w700,
            color: textColor ?? AppColors.primary,
          ),
        ),
      ),
    );
  }
}
