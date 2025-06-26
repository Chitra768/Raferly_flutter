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
      body: SvgPicture.asset(
        AppAssets.imgSplash,
        fit: BoxFit.fill,
        width: double.infinity,
        height: double.infinity,
      ),
    );
  }
}
