import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:referaly/widgets/widget_loading.dart';
import '../../controller/controller_login.dart';
import '../../resources/app_assets.dart';
import '../../resources/app_colors.dart';
import '../../resources/app_log.dart';
import '../../social_logins/google_sign_in_service.dart';
import '../../widgets/custom_auth_app_bar.dart';
import '../../widgets/primary_button.dart';
import '../home/screen_main.dart';
import 'forgot_password.dart';
import 'screen_registration.dart';

class ScreenLogin extends StatelessWidget {
  static const String pageId = "/ScreenLogin";
  final ControllerLogin controller = Get.put(ControllerLogin());

  ScreenLogin({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: CustomAuthAppBar(),
        backgroundColor: AppColors.whiteColor,
        body: SingleChildScrollView(
          child: Form(
            key: controller.loginFormKey,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      const Expanded(
                          child: Divider(thickness: 1, color: Colors.grey)),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(
                          "Create an account in 2 seconds",
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 18,
                            color: AppColors.blackColor,
                          ),
                        ),
                      ),
                      const Expanded(
                          child: Divider(thickness: 1, color: Colors.grey)),
                    ],
                  ),
                  const SizedBox(height: 20),
                  /// Social Signup
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _socialIcon(Icons.g_mobiledata, 'Google', () async {
                        final user = await GoogleSignInService.loginWithGoogle();
                        if (user != null) {
                     AppLog.d('user name : "${user.displayName}');
                     Get.toNamed(ScreenMain.pageId);

                          // controller.loginWithSocial(
                          //   email: user.email ?? '',
                          //   providerUIdToken: user.uid,
                          //   provider: 'google',
                          //   fullName: user.displayName,
                          // ).then((value) {
                          //   if (value != null && value.success == true) {
                          //     AppLog.d('Google User Data: $user');
                          //   }
                          // });
                        }
                      }),
                      const SizedBox(width: 20),
                      _socialIcon(Icons.apple, 'Apple', () async {
                        // final user = await GoogleSignInService.newSignInWithApple();
                        // if (user != null) {
                        //   print('user name apple ${user.email}');
                        //   print('Apple user given ${GoogleSignInService.firstName}');
                        //   print('Apple user family ${GoogleSignInService.lastName}');
                        //   controllerr.loginWithSocial(
                        //     email: user.email ?? '',
                        //     providerUIdToken: user.uid,
                        //     provider: 'apple',
                        //     firstName: GoogleSignInService.firstName ?? '',
                        //     lastName: GoogleSignInService.lastName ?? '',
                        //   ).then((value) {
                        //     if (value != null && value.success == true) {
                        //       AppLog.d('Apple User Data: $user');
                        //     }
                        //   });
                        //}
                      }),
                      const SizedBox(width: 20),
                      _socialIcon(Icons.facebook, 'Facebook', () async {
                        User? user = await GoogleSignInService.loginWithFacebook();
                        AppLog.d('user name : "${user!.displayName!}');

                        print("Facebook sign-in clicked");
                      }),
                    ],
                  ),


                  const SizedBox(height: 30),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Login to continue",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 22,
                            color: Colors.black87,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          "Welcome back to Referaly!",
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Email
                  _buildTextField(
                    controller: controller.tcEmail,
                    hintText: 'Enter Email',
                    label: 'Email',
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter email';
                      }
                      // Regular expression for validating email format
                      String pattern =
                          r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
                      RegExp regex = RegExp(pattern);
                      if (!regex.hasMatch(value)) {
                        return 'Please enter a valid email address';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 20),

                  // Password
                  Obx(() => _buildTextField(
                        controller: controller.tcPassword,
                        hintText: 'Enter Password',
                        label: 'Password',
                        obscureText: !controller.isPasswordVisible.value,
                        validator: (value) => value == null || value.isEmpty
                            ? 'Please enter password'
                            : null,
                        suffixIcon: IconButton(
                          icon: Icon(
                            controller.isPasswordVisible.value
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                            color: Colors.grey[500],
                          ),
                          onPressed: controller.togglePasswordVisibility,
                        ),
                      )),

                  const SizedBox(height: 10),

                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () => Get.toNamed(ScreenForgotPassword.pageId),
                      child: Text(
                        "Forgot Password?",
                        style: TextStyle(
                          color: AppColors.blackColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  Obx(() {
                    return SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: controller.isLoadingLogin.value
                          ? const WidgetLoading()
                          : PrimaryButton(
                              text: "Login",
                              onPressed: () => controller.loginApi(),
                              elevation: 2,
                            ),
                    );
                  }),

                  const SizedBox(height: 30),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Don’t have an account ? ",
                        style: TextStyle(
                            color: AppColors.greyFontColor, fontSize: 15),
                      ),
                      GestureDetector(
                        onTap: () => Get.toNamed(ScreenRegistration.pageId),
                        child: Text(
                          "Sign Up",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: AppColors.blackColor,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required String label,
    required String? Function(String?) validator,
    bool obscureText = false,
    Widget? suffixIcon,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label, // No "*" here
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: Colors.black.withOpacity(0.7),
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          validator: validator,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(color: Colors.grey[400]),
            filled: true,
            fillColor: Colors.grey[100],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            suffixIcon: suffixIcon,
          ),
        ),
      ],
    );
  }

  Widget _socialIcon(IconData iconData, String tooltip, VoidCallback onTapCallback) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onTapCallback,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.primary, width: 1),
            borderRadius: BorderRadius.circular(40),
          ),
          child: Icon(
            iconData,
            color: AppColors.primary,
            size: 28,
          ),
        ),
      ),
    );
  }

}
