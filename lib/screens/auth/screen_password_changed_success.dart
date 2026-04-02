import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:referaly/controller/controller_password_changed_success.dart';
import 'package:referaly/get/screens.dart';
import 'package:referaly/resources/app_assets.dart';
import 'package:referaly/resources/app_colors.dart';
import 'package:referaly/utils/translations.dart';
import 'package:referaly/languages/languagekeys.dart';
import 'package:flutter/services.dart';

class ScreenPasswordChangedSuccess
    extends GetView<ControllerPasswordChangedSuccess> {
  static const String pageId = '/ScreenPasswordChangedSuccess';

  final controller = Get.put(ControllerPasswordChangedSuccess());

  @override
  Widget build(BuildContext context) {
    // Hide the status bar
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Image.asset(
            width: MediaQuery.of(context).size.width,
            AppAssets.imgHeaderBg,
            fit: BoxFit.cover,
          ),
          const SizedBox(height: 20),
          // Logo and header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: Column(
              children: [
                // You can replace this with your logo widget if needed

                Image.asset(
                  AppAssets.imgSuccessMark,
                  width: 100,
                  height: 100,
                ),
                const SizedBox(height: 32),
                Text(
                  tr(LanguageKeys.passChanged),
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Text(
                  tr(LanguageKeys.passChangedSubtext),
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.grey,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 48),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    onPressed: () {
                      Get.offAllNamed(ScreenLogin.pageId);
                    },
                    child: Text(
                      tr(LanguageKeys.login),
                      style: const TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
