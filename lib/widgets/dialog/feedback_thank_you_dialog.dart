import 'package:flutter/material.dart';
import 'package:referaly/languages/languagekeys.dart';
import 'package:referaly/resources/app_colors.dart';
import 'package:referaly/resources/text_style.dart';
import 'package:referaly/utils/translations.dart';

/// Thank-you step after feedback submission (matches Referaly feedback success UI).
class FeedbackThankYouDialog extends StatelessWidget {
  final VoidCallback onBackToApp;

  const FeedbackThankYouDialog({super.key, required this.onBackToApp});

  static Future<void> show(
    BuildContext context, {
    required VoidCallback onBackToApp,
  }) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => FeedbackThankYouDialog(onBackToApp: onBackToApp),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      backgroundColor: AppColors.whiteColor,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 96,
              height: 96,
              decoration: const BoxDecoration(
                color: Color(0xFFF5F3FF),
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: const Icon(
                Icons.check_rounded,
                size: 44,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              tr(LanguageKeys.feedbackThankYouTitle),
              textAlign: TextAlign.center,
              style: stylePoppins(
                fontSize: 28,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF111827),
              ),
            ),
            const SizedBox(height: 20),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(20, 22, 20, 22),
              decoration: BoxDecoration(
                color: const Color(0xFFFAFAFA),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFFF0F0F0)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 1,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Text(
                    tr(LanguageKeys.feedbackThankYouBody1),
                    textAlign: TextAlign.center,
                    style: stylePoppins(
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                      color: AppColors.k6B7280,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Divider(height: 1, color: Colors.grey.shade300),
                  const SizedBox(height: 14),
                  Text(
                    tr(LanguageKeys.feedbackThankYouBody2),
                    textAlign: TextAlign.center,
                    style: stylePoppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: AppColors.k6B7280,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.whiteColor,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  shadowColor: Colors.black.withValues(alpha: 0.08),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                  onBackToApp();
                },
                child: Text(
                  tr(LanguageKeys.feedbackBackToApp),
                  style: stylePoppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.whiteColor,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
