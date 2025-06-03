import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
  final bool? isLoading;
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
    this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height ?? 55.h,
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor ?? AppColors.primary,
          foregroundColor: foregroundColor ?? AppColors.whiteColor,
          disabledBackgroundColor: disabledBackgroundColor ??
              AppColors.primary.withValues(alpha: 0.5),
          padding:
              padding ?? EdgeInsets.symmetric(horizontal: 50.w, vertical: 15.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius ?? 10.r),
          ),
          elevation: elevation,
        ),
        child: isLoading ?? false
            ? SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  color: AppColors.whiteColor,
                  strokeWidth: 2.5,
                ),
              )
            : Text(
                text,
                style: TextStyle(
                  color: textColor ?? AppColors.whiteColor,
                  fontWeight: fontWeight ?? FontWeight.w600,
                  fontSize: fontSize ?? 14.sp,
                ),
              ),
      ),
    );
  }
}
