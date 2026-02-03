import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:referaly/controller/profile_controller.dart';
import 'package:referaly/languages/languagekeys.dart';
import 'package:referaly/resources/app_assets.dart';
import 'package:referaly/resources/app_colors.dart';
import 'package:referaly/resources/text_style.dart';
import 'package:referaly/screens/onboarding/complete_profile_screen.dart';
import 'package:referaly/screens/profile/my_profile_screen.dart';
import 'package:referaly/screens/search/search_professionals_screen.dart';
import 'package:referaly/utils/translations.dart';

class WelcomeFinderScreen extends StatelessWidget {
  const WelcomeFinderScreen({super.key});

  static String pageId = '/welcomeFinder';

  @override
  Widget build(BuildContext context) {
    // Get ProfileController (should be registered by BindingWelcomeFinder)
    final ProfileController profileController = Get.find<ProfileController>();

    // Fetch profile if not loaded (using post frame callback to avoid calling in build)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!profileController.isProfileLoaded.value &&
          !profileController.isLoading.value) {
        profileController.getProfile();
      }
    });

    return Scaffold(
      backgroundColor: AppColors.circleBackgrey,
      appBar: AppBar(
        backgroundColor: AppColors.whiteColor,
        surfaceTintColor: AppColors.whiteColor,
        automaticallyImplyLeading: false,
        elevation: 0,
        title: Row(
          children: [
            GestureDetector(
              onTap: () => Get.back(),
              child: Row(
                children: [
                  Icon(
                    Icons.arrow_back,
                    size: 24.sp,
                    color: AppColors.fontBlack,
                  ),
                  SizedBox(width: 8.w),
                  Container(
                    width: 30.w,
                    height: 30.w,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Center(
                      child: SvgPicture.asset(
                        AppAssets.imgHandshake,
                        width: 24.w,
                        height: 24.w,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 12.w),
            Text(
              "Referaly",
              style: stylePoppins(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.fontBlack,
              ),
            ),
          ],
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(1.h),
          child: Container(
            height: 1.h,
            color: AppColors.grey200,
          ),
        ),
      ),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // Rocket illustration with light purple circle background
              _buildRocketIllustration(),
              Text(
                tr(LanguageKeys.welcomeToReferalyFinder),
                textAlign: TextAlign.center,
                style: stylePoppins(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.fontBlack,
                ),
              ),
              SizedBox(height: 8.h),
              // Description text - centered, smaller, medium grey
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Text(
                  tr(LanguageKeys.welcomeToReferalyFinderDescription),
                  textAlign: TextAlign.center,
                  style: stylePoppins(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w400,
                    color: AppColors.grey600,
                  ),
                ),
              ),
              SizedBox(height: 40.h),
              // Step cards - using Obx to reactively update based on profile data
              Obx(() {
                final isProfileCompleted =
                    profileController.profile.value?.data?.isProfileCompleted ??
                        false;
                final isCompanyCompleted =
                    profileController.profile.value?.data?.isCompanyCompleted ??
                        false;
                final isFinderCompleted =
                    profileController.profile.value?.data?.isFinderCompleted ??
                        false;

                return Column(
                  children: [
                    _buildStepCard(
                      stepNumber: 1,
                      title: tr(LanguageKeys.stepPersonalInformation),
                      status: isProfileCompleted
                          ? tr(LanguageKeys.completed)
                          : tr(LanguageKeys.required),
                      description:
                          tr(LanguageKeys.stepPersonalInformationDescription),
                      keywords:
                          tr(LanguageKeys.stepPersonalInformationKeywords),
                      icon: Icons.person,
                      isRequired: true,
                      isCompleted: isProfileCompleted,
                      onTap: isProfileCompleted
                          ? () => Get.toNamed(SearchProfessionalsScreen.pageId)
                          : () => Get.toNamed(MyProfileScreen.pageId,
                              arguments: {'initialTab': 0}),
                    ),
                    SizedBox(height: 16.h),
                    _buildStepCard(
                      stepNumber: 2,
                      title: tr(LanguageKeys.stepCompanyInformation),
                      status: isCompanyCompleted
                          ? tr(LanguageKeys.completed)
                          : tr(LanguageKeys.pending),
                      description:
                          tr(LanguageKeys.stepCompanyInformationDescription),
                      keywords: tr(LanguageKeys.stepCompanyInformationKeywords),
                      icon: Icons.business,
                      isRequired: false,
                      isCompleted: isCompanyCompleted,
                      onTap: isCompanyCompleted
                          ? () => Get.toNamed(SearchProfessionalsScreen.pageId)
                          : () => Get.toNamed(MyProfileScreen.pageId,
                              arguments: {'initialTab': 1}),
                    ),
                    SizedBox(height: 16.h),
                    _buildStepCard(
                      stepNumber: 3,
                      title: tr(LanguageKeys.stepFinderForm),
                      status: isFinderCompleted
                          ? tr(LanguageKeys.completed)
                          : tr(LanguageKeys.pending),
                      description: tr(LanguageKeys.stepFinderFormDescription),
                      keywords: tr(LanguageKeys.stepFinderFormKeywords),
                      icon: Icons.search,
                      isRequired: false,
                      isCompleted: isFinderCompleted,
                      onTap: isFinderCompleted
                          ? () => Get.toNamed(SearchProfessionalsScreen.pageId)
                          : () => Get.toNamed(CompleteProfileScreen.pageId),
                    ),
                  ],
                );
              }),
              SizedBox(height: 40.h),
              // Start button
              Obx(() => _buildStartButton(profileController)),
              SizedBox(height: 20.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRocketIllustration() {
    return Container(
      width: 60.w,
      height: 60.w,
      decoration: BoxDecoration(
        color:
            AppColors.primary.withOpacity(0.15), // Light purple/lavender circle
        shape: BoxShape.circle,
      ),
      child: Center(
        child: SvgPicture.asset(
          AppAssets.imgRocketNew,
          width: 20.w,
          height: 20.w,
        ),
      ),
    );
  }

  Widget _buildStepCard({
    required int stepNumber,
    required String title,
    required String status,
    required String description,
    required String keywords,
    required IconData icon,
    required bool isRequired,
    bool isCompleted = false,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Step number circle - purple if required or completed
            Container(
              width: 28.w,
              height: 28.w,
              decoration: BoxDecoration(
                color: (isRequired || isCompleted)
                    ? AppColors.primary
                    : AppColors.grey300.withOpacity(0.5),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: isCompleted
                    ? Icon(
                        Icons.check,
                        size: 16.sp,
                        color: Colors.white,
                      )
                    : Text(
                        stepNumber.toString(),
                        style: stylePoppins(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500,
                          color: (isRequired || isCompleted)
                              ? Colors.white
                              : AppColors.grey700,
                        ),
                      ),
              ),
            ),
            SizedBox(width: 16.w),
            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          style: stylePoppins(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.fontBlack,
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 8.w, vertical: 4.h),
                        decoration: BoxDecoration(
                          color: isCompleted
                              ? AppColors.primary.withOpacity(0.2)
                              : isRequired
                                  ? AppColors.primary.withOpacity(0.2)
                                  : AppColors.grey300.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Text(
                          status,
                          style: stylePoppins(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w500,
                            color: isCompleted || isRequired
                                ? AppColors.primary
                                : AppColors.grey700,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    description,
                    style: stylePoppins(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w400,
                      color: AppColors.grey600,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Row(
                    children: [
                      Icon(
                        icon,
                        size: 16.sp,
                        color: (isRequired || isCompleted)
                            ? AppColors.primary
                            : AppColors.grey600,
                      ),
                      SizedBox(width: 6.w),
                      Expanded(
                        child: Text(
                          keywords,
                          style: stylePoppins(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w400,
                            color: AppColors.grey600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStartButton(ProfileController profileController) {
    final isProfileCompleted =
        profileController.profile.value?.data?.isProfileCompleted ?? false;
    final isCompanyCompleted =
        profileController.profile.value?.data?.isCompanyCompleted ?? false;
    final isFinderCompleted =
        profileController.profile.value?.data?.isFinderCompleted ?? false;

    return SizedBox(
      width: double.infinity,
      height: 50.h,
      child: ElevatedButton(
        onPressed: () {
          // Get.toNamed(CompleteProfileScreen.pageId);
          // If any step is completed, navigate to SearchProfessionalsScreen
          // Otherwise, navigate to Complete Profile Screen
          if (isProfileCompleted || isCompanyCompleted || isFinderCompleted) {
            Get.toNamed(SearchProfessionalsScreen.pageId);
          } else {
            Get.toNamed(CompleteProfileScreen.pageId);
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
          elevation: 0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              tr(LanguageKeys.start),
              style: stylePoppins(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            SizedBox(width: 8.w),
            Icon(
              Icons.arrow_forward,
              color: Colors.white,
              size: 20.sp,
            ),
          ],
        ),
      ),
    );
  }
}
