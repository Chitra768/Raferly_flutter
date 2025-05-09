// ignore_for_file: unused_import

import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:get/get_navigation/src/routes/transitions_type.dart';
import 'package:referaly/bindings/binding_activity.dart' show BindingActivity;
import 'package:referaly/bindings/binding_create_new_password.dart';
import 'package:referaly/bindings/binding_registration.dart';

import 'package:referaly/bindings/binding_activity.dart' show BindingActivity;
import 'package:referaly/bindings/binding_create_new_password.dart';
import 'package:referaly/bindings/binding_outofraferly.dart' show BindingOutofraferly;
import 'package:referaly/bindings/binding_registration.dart';
import 'package:referaly/get/bindings.dart';
import 'package:referaly/get/screens.dart';
import 'package:referaly/screens/auth/create_new_password.dart';
import 'package:referaly/screens/auth/screen_registration.dart';
import 'package:referaly/screens/company_profile/edit_company_profile.dart';
import 'package:referaly/screens/dashboard/membership_screen.dart';
import 'package:referaly/screens/dashboard/my_activity_screen.dart' as dashboard;
import 'package:referaly/screens/dashboard/my_activity_screen.dart';
import 'package:referaly/screens/deals/business_referrer_contract_screen.dart';
import 'package:referaly/screens/deals/invited_deals_screen.dart';
import 'package:referaly/screens/deals/out_of_referaly_dialog.dart' show OutOfReferalyScreen;
import 'package:referaly/screens/edit_profile_screen.dart';
import 'package:referaly/screens/profile/company_profile_screen.dart';
import 'package:referaly/screens/profile/my_profile_screen.dart';

import '../bindings/binding_archeivelist.dart';
import '../bindings/binding_company_profile.dart';
import '../bindings/binding_feedback.dart';
import '../bindings/binding_main.dart';
import '../screens/archeive/archeive_list.dart';
import '../screens/feedbacks/feedbacks_screen.dart';
import '../screens/home/screen_main.dart';
import 'package:referaly/screens/auth/create_new_password.dart';
import 'package:referaly/screens/auth/screen_registration.dart';
import '../bindings/binding_company_profile.dart';
import '../bindings/binding_my_profile.dart';

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
      page: () => const MyActivityScreen(),
      binding: BindingActivity(),
      transition: Transition.cupertino,
      transitionDuration: const Duration(milliseconds: 500),
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
      name: IndividualHome.pageId,
      page: () => const IndividualHome(),
      transition: Transition.noTransition,
      transitionDuration: const Duration(milliseconds: 500),
    ),

    GetPage(
      name: InvitedDealsScreen.pageId,
      page: () => const InvitedDealsScreen(),
      binding: BindingInvitedDeals(),
      transition: Transition.cupertino,
      transitionDuration: const Duration(milliseconds: 500),
    ),
    GetPage(
      name: BusinessReferrerContractScreen.pageId,
      page: () => const BusinessReferrerContractScreen(),
      binding: BindingBusinessReferrerContract(),
      transition: Transition.noTransition,
      transitionDuration: const Duration(milliseconds: 500),
    ),
    GetPage(
      name: FeedbacksScreen.pageId,
      page: () => const FeedbacksScreen(),
      binding: BindingFeedback(),
      transition: Transition.noTransition,
      transitionDuration: const Duration(milliseconds: 500),
    ),
    GetPage(
      name: ScreenRegistration.pageId,
      page: () => ScreenRegistration(),
      binding: BindingRegistration(),
      transition: Transition.noTransition, // Define the transition here
      transitionDuration: const Duration(milliseconds: 500), // Set the duration
    ),
    GetPage(
      name: ScreenCreateNewPassword.pageId,
      page: () => ScreenCreateNewPassword(),
      binding: BindingCreateNewPassword(),
      transition: Transition.noTransition, // Define the transition here
      transitionDuration: const Duration(milliseconds: 500), // Set the duration
    ),

    // Inside your GetPage list:
    GetPage(
      name: '/myProfile',
      page: () => MyProfileScreen(),
      binding: BindingMyProfile(),
      transition: Transition.noTransition,
      transitionDuration: const Duration(milliseconds: 500),
    ),
    GetPage(
      name: CompanyProfileScreen.pageId,
      page: () => CompanyProfileScreen(),
      binding: BindingCompanyProfile(),
      transition: Transition.noTransition,
      transitionDuration: const Duration(milliseconds: 500),
    ),
    GetPage(
      name: '/membership',
      page: () => const MembershipScreen(),
      transition: Transition.cupertino,
      transitionDuration: const Duration(milliseconds: 500),
    ),
    GetPage(
      name: OutOfReferalyScreen.pageId,
      page: () => OutOfReferalyScreen(),
      transition: Transition.cupertino,
      transitionDuration: const Duration(milliseconds: 500),
    ),
  ];
}
