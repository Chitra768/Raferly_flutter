import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:referaly/controller/add_lead_source_controller.dart';
import 'package:referaly/languages/languagekeys.dart';
import 'package:referaly/models/model_network_response.dart';
import 'package:referaly/resources/app_assets.dart';
import 'package:referaly/resources/app_colors.dart';
import 'package:referaly/resources/text_style.dart';
import 'package:referaly/utils/translations.dart';

enum _ContactImportTarget { referrer, lead }

class AddLeadSourceScreen extends GetView<AddLeadSourceController> {
  static String pageId = "/addLeadSource";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: SafeArea(
        child: Column(
          children: [
            // Header with back button and title
            _buildHeader(),
            // Progress bar
            _buildProgressBar(),
            // Main content - conditionally show Step 1 or Step 2
            Expanded(
              child: Obx(() {
                if (controller.currentStep.value == 1) {
                  return _buildStep1();
                } else {
                  return _buildStep2();
                }
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStep1() {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          const SizedBox(height: 20),
          // Lead Source Title
          Text(
            tr(LanguageKeys.leadSource),
            style: stylePoppins(
              fontSize: 20.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.blackColor,
            ),
          ),
          const SizedBox(height: 8),
          // Subtitle
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              tr(LanguageKeys.whereDidThisLeadComeFrom),
              textAlign: TextAlign.center,
              style: stylePoppins(
                fontSize: 13.sp,
                fontWeight: FontWeight.w400,
                color: AppColors.grey600,
              ),
            ),
          ),
          const SizedBox(height: 30),
          // Radio button options
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  _buildSourceOption(
                    value: 'network',
                    title: tr(LanguageKeys.referrerInYourNetwork),
                    description: tr(LanguageKeys.referrerInNetworkDescription),
                  ),
                  const SizedBox(height: 16),
                  _buildSourceOption(
                    value: 'external',
                    title: tr(LanguageKeys.externalSource),
                    description: tr(LanguageKeys.externalSourceDescription),
                  ),
                ],
              ),
            ),
          ),
          // Continue button
          _buildContinueButton(),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget _buildStep2() {
    return SingleChildScrollView(
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              // Referrer Section
              Obx(
                () {
                  final source = controller.selectedLeadSource.value;
                  if (source == 'network') {
                    return _buildBusinessReferrerSection();
                  }
                  return _buildExternalReferrerSection();
                },
              ),
              const SizedBox(height: 24),
              // Lead Information Section
              _buildLeadInformationSection(),
              const SizedBox(height: 30),
              // Add Lead Button
              _buildAddLeadButton(),
              const SizedBox(height: 30),
            ],
          ),
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
          // Back button aligned to the left
          Align(
            alignment: Alignment.centerLeft,
            child: IconButton(
              icon: Icon(Icons.arrow_back, color: AppColors.blackColor),
              onPressed: () => controller.onBack(),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
          ),
          // Centered title
          Center(
            child: Text(
              tr(LanguageKeys.addLead),
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

  Widget _buildProgressBar() {
    return Obx(() {
      final progress = controller.currentStep.value == 1 ? 0.5 : 1.0;
      final stepText = controller.currentStep.value == 1
          ? tr(LanguageKeys.step1Of2)
          : tr(LanguageKeys.step2Of2);

      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            Expanded(
              child: Container(
                height: 4,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(2),
                  color: AppColors.grey300,
                ),
                child: FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor: progress,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(2),
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Text(
              stepText,
              style: stylePoppins(
                fontSize: 12.sp,
                fontWeight: FontWeight.w400,
                color: AppColors.grey600,
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildSourceOption({
    required String value,
    required String title,
    required String description,
  }) {
    return Obx(
      () {
        final isSelected = controller.selectedLeadSource.value == value;
        return GestureDetector(
          onTap: () => controller.selectLeadSource(value),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isSelected ? AppColors.primaryLightPink : Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected ? AppColors.primary : AppColors.grey300,
                width: 1.5,
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Radio button
                Container(
                  width: 18,
                  height: 18,
                  margin: const EdgeInsets.only(top: 14),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isSelected ? AppColors.primary : AppColors.grey300,
                      width: 2,
                    ),
                    color: Colors.white,
                  ),
                  child: isSelected
                      ? Center(
                          child: Container(
                            width: 10,
                            height: 10,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.primary,
                            ),
                          ),
                        )
                      : null,
                ),
                const SizedBox(width: 16),
                // Text content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: stylePoppins(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w500,
                          color: AppColors.blackColor,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        description,
                        style: stylePoppins(
                          fontSize: 11.sp,
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
      },
    );
  }

  Widget _buildContinueButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: SizedBox(
        width: double.infinity,
        height: 50,
        child: ElevatedButton(
          onPressed: () => controller.onContinue(),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 0,
          ),
          child: Text(
            tr(LanguageKeys.Continue),
            style: stylePoppins(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBusinessReferrerSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          tr(LanguageKeys.searchYourBusinessReferrer),
          style: stylePoppins(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.blackColor,
          ),
        ),
        const SizedBox(height: 12),
        // Search bar
        TextField(
          controller: controller.searchController,
          onChanged: (value) {
            // Trigger filtering immediately when text changes
            controller.filterReferrers();
          },
          decoration: InputDecoration(
            hintText: tr(LanguageKeys.searchYourNetwork),
            hintStyle: stylePoppins(
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
              color: AppColors.grey600,
            ),
            prefixIcon: Icon(Icons.search, color: AppColors.grey600),
            filled: true,
            fillColor: AppColors.grey100,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
          ),
        ),
        const SizedBox(height: 16),
        // Referrer list
        Obx(() {
          if (controller.isLoadingReferrers.value) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: CircularProgressIndicator(),
              ),
            );
          }

          // Use filteredReferrers which is reactive and automatically updates when search text changes
          final referrers = controller.filteredReferrers;

          if (referrers.isEmpty) {
            return Padding(
              padding: const EdgeInsets.all(20),
              child: Text(
                tr(LanguageKeys.noDataFound),
                style: stylePoppins(
                  fontSize: 14.sp,
                  color: AppColors.grey600,
                ),
              ),
            );
          }

          // Show only 3 referrers initially, or all if showAllReferrers is true
          final shouldShowAll = controller.showAllReferrers.value;
          final displayCount = shouldShowAll ? referrers.length : 3;
          final displayReferrers = referrers.take(displayCount).toList();
          final hasMore = referrers.length > 3;

          return Column(
            children: [
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: displayReferrers.length,
                itemBuilder: (context, index) {
                  final referrer = displayReferrers[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Obx(() {
                      final isSelected =
                          controller.selectedReferrerId.value == referrer.id;
                      return _buildReferrerCard(referrer, isSelected);
                    }),
                  );
                },
              ),
              // Show "View More" button if there are more than 3 referrers and not showing all
              if (hasMore && !shouldShowAll) ...[
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: TextButton(
                    onPressed: () => controller.toggleShowAllReferrers(),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(color: AppColors.primary, width: 1.5),
                      ),
                    ),
                    child: Text(
                      tr(LanguageKeys.seeMore),
                      style: stylePoppins(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ),
              ],
            ],
          );
        }),
      ],
    );
  }

  Widget _buildExternalDealDropdown() {
    return Obx(() {
      if (controller.isLoadingBusinessDeals.value) {
        return const Padding(
          padding: EdgeInsets.symmetric(vertical: 12),
          child: Center(child: CircularProgressIndicator()),
        );
      }
      if (controller.businessDealError.value.isNotEmpty) {
        return _buildDealStatusMessage(controller.businessDealError.value);
      }
      final deals =
          controller.businessDeals.where((deal) => deal.id != null).toList();
      if (deals.isEmpty) {
        return _buildDealStatusMessage(tr(LanguageKeys.noDataFound));
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInputLabel(tr(LanguageKeys.selectDeal), isRequired: true),
          const SizedBox(height: 6),
          DropdownButtonFormField<int>(
            value: controller.selectedBusinessDealId.value,
            isExpanded: true,
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
            onChanged: (value) =>
                controller.selectedBusinessDealId.value = value,
            validator: (value) {
              if (value == null) {
                return tr(LanguageKeys.selectDeal) + ' is required';
              }
              return null;
            },
            icon: Icon(
              Icons.keyboard_arrow_down_rounded,
              color: AppColors.grey700,
            ),
            decoration: InputDecoration(
              hintText: tr(LanguageKeys.selectDeal),
              hintStyle: stylePoppins(
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
                color: AppColors.grey600,
              ),
              filled: true,
              fillColor: AppColors.grey100,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ],
      );
    });
  }

  Widget _buildExternalReferrerSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFFF6EDFF), Color(0xFFFDF7FF)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFFE8D8FF)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.person,
                      color: Colors.white,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          tr(LanguageKeys.referrerInformation),
                          style: stylePoppins(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.blackColor,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          tr(LanguageKeys.inviteThemToReferaly),
                          style: stylePoppins(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w500,
                            color: AppColors.primary,
                          ).copyWith(decoration: TextDecoration.underline),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: () =>
                        _importFromContacts(_ContactImportTarget.referrer),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 10,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 0,
                      minimumSize: Size.zero,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SvgPicture.asset(
                          AppAssets.imgDownload,
                          width: 16,
                          height: 16,
                          color: Colors.white,
                        ),
                        const SizedBox(width: 18),
                        Text(
                          tr(LanguageKeys.import),
                          style: stylePoppins(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: _buildLabeledTextField(
                      label: tr(LanguageKeys.firstName),
                      controller: controller.referrerFirstNameController,
                      hint: tr(LanguageKeys.firstName),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: _buildLabeledTextField(
                      label: tr(LanguageKeys.lastName),
                      controller: controller.referrerLastNameController,
                      hint: tr(LanguageKeys.lastName),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _buildLabeledTextField(
                label: tr(LanguageKeys.email),
                controller: controller.referrerEmailController,
                hint: 'email@example.com',
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),
              _buildLabeledTextField(
                label: tr(LanguageKeys.phoneNumber),
                controller: controller.referrerPhoneController,
                hint: '+1 (555) 000-0000',
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 16),
              _buildExternalDealDropdown(),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _buildLabeledTextField(
                      label: tr(LanguageKeys.jobTitle),
                      controller: controller.referrerJobTitleController,
                      hint: tr(LanguageKeys.jobTitle),
                      isRequired: false,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: _buildLabeledTextField(
                      label: tr(LanguageKeys.city),
                      controller: controller.referrerCityController,
                      hint: tr(LanguageKeys.city),
                      isRequired: false,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFE3DAFF)),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 36,
                padding: const EdgeInsets.all(8),
                height: 36,
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: SvgPicture.asset(
                  AppAssets.imgInfoSvg,
                  width: 10,
                  height: 10,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      tr(LanguageKeys.automaticAdditionTitle),
                      style: stylePoppins(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.blackColor,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      tr(LanguageKeys.automaticAdditionDescription),
                      style: stylePoppins(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w400,
                        color: AppColors.grey700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDealStatusMessage(String message) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.grey100,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.grey200),
      ),
      child: Text(
        message,
        style: stylePoppins(
          fontSize: 13.sp,
          fontWeight: FontWeight.w500,
          color: AppColors.grey700,
        ),
      ),
    );
  }

  Widget _buildReferrerCard(BusinessReferrers referrer, bool isSelected) {
    final fullName =
        '${referrer.firstName ?? ''} ${referrer.lastName ?? ''}'.trim();
    final job = referrer.job ?? '';

    return GestureDetector(
      onTap: () => controller.selectReferrer(referrer.id),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFF5F1FF) : const Color(0xFFF7F7F8),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.grey200,
            width: 1.5,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.08),
                    blurRadius: 14,
                    offset: const Offset(0, 6),
                  ),
                ]
              : [],
        ),
        child: Row(
          children: [
            // Avatar
            ClipRRect(
              borderRadius: BorderRadius.circular(22),
              child: referrer.avatarUrl != null &&
                      referrer.avatarUrl!.isNotEmpty
                  ? Image.network(
                      referrer.avatarUrl!,
                      width: 44,
                      height: 44,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        width: 44,
                        height: 44,
                        color: AppColors.grey300,
                        child: Icon(Icons.person, color: AppColors.grey600),
                      ),
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Container(
                          width: 44,
                          height: 44,
                          color: AppColors.grey300,
                          child: const Center(
                            child: SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                          ),
                        );
                      },
                    )
                  : Container(
                      width: 44,
                      height: 44,
                      color: AppColors.grey300,
                      child: Icon(Icons.person, color: AppColors.grey600),
                    ),
            ),
            const SizedBox(width: 12),
            // Name and job
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    fullName,
                    style: stylePoppins(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.blackColor,
                    ),
                  ),
                  if (job.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      job,
                      style: stylePoppins(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w400,
                        color: AppColors.grey600,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            // Radio button
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 26,
              height: 26,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? AppColors.primary : AppColors.grey300,
                  width: 2.2,
                ),
                color: Colors.white,
              ),
              child: isSelected
                  ? Center(
                      child: Container(
                        width: 12,
                        height: 12,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.primary,
                        ),
                      ),
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLeadInformationSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFF9FBFF), Color(0xFFF2F6FF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE3ECFF)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 32,
                height: 42,
                decoration: BoxDecoration(
                  color: AppColors.blueColor2,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.person_add_alt_1,
                  color: AppColors.whiteColor,
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  tr(LanguageKeys.leadInformation),
                  style: stylePoppins(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.blackColor,
                  ).copyWith(height: 1.1),
                ),
              ),
              const SizedBox(width: 12),
              ElevatedButton(
                onPressed: () => _importFromContacts(_ContactImportTarget.lead),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 10,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                  minimumSize: Size.zero,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SvgPicture.asset(
                      AppAssets.imgDownload,
                      width: 16,
                      height: 16,
                      color: Colors.white,
                    ),
                    const SizedBox(width: 18),
                    Text(
                      tr(LanguageKeys.import),
                      style: stylePoppins(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _buildLabeledTextField(
                  label: tr(LanguageKeys.firstName),
                  controller: controller.firstNameController,
                  hint: tr(LanguageKeys.firstName),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: _buildLabeledTextField(
                  label: tr(LanguageKeys.lastName),
                  controller: controller.lastNameController,
                  hint: tr(LanguageKeys.lastName),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildLabeledTextField(
            label: tr(LanguageKeys.phoneNumber),
            controller: controller.phoneController,
            hint: '06 XX XX XX XX',
            keyboardType: TextInputType.phone,
          ),
          const SizedBox(height: 16),
          _buildLabeledTextField(
            label: tr(LanguageKeys.email),
            controller: controller.emailController,
            hint: 'email@example.com',
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 16),
          Obx(
            () => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildInputLabel(
                  '${tr(LanguageKeys.note)} (${controller.noteLength.value}/500)',
                ),
                const SizedBox(height: 6),
                TextField(
                  controller: controller.noteController,
                  maxLines: 4,
                  maxLength: 500,
                  buildCounter: (_,
                          {int? currentLength,
                          int? maxLength,
                          bool? isFocused}) =>
                      const SizedBox.shrink(),
                  decoration: _inputDecoration(
                    tr(LanguageKeys.detailsProspectNeedsContext),
                  ),
                  textInputAction: TextInputAction.newline,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddLeadButton() {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: () => controller.onAddLead(),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
        child: Text(
          tr(LanguageKeys.addLead),
          style: stylePoppins(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildLabeledTextField({
    required String label,
    required TextEditingController controller,
    required String hint,
    TextInputType keyboardType = TextInputType.text,
    TextInputAction textInputAction = TextInputAction.next,
    bool isRequired = true,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildInputLabel(label, isRequired: isRequired),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          decoration: _inputDecoration(hint),
        ),
      ],
    );
  }

  Widget _buildInputLabel(String text, {bool isRequired = true}) {
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

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: stylePoppins(
        fontSize: 14.sp,
        fontWeight: FontWeight.w400,
        color: AppColors.grey600,
      ),
      filled: true,
      fillColor: const Color(0xFFF8FBFF),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xFFD4E7FF)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xFF7C9DFF)),
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xFFD4E7FF)),
      ),
    );
  }

  Future<void> _importFromContacts(_ContactImportTarget target) async {
    try {
      final status = await FlutterContacts.requestPermission();
      if (!status) {
        Get.snackbar(
          tr(LanguageKeys.error),
          tr(LanguageKeys.contactPermissionDenied),
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }

      final contacts = await FlutterContacts.getContacts(
        withProperties: true,
        withPhoto: false,
      );

      if (contacts.isEmpty) {
        Get.snackbar(
          tr(LanguageKeys.error),
          tr(LanguageKeys.noDataFound),
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }

      final selected = await showDialog<Contact>(
        context: Get.context!,
        barrierColor: Colors.black.withOpacity(0.4),
        builder: (context) {
          final TextEditingController searchController =
              TextEditingController();
          List<Contact> filtered = List.of(contacts);

          return StatefulBuilder(
            builder: (context, setState) {
              return Dialog(
                insetPadding:
                    const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(28),
                ),
                child: Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5EDFF),
                    borderRadius: BorderRadius.circular(28),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        tr(LanguageKeys.selectContact),
                        style: stylePoppins(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.blackColor,
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextField(
                        controller: searchController,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(
                            Icons.search,
                            color: AppColors.primary,
                          ),
                          hintText: tr(LanguageKeys.searchPlaceholder),
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 14,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        onChanged: (value) {
                          setState(() {
                            if (value.isEmpty) {
                              filtered = List.of(contacts);
                            } else {
                              filtered = contacts.where((contact) {
                                final displayName =
                                    '${contact.name.first} ${contact.name.last}'
                                        .toLowerCase();
                                return displayName
                                    .contains(value.toLowerCase());
                              }).toList();
                            }
                          });
                        },
                      ),
                      const SizedBox(height: 16),
                      const Divider(color: Color(0xFFD8C7F9)),
                      const SizedBox(height: 12),
                      SizedBox(
                        height: 260,
                        child: filtered.isEmpty
                            ? Center(
                                child: Text(
                                  tr(LanguageKeys.noDataFound),
                                  style: stylePoppins(
                                    fontSize: 14.sp,
                                    color: AppColors.grey600,
                                  ),
                                ),
                              )
                            : ListView.separated(
                                itemCount: filtered.length,
                                separatorBuilder: (_, __) =>
                                    const SizedBox(height: 12),
                                itemBuilder: (context, index) {
                                  final contact = filtered[index];
                                  final name =
                                      '${contact.name.first} ${contact.name.last}'
                                          .trim();
                                  final phone = contact.phones.isNotEmpty
                                      ? contact.phones.first.number
                                      : '';
                                  final email = contact.emails.isNotEmpty
                                      ? contact.emails.first.address
                                      : '';

                                  return GestureDetector(
                                    onTap: () =>
                                        Navigator.of(context).pop(contact),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            name,
                                            style: stylePoppins(
                                              fontSize: 16.sp,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            phone.isNotEmpty ? phone : email,
                                            style: stylePoppins(
                                              fontSize: 14.sp,
                                              color: AppColors.grey600,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                      ),
                      const SizedBox(height: 12),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: Text(
                            tr(LanguageKeys.cancel),
                            style: stylePoppins(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      );

      if (selected != null) {
        final rawFirstName = selected.name.first.trim();
        final rawLastName = selected.name.last.trim();
        String detectedBusinessName = '';

        String _sanitizeName(String value) {
          if (value.isEmpty) return value;
          final regex = RegExp(r'\(([^)]+)\)');
          final match = regex.firstMatch(value);
          if (match != null) {
            final company = match.group(1)?.trim() ?? '';
            if (company.isNotEmpty && detectedBusinessName.isEmpty) {
              detectedBusinessName = company;
            }
            final cleaned =
                (value.substring(0, match.start) + value.substring(match.end))
                    .trim();
            return cleaned;
          }
          return value.trim();
        }

        String firstName = _sanitizeName(rawFirstName);
        String lastName = _sanitizeName(rawLastName);

        if (lastName.isEmpty && firstName.contains(' ')) {
          final parts = firstName
              .split(RegExp(r'\s+'))
              .where((p) => p.isNotEmpty)
              .toList();
          if (parts.length > 1) {
            lastName = parts.removeLast();
            firstName = parts.join(' ');
          }
        }
        final phone =
            selected.phones.isNotEmpty ? selected.phones.first.number : '';
        final email =
            selected.emails.isNotEmpty ? selected.emails.first.address : '';

        if (target == _ContactImportTarget.lead) {
          controller.firstNameController.text = firstName;
          controller.lastNameController.text = lastName;
          controller.phoneController.text = phone;
          controller.emailController.text = email;
        } else {
          controller.referrerFirstNameController.text = firstName;
          controller.referrerLastNameController.text = lastName;
          controller.referrerPhoneController.text = phone;
          controller.referrerEmailController.text = email;

          if (detectedBusinessName.isNotEmpty) {
            controller.referrerJobTitleController.text = detectedBusinessName;
          }
        }
      }
    } catch (e) {
      Get.snackbar(
        tr(LanguageKeys.error),
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}
