import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:referaly/controller/add_business_referrer_controller.dart';
import 'package:referaly/languages/languagekeys.dart';
import 'package:referaly/models/model_network_response.dart';
import 'package:referaly/resources/app_assets.dart';
import 'package:referaly/resources/app_colors.dart';
import 'package:referaly/resources/text_style.dart';
import 'package:referaly/utils/translations.dart';
import 'package:referaly/widgets/job_selection_field.dart';
import 'package:referaly/widgets/role_type_card_selector.dart';

class AddBusinessReferrerScreen extends GetView<AddBusinessReferrerController> {
  static String pageId = "/addBusinessReferrer";

  const AddBusinessReferrerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),
                    _buildEmailNotificationBox(),
                    const SizedBox(height: 24),
                    _buildForm(),
                    const SizedBox(height: 24),
                    _buildReferralAgreementCheckbox(),
                    const SizedBox(height: 32),
                    _buildAddButton(),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: IconButton(
              icon: Icon(Icons.arrow_back, color: AppColors.blackColor),
              onPressed: controller.onBack,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
          ),
          Center(
            child: Text(
              tr(LanguageKeys.addBusinessReferrerTitle),
              style: stylePoppins(
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.blackColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmailNotificationBox() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.primary.withOpacity(0.4)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SvgPicture.asset(
            AppAssets.imgInfoSvg,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  tr(LanguageKeys.emailNotifications),
                  style: stylePoppins(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w400,
                    color: AppColors.primary,
                  ),
                ),
                Text(
                  tr(LanguageKeys.emailNotificationAddBusinessReferrer),
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
    );
  }

  Widget _buildForm() {
    final bool showManualBlocks = Get.arguments['created_by_parent'] == "false";
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (showManualBlocks) _buildLabel(tr(LanguageKeys.selectDeal), isRequired: true),
        if (showManualBlocks) const SizedBox(height: 6),
        if (showManualBlocks) _buildDealDropdown(),
        if (showManualBlocks) const SizedBox(height: 16),
        if (showManualBlocks) _buildSponsorSection(),
        const SizedBox(height: 16),
        _buildLabel(tr(LanguageKeys.firstName), isRequired: true),
        const SizedBox(height: 6),
        _buildTextField(
          controller: controller.firstNameController,
          hint: tr(LanguageKeys.enterFirstName),
        ),
        const SizedBox(height: 16),
        _buildLabel(tr(LanguageKeys.lastName), isRequired: true),
        const SizedBox(height: 6),
        _buildTextField(
          controller: controller.lastNameController,
          hint: tr(LanguageKeys.enterLastName),
        ),
        const SizedBox(height: 16),
        _buildLabel(tr(LanguageKeys.phoneNumber), isRequired: true),
        const SizedBox(height: 6),
        Row(
          children: [
            Container(
              width: 100,
              height: 50,
              child: _buildTextField(
                controller: controller.countryCodeController,
                hint: tr(LanguageKeys.countryCode),
                keyboardType: TextInputType.text,
                // prefixIcon: Icon(Icons.phone_outlined, size: 20, color: AppColors.grey600),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildTextField(
                controller: controller.phoneController,
                hint: tr(LanguageKeys.pleasePhoneNumber),
                keyboardType: TextInputType.phone,
                prefixIcon: Icon(Icons.phone_outlined, size: 20, color: AppColors.grey600),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        _buildLabel(tr(LanguageKeys.emailAddress), isRequired: true),
        const SizedBox(height: 6),
        _buildTextField(
          controller: controller.emailController,
          hint: tr(LanguageKeys.enterEmail),
          keyboardType: TextInputType.emailAddress,
          prefixIcon: Icon(Icons.email_outlined, size: 20, color: AppColors.grey600),
        ),
        const SizedBox(height: 16),
        _buildLabel(tr(LanguageKeys.userType), isRequired: true),
        const SizedBox(height: 10),
        Obx(() => RoleTypeCardSelector(
              selectedIsProfessional: controller.isProfessional,
              onSelectProfessional: controller.selectProfessional,
              onSelectIndividual: controller.selectIndividual,
              showError: controller.showUserTypeError.value,
              errorText: tr(LanguageKeys.pleaseSelectUserType),
            )),
        Obx(() {
          if (controller.isProfessional.value != true) {
            return const SizedBox.shrink();
          }
          return Column(
            children: [
              const SizedBox(height: 16),
              JobSelectionField(
                controller: controller.jobTitleController,
                hintText: tr(LanguageKeys.enterJobTitle),
                label: tr(LanguageKeys.jobTitle),
                isRequired: true,
                style: JobSelectionFieldStyle.dashboard,
                onJobSelected: controller.onJobSelected,
                validator: (value) => value == null || value.trim().isEmpty
                    ? tr(LanguageKeys.jobRequired)
                    : null,
              ),
            ],
          );
        }),
        const SizedBox(height: 16),
        _buildLabel(tr(LanguageKeys.preferredLanguage), isRequired: true),
        const SizedBox(height: 6),
        _buildLanguageDropdown(),
      ],
    );
  }

  Widget _buildDealDropdown() {
    return Obx(() {
      if (controller.isLoadingDeals.value) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          decoration: BoxDecoration(
            color: AppColors.grey100,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.grey300),
          ),
          child: const Center(
            child: SizedBox(
              width: 22,
              height: 22,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          ),
        );
      }
      final deals = controller.businessDeals.where((d) => d.id != null).toList();
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
        decoration: BoxDecoration(
          color: AppColors.whiteColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.grey300),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<int>(
            value: controller.selectedDealId.value,
            isExpanded: true,
            hint: Text(
              tr(LanguageKeys.selectDeal),
              style: stylePoppins(
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
                color: AppColors.grey600,
              ),
            ),
            icon: Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.grey700),
            items: deals
                .map(
                  (deal) => DropdownMenuItem<int>(
                    value: deal.id,
                    child: Text(
                      deal.dealName ?? '-',
                      style: stylePoppins(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                        color: AppColors.blackColor,
                      ),
                    ),
                  ),
                )
                .toList(),
            onChanged: (value) => controller.selectedDealId.value = value,
          ),
        ),
      );
    });
  }

  Widget _buildSponsorSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel(tr(LanguageKeys.sponsoredByQuestion), isRequired: false),
        const SizedBox(height: 10),
        Obx(() => _buildSponsoredSelector()),
        Obx(() {
          if (!controller.isSponsored.value) return const SizedBox.shrink();
          return Padding(
            padding: const EdgeInsets.only(top: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildLabel(tr(LanguageKeys.sponsoredBy), isRequired: true),
                const SizedBox(height: 6),
                _buildSponsorDropdown(),
              ],
            ),
          );
        }),
      ],
    );
  }

  Widget _buildSponsoredSelector() {
    return Row(
      children: [
        Expanded(
          child: _buildSponsoredChip(
            value: false,
            label: tr(LanguageKeys.no),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildSponsoredChip(
            value: true,
            label: tr(LanguageKeys.yes),
          ),
        ),
      ],
    );
  }

  Widget _buildSponsoredChip({required bool value, required String label}) {
    final bool isSelected = controller.isSponsored.value == value;
    return GestureDetector(
      onTap: () => controller.setIsSponsored(value),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.whiteColor,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.grey300,
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: stylePoppins(
              fontSize: 13.sp,
              fontWeight: FontWeight.w500,
              color: isSelected ? AppColors.primary : AppColors.grey700,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSponsorDropdown() {
    return Obx(() {
      if (controller.isLoadingSponsors.value) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          decoration: BoxDecoration(
            color: AppColors.grey100,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.grey300),
          ),
          child: const Center(
            child: SizedBox(
              width: 22,
              height: 22,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          ),
        );
      }
      final sponsors = controller.sponsors;
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
        decoration: BoxDecoration(
          color: AppColors.whiteColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.grey300),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<int>(
            value: controller.selectedSponsorId.value,
            isExpanded: true,
            hint: Text(
              tr(LanguageKeys.sponsoredBy),
              style: stylePoppins(
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
                color: AppColors.grey600,
              ),
            ),
            icon: Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.grey700),
            items: sponsors
                .map(
                  (sponsor) => DropdownMenuItem<int>(
                    value: sponsor.id,
                    child: Text(
                      _sponsorDisplayName(sponsor),
                      style: stylePoppins(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                        color: AppColors.blackColor,
                      ),
                    ),
                  ),
                )
                .toList(),
            onChanged: (value) => controller.selectedSponsorId.value = value,
          ),
        ),
      );
    });
  }

  String _sponsorDisplayName(BusinessReferrers sponsor) {
    final first = sponsor.firstName?.trim() ?? '';
    final last = sponsor.lastName?.trim() ?? '';
    final full = '$first $last'.trim();
    if (full.isNotEmpty) return full;
    final email = sponsor.email?.trim() ?? '';
    if (email.isNotEmpty) return email;
    return '-';
  }

  Widget _buildLabel(String text, {bool isRequired = true}) {
    return RichText(
      text: TextSpan(
        style: stylePoppins(
          fontSize: 14.sp,
          fontWeight: FontWeight.w600,
          color: AppColors.blackColor,
        ),
        children: [
          TextSpan(text: text),
          if (isRequired)
            TextSpan(
              text: ' *',
              style: stylePoppins(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.error300,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    TextInputType keyboardType = TextInputType.text,
    Widget? prefixIcon,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      style: stylePoppins(
        fontSize: 14.sp,
        fontWeight: FontWeight.w400,
        color: AppColors.blackColor,
      ),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: stylePoppins(
          fontSize: 14.sp,
          fontWeight: FontWeight.w400,
          color: AppColors.grey600,
        ),
        prefixIcon: prefixIcon,
        filled: true,
        fillColor: AppColors.whiteColor,
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.grey300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primary),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.grey300),
        ),
      ),
    );
  }

  Widget _buildLanguageDropdown() {
    return Obx(() {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
        decoration: BoxDecoration(
          color: AppColors.whiteColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.grey300),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: controller.selectedLanguage.value,
            isExpanded: true,
            hint: Text(
              tr(LanguageKeys.selectLanguage),
              style: stylePoppins(
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
                color: AppColors.grey600,
              ),
            ),
            icon: Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.grey700),
            items: controller.availableLanguages
                .map(
                  (lang) => DropdownMenuItem<String>(
                    value: lang['code'],
                    child: Text(
                      lang['name'] ?? '',
                      style: stylePoppins(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                        color: AppColors.blackColor,
                      ),
                    ),
                  ),
                )
                .toList(),
            onChanged: (value) => controller.selectedLanguage.value = value,
          ),
        ),
      );
    });
  }

  Widget _buildReferralAgreementCheckbox() {
    return Obx(() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildLabel(tr(LanguageKeys.referralAgreement), isRequired: true),
          const SizedBox(height: 10),
          GestureDetector(
            onTap: () {
              controller.referralAgreementChecked.value = !controller.referralAgreementChecked.value;
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
              decoration: BoxDecoration(
                color: AppColors.whiteColor,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.grey300),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 22,
                    height: 22,
                    child: Checkbox(
                      value: controller.referralAgreementChecked.value,
                      onChanged: (v) => controller.referralAgreementChecked.value = v ?? false,
                      activeColor: AppColors.primary,
                      side: BorderSide(color: AppColors.blackColor, width: 1.5),
                      fillColor: WidgetStateProperty.resolveWith((states) {
                        if (states.contains(WidgetState.selected)) {
                          return AppColors.primary;
                        }
                        return AppColors.whiteColor;
                      }),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: Text(
                        tr(LanguageKeys.referralAgreementConfirm),
                        style: stylePoppins(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w400,
                          color: AppColors.blackColor,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    });
  }

  Widget _buildAddButton() {
    return Obx(() {
      final isSubmitting = controller.isSubmitting.value;
      return SizedBox(
        width: double.infinity,
        height: 50,
        child: ElevatedButton(
          onPressed: isSubmitting ? null : controller.onSubmit,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            elevation: 0,
          ),
          child: isSubmitting
              ? SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: AppColors.whiteColor,
                  ),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add, size: 20, color: AppColors.whiteColor),
                    const SizedBox(width: 8),
                    Text(
                      tr(LanguageKeys.addBusinessReferrerTitle),
                      style: stylePoppins(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w500,
                        color: AppColors.whiteColor,
                      ),
                    ),
                  ],
                ),
        ),
      );
    });
  }
}
