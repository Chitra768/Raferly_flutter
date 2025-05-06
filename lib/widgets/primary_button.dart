import 'package:flutter/material.dart';

import '../resources/app_colors.dart';

class PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final double? borderRadius;
  final Color? disabledBackgroundColor;
  final double? elevation; // Added elevation property

  const PrimaryButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.borderRadius,
    this.disabledBackgroundColor,
    this.elevation, // Initialize elevation
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary, // Using AppColors.primary
          foregroundColor: AppColors.whiteColor,
          disabledBackgroundColor: disabledBackgroundColor,
          padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius ?? 12), // Using 12 as default
          ),
          elevation: elevation, // Applying the elevation
        ),
        child: Text(
          text,
          style: TextStyle(
            color: AppColors.whiteColor,
            fontWeight: FontWeight.w500,
            fontSize: 18, // Matching the provided theme's text size
          ),
        ),
      ),
    );
  }
}