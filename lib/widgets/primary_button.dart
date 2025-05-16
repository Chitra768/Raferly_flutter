import 'package:flutter/material.dart';

import '../resources/app_colors.dart';

class PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final double? borderRadius;
  final double? elevation;
  final double? height;
  final double? fontSize;
  final FontWeight? fontWeight; // Changed from double? to FontWeight?
  final Color? backgroundColor;
  final Color? foregroundColor;
  final Color? disabledBackgroundColor;
  final Color? textColor;
  final EdgeInsetsGeometry? padding;

  const PrimaryButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.borderRadius,
    this.elevation,
    this.height,
    this.fontSize,
    this.fontWeight,
    this.backgroundColor,
    this.foregroundColor,
    this.disabledBackgroundColor,
    this.textColor,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height ?? 55,
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor ?? AppColors.primary,
          foregroundColor: foregroundColor ?? AppColors.whiteColor,
          disabledBackgroundColor:
              disabledBackgroundColor ?? AppColors.primary.withOpacity(0.5),
          padding: padding ??
              const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius ?? 10),
          ),
          elevation: elevation,
        ),
        child: Text(
          text,
          style: TextStyle(
            color: textColor ?? AppColors.whiteColor,
            fontWeight: fontWeight ?? FontWeight.w600,
            fontSize: fontSize ?? 16,
          ),
        ),
      ),
    );
  }
}
