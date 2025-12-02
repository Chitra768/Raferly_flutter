import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:referaly/languages/languagekeys.dart';
import 'package:referaly/resources/app_colors.dart';
import 'package:referaly/resources/text_style.dart';
import 'package:referaly/utils/translations.dart';

class LeadAddedSuccessPopup extends StatelessWidget {
  final String leadName;
  final VoidCallback? onClose;

  const LeadAddedSuccessPopup({
    super.key,
    required this.leadName,
    this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.whiteColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Main content
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: 20),
                  // Success icon
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.success300.withOpacity(0.1),
                    ),
                    child: Icon(
                      Icons.check,
                      size: 30,
                      color: AppColors.success300,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Heading
                  Text(
                    tr(LanguageKeys.leadAdded),
                    style: stylePoppins(
                      fontSize: 22.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.blackColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),

                  // Confirmation message
                  _buildConfirmationMessage(),
                  const SizedBox(height: 24),

                  // Next Steps section
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      tr(LanguageKeys.nextSteps),
                      style: stylePoppins(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.blackColor,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // First step
                  _buildNextStepItemWithHighlight(
                    icon: Icons.check_circle,
                    text: tr(LanguageKeys.leadStatusMarkedAsNew),
                  ),
                  const SizedBox(height: 12),

                  // Second step
                  _buildNextStepItem(
                    icon: Icons.show_chart_rounded,
                    text: tr(LanguageKeys.trackProgressInDashboard),
                  ),
                  const SizedBox(height: 24),

                  // Close button
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        if (onClose != null) onClose!();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        tr(LanguageKeys.close),
                        style: stylePoppins(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildConfirmationMessage() {
    final message = tr(LanguageKeys.leadAddedSuccessfullyWithName);
    final parts = message.split('{name}');

    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        style: stylePoppins(
          fontSize: 14.sp,
          fontWeight: FontWeight.w400,
          color: AppColors.grey600,
        ),
        children: [
          if (parts.isNotEmpty) TextSpan(text: parts[0]),
          TextSpan(
            text: leadName,
            style: stylePoppins(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.blackColor,
            ),
          ),
          if (parts.length > 1) TextSpan(text: parts[1]),
        ],
      ),
    );
  }

  Widget _buildNextStepItemWithHighlight({
    required IconData icon,
    required String text,
  }) {
    // Find the word in quotes and make it bold and dark
    final regex = RegExp(r"'([^']+)'");
    final match = regex.firstMatch(text);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 16,
          color: AppColors.primary,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: match != null
              ? RichText(
                  text: TextSpan(
                    style: stylePoppins(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400,
                      color: AppColors.grey600,
                    ),
                    children: [
                      TextSpan(text: text.substring(0, match.start)),
                      TextSpan(
                        text: match.group(0), // Include the quotes
                        style: stylePoppins(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.blackColor,
                        ),
                      ),
                      if (match.end < text.length)
                        TextSpan(text: text.substring(match.end)),
                    ],
                  ),
                )
              : Text(
                  text,
                  style: stylePoppins(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                    color: AppColors.grey600,
                  ),
                ),
        ),
      ],
    );
  }

  Widget _buildNextStepItem({
    required IconData icon,
    required String text,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 16,
          color: AppColors.primary,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: stylePoppins(
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
              color: AppColors.grey600,
            ),
          ),
        ),
      ],
    );
  }
}
