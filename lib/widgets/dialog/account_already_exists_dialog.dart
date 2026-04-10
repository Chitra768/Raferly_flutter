import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:referaly/controller/controller_login.dart';
import 'package:referaly/languages/languagekeys.dart';
import 'package:referaly/resources/app_assets.dart';
import 'package:referaly/resources/app_colors.dart';
import 'package:referaly/screens/auth/forgot_password.dart';
import 'package:referaly/screens/auth/screen_registration.dart';
import 'package:referaly/social_logins/google_sign_in_service.dart';
import 'package:referaly/utils/translations.dart';
import 'package:referaly/widgets/custom_toast_msg.dart';

class AccountAlreadyExistsDialog extends StatefulWidget {
  final String email;

  const AccountAlreadyExistsDialog({
    super.key,
    required this.email,
  });

  @override
  State<AccountAlreadyExistsDialog> createState() =>
      _AccountAlreadyExistsDialogState();
}

class _AccountAlreadyExistsDialogState
    extends State<AccountAlreadyExistsDialog> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _loginController = Get.put(ControllerLogin());
  final _isPasswordVisible = false.obs;

  @override
  void initState() {
    super.initState();
    _emailController.text = widget.email;
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _togglePasswordVisibility() {
    _isPasswordVisible.value = !_isPasswordVisible.value;
  }

  Future<void> _handleSignIn() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    _loginController.tcEmail.text = _emailController.text.trim();
    _loginController.tcPassword.text = _passwordController.text.trim();

    await _loginController.loginApi();
  }

  Future<void> _handleGoogleSignIn() async {
    try {
      final user = await GoogleSignInService.loginWithGoogle();
      if (user != null) {
        final tokenId =
            await FirebaseAuth.instance.currentUser?.getIdToken(true);

        if (tokenId != null) {
          final success = await GoogleSignInService.socialLoginApi(
            user,
            tokenId,
            socialType: 'google',
          );
          if (success) {
            Get.back(); // Close the dialog
          }
        }
      } else {
        CustomToast.show(
          Get.overlayContext!,
          tr(LanguageKeys.socialLoginCancelled),
        );
      }
    } catch (e) {
      CustomToast.show(
        Get.overlayContext!,
        tr(LanguageKeys.socialLoginError),
      );
    }
  }

  void _handleUseDifferentEmail() {
    Get.back(); // Close the dialog
    // Navigate to registration screen
    Get.toNamed(ScreenRegistration.pageId);
    //  Get.toNamed(
    //   ScreenRegistration.pageId,
    //   arguments: {ScreenRegistration.argReturnToLoginOnSignIn: true},
    // );
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
          borderRadius: BorderRadius.circular(16),
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
            padding: EdgeInsets.all(20.w),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Close Button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: () => Get.back(),
                        child: Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: AppColors.grey200.withOpacity(0.5),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.close,
                            size: 18,
                            color: AppColors.greyFontColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16.w),

                  // Header Icon
                  Center(
                    child: Container(
                      width: 64,
                      height: 64,
                      decoration: const BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.person,
                        color: Colors.white,
                        size: 32,
                      ),
                    ),
                  ),
                  SizedBox(height: 24.w),

                  // Title
                  Text(
                    tr(LanguageKeys.accountAlreadyExists),
                    style: TextStyle(
                      fontSize: 22.w,
                      fontWeight: FontWeight.w600,
                      color: AppColors.blackColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 12.w),

                  // Description
                  Text(
                    tr(LanguageKeys.accountAlreadyExistsDescription),
                    style: TextStyle(
                      fontSize: 14.w,
                      color: AppColors.greyFontColor,
                      fontWeight: FontWeight.w400,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 24.w),

                  // Email Field
                  Text(
                    tr(LanguageKeys.email),
                    style: TextStyle(
                      fontSize: 14.w,
                      color: AppColors.blackColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 8.w),
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    enabled: false,
                    decoration: InputDecoration(
                      hintText: tr(LanguageKeys.enterEmail),
                      isDense: true,
                      filled: true,
                      fillColor: Colors.white,
                      hintStyle: TextStyle(color: AppColors.greyFontColor),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 16.w,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: Colors.grey.withOpacity(0.2),
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: Colors.grey.withOpacity(0.2),
                        ),
                      ),
                      disabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: Colors.grey.withOpacity(0.2),
                        ),
                      ),
                      suffixIcon: Container(
                        margin: EdgeInsets.all(8.w),
                        decoration: BoxDecoration(
                          color: AppColors.whiteColor,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.email,
                          size: 18,
                          color: AppColors.greyFontColor,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 16.w),

                  // Password Field
                  Text(
                    tr(LanguageKeys.password),
                    style: TextStyle(
                      fontSize: 14.w,
                      color: AppColors.blackColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 8.w),
                  Obx(
                    () => TextFormField(
                      controller: _passwordController,
                      obscureText: !_isPasswordVisible.value,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return tr(LanguageKeys.pleaseEnterPassword);
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        hintText: tr(LanguageKeys.enterPassword),
                        isDense: true,
                        filled: true,
                        fillColor: Colors.white,
                        hintStyle: TextStyle(color: AppColors.greyFontColor),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 16.w,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: Colors.grey.withOpacity(0.2),
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: Colors.grey.withOpacity(0.2),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: AppColors.primary,
                            width: 1.5,
                          ),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: AppColors.redColor,
                          ),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: AppColors.redColor,
                            width: 2,
                          ),
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isPasswordVisible.value
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: AppColors.greyFontColor,
                          ),
                          onPressed: _togglePasswordVisibility,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 8.w),

                  // Forgot Password Link
                  Align(
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                      onTap: () {
                        Get.back();
                        Get.toNamed(ScreenForgotPassword.pageId);
                      },
                      child: Text(
                        tr(LanguageKeys.forgotPassword),
                        style: TextStyle(
                          fontSize: 14.w,
                          color: AppColors.primary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 24.w),

                  // Sign In Button
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: Obx(
                      () => ElevatedButton(
                        onPressed: _loginController.isLoadingLogin.value
                            ? null
                            : _handleSignIn,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          disabledBackgroundColor: AppColors.grey300,
                        ),
                        child: _loginController.isLoadingLogin.value
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.white,
                                  ),
                                ),
                              )
                            : Text(
                                tr(LanguageKeys.signIn),
                                style: TextStyle(
                                  fontSize: 16.w,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                      ),
                    ),
                  ),
                  SizedBox(height: 24.w),

                  // Separator
                  Row(
                    children: [
                      Expanded(
                        child: Divider(
                          thickness: 1,
                          color: Colors.grey.withOpacity(0.2),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.0.w),
                        child: Text(
                          tr(LanguageKeys.or),
                          style: TextStyle(
                            color: AppColors.greyFontColor,
                            fontSize: 14.w,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Divider(
                          thickness: 1,
                          color: Colors.grey.withOpacity(0.2),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 24.w),

                  // Continue with Google Button
                  SizedBox(
                    height: 38,
                    width: double.infinity,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        backgroundColor: Colors.white,
                        side: BorderSide(
                          color: Colors.grey.withOpacity(0.3),
                          width: 1,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 0,
                      ),
                      onPressed: _handleGoogleSignIn,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 20,
                            height: 20,
                            child: SvgPicture.asset(
                              AppAssets.imgGoogle1,
                              colorFilter: const ColorFilter.mode(
                                Colors.red,
                                BlendMode.srcIn,
                              ),
                            ),
                          ),
                          SizedBox(width: 12.w),
                          Text(
                            tr(LanguageKeys.continueWithGoogle),
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: AppColors.blackColor,
                              fontSize: 12.w,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 24.w),

                  // Use Different Email Link
                  Center(
                    child: GestureDetector(
                      onTap: _handleUseDifferentEmail,
                      child: Text(
                        tr(LanguageKeys.useDifferentEmailAddress),
                        style: TextStyle(
                          fontSize: 14.w,
                          color: AppColors.primary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
