
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:referaly/resources/app_assets.dart';

import 'get/get_routes.dart';
import 'resources/app_colors.dart';
import 'screens/splash.dart';


void main() {
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.white, // Set status bar color to white
    statusBarIconBrightness: Brightness.dark, // Dark icons for contrast
    systemNavigationBarColor: Colors.white, // Navigation bar white
    systemNavigationBarIconBrightness: Brightness.dark,
  ));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return  GetMaterialApp(
      title: 'REFERALY',
      debugShowCheckedModeBanner: false,
      color: AppColors.whiteColor,
      theme: ThemeData(
        primaryColor: AppColors.primaryLightPink,
        fontFamily: "Poppins",
        // fontFamily: "Inter",
        inputDecorationTheme: InputDecorationTheme(
          errorStyle: TextStyle(color: AppColors.redColor),
        ),
      ),
      home: SplashScreen(),
      // home: ScreenSetting(),
      // home: ScreenDashboardList(),
      getPages: AppPages.pages,
    );
  }
}

