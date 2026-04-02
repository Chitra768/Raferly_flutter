import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:referaly/controller/business_referrer_contract_controller.dart'
    show BusinessReferrerContractController;
import 'package:referaly/languages/languagekeys.dart';
import 'package:referaly/resources/app_colors.dart';
import 'package:referaly/resources/app_helper.dart';
import 'package:referaly/resources/text_style.dart';
import 'package:referaly/utils/translations.dart';
import 'package:referaly/widgets/logo_loader.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../resources/app_preference.dart';
import '../../widgets/dialog/premium_upgrade_dialog.dart';
import '../dashboard/membership_screen.dart';

class BusinessReferrerContractScreen extends StatefulWidget {
  static String pageId = "/businessReferrerContract";

  const BusinessReferrerContractScreen({super.key});

  @override
  State<BusinessReferrerContractScreen> createState() =>
      _BusinessReferrerContractScreenState();
}

class _BusinessReferrerContractScreenState
    extends State<BusinessReferrerContractScreen> {
  late BusinessReferrerContractController controller =
      Get.put(BusinessReferrerContractController());
  final List<String> commissionOptions = [
    tr(LanguageKeys.no_commission),
    tr(LanguageKeys.fix_commission),
    tr(LanguageKeys.percentage_commission)
  ];

  // Add persistent controllers for different commission controller.cases
  List<TextEditingController> leadTypeControllers = [];
  List<TextEditingController> commissionValueControllers = [];

  bool _isEditingContractName = false;
  bool _multiLevelReferralEnabled = false;
  final TextEditingController _level2CommissionController =
      TextEditingController(text: '20');

  @override
  void initState() {
    super.initState();
    // Initialize controllers for the first case
    _initializeControllers();
  }

  void _initializeControllers() {
    // Clear existing controllers
    for (var controller in leadTypeControllers) {
      controller.dispose();
    }
    for (var controller in commissionValueControllers) {
      controller.dispose();
    }

    leadTypeControllers.clear();
    commissionValueControllers.clear();

    // Create controllers for each case
    for (int i = 0; i < controller.cases.length; i++) {
      final leadController =
          TextEditingController(text: controller.cases[i]["lead_type"]);
      final commissionController =
          TextEditingController(text: controller.cases[i]["commission_value"]);

      // Add listeners to keep controller.cases data in sync
      leadController.addListener(() {
        if (i < controller.cases.length) {
          controller.cases[i]["lead_type"] = leadController.text;
        }
      });

      commissionController.addListener(() {
        if (i < controller.cases.length) {
          controller.cases[i]["commission_value"] = commissionController.text;
        }
      });

      leadTypeControllers.add(leadController);
      commissionValueControllers.add(commissionController);
    }
  }

  @override
  void dispose() {
    _level2CommissionController.dispose();
    // Dispose controllers
    for (var controller in leadTypeControllers) {
      controller.dispose();
    }
    for (var controller in commissionValueControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        backgroundColor: AppColors.backgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: AppColors.fontBlack),
          onPressed: () => Get.back(),
        ),
        title: Text(
          tr(LanguageKeys.referralContract),
          style: stylePoppins(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppColors.fontBlack,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () async {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  backgroundColor: AppColors.whiteColor,
                  insetPadding: const EdgeInsets.symmetric(horizontal: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  contentPadding: const EdgeInsets.fromLTRB(40, 32, 40, 0),
                  content: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          tr(LanguageKeys.deleteCofirmation),
                          style: stylePoppins(
                              fontSize: 13, color: AppColors.fontBlack),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 24),
                        Row(
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.of(context).pop();
                                },
                                child: Container(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 14),
                                  decoration: BoxDecoration(
                                    color: AppColors.whiteColor,
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                        color: AppColors.primary, width: 1),
                                  ),
                                  child: Center(
                                    child: Text(tr(LanguageKeys.cancel),
                                        style: stylePoppins(
                                            color: AppColors.primary,
                                            fontWeight: FontWeight.w500)),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: GestureDetector(
                                onTap: () async {
                                  Navigator.of(context).pop();
                                  if (controller.dealId.value.isNotEmpty) {
                                    await controller.deleteContract(
                                        controller.dealId.value);
                                  }
                                },
                                child: Container(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 14),
                                  decoration: BoxDecoration(
                                    color: AppColors.primary,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Center(
                                    child: Text(tr(LanguageKeys.yes),
                                        style: stylePoppins(
                                            color: AppColors.whiteColor,
                                            fontWeight: FontWeight.w500)),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
              // TODO: Implement share functionality
              // Add your delete logic here
              // if (controller.dealId.value.isNotEmpty) {
              //   await controller.deleteContract(controller.dealId.value);
              // }
            },
            icon: Icon(
              Icons.delete_outline,
              color: AppColors.fontBlack,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildAcademyVideoCard(),
                const SizedBox(height: 20),
                buildContractNameSection(),
                const SizedBox(height: 20),
                buildSegmentControl(),
                const SizedBox(height: 8),
                buildCommissionInfo(),
                const SizedBox(height: 20),
                buildCommissionSharedDropdown(),
                const SizedBox(height: 20),
                _buildMultiLevelReferralCard(),
                const SizedBox(height: 20),
                buildContractSection(),
                const SizedBox(height: 20),
                buildTrackNameSection(),
                const SizedBox(height: 20),
                buildStageItems(),
                const SizedBox(height: 20),
                buildAddNewButton(),
                const SizedBox(height: 24),
                buildBottomActionButtons(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildBottomActionButtons() {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () => Get.back(),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                color: AppColors.whiteColor,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.primary),
              ),
              child: Center(
                child: Text(
                  tr(LanguageKeys.cancel),
                  style: stylePoppins(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: GestureDetector(
            onTap: () {
              if (AppPreference.readString(AppPreference.isPaid) == "0") {
                Get.dialog(PremiumUpgradeDialog(
                  onSeeOffers: () {
                    Get.back();
                    Get.toNamed(MembershipScreen.pageId)?.then((value) {
                      controller.mainController.getProfile();
                    });
                  },
                ));
              } else {
                if (!_validateCommissionSelection()) {
                  return;
                }
                AppHelper.showLog(
                    'controller.cases: ${controller.cases.toString()}');
                controller.submitDeal(
                  controller.cases,
                  multiLevelReferral: _multiLevelReferralEnabled ? 1 : 0,
                  level2CommissionPercentage: _multiLevelReferralEnabled &&
                          _level2CommissionController.text.trim().isEmpty
                      ? '0'
                      : _level2CommissionController.text.trim(),
                );
              }
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Obx(
                  () => controller.isLoading.value
                      ? SizedBox(
                          width: 24,
                          height: 24,
                          child: LogoLoader(color: AppColors.whiteColor),
                        )
                      : Text(
                          controller.dealId.value.isNotEmpty
                              ? tr(LanguageKeys.updateDeal)
                              : tr(LanguageKeys.saveContract),
                          style: stylePoppins(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppColors.whiteColor,
                          ),
                        ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  String get _displayContractName {
    if (controller.selectedProgramType == tr(LanguageKeys.writeACustomName)) {
      return controller.dealNameController.text.isEmpty
          ? tr(LanguageKeys.enterDealName)
          : controller.dealNameController.text;
    }
    return controller.selectedProgramType;
  }

  void _applyContractNameSelection() {
    setState(() {
      if (controller.selectedProgramType ==
              tr(LanguageKeys.businessReferralProgram) ||
          controller.selectedProgramType ==
              tr(LanguageKeys.ambassadorProgram)) {
        controller.dealNameController.text = controller.selectedProgramType;
      }
      _isEditingContractName = false;
    });
  }

  /// Academy video card - supports YouTube link (dummy link used for now).
  static const String _kAcademyVideoId = 'dQw4w9WgXcQ';

  Widget _buildAcademyVideoCard() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: AppColors.fontBlack.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.school_rounded,
                      size: 20,
                      color: AppColors.primary,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'ACADEMY',
                      style: stylePoppins(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
                Text(
                  '3 min',
                  style: stylePoppins(
                    fontSize: 12,
                    color: AppColors.grey600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              tr(LanguageKeys.buildAnEffectiveProgram),
              style: stylePoppins(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColors.fontBlack,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              tr(LanguageKeys.discoverBestPractices),
              style: stylePoppins(
                fontSize: 13,
                color: AppColors.grey600,
              ),
            ),
            const SizedBox(height: 14),
            GestureDetector(
              onTap: () {
                // TODO: Open YouTube link or in-app video player
                launchUrl(Uri.parse(
                    "https://www.youtube.com/watch?v=A3npLMbKRT4&feature=youtu.be"));
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Image.network(
                      'https://img.youtube.com/vi/A3npLMbKRT4/hqdefault.jpg',
                      width: double.infinity,
                      height: 180,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        width: double.infinity,
                        height: 180,
                        color: AppColors.grey200,
                        child: Icon(
                          Icons.video_library_outlined,
                          size: 48,
                          color: AppColors.grey500,
                        ),
                      ),
                    ),
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: AppColors.whiteColor,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.fontBlack.withOpacity(0.2),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.play_arrow_rounded,
                        size: 36,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildContractNameSection() {
    final bool canEdit = controller.isEditMode.value != true;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          tr(LanguageKeys.nameOfDeal),
          style: stylePoppins(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: AppColors.fontBlack,
          ),
        ),
        const SizedBox(height: 8),
        if (_isEditingContractName && canEdit) ...[
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.grey500.withOpacity(0.1),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        isExpanded: true,
                        value: controller.selectedProgramType !=
                                tr(LanguageKeys.selectAnOption)
                            ? controller.selectedProgramType
                            : null,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: AppColors.grey100,
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 10),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        dropdownColor: AppColors.whiteColor,
                        hint: Text(
                          tr(LanguageKeys.selectAnOption),
                          style: stylePoppins(
                              fontSize: 14, color: AppColors.grey600),
                        ),
                        style: stylePoppins(
                            fontSize: 14, color: AppColors.fontBlack),
                        onChanged: (value) {
                          if (value != null) {
                            setState(() {
                              controller.selectedProgramType = value;
                              if (value != tr(LanguageKeys.writeACustomName)) {
                                controller.dealNameController.clear();
                                if (value ==
                                        tr(LanguageKeys
                                            .businessReferralProgram) ||
                                    value ==
                                        tr(LanguageKeys.ambassadorProgram)) {
                                  controller.dealNameController.text = value;
                                }
                              }
                            });
                          }
                        },
                        items: [
                          DropdownMenuItem<String>(
                            value: tr(LanguageKeys.businessReferralProgram),
                            child:
                                Text(tr(LanguageKeys.businessReferralProgram)),
                          ),
                          DropdownMenuItem<String>(
                            value: tr(LanguageKeys.ambassadorProgram),
                            child: Text(tr(LanguageKeys.ambassadorProgram)),
                          ),
                          DropdownMenuItem<String>(
                            value: tr(LanguageKeys.writeACustomName),
                            child: Text(tr(LanguageKeys.writeACustomName)),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: () => _applyContractNameSelection(),
                      child: const Icon(
                        Icons.check_circle,
                        size: 28,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
                if (controller.selectedProgramType ==
                    tr(LanguageKeys.writeACustomName)) ...[
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: controller.dealNameController,
                    decoration: InputDecoration(
                      hintText: tr(LanguageKeys.enterDealName),
                      filled: true,
                      fillColor: AppColors.grey100,
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 10),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    style:
                        stylePoppins(fontSize: 14, color: AppColors.fontBlack),
                  ),
                ],
              ],
            ),
          ),
        ] else ...[
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: AppColors.grey500.withOpacity(0.1),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (canEdit)
                  GestureDetector(
                    onTap: () {
                      setState(() => _isEditingContractName = true);
                    },
                    child: const Icon(
                      Icons.edit_outlined,
                      size: 20,
                      color: AppColors.primary,
                    ),
                  ),
                if (canEdit) const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    _displayContractName,
                    style: stylePoppins(
                      fontSize: 14,
                      color: controller.dealNameController.text.isEmpty &&
                              controller.selectedProgramType !=
                                  tr(LanguageKeys.writeACustomName)
                          ? AppColors.grey600
                          : AppColors.fontBlack,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.only(left: 16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 18,
                height: 18,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.transparent,
                  border: Border.all(
                    color: AppColors.grey600,
                    width: 1,
                  ),
                ),
                child: Text(
                  '?',
                  style: stylePoppins(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: AppColors.grey600,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: RichText(
                  textAlign: TextAlign.start,
                  softWrap: true,
                  text: TextSpan(
                    style: stylePoppins(
                      fontSize: 12,
                      color: AppColors.grey600,
                      fontWeight: FontWeight.normal,
                    ),
                    children: [
                      TextSpan(text: tr(LanguageKeys.tapOn)),
                      const WidgetSpan(
                        alignment: PlaceholderAlignment.middle,
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 2),
                          child: Icon(
                            Icons.edit,
                            size: 15,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                      TextSpan(text: tr(LanguageKeys.toChangeProgramName)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Widget buildDealNameField() {
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       Text(
  //         tr(LanguageKeys.nameOfDeal),
  //         style: stylePoppins(
  //           fontSize: 16,
  //           fontWeight: FontWeight.w500,
  //         ),
  //       ),
  //       const SizedBox(height: 8),
  //       TextFormField(
  //         controller: controller.dealNameController,
  //         decoration: InputDecoration(
  //           hintText: tr(LanguageKeys.enterDealName),
  //           hintStyle: stylePoppins(color: Colors.grey, fontSize: 14),
  //           filled: true,
  //           fillColor: Colors.grey[200],
  //           border: OutlineInputBorder(
  //             borderRadius: BorderRadius.circular(8),
  //             borderSide: BorderSide.none,
  //           ),
  //           contentPadding:
  //               const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
  //         ),
  //       ),
  //     ],
  //   );
  // }

  Widget buildSegmentControl() {
    return Obx(() => Container(
          decoration: BoxDecoration(
            color: AppColors.grey100,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              segmentItem(
                  title: tr(LanguageKeys.uniqueCommision),
                  isSelected: controller.isUniqueCommission.value),
              segmentItem(
                  title: tr(LanguageKeys.differentCommision),
                  isSelected: !controller.isUniqueCommission.value,
                  isFirst: false),
            ],
          ),
        ));
  }

  Expanded segmentItem(
      {required String title, required bool isSelected, bool isFirst = true}) {
    return Expanded(
      child: GestureDetector(
        onTap: () => controller.toggleCommissionType(isFirst),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          margin: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary : AppColors.whiteColor,
            borderRadius: BorderRadius.circular(8),
          ),
          alignment: Alignment.center,
          child: Text(
            title,
            maxLines: 2,
            textAlign: TextAlign.center,
            softWrap: false,
            style: stylePoppins(
              fontSize: 13,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              color: isSelected ? AppColors.whiteColor : AppColors.fontBlack,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMultiLevelReferralCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColors.fontBlack.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.primaryLightPink,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.groups_rounded,
                  size: 22,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  tr(LanguageKeys.multiLevelReferral),
                  style: stylePoppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.fontBlack,
                  ),
                ),
              ),
              Switch(
                value: _multiLevelReferralEnabled,
                onChanged: (value) {
                  setState(() => _multiLevelReferralEnabled = value);
                },
                activeTrackColor: AppColors.primary,
                inactiveTrackColor: AppColors.grey200,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            tr(LanguageKeys
                .enableThisOptionToRewardYourBusinessReferrersWhenTheyRecruitOtherReferrersForYourBusiness),
            style: stylePoppins(
              fontSize: 13,
              color: AppColors.grey600,
            ),
          ),
          if (_multiLevelReferralEnabled) ...[
            const SizedBox(height: 20),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.subdirectory_arrow_right_rounded,
                  size: 20,
                  color: AppColors.grey600,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        tr(LanguageKeys.level2Commission),
                        style: stylePoppins(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: AppColors.fontBlack,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        tr(LanguageKeys.level2CommissionSubLabel),
                        style: stylePoppins(
                          fontSize: 12,
                          color: AppColors.grey600,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        decoration: BoxDecoration(
                          color: AppColors.grey100,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: AppColors.grey200,
                          ),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: _level2CommissionController,
                                keyboardType: TextInputType.number,
                                style: stylePoppins(
                                  fontSize: 14,
                                  color: AppColors.fontBlack,
                                ),
                                decoration: InputDecoration(
                                  isDense: true,
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 12,
                                  ),
                                  border: InputBorder.none,
                                  hintText: '10',
                                  hintStyle: stylePoppins(
                                    fontSize: 14,
                                    color: AppColors.textTitleHint,
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              width: 1,
                              height: 40,
                              color: AppColors.grey200,
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 12,
                              ),
                              child: Text(
                                '%',
                                style: stylePoppins(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.fontBlack,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.grey100,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.grey200),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.warning_amber_rounded,
                    size: 22,
                    color: AppColors.warning300,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: RichText(
                      text: TextSpan(
                        style: stylePoppins(
                          fontSize: 12,
                          color: AppColors.grey700,
                          fontWeight: FontWeight.normal,
                        ),
                        children: [
                          TextSpan(
                            text: tr(
                                LanguageKeys.level2CommissionImportantPrefix),
                          ),
                          TextSpan(
                            text: tr(LanguageKeys
                                .level2CommissionImportantUnderlined),
                            style: stylePoppins(
                              fontSize: 12,
                              color: AppColors.grey700,
                              fontWeight: FontWeight.w600,
                            ).copyWith(
                              decoration: TextDecoration.underline,
                            ),
                          ),
                          TextSpan(
                            text: tr(
                                LanguageKeys.level2CommissionImportantSuffix),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget buildCommissionInfo() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.primaryLightPink,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          const Icon(Icons.info_outline, size: 18, color: AppColors.primary),
          const SizedBox(width: 8),
          Expanded(
            child: Obx(
              () => Text(
                controller.isUniqueCommission.value
                    ? tr(LanguageKeys.itWillSpecified)
                    : tr(LanguageKeys.ifYouAreOffer),
                style: stylePoppins(
                  fontSize: 12,
                  color: AppColors.primary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildCommissionSharedDropdown() {
    return Obx(() {
      if (controller.isUniqueCommission.value) {
        // OLD UI for Unique Commission
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              tr(LanguageKeys.commissionShared),
              style: stylePoppins(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                color: AppColors.grey500.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: DropdownButtonFormField<String>(
                value: controller.selectedCommissionOption.value !=
                        tr(LanguageKeys.chooseOneoption)
                    ? controller.selectedCommissionOption.value
                    : null,
                icon: Icon(Icons.keyboard_arrow_down, color: AppColors.grey600),
                decoration: const InputDecoration(
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  border: InputBorder.none,
                ),
                dropdownColor: AppColors.whiteColor,
                hint: Text(tr(LanguageKeys.chooseOneoption),
                    style:
                        stylePoppins(fontSize: 14, color: AppColors.grey600)),
                style: stylePoppins(fontSize: 14, color: AppColors.fontBlack),
                onChanged: (value) {
                  if (value != null) {
                    controller.setCommissionOption(value);
                    if (value == tr(LanguageKeys.no_commission)) {
                      controller.commissionValueController.text = '';
                    }
                    controller.update();
                  }
                },
                items: [
                  DropdownMenuItem<String>(
                    value: tr(LanguageKeys.no_commission),
                    child: Text(tr(LanguageKeys.no_commission)),
                  ),
                  DropdownMenuItem<String>(
                    value: tr(LanguageKeys.fix_commission),
                    child: Text(tr(LanguageKeys.fix_commission)),
                  ),
                  DropdownMenuItem<String>(
                    value: tr(LanguageKeys.percentage_commission),
                    child: Text(tr(LanguageKeys.percentage_commission)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Obx(() {
              if (controller.selectedCommissionOption.value ==
                      tr(LanguageKeys.fix_commission) ||
                  controller.selectedCommissionOption.value ==
                      tr(LanguageKeys.percentage_commission)) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),
                    Text(
                      tr(LanguageKeys.commisionValue),
                      style: stylePoppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: controller.commissionValueController,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: AppColors.grey500.withOpacity(0.1),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        hintText: tr(LanguageKeys.enterCommission),
                        suffixIcon: controller.selectedCommissionOption.value ==
                                tr(LanguageKeys.fix_commission)
                            ? const Padding(
                                padding: EdgeInsets.all(12.0),
                                child:
                                    Text('€', style: TextStyle(fontSize: 18)),
                              )
                            : const Padding(
                                padding: EdgeInsets.all(12.0),
                                child:
                                    Text('%', style: TextStyle(fontSize: 18)),
                              ),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ],
                );
              }
              return const SizedBox.shrink();
            }),
          ],
        );
      } else {
        // NEW UI for Different Commissions
        return StatefulBuilder(
            builder: (context, setState) => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ...List.generate(controller.cases.length, (index) {
                      return Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.grey500.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Stack(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(tr(LanguageKeys.leadType),
                                    style: stylePoppins(
                                        fontWeight: FontWeight.w500)),
                                const SizedBox(height: 8),
                                TextField(
                                  controller: leadTypeControllers[index],
                                  style: stylePoppins(fontSize: 14),
                                  decoration: InputDecoration(
                                    hintText: tr(LanguageKeys.enterLeadType),
                                    filled: true,
                                    fillColor: Colors.white,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide.none,
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 12),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  tr(LanguageKeys.commissionShared),
                                  style: stylePoppins(
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.fontBlack,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Container(
                                  decoration: BoxDecoration(
                                    color: AppColors.whiteColor,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: DropdownButtonFormField<String>(
                                    value: controller.cases[index]
                                                ["commission_type"] !=
                                            tr(LanguageKeys.chooseOneoption)
                                        ? controller.cases[index]
                                            ["commission_type"]
                                        : null,
                                    icon: const Icon(Icons.keyboard_arrow_down),
                                    decoration: const InputDecoration(
                                      contentPadding: EdgeInsets.symmetric(
                                          horizontal: 16, vertical: 8),
                                      border: InputBorder.none,
                                    ),
                                    dropdownColor: AppColors.whiteColor,
                                    hint: Text(tr(LanguageKeys.chooseOneoption),
                                        style: stylePoppins(fontSize: 11)),
                                    style: stylePoppins(
                                        fontSize: 14,
                                        color: AppColors.fontBlack),
                                    onChanged: (value) {
                                      if (value != null) {
                                        setState(() {
                                          AppHelper.showLog(
                                              "DropdownValue: ${value}");
                                          controller.cases[index]
                                              ["commission_type"] = value;
                                          if (value ==
                                              tr(LanguageKeys.no_commission)) {
                                            controller.cases[index]
                                                ["commission_value"] = '';
                                          }
                                        });
                                      }
                                    },
                                    items: [
                                      DropdownMenuItem<String>(
                                        value: "no_commission",
                                        child: Text(
                                            tr(LanguageKeys.no_commission)),
                                      ),
                                      DropdownMenuItem<String>(
                                        value: "fix_commission",
                                        child: Text(
                                            tr(LanguageKeys.fix_commission)),
                                      ),
                                      DropdownMenuItem<String>(
                                        value: "percentage_commission",
                                        child: Text(tr(LanguageKeys
                                            .percentage_commission)),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 10),
                                if (controller.cases[index]
                                            ["commission_type"] ==
                                        "fix_commission" ||
                                    controller.cases[index]
                                            ["commission_type"] ==
                                        "percentage_commission")
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(height: 16),
                                      Text(
                                        tr(LanguageKeys.commisionValue),
                                        style: stylePoppins(
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      TextFormField(
                                        controller:
                                            commissionValueControllers[index],
                                        decoration: InputDecoration(
                                          filled: true,
                                          fillColor: AppColors.whiteColor,
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            borderSide: BorderSide.none,
                                          ),
                                          hintText:
                                              tr(LanguageKeys.enterCommission),
                                          suffixIcon: controller.cases[index]
                                                      ["commission_type"] ==
                                                  "fix_commission"
                                              ? const Padding(
                                                  padding: EdgeInsets.all(12.0),
                                                  child: Text('€',
                                                      style: TextStyle(
                                                          fontSize: 18)),
                                                )
                                              : const Padding(
                                                  padding: EdgeInsets.all(12.0),
                                                  child: Text('%',
                                                      style: TextStyle(
                                                          fontSize: 18)),
                                                ),
                                        ),
                                        keyboardType: TextInputType.number,
                                      ),
                                    ],
                                  ),
                              ],
                            ),
                            if (controller.cases.length > 1)
                              Positioned(
                                top: 0,
                                right: 0,
                                child: GestureDetector(
                                  onTap: () => removeCase(index),
                                  child: const Icon(
                                    Icons.delete_outline,
                                    color: AppColors.primary,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      );
                    }),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: addCase,
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: AppColors.primary),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                        ),
                        child: Text(
                          tr(LanguageKeys.addCase),
                          style: stylePoppins(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ],
                ));
      }
    });
  }

  Widget buildContractSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              tr(LanguageKeys.contract),
              style: stylePoppins(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: AppColors.fontBlack,
              ),
            ),
            const SizedBox(width: 4),
            Text(
              "*",
              style: stylePoppins(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: AppColors.redColor,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Obx(() => Column(
              children: [
                buildContractOption(
                  title: tr(LanguageKeys.generateContract),
                  isSelected: controller.isGenerateContract.value,
                  onTap: () => controller.toggleContractGeneration(true),
                ),
                const SizedBox(height: 8),
                buildContractOption(
                  title: tr(LanguageKeys.uploadYourOwn),
                  isSelected: !controller.isGenerateContract.value,
                  onTap: () => controller.toggleContractGeneration(false),
                  isUploadFile: true,
                ),
              ],
            )),
      ],
    );
  }

  Widget buildContractOption({
    required String title,
    required bool isSelected,
    required VoidCallback onTap,
    bool isUploadFile = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryLightPink : AppColors.whiteColor,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.grey300,
            width: 1,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Radio(
              value: true,
              groupValue: isSelected,
              onChanged: (_) => onTap(),
              activeColor: AppColors.primary,
            ),
            if (!isUploadFile)
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: stylePoppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: AppColors.fontBlack,
                      ),
                    ),
                    const SizedBox(height: 4),
                    GestureDetector(
                      onTap: () async {
                        final url = controller.mainController.dashboard.value
                                ?.data?.documentUrl ??
                            '';
                        AppHelper.showLog("url: $url");
                        controller.downloadAndOpenPdf(url);
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            tr(LanguageKeys.viewTemplate),
                            style: stylePoppins(
                              fontSize: 13,
                              color: AppColors.primary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(width: 4),
                          const Icon(
                            Icons.open_in_new,
                            size: 14,
                            color: AppColors.primary,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            if (isUploadFile)
              Expanded(
                child: GestureDetector(
                  onTap: () async {
                    try {
                      final ImagePicker picker = ImagePicker();
                      final XFile? file = await picker.pickMedia();
                      if (file != null) {
                        if (file.path.toLowerCase().endsWith('.pdf')) {
                          controller.contractFile = File(file.path);
                          AppHelper.showLog("file: ${controller.contractFile}");
                        } else {
                          Get.snackbar(
                            'Error',
                            'Please select a PDF file',
                            snackPosition: SnackPosition.BOTTOM,
                            backgroundColor: AppColors.redColor,
                            colorText: AppColors.whiteColor,
                          );
                        }
                      }
                    } catch (e) {
                      Get.snackbar(
                        'Error',
                        'Failed to select file',
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: AppColors.redColor,
                        colorText: AppColors.whiteColor,
                      );
                    }
                  },
                  child: DottedBorder(
                    color: AppColors.grey300,
                    strokeWidth: 1.5,
                    borderType: BorderType.RRect,
                    radius: const Radius.circular(8),
                    dashPattern: const [6, 4],
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 10),
                    child: Row(
                      children: [
                        Icon(Icons.upload_file,
                            size: 20, color: AppColors.grey600),
                        const SizedBox(width: 8),
                        Flexible(
                          child: Text(
                            title,
                            style: stylePoppins(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: AppColors.grey600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget buildTrackNameSection() {
    return Row(
      children: [
        Text(
          tr(LanguageKeys.followUpStepsForReferrers),
          style: stylePoppins(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: AppColors.fontBlack,
          ),
        ),
        const SizedBox(width: 6),
        PopupMenuButton(
          offset: const Offset(0, 40),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          color: AppColors.whiteColor,
          position: PopupMenuPosition.under,
          constraints: BoxConstraints(
            minWidth: MediaQuery.of(context).size.width - 32,
            maxWidth: MediaQuery.of(context).size.width - 32,
          ),
          itemBuilder: (context) => [
            PopupMenuItem(
              enabled: false,
              child: Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                decoration: BoxDecoration(
                  color: AppColors.whiteColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                alignment: Alignment.centerLeft,
                child: Obx(
                  () => Text(
                    tr(LanguageKeys.theTrackingStep),
                    style: stylePoppins(
                      fontSize: 12,
                      color: AppColors.grey700,
                    ),
                  ),
                ),
              ),
            ),
          ],
          child: Icon(
            Icons.help_outline,
            size: 20,
            color: AppColors.grey600,
          ),
        ),
      ],
    );
  }

  Widget buildStageItems() {
    return Obx(() => Column(
          children: [
            ReorderableListView.builder(
              key: const PageStorageKey('stage_items_list'),
              shrinkWrap: true,
              primary: false,
              physics: const NeverScrollableScrollPhysics(),
              padding: EdgeInsets.zero,
              buildDefaultDragHandles: false,
              itemCount: controller.dynamicFields.length,
              onReorder: (oldIndex, newIndex) {
                FocusScope.of(context).unfocus();
                controller.reorderDynamicFields(oldIndex, newIndex);
              },
              itemBuilder: (context, index) {
                final itemController = controller.dynamicFields[index];
                return Column(
                  key: ValueKey(itemController),
                  children: [
                    ReorderableDelayedDragStartListener(
                      index: index,
                      child: buildStageItem(
                        controller: itemController,
                        hintText: tr(LanguageKeys.enterTrackName),
                        showDelete: index != 0,
                        onTap: () => controller.removeDynamicField(index),
                      ),
                    ),
                    if (index != controller.dynamicFields.length - 1)
                      const SizedBox(height: 10),
                  ],
                );
              },
            ),
            if (controller.selectedCommissionOption.value !=
                    tr(LanguageKeys.no_commission) &&
                controller.selectedCommissionOption.value !=
                    tr(LanguageKeys.chooseOneoption))
              Container(
                margin: const EdgeInsets.only(bottom: 8, top: 10),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                decoration: BoxDecoration(
                  color: AppColors.grey100,
                  borderRadius: BorderRadius.circular(8),
                ),
                alignment: Alignment.centerLeft,
                child: Text(
                  tr(LanguageKeys.commisionPaid),
                  style: stylePoppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: AppColors.fontBlack),
                ),
              ),
          ],
        ));
  }

  Widget buildStageItem({
    required TextEditingController controller,
    required String hintText,
    required bool showDelete,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.grey500.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(
            Icons.drag_handle,
            size: 20,
            color: AppColors.grey600,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: TextFormField(
              controller: controller,
              style: stylePoppins(fontSize: 14, color: AppColors.fontBlack),
              decoration: InputDecoration(
                isDense: true,
                contentPadding: EdgeInsets.zero,
                hintText: hintText,
                hintStyle: stylePoppins(color: AppColors.grey600, fontSize: 14),
                border: InputBorder.none,
              ),
            ),
          ),
          if (showDelete)
            SizedBox(
              width: 32,
              child: GestureDetector(
                onTap: onTap,
                child: Icon(
                  Icons.delete_outline,
                  size: 20,
                  color: AppColors.grey600,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget buildAddNewButton() {
    return GestureDetector(
      onTap: () {
        controller.addDynamicField();
      },
      child: DottedBorder(
        color: AppColors.grey300,
        strokeWidth: 1.5,
        borderType: BorderType.RRect,
        radius: const Radius.circular(8),
        dashPattern: const [6, 4],
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: AppColors.grey100,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.add,
                size: 20,
                color: AppColors.grey700,
              ),
              const SizedBox(width: 8),
              Text(
                tr(LanguageKeys.addNewStep),
                style: stylePoppins(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: AppColors.grey700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool _validateCommissionSelection() {
    if (controller.isUniqueCommission.value) {
      if (controller.selectedCommissionOption.value ==
          tr(LanguageKeys.chooseOneoption)) {
        _showCommissionSelectionError();
        return false;
      }
    } else {
      final hasInvalidCase = controller.cases.any((caseItem) {
        final commissionType = caseItem["commission_type"] ?? '';
        return commissionType.isEmpty ||
            commissionType == tr(LanguageKeys.chooseOneoption);
      });
      if (hasInvalidCase) {
        _showCommissionSelectionError();
        return false;
      }
    }
    return true;
  }

  void _showCommissionSelectionError() {
    Get.snackbar(
      tr(LanguageKeys.error),
      tr(LanguageKeys.pleaseSelectCommType),
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: AppColors.redColor,
      colorText: AppColors.whiteColor,
    );
  }

  void addCase() {
    setState(() {
      final newIndex = controller.cases.length;
      controller.cases.add({
        "id": "0",
        "deal_id":
            controller.dealId.value.isNotEmpty ? controller.dealId.value : "0",
        "name": "",
        "created_at": "",
        "updated_at": "",
        "lead_type": "",
        "commission_type": tr(LanguageKeys.chooseOneoption),
        "commission_value": "0"
      });

      // Add controllers for the new case with listeners
      final leadController = TextEditingController();
      final commissionController = TextEditingController();

      // Add listeners to keep controller.cases data in sync
      leadController.addListener(() {
        if (newIndex < controller.cases.length) {
          controller.cases[newIndex]["lead_type"] = leadController.text;
        }
      });

      commissionController.addListener(() {
        if (newIndex < controller.cases.length) {
          controller.cases[newIndex]["commission_value"] =
              commissionController.text;
        }
      });

      leadTypeControllers.add(leadController);
      commissionValueControllers.add(commissionController);
    });
  }

  void removeCase(int index) {
    setState(() {
      // Dispose controllers before removing
      if (index < leadTypeControllers.length) {
        leadTypeControllers[index].dispose();
        leadTypeControllers.removeAt(index);
      }
      if (index < commissionValueControllers.length) {
        commissionValueControllers[index].dispose();
        commissionValueControllers.removeAt(index);
      }
      controller.cases.removeAt(index);
    });
  }
}
