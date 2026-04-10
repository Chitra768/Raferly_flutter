import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:referaly/controller/controller_registration.dart';
import 'package:referaly/controller/profile_controller.dart';
import 'package:referaly/languages/languagekeys.dart';
import 'package:referaly/resources/app_colors.dart';
import 'package:referaly/resources/text_style.dart';
import 'package:referaly/utils/translations.dart';
import 'package:referaly/widgets/logo_loader.dart';
import 'referral_onboarding_business_screen.dart';

/// Step 2 of 3: Personal Information for referral onboarding.
/// Prefilled from profile when available. On Continue → Step 3 (Business).
class ReferralOnboardingPersonalScreen extends StatelessWidget {
  const ReferralOnboardingPersonalScreen({super.key});

  static String pageId = '/referralOnboardingPersonal';

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ProfileController>();

    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: _buildAppBar(),
      body: Obx(() {
        if (controller.isLoading.value && !controller.isProfileLoaded.value) {
          return const Center(
              child: SizedBox(width: 24, height: 24, child: LogoLoader()));
        }
        return SafeArea(
          top: false,
          child: Form(
            key: controller.formKey,
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 14.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    tr(LanguageKeys.stepPersonalInformation),
                    style: stylePoppins(
                      fontSize: 24.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.fontBlack,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    tr(LanguageKeys.tellUsAboutYourself),
                    style: stylePoppins(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400,
                      color: AppColors.grey600,
                    ),
                  ),
                  SizedBox(height: 32.h),
                  _buildLabel(tr(LanguageKeys.firstName), isRequired: true),
                  SizedBox(height: 8.h),
                  _buildTextField(controller.firstNameController,
                      hint: tr(LanguageKeys.firstName),
                      validator: (v) => v == null || v.trim().isEmpty
                          ? tr(LanguageKeys.pleaseEnterFirstName)
                          : null),
                  SizedBox(height: 24.h),
                  _buildLabel(tr(LanguageKeys.lastName), isRequired: true),
                  SizedBox(height: 8.h),
                  _buildTextField(controller.lastNameController,
                      hint: tr(LanguageKeys.lastName),
                      validator: (v) => v == null || v.trim().isEmpty
                          ? tr(LanguageKeys.pleaseEnterLastName)
                          : null),
                  SizedBox(height: 24.h),
                  _buildLabel(tr(LanguageKeys.email), isRequired: true),
                  SizedBox(height: 8.h),
                  _buildTextField(controller.emailController,
                      hint: tr(LanguageKeys.email),
                      keyboardType: TextInputType.emailAddress),
                  SizedBox(height: 24.h),
                  _buildLabel(tr(LanguageKeys.phoneNumber), isRequired: true),
                  SizedBox(height: 8.h),
                  _buildPhoneField(controller),
                  SizedBox(height: 24.h),
                  _buildLabel(tr(LanguageKeys.jobTitle), isRequired: true),
                  SizedBox(height: 8.h),
                  _buildTextField(controller.jobController,
                      hint: tr(LanguageKeys.enterJob),
                      validator: (v) => v == null || v.trim().isEmpty
                          ? tr(LanguageKeys.jobRequired)
                          : null),
                  SizedBox(height: 24.h),
                  _buildLabel(tr(LanguageKeys.city), isRequired: true),
                  SizedBox(height: 8.h),
                  _buildTextField(controller.cityController,
                      hint: tr(LanguageKeys.enterCity),
                      validator: (v) => v == null || v.trim().isEmpty
                          ? tr(LanguageKeys.cityRequired)
                          : null),
                  SizedBox(height: 40.h),
                  SizedBox(
                    width: double.infinity,
                    height: 50.h,
                    child: ElevatedButton(
                      onPressed: controller.isLoading.value
                          ? null
                          : () async {
                              if (!controller.validateAndSave()) return;
                              await controller.updateProfile(
                                onSuccessNavigate: () {
                                  Get.offNamed(
                                    ReferralOnboardingBusinessScreen.pageId,
                                  );
                                },
                              );
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
                                    AppColors.whiteColor),
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
                  ),
                  Container(
                    alignment: Alignment.center,
                    child: TextButton(
                      onPressed: () => Get.back(),
                      child: Text(
                        tr(LanguageKeys.back),
                        textAlign: TextAlign.center,
                        style: stylePoppins(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                          color: AppColors.grey600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.whiteColor,
      elevation: 0,
      automaticallyImplyLeading: false,
      surfaceTintColor: AppColors.whiteColor,
      title: Row(
        children: [
          GestureDetector(
            onTap: () => Get.back(),
            child:
                Icon(Icons.arrow_back, size: 24.sp, color: AppColors.fontBlack),
          ),
        ],
      ),
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(20.h),
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
          Text(' *', style: TextStyle(color: AppColors.redColor, fontSize: 16)),
      ],
    );
  }

  Widget _buildTextField(
    TextEditingController controller, {
    required String hint,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      validator: validator,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: stylePoppins(
          fontSize: 14.sp,
          fontWeight: FontWeight.w400,
          color: AppColors.grey600,
        ),
        filled: true,
        fillColor: AppColors.whiteColor,
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
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      ),
      style: stylePoppins(
        fontSize: 14.sp,
        fontWeight: FontWeight.w400,
        color: AppColors.fontBlack,
      ),
    );
  }

  Widget _buildPhoneField(ProfileController controller) {
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
                _countryPicker(
                    controller.countries, controller.selectedCountry),
                isScrollControlled: true,
                backgroundColor: Colors.white,
              );
            },
            child: Obx(() => Container(
                  width: 80.w,
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                  child: Text(
                    controller.selectedCountry.value.code,
                    style: stylePoppins(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColors.fontBlack,
                    ),
                  ),
                )),
          ),
          Container(width: 1, height: 30, color: AppColors.grey300),
          SizedBox(width: 12.w),
          Expanded(
            child: TextFormField(
              controller: controller.phoneController,
              keyboardType: TextInputType.phone,
              validator: (v) => v == null || v.trim().isEmpty
                  ? tr(LanguageKeys.pleaseEnterPhoneNumber)
                  : null,
              decoration: InputDecoration(
                hintText: tr(LanguageKeys.enterNum),
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.symmetric(vertical: 16.h),
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

  Widget _countryPicker(List<Country> list, Rx<Country> selected) {
    return SafeArea(
      child: Container(
        height: Get.height * 0.7,
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            IconButton(
              onPressed: () => Get.back(),
              icon: Icon(Icons.close, color: AppColors.fontBlack),
            ),
            SizedBox(height: 8.h),
            Expanded(
              child: ListView.separated(
                itemCount: list.length,
                separatorBuilder: (_, __) => Divider(color: AppColors.grey200),
                itemBuilder: (context, index) {
                  final country = list[index];
                  return ListTile(
                    onTap: () {
                      selected.value = country;
                      Get.back();
                    },
                    leading: Text(country.emoji,
                        style: const TextStyle(fontSize: 20)),
                    title: Text(country.name),
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
