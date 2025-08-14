import 'package:flutter/material.dart';
import 'package:referaly/languages/languagekeys.dart';
import 'package:referaly/resources/app_colors.dart';
import 'package:referaly/resources/text_style.dart';
import 'package:referaly/utils/translations.dart';

class ConfirmationPopup extends StatelessWidget {
  final String message;
  final String? confirmText;
  final String? cancelText;
  final VoidCallback? onConfirm;
  final Color? confirmButtonColor;
  final Color? cancelButtonColor;

  const ConfirmationPopup({
    Key? key,
    required this.message,
    this.confirmText,
    this.cancelText,
    this.onConfirm,
    this.confirmButtonColor,
    this.cancelButtonColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      backgroundColor: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
         
            Text(
              message,
              style: stylePoppins(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            Row(
              children: [
              
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: confirmButtonColor ?? AppColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                      if (onConfirm != null) onConfirm!();
                    },
                    child: Text(
                      confirmText ?? tr(LanguageKeys.submit),
                      style: stylePoppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
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
}
