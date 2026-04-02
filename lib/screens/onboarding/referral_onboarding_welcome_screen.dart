import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:referaly/languages/languagekeys.dart';
import 'package:referaly/resources/app_assets.dart' show AppAssets;
import 'package:referaly/resources/app_colors.dart';
import 'package:referaly/resources/text_style.dart';
import 'package:referaly/utils/translations.dart';
import 'package:referaly/screens/onboarding/referral_onboarding_personal_screen.dart';

/// Step 1 of 3: Shown when user has a pending deal (from referral link) but
/// mandatory profile (Personal + Business) is incomplete. After "Get Started",
/// user goes through Personal Info (Step 2) and Business Info (Step 3); then
/// the deal opens and they can accept the contract and see the lead/contract.
class ReferralOnboardingWelcomeScreen extends StatelessWidget {
  const ReferralOnboardingWelcomeScreen({super.key});

  static String pageId = '/referralOnboardingWelcome';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: AppBar(
        backgroundColor: AppColors.whiteColor,
        elevation: 0,
        automaticallyImplyLeading: false,
        surfaceTintColor: AppColors.whiteColor,
        title: Row(
          children: [
            GestureDetector(
              onTap: () => Get.back(),
              child: Icon(
                Icons.arrow_back,
                size: 24.sp,
                color: AppColors.fontBlack,
              ),
            ),
          ],
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(20.h),
          child: Container(
            color: AppColors.whiteColor,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        tr(LanguageKeys.step1Of3),
                        style: stylePoppins(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w400,
                          color: AppColors.grey600,
                        ),
                      ),
                      Text(
                        '33%',
                        style: stylePoppins(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w400,
                          color: AppColors.grey600,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8.h),
                  Container(
                    height: 4.h,
                    decoration: BoxDecoration(
                      color: AppColors.grey300,
                      borderRadius: BorderRadius.circular(2.r),
                    ),
                    child: FractionallySizedBox(
                      alignment: Alignment.centerLeft,
                      widthFactor: 0.33,
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(2.r),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  Container(
                    padding: EdgeInsets.all(12.w),
                    decoration: const BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: SvgPicture.asset(
                        AppAssets.imgHandshake,
                      ),
                    ),
                  ),
                  Text(
                    tr(LanguageKeys.greatNews),
                    textAlign: TextAlign.center,
                    style: stylePoppins(
                      fontSize: 24.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.fontBlack,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.h),
              Text(
                tr(LanguageKeys.referralOnboardingTitle),
                style: stylePoppins(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                  color: AppColors.grey600,
                ),
              ),
              SizedBox(height: 24.h),
              Container(
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(
                  color: AppColors.whiteColor,
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(color: AppColors.grey200),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      tr(LanguageKeys.whatWeNeedFromYou),
                      style: stylePoppins(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.fontBlack,
                      ),
                    ),
                    SizedBox(height: 12.h),
                    _bullet(tr(LanguageKeys.personalInfoLabel), Icons.person,
                        AppColors.grey600),
                    SizedBox(height: 8.h),
                    _bullet(tr(LanguageKeys.professionalInfoLabel),
                        Icons.business, AppColors.grey600),
                  ],
                ),
              ),
              SizedBox(height: 24.h),
              Container(
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(color: AppColors.primary.withOpacity(0.2)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      tr(LanguageKeys.whyThisMatters),
                      style: stylePoppins(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                    ),
                    SizedBox(height: 12.h),
                    _bullet('✓ ${tr(LanguageKeys.buildsTrustWithClients)}',
                        null, AppColors.primary),
                    SizedBox(height: 8.h),
                    _bullet(
                        '✓ ${tr(LanguageKeys.enablesSecureContractProcessing)}',
                        null,
                        AppColors.primary),
                    SizedBox(height: 8.h),
                    _bullet('✓ ${tr(LanguageKeys.unlocksFullPlatformFeatures)}',
                        null, AppColors.primary),
                  ],
                ),
              ),
              SizedBox(height: 40.h),
              SizedBox(
                width: double.infinity,
                height: 50.h,
                child: ElevatedButton(
                  onPressed: _onGetStarted,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    tr(LanguageKeys.profileTypeGetStarted),
                    style: stylePoppins(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.whiteColor,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _bullet(String text, IconData? icon, Color color) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (icon != null)
          Padding(
            padding: EdgeInsets.only(top: 6.h),
            child: Container(
              padding: EdgeInsets.all(6.w),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Icon(icon, size: 12.sp, color: AppColors.primary),
              ),
            ),
          ),
        SizedBox(width: 12.w),
        Expanded(
          child: Text(
            text,
            style: stylePoppins(
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
              color: color,
            ),
          ),
        ),
      ],
    );
  }

  void _onGetStarted() {
    Get.toNamed(ReferralOnboardingPersonalScreen.pageId);
  }
}
