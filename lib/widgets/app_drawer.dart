import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:referaly/resources/text_style.dart';
import 'package:referaly/screens/dashboard/membership_screen.dart';
import 'package:referaly/screens/edit_profile_screen.dart';
import 'package:referaly/screens/profile/my_profile_screen.dart';

import '../resources/app_assets.dart';
import '../resources/app_colors.dart';

class AppDrawer extends StatefulWidget {
  const AppDrawer({super.key});

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  String profileImagePath = "";
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
                    title: 'Home',
                    onTap: () => Get.back(),
                  ),
                  const SizedBox(height: 5),
                  _buildDrawerItem(
                    imgePath: AppAssets.imgPerson,
                    title: 'My Profile',
                    onTap: () {
                      Get.toNamed(MyProfileScreen.pageId);
                    },
                  ),
                  const SizedBox(height: 5),
                  _buildDrawerItem(
                    imgePath: AppAssets.imgpremium,
                    title: 'Membership',
                    onTap: () {
                      Get.toNamed(MembershipScreen.pageId);
                    },
                  ),
                  const SizedBox(height: 5),
                  _buildDrawerItem(
                    imgePath: AppAssets.imgFeedBack,
                    title: 'Feedbacks',
                    onTap: () {
                      Get.toNamed(EditProfileScreen.pageId);
                    },
                  ),
                  const SizedBox(height: 5),
                  _buildDrawerItem(
                    imgePath: AppAssets.imgLogout,
                    title: 'Logout',
                    onTap: () {},
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
              Container(
                height: 95,
                width: 95,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.primary,
                    width: 3,
                  ),
                ),
                child: ClipOval(
                  child: profileImagePath.isNotEmpty
                      ? Image.asset(
                          profileImagePath,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Icon(
                            Icons.person,
                            size: 60,
                            color: AppColors.primary,
                          ),
                        )
                      : Image.asset(
                          AppAssets.imgProfileImage,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Icon(
                            Icons.person,
                            size: 60,
                            color: AppColors.primary,
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
          Text(
            "Arnaud Attencia",
            style: stylePoppins(
              fontSize: 19,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            "07 69 6 9 69 69",
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
