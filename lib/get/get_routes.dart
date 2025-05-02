// ignore_for_file: unused_import

import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:get/get_navigation/src/routes/transitions_type.dart';
import 'package:referaly/bindings/binding_forgot_password.dart';
import 'package:referaly/get/bindings.dart';
import 'package:referaly/get/screens.dart';





class AppPages {
  static final List<GetPage> pages = [
    // GetPage(
    //   name: SplashScreen.pageId,
    //   page: () => SplashScreen(),
    //   binding: BindingSplash(),
    //   transition: Transition.noTransition, // Define the transition here
    //   transitionDuration: const Duration(milliseconds: 500), // Set the duration
    // ),
    GetPage(
      name: ScreenLogin.pageId,
      page: () => ScreenLogin(),
      binding: BindingLogin(),
      transition: Transition.noTransition, // Define the transition here
      transitionDuration: const Duration(milliseconds: 500), // Set the duration
    ),
    GetPage(
      name: ScreenForgotPassword.pageId,
      page: () => ScreenForgotPassword(),
      binding: BindingForgotPassword(),
      transition: Transition.noTransition, // Define the transition here
      transitionDuration: const Duration(milliseconds: 500), // Set the duration
    ),
  ];
}
