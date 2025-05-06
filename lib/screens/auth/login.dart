import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:referaly/get/screens.dart';

import '../../controller/controller_login.dart';
import '../../resources/app_assets.dart';
import '../../resources/app_colors.dart';
import '../../widgets/primary_button.dart';

class ScreenLogin extends StatelessWidget {
  static const String pageId = "/ScreenLogin";
  final ControllerLogin controller = Get.put(ControllerLogin());

  ScreenLogin({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),

            // Logo
            Row(
              children: [
                IconButton(onPressed: (){}, icon: const Icon(Icons.arrow_back_ios)),
                Container(
                  height: 70,
                  width: 70,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: SvgPicture.asset(
                      AppAssets.imgAppLgo,
                      height: 40,
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                Text(
                  'REFERALY',
                  style: TextStyle(
                    fontSize: 28,
                    color: AppColors.primary,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Poppins',
                    letterSpacing: 1.5,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 40),

            Row(
              children: [
                const Expanded(child: Divider(thickness: 1, color: Colors.grey)),
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
                const Expanded(child: Divider(thickness: 1, color: Colors.grey)),
              ],
            ),

            const SizedBox(height: 24),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _socialIcon(Icons.g_mobiledata, 'Google'),
                const SizedBox(width: 20),
                _socialIcon(Icons.apple, 'Apple'),
                const SizedBox(width: 20),
                _socialIcon(Icons.facebook, 'Facebook'),
              ],
            ),

            const SizedBox(height: 40),

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

            // Email Field
            _buildTextField(
              controller: controller.emailController,
              hintText: 'Enter Email',
              label: 'Email',
              validator: (value) =>
              value == null || value.isEmpty ? 'Please enter email' : null,
            ),

            const SizedBox(height: 20),

            // Password Field
            Obx(() => _buildTextField(
              controller: controller.passwordController,
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

            const SizedBox(height: 12),

            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  print("Forgot Password Tapped");
                  Get.toNamed(ScreenForgotPassword.pageId);
                },
                child: Text(
                  "Forgot Password?",
                  style: TextStyle(
                    color: AppColors.blackColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              height: 55,
              child: PrimaryButton(
                text: "Login",
                onPressed: controller.onLoginPressed,
                elevation: 2,
              )
              ,
            ),

            const SizedBox(height: 30),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Don’t have an account ? ",
                  style:
                  TextStyle(color: AppColors.greyFontColor, fontSize: 15),
                ),
                GestureDetector(
                  onTap: () {
                    print("Sign Up Tapped");
                  },
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
            const SizedBox(height: 20),
          ],
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
          label,
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

  Widget _socialIcon(IconData iconData, String tooltip) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: () {
          print("Tapped on $tooltip");
        },
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            border: Border.all(
              color: AppColors.primary,
              width: 1,
            ),
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
