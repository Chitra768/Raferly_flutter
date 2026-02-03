import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:referaly/languages/languagekeys.dart';
import 'package:referaly/resources/app_colors.dart';
import 'package:referaly/screens/auth/login.dart';
import 'package:referaly/utils/translations.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../apis/api_result.dart';
import '../../apis/rest_auth.dart';
import '../../models/model_common.dart';
import '../../resources/app_helper.dart';
import '../../widgets/custom_toast_msg.dart';

class EmailVerificationDialog extends StatefulWidget {
  final String email;

  const EmailVerificationDialog({
    super.key,
    required this.email,
  });

  @override
  State<EmailVerificationDialog> createState() =>
      _EmailVerificationDialogState();
}

class _EmailVerificationDialogState extends State<EmailVerificationDialog> {
  bool _isResending = false;

  Future<void> _openGmail() async {
    try {
      if (Platform.isAndroid) {
        // Android: Try Gmail app first with intent
        final gmailIntent = Uri.parse(
            'intent://mail.google.com/mail/#Intent;scheme=https;package=com.google.android.gm;end');

        if (await canLaunchUrl(gmailIntent)) {
          await launchUrl(gmailIntent, mode: LaunchMode.externalApplication);
          return;
        }

        // Fallback: Try opening any email app
        final mailtoUri = Uri.parse('mailto:');
        if (await canLaunchUrl(mailtoUri)) {
          await launchUrl(mailtoUri, mode: LaunchMode.externalApplication);
          return;
        }
      } else if (Platform.isIOS) {
        // iOS: Try Gmail app URL scheme
        final gmailSchemes = [
          'googlegmail://', // Gmail app
          'message://', // iOS Mail app as fallback
        ];

        for (final scheme in gmailSchemes) {
          final uri = Uri.parse(scheme);
          if (await canLaunchUrl(uri)) {
            await launchUrl(uri, mode: LaunchMode.externalApplication);
            return;
          }
        }
      }

      // Final fallback: Open Gmail web (only if app launch fails)
      final gmailWebUri = Uri.parse('https://mail.google.com');
      final launched =
          await launchUrl(gmailWebUri, mode: LaunchMode.externalApplication);

      if (!launched && mounted) {
        CustomToast.show(
          context,
          tr(LanguageKeys.noEmailAppAvailable),
        );
      }
    } catch (e) {
      debugPrint('Error opening Gmail: $e');
      if (mounted) {
        CustomToast.show(
          context,
          tr(LanguageKeys.noEmailAppAvailable),
        );
      }
    }
  }

  Future<void> _resendEmail() async {
    if (_isResending) return;

    setState(() {
      _isResending = true;
    });

    AppHelper.hideKeyboard(context);

    try {
      // Call resend verification email API
      // Note: You may need to create this API endpoint if it doesn't exist
      final response = await RESTAuth.resendVerificationEmail(
        email: widget.email.toLowerCase(),
      );

      if (response is ApiSuccess<ModelCommon>) {
        if (response.data.status == true) {
          if (mounted) {
            CustomToast.show(
              context,
              response.data.message ?? tr(LanguageKeys.emailResentSuccessfully),
            );
          }
        } else {
          if (mounted) {
            CustomToast.show(
              context,
              response.data.message ?? tr(LanguageKeys.somethingWentWrong),
            );
          }
        }
      } else if (response is ApiFailure) {
        if (mounted) {
          CustomToast.show(
            context,
            response.error.message ?? tr(LanguageKeys.somethingWentWrong),
          );
        }
      }
    } catch (e) {
      debugPrint('Resend email error: $e');
      if (mounted) {
        CustomToast.show(
          context,
          tr(LanguageKeys.somethingWentWrong),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isResending = false;
        });
      }
    }
  }

  void _goBackToLogin() {
    Get.back(); // Close the dialog
    Get.offAllNamed(ScreenLogin.pageId);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.w),
      child: Container(
        constraints: BoxConstraints(
          maxWidth: 400,
          maxHeight: MediaQuery.of(context).size.height * 0.9,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(24.w),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Email Icon
                Container(
                  width: 80.w,
                  height: 80.w,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.email_outlined,
                    color: Colors.white,
                    size: 40.w,
                  ),
                ),
                SizedBox(height: 24.w),

                // Heading
                Text(
                  tr(LanguageKeys.checkYourEmail),
                  style: TextStyle(
                    fontSize: 24.w,
                    fontWeight: FontWeight.bold,
                    color: AppColors.blackColor,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 16.w),

                // Introductory Text
                Text(
                  tr(LanguageKeys.weveSentVerificationEmail),
                  style: TextStyle(
                    fontSize: 16.w,
                    color: AppColors.greyFontColor,
                    fontWeight: FontWeight.w400,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 16.w),

                // Email Address Display
                Container(
                  width: double.infinity,
                  padding:
                      EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.w),
                  decoration: BoxDecoration(
                    color: AppColors.primaryLightPink,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppColors.primary.withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    widget.email,
                    style: TextStyle(
                      fontSize: 14.w,
                      color: AppColors.blackColor,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: 24.w),

                // Instructions
                Text(
                  tr(LanguageKeys.pleaseOpenEmailAndClickLink),
                  style: TextStyle(
                    fontSize: 14.w,
                    color: AppColors.greyFontColor,
                    fontWeight: FontWeight.w400,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 32.w),

                // Open Gmail Button
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: _openGmail,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              'G',
                              style: TextStyle(
                                color: AppColors.primary,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Text(
                          tr(LanguageKeys.openGmail),
                          style: TextStyle(
                            fontSize: 16.w,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 16.w),

                // Resend Email Button
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: OutlinedButton(
                    onPressed: _isResending ? null : _resendEmail,
                    style: OutlinedButton.styleFrom(
                      backgroundColor: Colors.white,
                      side: BorderSide(
                        color: AppColors.primary,
                        width: 1.5,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: _isResending
                        ? SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                AppColors.primary,
                              ),
                            ),
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.refresh,
                                color: AppColors.primary,
                                size: 20,
                              ),
                              SizedBox(width: 8.w),
                              Text(
                                tr(LanguageKeys.resendEmail),
                                style: TextStyle(
                                  fontSize: 16.w,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.primary,
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
                SizedBox(height: 16.w),

                // Help Text
                Text(
                  tr(LanguageKeys.didntReceiveEmailCheckSpam),
                  style: TextStyle(
                    fontSize: 12.w,
                    color: AppColors.greyFontColor,
                    fontWeight: FontWeight.w400,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 24.w),

                // Back to Login Link
                GestureDetector(
                  onTap: _goBackToLogin,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.arrow_back,
                        size: 16,
                        color: AppColors.primary,
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        tr(LanguageKeys.backToLogin),
                        style: TextStyle(
                          fontSize: 14.w,
                          color: AppColors.primary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
