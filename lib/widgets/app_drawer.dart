import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:referaly/controller/controller_main_professional.dart';
import 'package:referaly/controller/controller_splash.dart';
import 'package:referaly/controller/track_lead.dart';
import 'package:referaly/languages/languagekeys.dart';
import 'package:referaly/resources/app_preference.dart';
import 'package:referaly/resources/text_style.dart';
import 'package:referaly/screens/auth/screen_initial_language.dart';
import 'package:referaly/screens/auth/screen_welcome.dart';
import 'package:referaly/screens/dashboard/membership_screen.dart';
import 'package:referaly/screens/feedbacks/feedbacks_screen.dart';
import 'package:referaly/screens/profile/my_profile_screen.dart';
import 'package:referaly/screens/profile/new_profile_screen.dart';
import 'package:referaly/screens/profile/profile_view_screen.dart';
import 'package:referaly/utils/translations.dart';

import '../resources/app_assets.dart';
import '../resources/app_colors.dart';

class AppDrawer extends StatefulWidget {
  const AppDrawer({super.key});

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  final controller = Get.find<ControllerMainProfessional>();
  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppColors.whiteColor,
      width: MediaQuery.of(context).size.width * 0.75,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.zero,
      ),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProfileSection(),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  _buildDrawerItem(
                    imgePath: AppAssets.imgHome,
                    title: tr(LanguageKeys.home),
                    onTap: () => Get.back(),
                  ),
                  const SizedBox(height: 5),
                  _buildDrawerItem(
                    imgePath: AppAssets.imgPerson,
                    title: tr(LanguageKeys.myprofile),
                    onTap: () {
                      Get.back();
                      Get.toNamed(MyProfileScreen.pageId);
                    },
                  ),
                  const SizedBox(height: 5),
                  Obx(() {
                    debugPrint(
                        'Company Type from API: ${controller.profile.value?.data?.companyType}');
                    debugPrint(
                        'Translated Type: ${tr(LanguageKeys.professional)}');
                    return controller.profile.value?.data?.companyType
                                ?.toLowerCase()
                                .trim() ==
                            "professional"
                        ? Column(
                            children: [
                              _buildDrawerItem(
                                imgePath: AppAssets.imgpremium,
                                title: tr(LanguageKeys.Membership),
                                onTap: () {
                                  Get.back();
                                  Get.toNamed(MembershipScreen.pageId)
                                      ?.then((value) {
                                    controller.getProfile();
                                    Get.back();
                                  });
                                },
                              ),
                              const SizedBox(height: 5),
                              _buildDrawerItem(
                                imgePath: AppAssets.imgFeedBack,
                                title: tr(LanguageKeys.feedbacks),
                                onTap: () {
                                  Get.back();
                                  Get.toNamed(FeedbacksScreen.pageId);
                                },
                              ),
                              const SizedBox(height: 5),
                            ],
                          )
                        : const SizedBox();
                  }),
                  _buildDrawerItem(
                    imgePath: AppAssets.imgLogout,
                    title: tr(LanguageKeys.logout),
                    onTap: () async {
                      try {
                        // Clear controller cached data first
                        if (Get.isRegistered<ControllerMainProfessional>()) {
                          Get.find<ControllerMainProfessional>()
                              .clearCachedData();
                        }
                        if (Get.isRegistered<TrackLeadsController>()) {
                          Get.delete<TrackLeadsController>();
                        }

                        // Clear all SharedPreferences data
                        await AppPreference.clearPreferences();

                        // Clear any cached data
                        await AppPreference.clearLoginData();

                        // Clear access token specifically
                        await AppPreference.clearAccessToken();

                        // Clear deep link tracking
                        if (Get.isRegistered<ControllerSplash>()) {
                          final splashController = Get.find<ControllerSplash>();
                          splashController.clearDeepLinkTracking();
                        }

                        // Clear any pending deep link data
                        AppPreference.writeString('pending_deal_id', '');
                        AppPreference.writeString('pending_campaign', '');
                        AppPreference.writeString('pending_stage', '');
                        AppPreference.writeBool(
                            AppPreference.isDeeplink, false);

                        // Optional: reset GetX memory state

                        // Optional: short delay before navigating

                        // Navigate to welcome screen
                        Get.offAllNamed(ScreenInitialLanguage.pageId);
                      } catch (e) {
                        debugPrint('Error during logout: $e');
                        // Even if there's an error, try to navigate to login
                        Get.until((route) => false);
                        Get.offAllNamed(ScreenInitialLanguage.pageId);
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileSection() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              GestureDetector(
                onTap: () {
                  Get.back();
                  Get.toNamed(MyProfileScreen.pageId);
                },
                child: Container(
                  height: 95,
                  width: 95,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.primary,
                      width: 3,
                    ),
                  ),
                  child: Obx(
                    () => ClipOval(
                      child: controller.profileImagePath.isNotEmpty
                          ? Image.network(
                              controller.profileImagePath.value,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  Icon(
                                Icons.person,
                                size: 60,
                                color: AppColors.primary,
                              ),
                            )
                          : Image.asset(
                              AppAssets.imgProfileImage,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  Icon(
                                Icons.person,
                                size: 60,
                                color: AppColors.primary,
                              ),
                            ),
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Image.asset(
                  AppAssets.imgCamera,
                  height: 30,
                  width: 30,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Obx(
                () => Flexible(
                  child: Text(
                    "${controller.profile.value?.data?.firstName ?? ""} ${controller.profile.value?.data?.lastName ?? ""}",
                    style: stylePoppins(
                      fontSize: 19,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 25),
              AppPreference.readString(AppPreference.isPaid) == "2" &&
                      AppPreference.readString(AppPreference.isPaid) == "3"
                  ? SvgPicture.asset(
                      AppAssets.imgHDashboardCrown,
                      height: 20,
                      width: 20,
                    )
                  : const SizedBox(),
              Spacer()
            ],
          ),
          const SizedBox(height: 5),
          Text(
            controller.profile.value?.data?.phoneNumber ?? "",
            style: stylePoppins(
              fontSize: 16,
              color: AppColors.grey600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(
      {required String imgePath, required String title, VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          children: [
            Container(
              height: 42,
              width: 42,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
              ),
              child: Image.asset(
                imgePath,
                height: 24,
                width: 24,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(width: 15),
            Text(
              title,
              style: stylePoppins(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: AppColors.blackColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
