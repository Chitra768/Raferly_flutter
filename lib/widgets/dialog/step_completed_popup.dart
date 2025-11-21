import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:referaly/languages/languagekeys.dart';
import 'package:referaly/resources/app_assets.dart';
import 'package:referaly/resources/app_colors.dart';
import 'package:referaly/resources/text_style.dart';
import 'package:referaly/utils/translations.dart';

class StepCompletedPopup extends StatelessWidget {
  final VoidCallback onMarkAsSuccessful;
  final VoidCallback? onNotNow;

  const StepCompletedPopup({
    Key? key,
    required this.onMarkAsSuccessful,
    this.onNotNow,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 15),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      backgroundColor: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Close button
            Align(
              alignment: Alignment.topRight,
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                  if (onNotNow != null) {
                    onNotNow!();
                  }
                },
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.grey300.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.close,
                    size: 15,
                    color: Colors.grey,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            // Checkmark icon in purple circle
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primary.withOpacity(0.1),
              ),
              child: const Center(
                child: Icon(Icons.check, size: 24, color: AppColors.primary),
              ),
            ),
            const SizedBox(height: 20),
            // Title
            Text(
              tr(LanguageKeys.stepCompleted),
              style: stylePoppins(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 18),
            // Description
            Text(
              tr(LanguageKeys.stepCompletedDescription),
              style: stylePoppins(
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: Colors.grey.shade700,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            // Primary button - Mark as Successful
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  elevation: 0,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                  onMarkAsSuccessful();
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      AppAssets.imgTrophyWon,
                      width: 18,
                      height: 18,
                      colorFilter: ColorFilter.mode(
                        AppColors.whiteColor,
                        BlendMode.srcIn,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      tr(LanguageKeys.markAsSuccessful),
                      style: stylePoppins(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: AppColors.whiteColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            // Secondary button - Not Now
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFF5F5F7),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  elevation: 0,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                  if (onNotNow != null) {
                    onNotNow!();
                  }
                },
                child: Text(
                  tr(LanguageKeys.notNow),
                  style: stylePoppins(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Info note
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.05),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                      child: SvgPicture.asset(
                        AppAssets.imgInfoActivity,
                        width: 8,
                        height: 8,
                        color: AppColors.whiteColor,
                      )),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      tr(LanguageKeys.referrerNotificationInfo),
                      style: stylePoppins(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: AppColors.primary,
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
