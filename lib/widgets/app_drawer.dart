import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:referaly/controller/controller_main_professional.dart';
import 'package:referaly/controller/controller_splash.dart';
import 'package:referaly/controller/track_lead_controller.dart';
import 'package:referaly/helpers/agency_colleague_access_helper.dart';
import 'package:referaly/helpers/premium_helper.dart';
import 'package:referaly/languages/languagekeys.dart';
import 'package:referaly/resources/app_preference.dart';
import 'package:referaly/resources/text_style.dart';
import 'package:referaly/screens/auth/screen_initial_language.dart';
import 'package:referaly/screens/permissions/notification_permissions_screen.dart';
import 'package:referaly/screens/profile/my_profile_screen.dart';
import 'package:referaly/utils/translations.dart';

import '../resources/app_assets.dart';
import '../resources/app_colors.dart';
import '../screens/dashboard/membership_plan_new.dart';
import '../screens/feedbacks/feedbacks_screen.dart';

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
            // _buildProfileSection(),
            // const SizedBox(height: 10),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
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
                          _buildDrawerItem(
                            imgePath: AppAssets.imgAddNotification,
                            title: tr(LanguageKeys.notificationAndPermissions),
                            onTap: () {
                              Get.back();
                              Get.toNamed(NotificationPermissionsScreen.pageId);
                            },
                          ),
                          const SizedBox(height: 5),
                          _buildDrawerItem(
                            imgePath: AppAssets.imgFeedBack,
                            // title: tr(LanguageKeys.feedbacks),
                            title: tr(LanguageKeys.bugAndSuggestions),
                            onTap: () {
                              Get.back();
                              Get.toNamed(FeedbacksScreen.pageId);
                            },
                          ),
                          const SizedBox(height: 5),
                          Obx(() {
                            final profileData = controller.profile.value?.data;
                            // Hide Membership for agency / independent colleagues — their
                            // plan is owned by the sponsoring account.
                            if (AgencyColleagueAccessHelper.isAgencyColleague(profileData) ||
                                AgencyColleagueAccessHelper.isIndependentColleague(profileData)) {
                              return const SizedBox();
                            }
                            final companyType = profileData?.companyType?.toLowerCase().trim();
                            return companyType != "individual" &&
                                    companyType != '' &&
                                    companyType != null &&
                                    companyType != 'null'
                                ? Column(
                                    children: [
                                      _buildDrawerItem(
                                        imgePath: AppAssets.imgpremium,
                                        title: tr(LanguageKeys.Membership),
                                        onTap: () {
                                          Get.back();
                                          Get.toNamed(MembershipPlanNewScreen.pageId)?.then((value) {
                                            controller.getProfile();
                                            Get.back();
                                          });
                                        },
                                      ),
                                      const SizedBox(height: 5),
                                    ],
                                  )
                                : const SizedBox();
                          }),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: _buildDrawerItem(
                imgePath: AppAssets.imgLogout,
                title: tr(LanguageKeys.logout),
                onTap: () async {
                  try {
                    // Clear controller cached data first
                    if (Get.isRegistered<ControllerMainProfessional>()) {
                      Get.find<ControllerMainProfessional>().clearCachedData();
                    }
                    if (Get.isRegistered<TrackLeadsController>()) {
                      Get.delete<TrackLeadsController>();
                    }

                    // Clear authenticated session (preserve remember-me credentials if enabled)
                    final preserveRememberMe = AppPreference.readBool(AppPreference.rememberMe);
                    await AppPreference.clearSession(
                      preserveRememberMe: preserveRememberMe,
                    );

                    // Clear deep link tracking
                    if (Get.isRegistered<ControllerSplash>()) {
                      final splashController = Get.find<ControllerSplash>();
                      splashController.clearDeepLinkTracking();
                    }

                    // Clear any pending deep link data
                    AppPreference.writeString('pending_deal_id', '');
                    AppPreference.writeString('pending_campaign', '');
                    AppPreference.writeString('pending_stage', '');
                    AppPreference.writeBool(AppPreference.isDeeplink, false);

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
                              errorBuilder: (context, error, stackTrace) => const Icon(
                                Icons.person,
                                size: 60,
                                color: AppColors.primary,
                              ),
                            )
                          : Image.asset(
                              AppAssets.imgProfileImage,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) => const Icon(
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
                child: Container(
                  height: 30,
                  width: 30,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Icon(Icons.camera_alt_outlined, color: AppColors.whiteColor, size: 17),
                ),
                // child: Image.asset(
                //   AppAssets.imgCamera,
                //   height: 30,
                //   width: 30,
                // ),
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
              Obx(() {
                final premium = PremiumHelper.isPremiumUser(controller.profile.value?.data);
                return premium
                    ? SvgPicture.asset(
                        AppAssets.imgHDashboardCrown,
                        height: 20,
                        width: 20,
                      )
                    : const SizedBox();
              }),
              // const Spacer()
            ],
          ),
          const SizedBox(height: 5),
          Text(
            controller.profile.value?.data?.companyName ?? "",
            style: stylePoppins(
              fontSize: 16,
              color: AppColors.grey600,
            ),
          ),
          const SizedBox(height: 4),
          Obx(
            () => Text(
              AgencyColleagueAccessHelper.accountHeaderLabel(
                controller.profile.value?.data,
              ),
              style: stylePoppins(
                fontSize: 13,
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          // Show company description if company type is null
          // Obx(() {
          //   final companyType = controller.profile.value?.data?.companyType;
          //   final companyDescription = controller.profile.value?.data?.companyDescription;

          //   if ((companyType == null || companyType == 'null' || companyType.isEmpty) &&
          //       companyDescription != null &&
          //       companyDescription.isNotEmpty) {
          //     return Column(
          //       crossAxisAlignment: CrossAxisAlignment.start,
          //       children: [
          //         const SizedBox(height: 8),
          //         Text(
          //           companyDescription,
          //           style: stylePoppins(
          //             fontSize: 14,
          //             color: AppColors.grey600,
          //             fontWeight: FontWeight.w400,
          //           ).copyWith(height: 1.4),
          //         ),
          //       ],
          //     );
          //   }
          //   return const SizedBox.shrink();
          // }),
        ],
      ),
    );
  }

  Widget _buildDrawerItem({required String imgePath, required String title, VoidCallback? onTap}) {
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
            Expanded(
              child: Text(
                title,
                style: stylePoppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: AppColors.blackColor,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
