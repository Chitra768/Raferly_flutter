import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../apis/api_path.dart';
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
          Positioned.fill(
            child: SvgPicture.asset(
              AppAssets.imgSplashNewColor,
              fit: BoxFit.fill,
              width: double.infinity,
              height: double.infinity,
            ),
          ),
          if (ApiPath.baseUrl == 'https://refearly-back.developmentlabs.co/api/')
            Positioned(
              top: kToolbarHeight,
              left: 16,
              right: 0,
              bottom: 0,
              child: Text(
                'UAT',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: AppColors.whiteColor,
                  fontFamily: 'Poppins',
                ),
              ),
            ),
        ],
      ),
    );
  }
}
