import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:referaly/controller/controller_login.dart';
import 'package:referaly/controller/controller_main_professional.dart';
import 'package:referaly/get/screens.dart';
import 'package:referaly/languages/languagekeys.dart';
import 'package:referaly/resources/app_preference.dart';
import 'package:referaly/resources/text_style.dart';
import 'package:referaly/screens/dashboard/membership_screen.dart';
import 'package:referaly/screens/edit_profile_screen.dart';
import 'package:referaly/screens/feedbacks/feedbacks_screen.dart';
import 'package:referaly/screens/profile/my_profile_screen.dart';
import 'package:referaly/utils/translations.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
                  _buildDrawerItem(
                    imgePath: AppAssets.imgpremium,
                    title: tr(LanguageKeys.Membership),
                    onTap: () {
                      Get.back();
                      Get.toNamed(MembershipScreen.pageId);
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
                  _buildDrawerItem(
                    imgePath: AppAssets.imgLogout,
                    title: tr(LanguageKeys.logout),
                    onTap: () async {
                      // Clear all routes
                      Get.until((route) => false);

                      // Clear preferences
                      await AppPreference.clearLoginData();

                      // Navigate to login
                      Get.offAllNamed(ScreenLogin.pageId);
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
                () => Text(
                  "${controller.profile.value?.data?.firstName ?? ""} ${controller.profile.value?.data?.lastName ?? ""}",
                  style: stylePoppins(
                    fontSize: 19,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(width: 25),
              AppPreference.readString(AppPreference.isPaid) == "2"
                  ? SvgPicture.asset(
                      AppAssets.imgHomeCrown,
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
