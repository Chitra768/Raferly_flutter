import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:referaly/languages/languagekeys.dart';
import 'package:referaly/resources/app_colors.dart';
import 'package:referaly/resources/text_style.dart';
import 'package:referaly/utils/translations.dart';

/// Permission-denied placeholder shown when an `agency.access` 403 is returned
/// for a list/screen. Lives inside list scroll areas, not as a full screen.
class AccessDeniedView extends StatelessWidget {
  final String? message;
  final EdgeInsetsGeometry padding;

  const AccessDeniedView({
    super.key,
    this.message,
    this.padding = const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
  });

  @override
  Widget build(BuildContext context) {
    final text = (message?.trim().isNotEmpty ?? false)
        ? message!.trim()
        : tr(LanguageKeys.agencyColleagueAccessDenied);

    return Padding(
      padding: padding,
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.08),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.primary.withOpacity(0.2)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.lock_outline, color: AppColors.primary, size: 32),
              const SizedBox(height: 12),
              Text(
                text,
                textAlign: TextAlign.center,
                style: stylePoppins(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColors.slate900,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
