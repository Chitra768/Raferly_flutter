// ignore_for_file: unused_import

import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:get/get_navigation/src/routes/transitions_type.dart';
import 'package:referaly/bindings/binding_forgot_password.dart';
import 'package:referaly/get/bindings.dart';
import 'package:referaly/get/screens.dart';
import 'package:referaly/screens/company_profile/edit_company_profile.dart';
import 'package:referaly/screens/edit_profile_screen.dart';

import '../bindings/binding_archeivelist.dart';
import '../bindings/binding_main.dart';
import '../bindings/binding_my_activity.dart';
import '../screens/archeive/archeive_list.dart';
import '../screens/home/screen_main.dart';
import '../screens/my_activity/my_activity.dart';

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
    GetPage(
      name: ScreenMain.pageId,
      page: () => ScreenMain(),
      binding: BindingMain(),
      transition: Transition.noTransition, // Define the transition here
      transitionDuration: const Duration(milliseconds: 500), // Set the duration
    ),
    GetPage(
      name: ArchiveList.pageId,
      page: () => const ArchiveList(),
      binding: BindingArcheiveList(),
      transition: Transition.noTransition, // Define the transition here
      transitionDuration: const Duration(milliseconds: 500), // Set the duration
    ),
    GetPage(
      name: MyActivityScreen.pageId,
      page: () => MyActivityScreen(),
      binding: BindingMyActivity(),
      transition: Transition.noTransition, // Define the transition here
      transitionDuration: const Duration(milliseconds: 500), // Set the duration
    ),
    GetPage(
      name: EditCompanyProfileScreen.pageId,
      page: () => const EditCompanyProfileScreen(),
      transition: Transition.noTransition, // Define the transition here
      transitionDuration: const Duration(milliseconds: 500), // Set the duration
    ),
    GetPage(
      name: EditProfileScreen.pageId,
      page: () => EditProfileScreen(),
      transition: Transition.noTransition, // Define the transition here
      transitionDuration: const Duration(milliseconds: 500), // Set the duration
    ),
  ];
}
