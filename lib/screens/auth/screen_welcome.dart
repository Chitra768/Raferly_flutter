import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:referaly/get/screens.dart';
import 'package:referaly/resources/app_assets.dart';
import 'package:referaly/widgets/primary_button.dart';

import '../../controller/controller_welcome.dart';
import '../../resources/app_colors.dart';
import '../../widgets/secondary_button_outline.dart';

class ScreenWelcome extends GetView<WelcomeController> {
  static String pageId = "/ScreenWelcome";

  final welcomeController = Get.put(WelcomeController());

  ScreenWelcome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            // Placeholder for the house image
            Image.asset(
              AppAssets.imgWelcomeHouse,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 20),

            // Welcome text
            const Text(
              'Welcome',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w800,
                color: Colors.black, // Set the color to black
              ),
            ),

            const SizedBox(height: 20),
            PrimaryButton(text: "Create an account", onPressed: () {}),
            const SizedBox(height: 25),
            SecondaryButton(
              text: 'login',
              onPressed: () {
                Get.toNamed(ScreenLogin.pageId);
              },
            ),
            const SizedBox(height: 20),

            Row(
              children: [
                Expanded(
                    child: Divider(
                        thickness: 1, color: Colors.grey.withOpacity(0.40))),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    "Create an account in 2 seconds",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color: AppColors.blackColor,
                    ),
                  ),
                ),
                Expanded(
                    child: Divider(
                        thickness: 1, color: Colors.grey.withOpacity(0.40))),
              ],
            ),

            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _socialIcon(Icons.g_mobiledata, 'Google'),
                const SizedBox(width: 20),
                _socialIcon(Icons.facebook, 'Facebook'),
              ],
            ),
          ],
        ),
      ),
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
