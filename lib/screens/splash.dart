import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../controller/controller_splash.dart';
import '../resources/app_assets.dart';
import '../resources/app_colors.dart';

class SplashScreen extends GetView<ControllerSplash> {
  static String pageId = "/ScreenSplash";
  @override
  final ControllerSplash controller = Get.put(ControllerSplash());

  SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Top-left decorative SVG
          Positioned(
            top: 80,
            bottom: -25,
            left: 1,
            child: Opacity(
              opacity: 1,
              child: SvgPicture.asset(
                AppAssets.imgSplashLeftLogo,
                height: 80,
              ),
            ),
          ),

          // Top-right decorative SVG
          Positioned(
            top: 65,
            right: 1,
            child: Opacity(
              opacity: 1,
              child: SvgPicture.asset(
                AppAssets.imgSplashRightLogo,
                height: 80,
              ),
            ),
          ),

          // Bottom-right large SVG design
          Positioned(
            bottom: 0,
            right: 0,
            child: SvgPicture.asset(
              AppAssets.imgSplashMainLogo,
              height: 400,
            ),
          ),

          // REFERALY text and logo near the top
          Positioned(
            top: 250, // adjust this value to control how far from top
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  AppAssets.imgAppLgo,
                  height: 60,
                ),
                const SizedBox(width: 20),
                Text(
                  'REFERALY',
                  style: TextStyle(
                    fontSize: 45,
                    color: AppColors.primary,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 2,
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
