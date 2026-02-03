import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:referaly/languages/languagekeys.dart';
import 'package:referaly/resources/app_assets.dart';
import 'package:referaly/resources/text_style.dart';
import 'package:referaly/utils/translations.dart';

class DeleteBusinessReferrerDialog extends StatelessWidget {
  final int? refererId;
  final VoidCallback? onConfirm;
  final VoidCallback? onCancel;

  const DeleteBusinessReferrerDialog({
    super.key,
    this.refererId,
    this.onConfirm,
    this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Warning Icon
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.warning_amber_rounded,
                color: Colors.red,
                size: 36,
              ),
            ),
            const SizedBox(height: 20),

            // Title
            Text(
              tr(LanguageKeys.deleteBusinessReferrerTitle),
              style: stylePoppins(
                fontSize: 20.sp,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),

            // Description
            Text(
              tr(LanguageKeys.deleteBusinessReferrerDescription),
              style: stylePoppins(
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),

            // Consequences Box
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.05),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.red.withOpacity(0.2),
                  width: 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    tr(LanguageKeys.deleteBusinessReferrerPermanently),
                    style: stylePoppins(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildConsequenceItem(
                    tr(LanguageKeys.deleteBusinessReferrerConsequence1),
                  ),
                  const SizedBox(height: 8),
                  _buildConsequenceItem(
                    tr(LanguageKeys.deleteBusinessReferrerConsequence2),
                  ),
                  const SizedBox(height: 8),
                  _buildConsequenceItem(
                    tr(LanguageKeys.deleteBusinessReferrerConsequence3),
                  ),
                  const SizedBox(height: 8),
                  _buildConsequenceItem(
                    tr(LanguageKeys.deleteBusinessReferrerConsequence4),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Action Buttons - Stacked vertically
            Column(
              children: [
                // Delete Button (Red) - On top
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                    if (onConfirm != null) {
                      onConfirm!();
                    }
                  },
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          AppAssets.imgDeleteicon,
                          height: 18,
                          width: 18,
                          color: Colors.white,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          tr(LanguageKeys.yesDeletePermanently),
                          style: stylePoppins(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // Cancel Button (White) - Below
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                    if (onCancel != null) onCancel!();
                  },
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: Colors.grey[300]!,
                        width: 1,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        tr(LanguageKeys.cancel),
                        style: stylePoppins(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildConsequenceItem(String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 6,
          height: 6,
          margin: const EdgeInsets.only(top: 6, right: 12),
          decoration: const BoxDecoration(
            color: Colors.red,
            shape: BoxShape.circle,
          ),
        ),
        Expanded(
          child: Text(
            text,
            style: stylePoppins(
              fontSize: 13.sp,
              fontWeight: FontWeight.w400,
              color: Colors.black87,
            ),
          ),
        ),
      ],
    );
  }
}
