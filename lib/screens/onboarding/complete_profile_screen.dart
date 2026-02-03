import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:referaly/controller/complete_profile_controller.dart';
import 'package:referaly/languages/languagekeys.dart';
import 'package:referaly/resources/app_assets.dart';
import 'package:referaly/resources/app_colors.dart';
import 'package:referaly/resources/text_style.dart';
import 'package:referaly/utils/translations.dart';
import 'package:referaly/screens/onboarding/select_jobs_screen.dart';

class CompleteProfileScreen extends StatelessWidget {
  const CompleteProfileScreen({super.key});

  static String pageId = '/completeProfile';

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CompleteProfileController>();

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
              child: Row(
                children: [
                  Icon(Icons.arrow_back,
                      size: 24.sp, color: AppColors.fontBlack),
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
        child: Form(
          key: controller.formKey,
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Profile Picture Section
                Center(
                  child: Container(
                    width: 80.w,
                    height: 80.w,
                    padding: EdgeInsets.all(20.w),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Container(
                      width: 20.w,
                      height: 20.w,
                      decoration: const BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.person,
                        size: 20.sp,
                        color: AppColors.whiteColor,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 24.h),

                // Title
                Text(
                  tr(LanguageKeys.completeYourProfile),
                  textAlign: TextAlign.left,
                  style: stylePoppins(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.fontBlack,
                  ),
                ),
                SizedBox(height: 8.h),

                // Subtitle
                Text(
                  tr(LanguageKeys.completeYourProfileDescription),
                  textAlign: TextAlign.center,
                  style: stylePoppins(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w400,
                    color: AppColors.grey600,
                  ),
                ),
                SizedBox(height: 32.h),

                // My Job Field
                _buildLabelWithIcon(
                  tr(LanguageKeys.myJob),
                  AppAssets.imgJobActivity,
                ),
                SizedBox(height: 8.h),
                _buildTextField(
                  controller: controller.jobController,
                  hintText: tr(LanguageKeys.myJobPlaceholder),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return tr(LanguageKeys.pleaseEnterJob);
                    }
                    return null;
                  },
                ),
                SizedBox(height: 24.h),

                // What type of professionals can I refer
                _buildLabelWithIcon(
                  tr(LanguageKeys.whatTypeOfProfessionalsCanIRefer),
                  AppAssets.imgHandshake,
                ),
                SizedBox(height: 8.h),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          GestureDetector(
                            onTap: () async {
                              final result = await Get.toNamed(
                                SelectJobsScreen.pageId,
                              );
                              if (result != null && result is Map) {
                                final ids = result['ids'] as List<int>?;
                                final titles =
                                    result['titles'] as Map<int, String>?;
                                if (ids != null && titles != null) {
                                  controller.professionalsCanReferList.clear();
                                  controller.professionalsCanReferList
                                      .addAll(ids);
                                  controller.professionalsCanReferTitles
                                      .clear();
                                  controller.professionalsCanReferTitles
                                      .addAll(titles);
                                  controller.professionalsCanReferError.value =
                                      '';
                                }
                              }
                            },
                            child: AbsorbPointer(
                              child: SizedBox(
                                height: 40.h,
                                child: TextFormField(
                                  controller: controller
                                      .professionalsCanReferController,
                                  style: stylePoppins(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w400,
                                    color: AppColors.fontBlack,
                                  ),
                                  decoration: InputDecoration(
                                    hintText: tr(LanguageKeys
                                        .whatTypeOfProfessionalsCanIReferPlaceholder),
                                    hintStyle: stylePoppins(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w400,
                                      color: AppColors.grey600,
                                    ),
                                    filled: true,
                                    fillColor: AppColors.grey100,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12.r),
                                      borderSide: BorderSide(
                                          color: AppColors.grey300, width: 1),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12.r),
                                      borderSide: BorderSide(
                                          color: AppColors.grey300, width: 1),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12.r),
                                      borderSide: const BorderSide(
                                          color: AppColors.primary, width: 2),
                                    ),
                                    errorBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12.r),
                                      borderSide: BorderSide(
                                          color: AppColors.redColor, width: 1),
                                    ),
                                    focusedErrorBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12.r),
                                      borderSide: BorderSide(
                                          color: AppColors.redColor, width: 2),
                                    ),
                                    contentPadding: EdgeInsets.symmetric(
                                        horizontal: 16.w, vertical: 10.h),
                                    errorStyle: const TextStyle(height: 0),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 4.h),
                          Obx(() => SizedBox(
                                height: 16.h,
                                child: controller.professionalsCanReferError
                                        .value.isNotEmpty
                                    ? Text(
                                        controller
                                            .professionalsCanReferError.value,
                                        style: stylePoppins(
                                          fontSize: 12.sp,
                                          fontWeight: FontWeight.w400,
                                          color: AppColors.redColor,
                                        ),
                                      )
                                    : const SizedBox.shrink(),
                              )),
                        ],
                      ),
                    ),
                  ],
                ),
                Obx(() => Align(
                      alignment: Alignment.centerLeft,
                      child: Wrap(
                        spacing: 8.w,
                        runSpacing: 8.h,
                        children: controller.professionalsCanReferList
                            .map((id) => Chip(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 12.w, vertical: 8.h),
                                  label: Text(
                                    controller
                                            .professionalsCanReferTitles[id] ??
                                        id.toString(),
                                    style: stylePoppins(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 14.sp,
                                      color: AppColors.fontBlack,
                                    ),
                                  ),
                                  backgroundColor:
                                      AppColors.primary.withOpacity(0.2),
                                  deleteIcon: const Icon(Icons.close, size: 18),
                                  onDeleted: () => controller
                                      .removeProfessionalsCanRefer(id),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15.r),
                                  ),
                                ))
                            .toList(),
                      ),
                    )),
                SizedBox(height: 24.h),

                // Who can refer me
                _buildLabelWithIcon(
                  tr(LanguageKeys.whoCanReferMe),
                  AppAssets.imgGroup,
                ),
                SizedBox(height: 8.h),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          GestureDetector(
                            onTap: () async {
                              final result = await Get.toNamed(
                                SelectJobsScreen.pageId,
                              );
                              if (result != null && result is Map) {
                                final ids = result['ids'] as List<int>?;
                                final titles =
                                    result['titles'] as Map<int, String>?;
                                if (ids != null && titles != null) {
                                  controller.whoCanReferMeList.clear();
                                  controller.whoCanReferMeList.addAll(ids);
                                  controller.whoCanReferMeTitles.clear();
                                  controller.whoCanReferMeTitles.addAll(titles);
                                  controller.whoCanReferMeError.value = '';
                                }
                              }
                            },
                            child: AbsorbPointer(
                              child: SizedBox(
                                height: 40.h,
                                child: TextFormField(
                                  controller:
                                      controller.whoCanReferMeController,
                                  style: stylePoppins(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w400,
                                    color: AppColors.fontBlack,
                                  ),
                                  decoration: InputDecoration(
                                    hintText: tr(
                                        LanguageKeys.whoCanReferMePlaceholder),
                                    hintStyle: stylePoppins(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w400,
                                      color: AppColors.grey600,
                                    ),
                                    filled: true,
                                    fillColor: AppColors.grey100,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12.r),
                                      borderSide: BorderSide(
                                          color: AppColors.grey300, width: 1),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12.r),
                                      borderSide: BorderSide(
                                          color: AppColors.grey300, width: 1),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12.r),
                                      borderSide: const BorderSide(
                                          color: AppColors.primary, width: 2),
                                    ),
                                    errorBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12.r),
                                      borderSide: BorderSide(
                                          color: AppColors.redColor, width: 1),
                                    ),
                                    focusedErrorBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12.r),
                                      borderSide: BorderSide(
                                          color: AppColors.redColor, width: 2),
                                    ),
                                    contentPadding: EdgeInsets.symmetric(
                                        horizontal: 16.w, vertical: 10.h),
                                    errorStyle: const TextStyle(height: 0),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 4.h),
                          Obx(() => SizedBox(
                                height: 16.h,
                                child: controller
                                        .whoCanReferMeError.value.isNotEmpty
                                    ? Text(
                                        controller.whoCanReferMeError.value,
                                        style: stylePoppins(
                                          fontSize: 12.sp,
                                          fontWeight: FontWeight.w400,
                                          color: AppColors.redColor,
                                        ),
                                      )
                                    : const SizedBox.shrink(),
                              )),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8.h),
                Obx(() => Align(
                      alignment: Alignment.centerLeft,
                      child: Wrap(
                        spacing: 8.w,
                        runSpacing: 8.h,
                        children: controller.whoCanReferMeList
                            .map((id) => Chip(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 12.w, vertical: 8.h),
                                  label: Text(
                                    controller.whoCanReferMeTitles[id] ??
                                        id.toString(),
                                    style: stylePoppins(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 14.sp,
                                      color: AppColors.fontBlack,
                                    ),
                                  ),
                                  backgroundColor:
                                      AppColors.primary.withOpacity(0.2),
                                  deleteIcon: const Icon(Icons.close, size: 18),
                                  onDeleted: () =>
                                      controller.removeWhoCanReferMe(id),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15.r),
                                  ),
                                ))
                            .toList(),
                      ),
                    )),
                SizedBox(height: 24.h),

                // Do I share commissions
                // Who can refer me
                _buildLabelWithIcon(
                  tr(LanguageKeys.doIShareCommissions),
                  AppAssets.imgPercentage,
                ),

                SizedBox(height: 12.h),
                Obx(() => Row(
                      children: [
                        Expanded(
                          child: _buildYesNoButton(
                            label: tr(LanguageKeys.yes),
                            isSelected: controller.sharesCommissions.value,
                            onTap: () =>
                                controller.toggleCommissionSharing(true),
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: _buildYesNoButton(
                            label: tr(LanguageKeys.no),
                            isSelected: !controller.sharesCommissions.value,
                            onTap: () =>
                                controller.toggleCommissionSharing(false),
                          ),
                        ),
                      ],
                    )),
                SizedBox(height: 24.h),

                // In which city do I live
                _buildLabelWithIcon(
                  tr(LanguageKeys.inWhichCityDoILive),
                  AppAssets.imgLocation,
                ),
                SizedBox(height: 8.h),
                _buildTextField(
                  controller: controller.cityController,
                  hintText: tr(LanguageKeys.inWhichCityDoILivePlaceholder),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return tr(LanguageKeys.pleaseEnterCity);
                    }
                    return null;
                  },
                ),
                SizedBox(height: 24.h),

                // Work Preferences
                _buildLabelWithIcon(
                  tr(LanguageKeys.workPreferences),
                  AppAssets.imgWorkPreference,
                ),
                SizedBox(height: 12.h),

                // Remote Only
                _buildWorkPreferenceCard(
                  controller: controller,
                  title: tr(LanguageKeys.remoteOnly),
                  subtitle: tr(LanguageKeys.remoteOnlyDescription),
                  preferenceKey: 'remote',
                ),
                SizedBox(height: 12.h),

                // In Person Only
                _buildWorkPreferenceCard(
                  controller: controller,
                  title: tr(LanguageKeys.inPersonOnly),
                  subtitle: tr(LanguageKeys.inPersonOnlyDescription),
                  preferenceKey: 'in_person',
                ),
                SizedBox(height: 12.h),

                // Hybrid
                _buildWorkPreferenceCard(
                  controller: controller,
                  title: tr(LanguageKeys.hybrid),
                  subtitle: tr(LanguageKeys.hybridDescription),
                  preferenceKey: 'hybrid',
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
                  return SizedBox.shrink();
                }),

                // Save Profile Button
                Obx(() => SizedBox(
                      width: double.infinity,
                      height: 50.h,
                      child: ElevatedButton(
                        onPressed: controller.isLoading.value
                            ? null
                            : () {
                                controller.saveProfile();
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
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.save,
                                    color: AppColors.whiteColor,
                                    size: 20.sp,
                                  ),
                                  SizedBox(width: 8.w),
                                  Text(
                                    tr(LanguageKeys.saveProfile),
                                    style: stylePoppins(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.whiteColor,
                                    ),
                                  ),
                                ],
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

  Widget _buildLabelWithIcon(String label, String icon) {
    return Row(
      children: [
        SvgPicture.asset(
          icon,
          width: 18.w,
          height: 18.w,
          color: AppColors.primary,
        ),
        SizedBox(width: 8.w),
        Expanded(
          child: Text(
            label,
            style: stylePoppins(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.fontBlack,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      validator: validator,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: stylePoppins(
          fontSize: 14.sp,
          fontWeight: FontWeight.w400,
          color: AppColors.grey600,
        ),
        filled: true,
        fillColor: AppColors.grey100,
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

  Widget _buildYesNoButton({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12.h),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary
                  .withOpacity(0.1) // Light grey background when selected
              : AppColors.whiteColor, // White background when unselected
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(
            color: isSelected
                ? AppColors.primary // Dark grey border when selected
                : AppColors.grey300, // Light grey border when unselected
            width: 1,
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: stylePoppins(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: isSelected
                  ? AppColors.primary
                  : AppColors.grey700, // Dark grey text for both states
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildWorkPreferenceCard({
    required CompleteProfileController controller,
    required String title,
    required String subtitle,
    required String preferenceKey,
  }) {
    return Obx(() {
      final isSelected =
          controller.selectedWorkPreference.value == preferenceKey;

      return GestureDetector(
        onTap: () => controller.selectWorkPreference(preferenceKey),
        child: Container(
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.primary
                    .withOpacity(0.1) // Light grey background when selected
                : AppColors.whiteColor, // White background when unselected
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              color: isSelected
                  ? AppColors.primary // Dark grey border when selected
                  : AppColors.grey300,
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 24.w,
                height: 24.w,
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primary : AppColors.grey200,
                  shape: BoxShape.circle,
                  // No border - solid fill only
                ),
                child: isSelected
                    ? Icon(
                        Icons.check,
                        size: 16.sp,
                        color: AppColors.whiteColor,
                      )
                    : null,
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: stylePoppins(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.fontBlack,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      subtitle,
                      style: stylePoppins(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w400,
                        color: AppColors.grey600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
