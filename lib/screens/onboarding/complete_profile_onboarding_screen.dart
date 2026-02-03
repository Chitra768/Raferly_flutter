import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:referaly/controller/complete_profile_onboarding_controller.dart';
import 'package:referaly/languages/languagekeys.dart';
import 'package:referaly/resources/app_assets.dart';
import 'package:referaly/resources/app_colors.dart';
import 'package:referaly/resources/text_style.dart';
import 'package:referaly/utils/translations.dart';
import '../../controller/controller_registration.dart';

class CompleteProfileOnboardingScreen extends StatelessWidget {
  const CompleteProfileOnboardingScreen({super.key});

  static String pageId = '/completeProfileOnboarding';

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CompleteProfileOnboardingController>();

    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: AppBar(
        backgroundColor: AppColors.grey100,
        elevation: 0,
        automaticallyImplyLeading: false,
        surfaceTintColor: AppColors.whiteColor,
        title: Row(
          children: [
            GestureDetector(
              onTap: () => Get.back(),
              child: Icon(Icons.arrow_back,
                  size: 24.sp, color: AppColors.fontBlack),
            ),
            SizedBox(width: 16.w),
            Text(
              tr(LanguageKeys.completeProfile),
              style: stylePoppins(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.fontBlack,
              ),
            ),
          ],
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(60.h),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      tr(LanguageKeys.step2Of3),
                      style: stylePoppins(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w400,
                        color: AppColors.grey600,
                      ),
                    ),
                    Text(
                      '67%',
                      style: stylePoppins(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w400,
                        color: AppColors.grey600,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8.h),
                // Progress bar
                Container(
                  height: 4.h,
                  decoration: BoxDecoration(
                    color: AppColors.grey300,
                    borderRadius: BorderRadius.circular(2.r),
                  ),
                  child: FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor: 0.67,
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
      body: SafeArea(
        top: false,
        child: Form(
          key: controller.formKey,
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                Text(
                  tr(LanguageKeys.tellUsAboutYourself),
                  style: stylePoppins(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.fontBlack,
                  ),
                ),
                SizedBox(height: 8.h),
                // Description
                Text(
                  tr(LanguageKeys.helpUsPersonalizeYourExperience),
                  style: stylePoppins(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                    color: AppColors.grey600,
                  ),
                ),
                SizedBox(height: 32.h),

                // Phone Number Field
                _buildLabel(tr(LanguageKeys.phoneNumber), isRequired: true),
                SizedBox(height: 8.h),
                _buildPhoneNumberField(
                  controller: controller.phoneNumberController,
                  selectedCountry: controller.selectedCountry,
                  countryList: controller.countries,
                  validator: (value) => value == null || value.trim().isEmpty
                      ? tr(LanguageKeys.phoneNumberRequired)
                      : null,
                ),
                SizedBox(height: 24.h),

                // City Field
                _buildLabel(tr(LanguageKeys.city), isRequired: true),
                SizedBox(height: 8.h),
                _buildTextField(
                  controller: controller.cityController,
                  hintText: tr(LanguageKeys.enterCity),
                  icon: AppAssets.imgLocation,
                  validator: (value) => value == null || value.trim().isEmpty
                      ? tr(LanguageKeys.cityRequired)
                      : null,
                ),
                SizedBox(height: 24.h),

                // Job Title Field
                _buildLabel(tr(LanguageKeys.jobTitle), isRequired: true),
                SizedBox(height: 8.h),
                _buildTextField(
                  controller: controller.jobController,
                  hintText: tr(LanguageKeys.enterJob),
                  icon: AppAssets.imgJobActivity,
                  validator: (value) => value == null || value.trim().isEmpty
                      ? tr(LanguageKeys.jobRequired)
                      : null,
                ),
                SizedBox(height: 32.h),

                // Privacy Notice
                Container(
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(12.r),
                    border:
                        Border.all(color: AppColors.primary.withOpacity(0.1)),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Information Icon
                      Container(
                        width: 20.w,
                        height: 20.w,
                        decoration: const BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            'i',
                            style: stylePoppins(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                              color: AppColors.whiteColor,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 12.w),
                      // Text Content
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              tr(LanguageKeys.privacyNotice),
                              style: stylePoppins(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w600,
                                color: AppColors.primary,
                              ),
                            ),
                            SizedBox(height: 4.h),
                            Text(
                              tr(LanguageKeys.privacyNoticeDescription),
                              style: stylePoppins(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w400,
                                color: AppColors.primary.withOpacity(0.8),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 32.h),

                // Error Message
                Obx(() {
                  if (controller.errorMessage.value.isNotEmpty) {
                    return Padding(
                      padding: EdgeInsets.only(bottom: 16.h),
                      child: Container(
                        padding: EdgeInsets.all(12.w),
                        decoration: BoxDecoration(
                          color: AppColors.redColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8.r),
                          border: Border.all(
                            color: AppColors.redColor.withOpacity(0.3),
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.error_outline,
                              color: AppColors.redColor,
                              size: 20.sp,
                            ),
                            SizedBox(width: 8.w),
                            Expanded(
                              child: Text(
                                controller.errorMessage.value,
                                style: stylePoppins(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w400,
                                  color: AppColors.redColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                }),

                // Continue Button
                Obx(() => SizedBox(
                      width: double.infinity,
                      height: 50.h,
                      child: ElevatedButton(
                        onPressed: controller.isLoading.value
                            ? null
                            : () {
                                controller.saveAndContinue();
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          disabledBackgroundColor:
                              AppColors.primary.withOpacity(0.6),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          elevation: 0,
                        ),
                        child: controller.isLoading.value
                            ? SizedBox(
                                width: 20.w,
                                height: 20.w,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    AppColors.whiteColor,
                                  ),
                                ),
                              )
                            : Text(
                                tr(LanguageKeys.continueText),
                                style: stylePoppins(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.whiteColor,
                                ),
                              ),
                      ),
                    )),
                SizedBox(height: 20.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text, {bool isRequired = false}) {
    return Row(
      children: [
        Text(
          text,
          style: stylePoppins(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.fontBlack,
          ),
        ),
        if (isRequired)
          Text(
            ' *',
            style: TextStyle(color: AppColors.redColor, fontSize: 16),
          ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required String icon,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      validator: validator,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: stylePoppins(
          fontSize: 14.sp,
          fontWeight: FontWeight.w400,
          color: AppColors.grey600,
        ),
        filled: true,
        fillColor: AppColors.whiteColor,
        prefixIcon: Padding(
          padding: EdgeInsets.all(12.w),
          child: SvgPicture.asset(
            icon,
            width: 20.w,
            height: 20.w,
            colorFilter: ColorFilter.mode(
              AppColors.grey600,
              BlendMode.srcIn,
            ),
          ),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(color: AppColors.grey300, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(color: AppColors.grey300, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(color: AppColors.redColor, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(color: AppColors.redColor, width: 2),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      ),
      style: stylePoppins(
        fontSize: 14.sp,
        fontWeight: FontWeight.w400,
        color: AppColors.fontBlack,
      ),
    );
  }

  Widget _buildPhoneNumberField({
    required TextEditingController controller,
    required Rx<Country> selectedCountry,
    required List<Country> countryList,
    String? Function(String?)? validator,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.grey300, width: 1),
      ),
      child: Row(
        children: [
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              Get.bottomSheet(
                _buildCountryPickerBottomSheet(
                  countryList: countryList,
                  selectedCountry: selectedCountry,
                ),
                isScrollControlled: true,
                backgroundColor: Colors.white,
              );
            },
            child: Obx(() => Container(
                  width: 80,
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        AppAssets.imgPhoneActivity,
                        width: 20.w,
                        height: 20.w,
                        colorFilter: ColorFilter.mode(
                          AppColors.grey600,
                          BlendMode.srcIn,
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        selectedCountry.value.code,
                        style: stylePoppins(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                          color: AppColors.fontBlack,
                        ),
                      ),
                    ],
                  ),
                )),
          ),
          Container(
            width: 1,
            height: 30,
            color: AppColors.grey300,
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: TextFormField(
              controller: controller,
              keyboardType: TextInputType.phone,
              validator: validator,
              onTapOutside: (_) =>
                  FocusManager.instance.primaryFocus?.unfocus(),
              decoration: InputDecoration(
                hintText: tr(LanguageKeys.enterNum),
                border: InputBorder.none,
                isDense: true,
                hintStyle: stylePoppins(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                  color: AppColors.grey600,
                ),
                contentPadding: EdgeInsets.symmetric(vertical: 16.h),
                errorStyle: const TextStyle(height: 0.8),
              ),
              style: stylePoppins(
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
                color: AppColors.fontBlack,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCountryPickerBottomSheet({
    required List<Country> countryList,
    required Rx<Country> selectedCountry,
  }) {
    return SafeArea(
      child: Container(
        height: Get.height * 0.7,
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            IconButton(
              onPressed: () => Get.back(),
              icon: Icon(
                Icons.close,
                color: AppColors.fontBlack,
              ),
              alignment: Alignment.centerLeft,
            ),
            SizedBox(height: 8.h),
            Expanded(
              child: ListView.separated(
                itemCount: countryList.length,
                separatorBuilder: (_, __) => Divider(color: AppColors.grey200),
                itemBuilder: (context, index) {
                  final country = countryList[index];
                  return ListTile(
                    minVerticalPadding: 0,
                    minTileHeight: 40,
                    onTap: () {
                      selectedCountry.value = country;
                      Get.back();
                    },
                    leading: Text(country.emoji,
                        style: const TextStyle(fontSize: 20)),
                    title: Text(
                      country.name,
                      style: stylePoppins(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                        color: AppColors.fontBlack,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
