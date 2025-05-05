// ignore_for_file: unused_import

import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:get/get_navigation/src/routes/transitions_type.dart';
import 'package:referaly/get/bindings.dart';
import 'package:referaly/get/screens.dart';
import 'package:referaly/screens/deals/invited_deals_screen.dart';

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
      name: ScreenChooseLanguage.pageId,
      page: () => ScreenChooseLanguage(),
      binding: BindingChooseLanguage(),
      transition: Transition.noTransition, // Define the transition here
      transitionDuration: const Duration(milliseconds: 500), // Set the duration
    ),
    GetPage(
      name: ScreenWelcome.pageId,
      page: () => ScreenWelcome(),
      binding: BindingWelcome(),
      transition: Transition.noTransition, // Define the transition here
      transitionDuration: const Duration(milliseconds: 500), // Set the duration
    ),
    GetPage(
      name: ScreenVerification.pageId,
      page: () => const ScreenVerification(),
      binding: BindingWelcome(),
      transition: Transition.noTransition, // Define the transition here
      transitionDuration: const Duration(milliseconds: 500), // Set the duration
    ),
    GetPage(
      name: HomeScreenWithoutPrimum.pageId,
      page: () => const HomeScreenWithoutPrimum(),
      transition: Transition.noTransition,
      transitionDuration: const Duration(milliseconds: 500),
    ),
    GetPage(
      name: TrackLeadsScreen.pageId,
      page: () => const TrackLeadsScreen(),
      transition: Transition.noTransition,
      transitionDuration: const Duration(milliseconds: 500),
    ),
    GetPage(
      name: InvitedDealsScreen.pageId,
      page: () => const InvitedDealsScreen(),
      transition: Transition.noTransition,
      transitionDuration: const Duration(milliseconds: 500),
    ),
  ];
}
