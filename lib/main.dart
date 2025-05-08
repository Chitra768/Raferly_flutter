import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:referaly/get/screens.dart';
import 'package:referaly/resources/app_preference.dart';
import 'package:referaly/screens/splash.dart' show SplashScreen;

import 'get/get_routes.dart';
import 'resources/app_colors.dart';

Future<void> main() async {
  // Ensure Flutter engine and plugin services are initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Optional: Set system UI overlay style
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.white,
    statusBarIconBrightness: Brightness.dark,
    systemNavigationBarColor: Colors.white,
    systemNavigationBarIconBrightness: Brightness.dark,
  ));

  await AppPreference.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'REFERALY',
      debugShowCheckedModeBanner: false,
      color: AppColors.whiteColor,
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: "Poppins",
        primaryColor: AppColors.primaryLightPink,
        textTheme: GoogleFonts.poppinsTextTheme(),
        inputDecorationTheme: InputDecorationTheme(
          errorStyle: TextStyle(color: AppColors.redColor),
        ),
      ),
      home: SplashScreen(),
      getPages: AppPages.pages,
    );
  }
}
