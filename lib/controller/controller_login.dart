import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:referaly/apis/api_result.dart';
import 'package:referaly/resources/app_preference.dart';
import 'package:referaly/screens/home/screen_main.dart';

import '../apis/rest_auth.dart';
import '../models/model_login.dart';
import '../resources/app_helper.dart';
import '../widgets/custom_toast_msg.dart';

class ControllerLogin extends GetxController {
  final tcEmail = TextEditingController();
  final tcPassword = TextEditingController();
  final isPasswordVisible = false.obs;
  final isLoadingLogin = false.obs;

  final loginFormKey = GlobalKey<FormState>();

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  Future<void> loginApi() async {
    AppHelper.hideKeyboard(Get.overlayContext!);

    if (!loginFormKey.currentState!.validate()) return;

    final email = tcEmail.text.trim();
    final password = tcPassword.text.trim();

    isLoadingLogin.value = true;

    try {
      const fcmToken = '';
      final response = await RESTAuth.login(
        email: email.toLowerCase(),
        password: password,
        fcmToken: fcmToken,
      );

      if (response is ApiSuccess<ModelLogin>) {
        if (response.data.status == true) {
          await AppPreference.writeString(AppPreference.accessToken, response.data.data!.accessToken!);
          await AppPreference.writeInt(AppPreference.isLoggedIn, 1);
          CustomToast.show(Get.overlayContext!, response.data.message ?? 'Login successful');
          Get.offAll(() => ScreenMain());
        } else {
          CustomToast.show(Get.overlayContext!, response.data.message ?? 'Login failed');
        }
      } else if (response is ApiFailure) {
        final errorMsg = response.error.message ?? 'Something went wrong';
        CustomToast.show(Get.overlayContext!, errorMsg);
      }
    } catch (e) {
      CustomToast.show(Get.overlayContext!, 'Something went wrong');
      debugPrint('Login Error: $e');
    } finally {
      isLoadingLogin.value = false;
    }
  }

  @override
  void dispose() {
    tcEmail.dispose();
    tcPassword.dispose();
    super.dispose();
  }
}
