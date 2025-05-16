import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:referaly/languages/languagekeys.dart';
import 'package:referaly/utils/translations.dart';
import 'package:referaly/widgets/primary_button.dart';

import '../../controller/controller_create_new_password.dart';
import '../../resources/app_assets.dart';
import '../../resources/app_colors.dart';
import '../../resources/app_helper.dart';
import '../../widgets/custom_auth_app_bar.dart';

class ScreenCreateNewPassword extends StatelessWidget {
  static const String pageId = "/ScreenCreateNewPassword";

  final ControllerCreateNewPassword controllerr =
      Get.put(ControllerCreateNewPassword());

  ScreenCreateNewPassword({super.key});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: const CustomAuthAppBar(),
        backgroundColor: AppColors.whiteColor,
        body: Form(
          key: controllerr.formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                // Title and Subtitle
                 Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        tr(LanguageKeys.createNewPass),
                        style: const TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        tr(LanguageKeys.createNewPasssubtext),
                        style: TextStyle(color: Colors.black54, fontSize: 14),
                      ),
                      SizedBox(height: 30),
                    ],
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildLabel(tr(LanguageKeys.newPass), isRequired: true),

                      _buildUnderlineField(
                        controllerr: controllerr.tcPassword,
                        hintText: 'Enter new password',
                        obscureTextRx: controllerr.obscurePassword,
                        onToggle: () => controllerr.obscurePassword.toggle(),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Password cannot be empty';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 35),
                      _buildLabel(tr(LanguageKeys.confirmPass), isRequired: true),
                      _buildUnderlineField(
                        controllerr: controllerr.tcConfirmPassword,
                        hintText: tr(LanguageKeys.confirmPass),
                        obscureTextRx: controllerr.obscureConfirmPassword,
                        onToggle: () =>
                            controllerr.obscureConfirmPassword.toggle(),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please confirm your password';
                          } else if (value != controllerr.tcPassword.text) {
                            return 'Passwords do not match';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 40),
                      PrimaryButton(
                          text: tr(LanguageKeys.submit),
                          onPressed: () {
                            AppHelper.hideKeyboard(context);
                            controllerr.onSubmit();
                          }),
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

  Widget _buildLabel(String text, {bool isRequired = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Text(
            text,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          ),
          if (isRequired)
            const Text(' *', style: TextStyle(color: Colors.red, fontSize: 16)),
        ],
      ),
    );
  }

  Widget _buildUnderlineField({
    required TextEditingController controllerr,
    required String hintText,
    required RxBool obscureTextRx,
    required VoidCallback onToggle,
    String? Function(String?)? validator,
  }) {
    return Obx(() => Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: TextFormField(
            controller: controllerr,
            obscureText: obscureTextRx.value,
            validator: validator,
            decoration: InputDecoration(
              hintText: hintText,
              isDense: true,
              filled: true,
              fillColor: Colors.black.withOpacity(0.045),
              hintStyle: const TextStyle(color: Colors.grey),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              suffixIcon: IconButton(
                icon: Icon(
                  obscureTextRx.value ? Icons.visibility_off : Icons.visibility,
                ),
                onPressed: onToggle,
              ),
            ),
          ),
        ));
  }
}
