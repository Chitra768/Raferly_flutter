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
  final TextAlign? textAlign;
  final double? borderRadius;
  final double? height;
  final Widget? leading;

  const SecondaryButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.textColor,
    this.borderColor,
    this.backgroundColor,
    this.fontSize,
    this.textAlign,
    this.fontWeight,
    this.borderRadius,
    this.height,
    this.leading,
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
        child: leading == null
            ? Center(
                child: Text(
                  text,
                  textAlign: textAlign ?? TextAlign.center,
                  style: TextStyle(
                    fontSize: fontSize ?? 16,
                    fontWeight: fontWeight ?? FontWeight.w700,
                    color: textColor ?? AppColors.primary,
                  ),
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  leading!,
                  const SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      text,
                      textAlign: textAlign ?? TextAlign.center,
                      style: TextStyle(
                          fontSize: fontSize ?? 16,
                          fontWeight: fontWeight ?? FontWeight.w700,
                          color: textColor ?? AppColors.primary),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
