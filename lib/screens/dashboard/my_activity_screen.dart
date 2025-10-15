// ignore_for_file: prefer_interpolation_to_compose_strings

import 'dart:io';
import 'dart:ui';

import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:referaly/controller/my_activity_controller.dart';
import 'package:referaly/languages/languagekeys.dart';
import 'package:referaly/models/model_contact_response.dart';
import 'package:referaly/models/model_network_response.dart';
import 'package:referaly/resources/app_assets.dart';
import 'package:referaly/resources/app_colors.dart';
import 'package:referaly/resources/app_helper.dart';
import 'package:referaly/resources/app_preference.dart';
import 'package:referaly/resources/text_style.dart';
import 'package:referaly/screens/busniess_referrers_list.dart';
import 'package:referaly/screens/dashboard/add_agency_coworker_dialog.dart';
import 'package:referaly/screens/dashboard/membership_screen.dart';
import 'package:referaly/screens/dashboard/track_leads_screen.dart';
import 'package:referaly/screens/deals/business_referrer_contract_screen.dart';
import 'package:referaly/screens/send_notification_screen.dart';
import 'package:referaly/utils/translations.dart';
import 'package:referaly/widgets/dialog/activity_info_dialog.dart';
import 'package:referaly/widgets/dialog/premium_upgrade_dialog.dart';
import 'package:referaly/widgets/dialog/share_form_bottom_sheet.dart';
import 'package:referaly/widgets/share_popup.dart';
import 'package:referaly/widgets/salesforce_partnership_card.dart';
import 'package:url_launcher/url_launcher.dart';

class MyActivityScreen extends StatefulWidget {
  static String pageId = "/myActivity";
  final int initialPage;

  const MyActivityScreen({super.key, this.initialPage = 0});

  @override
  State<MyActivityScreen> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyActivityScreen> {
  late MyActivityController controller;
  int? expandedIndex;
  int? expandedReferrerIndex;
  int? expandedDealCasesIndex;

  @override
  void initState() {
    super.initState();
    final args = Get.arguments as Map<String, dynamic>?;
    final initialPage = args?['initialPage'] ?? widget.initialPage;
    controller = Get.put(MyActivityController(initialPage: initialPage));
    // Set initial page
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.pageController.jumpToPage(initialPage);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        title: Text(
          tr(LanguageKeys.myDealinner),
          style: stylePoppins(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),
            buildSegmentControl(),
            const SizedBox(height: 20),
            Expanded(
              child: PageView(
                controller: controller.pageController,
                onPageChanged: (index) {
                  final isContracts = index == 0;
                  if (controller.isMyContractsSelected.value != isContracts) {
                    controller.toggleTabSelection(isContracts);
                  }
                },
                children: [
                  // Page 0 - My Deals (New Design)
                  buildNewDealsListView(),

                  // Page 1 - My Network
                  SingleChildScrollView(
                    child: Column(
                      children: [
                        buildPurpleCard(),
                        const SizedBox(height: 20),
                        buildActionButtonsRow(),
                        const SizedBox(height: 30),
                        buildBusinessReferrersSection(),
                        const SizedBox(height: 20),
                        buildVersionInfo(),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildSegmentControl() {
    return Obx(
      () {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: const Color(0xfff9fafb),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => controller.toggleTabSelection(true),
                  child: Container(
                    margin: const EdgeInsets.all(5),
                    height: 46,
                    decoration: BoxDecoration(
                      color: controller.isMyContractsSelected.value
                          ? AppColors.primary
                          : AppColors.transparent,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      tr(LanguageKeys.myPrograms),
                      style: stylePoppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: controller.isMyContractsSelected.value
                            ? Colors.white
                            : Colors.grey,
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () => controller.toggleTabSelection(false),
                  child: Stack(
                    children: [
                      Container(
                        margin: const EdgeInsets.all(5),
                        height: 46,
                        decoration: BoxDecoration(
                          color: !controller.isMyContractsSelected.value
                              ? AppColors.primary
                              : AppColors.transparent,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          tr(LanguageKeys.myNetwork),
                          style: stylePoppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: controller.isMyContractsSelected.value
                                ? Colors.grey
                                : Colors.white,
                          ),
                        ),
                      ),
                      (controller.networkList.value?.data?.notificationCount ??
                                  0) >
                              0
                          ? Positioned(
                              right: 0,
                              bottom: 0,
                              child: ClipPath(
                                clipper: HalfCircleClipper(),
                                child: Container(
                                  constraints: const BoxConstraints(
                                    minWidth: 20,
                                    minHeight: 20,
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: Colors.red,
                                    shape: BoxShape.circle,
                                    border:
                                        Border.all(color: Colors.red, width: 1),
                                  ),
                                  child: Center(
                                    child: Text(
                                      '${controller.networkList.value?.data?.notificationCount}',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            )
                          : const SizedBox(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // New Deals List View using SalesforcePartnershipCard
  Widget buildNewDealsListView() {
    return Obx(() {
      final hasData = controller.contactList.value?.data?.isNotEmpty ?? false;
      return Column(
        children: [
          Expanded(
            child: hasData
                ? RefreshIndicator(
                    onRefresh: () async {
                      await controller.updateInit();
                    },
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount:
                          controller.contactList.value?.data?.length ?? 0,
                      itemBuilder: (context, index) {
                        final contract =
                            controller.contactList.value?.data?[index];

                        return SalesforcePartnershipCard(
                          companyName:
                              contract?.companyName ?? "Unknown Company",
                          dealType: contract?.dealName ?? "Partnership Deal",
                          leadsReceived: "${contract?.leadCount ?? "0"} " + tr(LanguageKeys.leadsReceived),
                          commissionRate: contract?.dealCommissionType == 1
                              ? contract?.commissionValue ?? "0"
                              : "${contract?.dealCases?.first?.commissionValue ?? "0"}",
                          commissionType: contract?.dealCommissionType == 1
                              ? contract?.commissionType ?? "no_commission"
                              : contract?.dealCases?.first?.commissionType ??
                                  "no_commission",
                          isRecurring: (contract?.dealCommissionType == 1
                                  ? contract?.commissionType
                                  : contract
                                      ?.dealCases?.first?.commissionType) ==
                              "percentage_commission",
                          companyLogoUrl:
                              contract?.createdDetail?.companyLogoUrl,
                          onViewContract: () {
                            controller.openPdfBottomSheet(
                              context,
                              contract?.documentUrl ?? '',
                            );
                          },
                          onEdit: () {
                            Get.toNamed(BusinessReferrerContractScreen.pageId,
                                arguments: {
                                  'is_edit': true,
                                  'deal_id': contract?.id.toString() ?? '',
                                  'deal_name': contract?.dealName ?? '',
                                  'commission_type':
                                      contract?.commissionType ?? '',
                                  'track_names': contract?.dealSteps ?? [],
                                  'commission_value':
                                      contract?.commissionValue ?? '',
                                  'deal_commission_type':
                                      contract?.dealCommissionType ?? '',
                                  'deal_cases': contract?.dealCases ?? [],
                                })?.then((value) {
                              if (value == true) {
                                controller.getContactList();
                              }
                            });
                          },
                          onAttachFiles: () {
                            // Implement file attachment functionality
                            AppHelper.showLog(
                                "Attach files for ${contract?.dealName}");
                            showDialog(
                              context: context,
                              builder: (context) => UploadFilePopup(
                                id: contract?.id.toString() ?? '',
                              ),
                            );
                          },
                          onInvitePartner: () {
                            // Implement partner invitation functionality
                            Get.dialog(
                              SharePopup(
                                title: contract?.dealName ?? '',
                                link: contract?.deepLink ?? '',
                              ),
                            );
                          },
                          onShareForm: () {
                            _showShareFormBottomSheet(
                                context, contract?.referalFormUrl ?? '');
                          },
                          onHowItWorks: () {
                            // Show how it works dialog
                            _showHowItWorksDialog(context);
                          },
                          onMoreOptions: () {
                            // Show more options menu
                            _showMoreOptionsDialog(
                                context, contract?.id.toString() ?? '');
                          },
                        );
                      },
                    ),
                  )
                : Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        textAlign: TextAlign.center,
                        tr(LanguageKeys.createYourFirst),
                        style: stylePoppins(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: SizedBox(
              width: Get.width - 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  Get.toNamed(
                    BusinessReferrerContractScreen.pageId,
                    
                  )?.then((value) {
                    AppHelper.showLog("value: $value");
                    controller.getContactList();
                  });
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.add,
                      color: Colors.white,
                      size: 30,
                    ),
                    const SizedBox(width: 10),
                    Text(tr(LanguageKeys.createDeal),
                        style: TextStyle(fontSize: 14.sp, color: Colors.white)),
                  ],
                ),
              ),
            ),
          ),
        ],
      );
    });
  }

  void _showMoreOptionsDialog(BuildContext context, String contractId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
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
                style: stylePoppins(fontSize: 13),
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
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(color: Colors.black, width: 1),
                        ),
                        child: Center(
                          child: Text(
                            tr(LanguageKeys.cancel),
                              style: stylePoppins(color: Colors.black)
                              ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                        controller
                            .deleteContract(contractId)
                            .then((value) => controller.getContactList());
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Center(
                          child: Text(tr(LanguageKeys.yes),
                              style: stylePoppins(color: Colors.white)),
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
  }

  void _showHowItWorksDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 20),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Container(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            tr(LanguageKeys.howitworktitle),
                            style: stylePoppins(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          Text(
                            tr(LanguageKeys.howitworkdescription),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: stylePoppins(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          shape: BoxShape.circle,
                        ),
                        child: SvgPicture.asset(
                          AppAssets.imgCloseBtn,
                          width: 20,
                          height: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Content
              Flexible(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                  child: Column(
                    children: [
                      // More Options Section
                      _buildHowItWorksSection(
                        icon: Container(
                          width: 48,
                          height: 48,
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFEDD5), // Light red/pink
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: SvgPicture.asset(
                            AppAssets.imgInvitePartner,
                            width: 8,
                          ),
                        ),
                        title: tr(LanguageKeys.invitePartnerTitle),
                        description: tr(LanguageKeys.invitePartnerDescription),
                      ),
                      const SizedBox(height: 24),

                      // More Options Section
                      _buildHowItWorksSection(
                        icon: Container(
                          width: 48,
                          height: 48,
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFECACA), // Light red/pink
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(Icons.share,
                              color: Color(0xFFDC2626), size: 24),
                        ),
                        title: tr(LanguageKeys.shareTitle),
                        description: tr(LanguageKeys.shareDescription),
                      ),

                      const SizedBox(height: 24),
                      // Contract & Documents Section
                      _buildHowItWorksSection(
                        icon: Container(
                          width: 48,
                          height: 48,
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: const Color(0xFFDCFCE7), // Light blue
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: SvgPicture.asset(
                            AppAssets.imgAttachFiles,
                            width: 8,
                          ),
                        ),
                        title: tr(LanguageKeys.attchfiles),
                        description: tr(LanguageKeys.attachFilesDescription),
                      ),

                      const SizedBox(height: 24),

                      // Send a Lead Section
                      _buildHowItWorksSection(
                        icon: Container(
                          width: 48,
                          height: 48,
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: const Color(0xFEEBE5FF), // Purple
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: SvgPicture.asset(
                            AppAssets.imgDocumentContract,
                            width: 8,
                          ),
                        ),
                        title: tr(LanguageKeys.viewContractTitle),
                        description: tr(LanguageKeys.viewContractDescription),
                      ),

                      const SizedBox(height: 24),

                      _buildHowItWorksSection(
                        icon: Container(
                          width: 48,
                          height: 48,
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: const Color(0xFEDBEAFE), // Purple
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: SvgPicture.asset(
                            AppAssets.imgEditProgram,
                            width: 8,
                          ),
                        ),
                        title: tr(LanguageKeys.editProgram),
                        description: tr(LanguageKeys.editProgramDescription),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHowItWorksSection({
    required Widget icon,
    required String title,
    required String description,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        icon,
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title.replaceAll("\n", " "),
                style: stylePoppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                description,
                style: stylePoppins(
                  fontSize: 12,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Original Deals List View (My Contracts tab)
  Widget buildDealsListView() {
    return Obx(() {
      final hasData = controller.contactList.value?.data?.isNotEmpty ?? false;
      return Column(
        children: [
          Expanded(
            child: hasData
                ? Obx(() {
                    return RefreshIndicator(
                      onRefresh: () async {
                        await controller.updateInit();
                      },
                      child: ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount:
                            controller.contactList.value?.data?.length ?? 0,
                        itemBuilder: (context, index) {
                          final contract =
                              controller.contactList.value?.data?[index];
                          final isExpanded = expandedIndex == index;

                          return Container(
                            margin: const EdgeInsets.only(bottom: 10),
                            decoration: BoxDecoration(
                              color: const Color(0xfff9fafb),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.grey[200]!),
                            ),
                            child: Column(
                              children: [
                                buildDealHeader(
                                  title: contract?.companyName ?? "",
                                  referrer: contract?.dealName ?? "",
                                  id: contract?.id.toString() ?? "",
                                  index: index,
                                ),
                                const Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 16),
                                  child: Divider(height: 1),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      if (expandedIndex == index) {
                                        expandedIndex = null;
                                      } else {
                                        expandedIndex = index;
                                      }
                                    });
                                  },
                                  child: Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 12, horizontal: 16),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          tr(LanguageKeys.companyDetailsMydeal),
                                          style: const TextStyle(
                                              fontWeight: FontWeight.w500),
                                        ),
                                        Icon(
                                          expandedIndex == index
                                              ? Icons.remove
                                              : Icons.add,
                                          size: 20,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                if (expandedIndex == index)
                                  Container(
                                    width: double.infinity,
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 8),
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.05),
                                          blurRadius: 4,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text(tr(LanguageKeys.commision),
                                            style: const TextStyle(
                                                fontWeight: FontWeight.w500)),
                                        if (contract?.dealCommissionType == 1)
                                          Text(
                                            contract?.commissionType ==
                                                    "no_commission"
                                                ? tr(LanguageKeys.no_commission)
                                                : contract?.commissionType ==
                                                        "fix_commission"
                                                    ? ("${tr(LanguageKeys.fix_commission)} : ${contract?.commissionValue ?? ""} €")
                                                    : ("${tr(LanguageKeys.percentage_commission)}  : ${contract?.commissionValue ?? ""} % HT du montant facturé"),
                                          ),
                                        if (contract?.dealCommissionType == 2)
                                          if (contract?.dealCases != null &&
                                              contract!
                                                  .dealCases!.isNotEmpty) ...[
                                            const SizedBox(height: 8),
                                            // Show first deal case
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  bottom: 8),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    contract.dealCases![0]
                                                                .commissionType ==
                                                            "no_commission"
                                                        ? tr(LanguageKeys
                                                            .no_commission)
                                                        : contract.dealCases![0]
                                                                    .commissionType ==
                                                                "fix_commission"
                                                            ? ("${tr(LanguageKeys.fix_commission)} : ${contract.dealCases![0].commissionValue ?? ""} €")
                                                            : ("${tr(LanguageKeys.percentage_commission)}  : ${contract.dealCases![0].commissionValue ?? ""} % HT du montant facturé"),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            // Show remaining deal cases if expanded
                                            if (expandedDealCasesIndex ==
                                                index) ...[
                                              ...contract.dealCases!
                                                  .skip(1)
                                                  .map(
                                                    (dealCase) => Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              bottom: 8),
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            dealCase.commissionType ==
                                                                    "no_commission"
                                                                ? tr(LanguageKeys
                                                                    .no_commission)
                                                                : dealCase.commissionType ==
                                                                        "fix_commission"
                                                                    ? ("${tr(LanguageKeys.fix_commission)} : ${dealCase.commissionValue ?? ""} €")
                                                                    : ("${tr(LanguageKeys.percentage_commission)}  : ${dealCase.commissionValue ?? ""} % HT du montant facturé"),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  )
                                                  .toList(),
                                            ],
                                            // Show See more/See less button
                                            if (contract.dealCases!.length >
                                                1) ...[
                                              const SizedBox(height: 8),
                                              GestureDetector(
                                                onTap: () {
                                                  setState(() {
                                                    if (expandedDealCasesIndex ==
                                                        index) {
                                                      expandedDealCasesIndex =
                                                          null;
                                                    } else {
                                                      expandedDealCasesIndex =
                                                          index;
                                                    }
                                                  });
                                                },
                                                child: Text(
                                                  expandedDealCasesIndex ==
                                                          index
                                                      ? tr(LanguageKeys.seeLess)
                                                      : tr(
                                                          LanguageKeys.seeMore),
                                                  style: const TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w500,
                                                    color: AppColors.primary,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ],
                                      ],
                                    ),
                                  ),
                                buildDealActionButtons(contract),
                              ],
                            ),
                          );
                        },
                      ),
                    );
                  })
                : Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        textAlign: TextAlign.center,
                        tr(LanguageKeys.createYourFirst),
                        style: stylePoppins(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: SizedBox(
              width: Get.width - 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  Get.toNamed(
                    BusinessReferrerContractScreen.pageId,
                  )?.then((value) {
                    AppHelper.showLog("value: $value");
                    controller.getContactList();
                  });
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.add,
                      color: Colors.white,
                      size: 30,
                    ),
                    const SizedBox(width: 10),
                    Text(tr(LanguageKeys.createDeal),
                        style: TextStyle(fontSize: 14.sp, color: Colors.white)),
                  ],
                ),
              ),
            ),
          ),
        ],
      );
    });
  }

  Widget buildDealHeader(
      {required String title,
      required String referrer,
      required String id,
      required int index}) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: controller.contactList.value?.data?[index].createdDetail
                        ?.companyLogoUrl?.isNotEmpty ==
                    true
                ? Image.network(
                    controller.contactList.value?.data?[index].createdDetail!
                            .companyLogoUrl ??
                        '',
                    width: 48,
                    height: 48,
                    fit: BoxFit.cover,
                  )
                : Container(
                    width: 48,
                    height: 48,
                    child: Image.asset(
                      AppAssets.imgDefaultPerson,
                      width: 48,
                      height: 48,
                      fit: BoxFit.cover,
                    ),
                  ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                title != ""
                    ? Text(
                        title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: stylePoppins(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      )
                    : const SizedBox(),
                title != "" ? const SizedBox(height: 4) : const SizedBox(),
                Text(
                  referrer,
                  style: stylePoppins(
                    fontSize: 12.sp,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: [
              GestureDetector(
                onTap: () => {
                  // Get.toNamed(DocumentScreen.pageId, arguments: {
                  //   'id': id,
                  // })
                  AppHelper.showLog(
                      controller.contactList.value?.data?[index].documentUrl ??
                          ''),
                  controller.openPdfBottomSheet(
                      context,
                      controller.contactList.value?.data?[index].documentUrl ??
                          '')
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SvgPicture.asset(
                    AppAssets.imgDocIcon,
                    color: AppColors.primary,
                    height: 20,
                    width: 20,
                  ),
                ),
              ),
              PopupMenuButton<String>(
                color: Colors.white,
                icon: const Icon(Icons.more_vert, color: AppColors.primary),
                onSelected: (value) {
                  if (value == 'delete') {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        backgroundColor: Colors.white,
                        insetPadding:
                            const EdgeInsets.symmetric(horizontal: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        contentPadding:
                            const EdgeInsets.fromLTRB(40, 32, 40, 0),
                        content: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                tr(LanguageKeys.deleteCofirmation),
                                style: stylePoppins(fontSize: 13),
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
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 14),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          border: Border.all(
                                              color: Colors.black, width: 1),
                                        ),
                                        child: Center(
                                          child: Text(tr(LanguageKeys.cancel),
                                              style: stylePoppins(
                                                  color: Colors.black)),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () {
                                        // Close the dialog first
                                        Navigator.of(context).pop();
                                        // Add your delete logic here
                                        controller.deleteContract(id).then(
                                            (value) =>
                                                controller.getContactList());
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 14),
                                        decoration: BoxDecoration(
                                          color: AppColors.primary,
                                          borderRadius:
                                              BorderRadius.circular(5),
                                        ),
                                        child: Center(
                                          child: Text(tr(LanguageKeys.yes),
                                              style: stylePoppins(
                                                  color: Colors.white)),
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
                  }
                },
                itemBuilder: (context) => [
                  PopupMenuItem(
                    padding: const EdgeInsets.all(0),
                    height: 20,
                    value: 'delete',
                    child: Center(
                      child: Text(tr(LanguageKeys.delete)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildDealActionButtons(ContractData? contract) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () {
                Get.toNamed(BusinessReferrerContractScreen.pageId, arguments: {
                  'is_edit': true,
                  'deal_id': contract?.id.toString() ?? '',
                  'deal_name': contract?.dealName ?? '',
                  'commission_type': contract?.commissionType ?? '',
                  'track_names': contract?.dealSteps ?? [],
                  'commission_value': contract?.commissionValue ?? '',
                  'deal_commission_type': contract?.dealCommissionType ?? '',
                  'deal_cases': contract?.dealCases ?? [],
                })?.then((value) {
                  if (value == true) {
                    controller.getContactList();
                  }
                });
              },
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.primary,
                side: const BorderSide(color: AppColors.primary),
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                tr(LanguageKeys.editDeal),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: stylePoppins(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                Get.dialog(
                  SharePopup(
                    title: contract?.dealName ?? '',
                    link: contract?.deepLink ?? '',
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                tr(LanguageKeys.shareDeal),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: stylePoppins(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Network tab content
  Widget buildPurpleCard() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Stack(
        children: [
          // Corner images
          Positioned(
            top: 0,
            right: 0,
            child: SvgPicture.asset(
              AppAssets.imgHalfCircleRightTop,
              width: 40,
              height: 40,
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            child: SvgPicture.asset(
              AppAssets.imgHalfCircleLeftDown,
              width: 40,
              height: 40,
            ),
          ),
          // Main content
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SvgPicture.asset(AppAssets.imgReferrelsPeopleSvg, height: 60),
                const SizedBox(height: 5),
                Obx(
                  () => Text(
                    controller.networkList.value?.data?.totalBusinessReferrers
                            .toString() ??
                        "0",
                    style: stylePoppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 5),
                // Text(
                //   tr(LanguageKeys.activeReferrals),
                //   style: stylePoppins(
                //     fontSize: 20.sp,
                //     fontWeight: FontWeight.w500,
                //     color: Colors.white,
                //   ),
                // ),
                // const SizedBox(height: 5),
                Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.1),
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    tr(LanguageKeys.activeReferrals),
                    style: stylePoppins(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 5),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildActionButtonsRow() {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: AppColors.whiteColor,
          boxShadow: [
            BoxShadow(
              color: AppColors.grey600.withOpacity(0.2),
              blurRadius: 1,
              offset: const Offset(0, 1),
            ),
          ],
          border:
              Border.all(color: AppColors.grey600.withOpacity(0.2), width: 1)),
      padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
      child: SizedBox(
        width: Get.width - 35,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            GestureDetector(
                onTap: () => Get.dialog(const ActivityInfoDialog()),
                child: Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: SvgPicture.asset(
                    AppAssets.imgActivityInfoSvg,
                    height: 20,
                    width: 20,
                  ),
                )),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                singlePrItem(
                    image: AppAssets.imgRefrealSvg,
                    text: tr(LanguageKeys.collaborators),
                    isBlue: true,
                    onTap: () {
                      // Get.dialog(AddAgencyCoworkerDialog(

                      // ));
                      if ((AppPreference.readString(AppPreference.isPaid) !=
                              "3") &&
                          AppPreference.readString(AppPreference.isPaid) !=
                              "1") {
                        Get.dialog(PremiumUpgradeDialog(
                          onSeeOffers: () {
                            Get.back();
                            Get.toNamed(MembershipScreen.pageId)?.then((value) {
                              controller.mainController.getProfile();
                            });
                          },
                        ));
                      } else {
                        Get.dialog(AddAgencyCoworkerDialog());
                      }
                    },
                    scale: 30.sp,
                    request: controller.referrers.length,
                    type: "referal"),
                // singlePrItem(
                //     image: AppAssets.imgAddDoc,
                //     isBlue: false,
                //     onTap: () {
                //       if (AppPreference.readString(AppPreference.isPaid) ==
                //           "0") {
                //         Get.dialog(PremiumUpgradeDialog(
                //           onSeeOffers: () {
                //             Get.back();
                //             Get.toNamed(MembershipScreen.pageId)?.then((value) {
                //               controller.mainController.getProfile();
                //             });
                //           },
                //         ));
                //       } else {
                //         Get.toNamed(ActiveGoalScreen.pageId);
                //       }
                //     },
                //     scale: 4.1,
                //     type: ""),
                // singlePrItem(
                //     image: AppAssets.imgShare,
                //     isBlue: false,
                //     onTap: () {
                //       if (controller.userDealList.value?.data?.length == 0) {
                //         return;
                //       }
                //       if (controller.userDealList.value?.data?.length == 1) {
                //         Get.dialog(
                //           SharePopup(
                //             title: controller
                //                     .userDealList.value?.data?[0].dealName ??
                //                 '',
                //             link: controller
                //                     .userDealList.value?.data?[0].inviteLink ??
                //                 '',
                //           ),
                //         );
                //       } else {
                //         Get.dialog(LikeAddCoworkerDialog(
                //           coworkers: controller.userDealList.value?.data ?? [],
                //           onQrTap: (index) {
                //             Get.back();
                //             Get.dialog(
                //               SharePopup(
                //                 title: controller.userDealList.value
                //                         ?.data?[index].dealName ??
                //                     '',
                //                 link: controller.userDealList.value
                //                         ?.data?[index].inviteLink ??
                //                     '',
                //               ),
                //             );
                //           },
                //         ));
                //       }
                //     },
                //     scale: 4.1,
                //     type: ""),
                singlePrItem(
                    image: AppAssets.imgAddNotificationSvg,
                    isBlue: false,
                    text: tr(LanguageKeys.enveyers),
                    onTap: () {
                      if (AppPreference.readString(AppPreference.isPaid) ==
                          "0") {
                        Get.dialog(PremiumUpgradeDialog(
                          onSeeOffers: () {
                            Get.back();
                            Get.toNamed(MembershipScreen.pageId)?.then((value) {
                              controller.mainController.getProfile();
                            });
                            ;
                          },
                        ));
                      } else {
                        Get.toNamed(SendNotificationScreen.pageId);
                      }
                    },
                    scale: 60.sp,
                    type: ""),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget singlePrItem(
      {required String image,
      String? text,
      required VoidCallback onTap,
      int request = 0,
      required bool isBlue,
      required double scale,
      String? type}) {
    final width = ((Get.width - 52) / 2);
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: width,
        height: 120.h,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
              left: 10,
              top: 10,
              child: Container(
                width: width - 10,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      image,
                      height: 70.h,
                      // height: scale,
                      // color: AppColors.primary.withOpacity(0.9)
                    ),
                    Text(
                      text ?? text.toString(),
                      style: stylePoppins(
                        fontSize: 12,
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (type == "referal" &&
                AppPreference.readString(AppPreference.isPaid) != "3" &&
                AppPreference.readString(AppPreference.isPaid) != "1")
              Positioned(
                top: 0,
                left: MediaQuery.of(context).size.width * 0.15,
                child: SvgPicture.asset(AppAssets.imgHDashboardCrown,
                    height: 18, color: AppColors.blueColor),
              ),
            if (AppPreference.readString(AppPreference.isPaid) == "0")
              Positioned(
                top: 0,
                left: MediaQuery.of(context).size.width * 0.15,
                child: SvgPicture.asset(
                    isBlue
                        ? AppAssets.imgpointBlue
                        : AppAssets.imgHDashboardCrown,
                    height: 18),
              ),
            Obx(
              () => controller.referrers.length != 0 && request != 0
                  ? Positioned(
                      right: 15,
                      bottom: 5,
                      child: Container(
                        decoration: BoxDecoration(
                            shape: BoxShape.circle, color: AppColors.pdfBg),
                        padding: const EdgeInsets.all(6),
                        child: Text(
                          request.toString(),
                          style: stylePoppins(
                            fontSize: 12,
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    )
                  : const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildBusinessReferrersSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Obx(
        () => controller.networkList.value?.data?.businessReferrers!.length != 0
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    tr(LanguageKeys.bussinessreferrence),
                    style: stylePoppins(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Obx(
                    () => ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: (controller.networkList.value?.data
                                      ?.businessReferrers!.length ??
                                  0) >
                              6
                          ? 6
                          : controller.networkList.value?.data
                                  ?.businessReferrers!.length ??
                              0,
                      itemBuilder: (context, index) {
                        return ReferrerListItem(
                          data1Referrer: controller.networkList.value?.data
                              ?.businessReferrers![index],
                          name:
                              "${controller.networkList.value?.data?.businessReferrers![index].firstName} ${controller.networkList.value?.data?.businessReferrers![index].lastName}",
                          isExpanded: expandedReferrerIndex == index,
                          onHeaderTap: () {
                            setState(() {
                              if (expandedReferrerIndex == index) {
                                expandedReferrerIndex = null;
                              } else {
                                expandedReferrerIndex = index;
                              }
                            });
                          },
                        );
                      },
                    ),
                  )
                ],
              )
            : Center(
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    textAlign: TextAlign.center,
                    tr(LanguageKeys.addBusinessReferrence),
                    style: stylePoppins(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
      ),
    );
  }

  void _showAllDealCases(BuildContext context, List<DealCases> dealCases) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        insetPadding: const EdgeInsets.symmetric(horizontal: 20),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Text(
          "All Deal Cases",
          style: stylePoppins(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ...dealCases
                  .map((dealCase) => Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF9FAFB),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey[200]!),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                dealCase.leadType ?? "",
                                style: stylePoppins(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            Text(
                              "${dealCase.commissionValue ?? ""} ${dealCase.commissionType == "percentage_commission" ? "%" : "€"}",
                              style: stylePoppins(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: AppColors.primary,
                              ),
                            ),
                          ],
                        ),
                      ))
                  .toList(),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              "Close",
              style: stylePoppins(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: AppColors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildVersionInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppPreference.readString(AppPreference.isPaid) == "0"
            ? Center(
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    textAlign: TextAlign.center,
                    tr(LanguageKeys.premiumInformativeText),
                    style: stylePoppins(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              )
            : const SizedBox.shrink(),
        Obx(
          () => (controller
                          .networkList.value?.data?.businessReferrers?.length ??
                      0) >
                  3
              ? Column(
                  children: [
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: SizedBox(
                        width: double.infinity,
                        child: GestureDetector(
                          onTap: () {
                            if (AppPreference.readString(
                                    AppPreference.isPaid) !=
                                "0") {
                              Get.toNamed(BusinessReferrersListScreen.pageId,
                                  arguments: {
                                    "coworkers": controller.networkList.value
                                        ?.data?.businessReferrers,
                                  });
                            } else {
                              Get.dialog(PremiumUpgradeDialog(
                                onSeeOffers: () {
                                  Get.back();
                                  Get.toNamed(MembershipScreen.pageId)
                                      ?.then((value) {
                                    controller.mainController.getProfile();
                                  });
                                },
                              ));
                            }
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                  color: AppColors.primary, width: 1),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            child: Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SvgPicture.asset(AppAssets.imgActivityPerson,
                                      height: 16, color: AppColors.whiteColor),
                                  const SizedBox(width: 8),
                                  Text(
                                    tr(LanguageKeys.seeAll),
                                    style: stylePoppins(
                                      fontSize: 13.sp,
                                      fontWeight: FontWeight.w500,
                                      color: AppColors.whiteColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: SizedBox(
                        width: double.infinity,
                        child: GestureDetector(
                          onTap: () {
                            if (AppPreference.readString(
                                    AppPreference.isPaid) !=
                                "0") {
                              Get.toNamed(BusinessReferrersListScreen.pageId,
                                  arguments: {
                                    "coworkers": controller.networkList.value
                                        ?.data?.businessReferrers,
                                  });
                            } else {
                              Get.dialog(PremiumUpgradeDialog(
                                onSeeOffers: () {
                                  Get.back();
                                  Get.toNamed(MembershipScreen.pageId)
                                      ?.then((value) {
                                    controller.mainController.getProfile();
                                  });
                                },
                              ));
                            }
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: AppColors.whiteColor,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                  color: AppColors.primary, width: 1),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            child: Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SvgPicture.asset(AppAssets.imgActivityStatics,
                                      height: 16, color: AppColors.primary),
                                  const SizedBox(width: 8),
                                  Text(
                                    tr(LanguageKeys.seeStatistics),
                                    style: stylePoppins(
                                      fontSize: 13.sp,
                                      fontWeight: FontWeight.w500,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              : const SizedBox.shrink(),
        ),
      ],
    );
  }

  void _showShareFormBottomSheet(BuildContext context, String formUrl) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ShareFormBottomSheet(
        formUrl: formUrl,
        onPreviewForm: () {
          // Close the bottom sheet first
          Navigator.pop(context);
        },
      ),
    );
  }
}

class ReferrerListItem extends StatelessWidget {
  final String name;
  final bool showPrimium;
  final BusinessReferrers? data1Referrer;
  final bool isExpanded;
  final VoidCallback? onHeaderTap;
  const ReferrerListItem({
    super.key,
    required this.name,
    this.showPrimium = false,
    this.data1Referrer,
    this.isExpanded = false,
    this.onHeaderTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onHeaderTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: AppColors.whiteColor,
          // color: const Color(0xFFF3E9FB), // Light purple
          borderRadius: BorderRadius.circular(16),
          border:
              Border.all(color: AppColors.primary.withOpacity(0.2), width: 1),
        ),
        child: Stack(
          children: [
            data(context),
            if (showPrimium)
              Positioned.fill(
                  child: ClipRect(
                      child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: const SizedBox(),
              )))
          ],
        ),
      ),
    );
  }

  Widget data(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header section
          GestureDetector(
            onTap: onHeaderTap,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  // Avatar with letter
                  Container(
                    width: 45,
                    height: 45,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey[200]!),
                      color: Colors.white,
                    ),
                    child: data1Referrer?.avatarUrl != null
                        ? Image.network(
                            data1Referrer?.avatarUrl ?? "",
                            fit: BoxFit.cover,
                          )
                        : Container(
                            width: 45,
                            height: 45,
                            decoration: BoxDecoration(
                              color: Colors.grey[400],
                              shape: BoxShape.circle,
                            ),
                            child: Image.asset(AppAssets.imgDefaultPerson),
                          ),
                  ),
                  const SizedBox(width: 16),
                  // Name and leads count
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          style: stylePoppins(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            Container(
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(
                                color: AppColors.primary,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              "${data1Referrer?.leadCount ?? "0"} leads envoyés",
                              style: stylePoppins(
                                fontSize: 11.sp,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // Expand/collapse arrow
                  Icon(
                    isExpanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: AppColors.grey600,
                    size: 32,
                  ),
                ],
              ),
            ),
          ),

          // Expanded content
          if (isExpanded) ...[
            // Source section
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFF5F3FF),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        width: 25,
                        height: 25,
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: const Icon(
                          Icons.link,
                          color: Colors.white,
                          size: 15,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Source du contact",
                            style: stylePoppins(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          tr(LanguageKeys.viaReferaly),
                          style: stylePoppins(
                            fontSize: 8.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Ce contact a été ajouté via la plateforme Referaly et bénéficie de toutes les fonctionnalités de suivi automatisé.",
                    style: stylePoppins(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w400,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Contact details
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  _buildDetailRow(
                    icon: AppAssets.imgPhoneActivity,
                    iconColor: AppColors.primary,
                    label: tr(LanguageKeys.phoneNumberNetwork),
                    value: data1Referrer?.phoneNumber ??
                        tr(LanguageKeys.notAvialble),
                  ),
                  const SizedBox(height: 20),
                  _buildDetailRow(
                    icon: AppAssets.imgEmailactivity,
                    iconColor: AppColors.primary,
                    label: tr(LanguageKeys.email),
                    value: data1Referrer?.email ?? tr(LanguageKeys.notAvialble),
                  ),
                  const SizedBox(height: 20),
                  _buildDetailRow(
                    icon: AppAssets.imgPersonactivity,
                    iconColor: AppColors.primary,
                    label: tr(LanguageKeys.companyType),
                    value: data1Referrer?.companyName ??
                        tr(LanguageKeys.notAvialble),
                  ),
                  const SizedBox(height: 20),
                  _buildDetailRow(
                    icon: AppAssets.imgJobActivity,
                    iconColor: AppColors.primary,
                    label: tr(LanguageKeys.job),
                    value: data1Referrer?.job ?? tr(LanguageKeys.notAvialble),
                  ),
                  const SizedBox(height: 20),
                  _buildDetailRow(
                    icon: AppAssets.imgBusniesActivity,
                    iconColor: AppColors.primary,
                    label: tr(LanguageKeys.contract),
                    value: data1Referrer?.lastAcceptedDealName ??
                        tr(LanguageKeys.notAvialble),
                  ),
                  const SizedBox(height: 20),
                  _buildDetailRow(
                    icon: AppAssets.imgCalanderActivity,
                    iconColor: AppColors.primary,
                    label: tr(LanguageKeys.acceptedDate),
                    value: _formatCreatedAt(data1Referrer?.createdAt),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Action buttons
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        _showSaveContactDialog(context);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColors.primary),
                          borderRadius: BorderRadius.circular(12),
                          color: AppColors.primary.withOpacity(0.1),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset(AppAssets.imgSaveActivity,
                                height: 15, color: AppColors.primary),
                            const SizedBox(width: 8),
                            Text(
                              "Sauvegarder",
                              style: stylePoppins(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w600,
                                color: AppColors.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.bar_chart,
                            color: Colors.grey,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            "Statistiques",
                            style: stylePoppins(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),
          ],
        ],
      ),
    );
  }

  Widget _buildDetailRow({
    required String icon,
    required Color iconColor,
    required String label,
    required String value,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 32,
          height: 32,
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: iconColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: SvgPicture.asset(
            icon,
            color: iconColor,
            width: 4,
            height: 4,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: stylePoppins(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: stylePoppins(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget dataOld(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: onHeaderTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 45,
                  height: 45,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey[200]!),
                    color: Colors.white,
                  ),
                  child: data1Referrer?.avatarUrl != null
                      ? Image.network(
                          data1Referrer?.avatarUrl ?? "",
                          fit: BoxFit.cover,
                        )
                      : Container(
                          width: 45,
                          height: 45,
                          decoration: BoxDecoration(
                            color: Colors.grey[400],
                            shape: BoxShape.circle,
                          ),
                          child: Image.asset(AppAssets.imgDefaultPerson),
                        ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: stylePoppins(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Container(
                            width: 10,
                            height: 10,
                            decoration: const BoxDecoration(
                              color: AppColors.primary,
                              shape: BoxShape.circle,
                            ),
                          ),

                          // SvgPicture.asset(
                          //   AppAssets.imgHomeSent,
                          //   height: 16,
                          // ),
                          const SizedBox(width: 8),
                          Text(
                            data1Referrer?.leadCount ?? "",
                            style: stylePoppins(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Icon(
                  isExpanded
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                  color: AppColors.grey600,
                  size: 28,
                ),
              ],
            ),
          ),
        ),
        if (isExpanded)
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[200]!),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _infoRow(
                  icon: AppAssets.imgPhone,
                  label: tr(LanguageKeys.phoneNumber),
                  value: data1Referrer?.phoneNumber ?? "",
                  context: context,
                  isLink: true,
                ),
                const Divider(height: 24),
                _infoRow(
                  icon: AppAssets.imgEmailIcon,
                  label: tr(LanguageKeys.email),
                  value: data1Referrer?.email ?? "",
                  context: context,
                  isLink: true,
                ),
                const Divider(height: 24),
                _infoRow(
                  icon: AppAssets.imgCalendar,
                  label: tr(LanguageKeys.lastContractAccepted),
                  value: data1Referrer?.lastAcceptedDealName ?? "",
                  context: context,
                ),
                const Divider(height: 24),
                _infoRow(
                  icon: AppAssets.imgContract,
                  label: tr(LanguageKeys.acceptedDate),
                  value: data1Referrer?.createdAt ?? "",
                  context: context,
                  isDate: true,
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
      ],
    );
  }

  String _formatCreatedAt(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return '';
    try {
      final date = DateTime.parse(dateStr);
      return DateFormat('dd/MM/yyyy').format(date);
    } catch (e) {
      return dateStr;
    }
  }

  Widget _infoRow({
    required String icon,
    required String label,
    required String value,
    required BuildContext context,
    bool isLink = false,
    bool isDate = false,
  }) {
    final displayValue = isDate ? _formatCreatedAt(value) : value;
    final isClickable = isLink && value.isNotEmpty && value != "Not Provided";
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            width: 22,
            height: 22,
            child: SvgPicture.asset(
              icon,
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: stylePoppins(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textTitleHint,
                  ),
                ),
                const SizedBox(height: 2),
                isClickable
                    ? GestureDetector(
                        onTap: () async {
                          if (label.toLowerCase() ==
                              tr(LanguageKeys.email).toLowerCase()) {
                            final Uri emailUri =
                                Uri(scheme: 'mailto', path: value);
                            if (await canLaunchUrl(emailUri)) {
                              await launchUrl(emailUri);
                            }
                          } else if (label.toLowerCase() ==
                              tr(LanguageKeys.phoneNumber).toLowerCase()) {
                            final Uri phoneUri =
                                Uri(scheme: 'tel', path: value);
                            if (await canLaunchUrl(phoneUri)) {
                              await launchUrl(phoneUri);
                            }
                          }
                        },
                        child: Text(
                          displayValue != "Not Provided"
                              ? displayValue
                              : tr(LanguageKeys.nullDataText),
                          style: stylePoppins(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w500,
                            color: AppColors.primary,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          textAlign: TextAlign.left,
                        ),
                      )
                    : Text(
                        displayValue != "Not Provided"
                            ? displayValue
                            : tr(LanguageKeys.nullDataText),
                        maxLines: 2,
                        style: stylePoppins(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w500,
                        ),
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.left,
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showSaveContactDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 20),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header with close button
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.close,
                          color: Colors.black,
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Profile Picture Section
              Center(
                child: Stack(
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.grey[200]!, width: 2),
                      ),
                      child: data1Referrer?.avatarUrl != null
                          ? ClipOval(
                              child: Image.network(
                                data1Referrer!.avatarUrl!,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    decoration: BoxDecoration(
                                      color: Colors.grey[400],
                                      shape: BoxShape.circle,
                                    ),
                                    child:
                                        Image.asset(AppAssets.imgDefaultPerson),
                                  );
                                },
                              ),
                            )
                          : Container(
                              decoration: BoxDecoration(
                                color: Colors.grey[400],
                                shape: BoxShape.circle,
                              ),
                              child: Image.asset(AppAssets.imgDefaultPerson),
                            ),
                    ),
                    // Online indicator
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          color: Colors.green,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Name
              Text(
                name,
                style: stylePoppins(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 24),

              // Contact Information Fields
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  children: [
                    // Phone Field
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey[200]!),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 30,
                            height: 30,
                            decoration: BoxDecoration(
                              color: AppColors.primary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              Icons.phone,
                              color: AppColors.primary,
                              size: 15,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  tr(LanguageKeys.phoneNumber),
                                  style: stylePoppins(
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.grey[600],
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  data1Referrer?.phoneNumber ??
                                      tr(LanguageKeys.notAvialble),
                                  style: stylePoppins(
                                    fontSize: 13.sp,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          GestureDetector(
                            onTap: () async {
                              final Uri phoneUri = Uri(
                                  scheme: 'tel',
                                  path: data1Referrer?.phoneNumber);
                              if (await canLaunchUrl(phoneUri)) {
                                await launchUrl(phoneUri);
                              }
                            },
                            child: Container(
                              width: 30,
                              height: 30,
                              decoration: BoxDecoration(
                                color: AppColors.primary,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(
                                Icons.phone,
                                color: Colors.white,
                                size: 15,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Email Field
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey[200]!),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 30,
                            height: 30,
                            decoration: BoxDecoration(
                              color: AppColors.primary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              Icons.email,
                              color: AppColors.primary,
                              size: 15,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  tr(LanguageKeys.email),
                                  style: stylePoppins(
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.grey[600],
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  data1Referrer?.email ??
                                      tr(LanguageKeys.notAvialble),
                                  style: stylePoppins(
                                    fontSize: 13.sp,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          GestureDetector(
                            onTap: () async {
                              final Uri emailUri = Uri(
                                  scheme: 'mailto', path: data1Referrer?.email);
                              if (await canLaunchUrl(emailUri)) {
                                await launchUrl(emailUri);
                              }
                            },
                            child: Container(
                              width: 30,
                              height: 30,
                              decoration: BoxDecoration(
                                color: AppColors.primary,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(
                                Icons.email,
                                color: Colors.white,
                                size: 15,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Add Contact Button
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                child: Center(
                  child: GestureDetector(
                    onTap: () {
                      // TODO: Implement add contact functionality
                      Navigator.of(context).pop();
                      // Show success message
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            "Contact ajouté avec succès",
                            style: stylePoppins(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                          ),
                          backgroundColor: AppColors.primary,
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 12),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.person_add_alt_1,
                            color: Colors.white,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            "Ajouter le contact",
                            style: stylePoppins(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
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
}

// =============================================================================
// UPLOAD FILE POPUP
// =============================================================================

class UploadFilePopup extends StatefulWidget {
  final String id;

  const UploadFilePopup({Key? key, required this.id}) : super(key: key);

  @override
  State<UploadFilePopup> createState() => _UploadFilePopupState();
}

class _UploadFilePopupState extends State<UploadFilePopup> {
  // ---------------------------------------------------------------------------
  // STATE VARIABLES
  // ---------------------------------------------------------------------------

  List<PlatformFile> selectedFiles = [];
  Map<String, TextEditingController> fileNameControllers = {};
  Set<String> editingFiles = {};
  bool notifyNetwork = true;
  final MyActivityController controller = Get.find();

  // ---------------------------------------------------------------------------
  // LIFECYCLE METHODS
  // ---------------------------------------------------------------------------

  @override
  void dispose() {
    for (var controller in fileNameControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  // ---------------------------------------------------------------------------
  // FILE PICKER METHOD
  // ---------------------------------------------------------------------------

  Future<void> pickPdfFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
      allowMultiple: true,
    );

    if (result != null && result.files.isNotEmpty) {
      setState(() {
        for (var file in result.files) {
          if (!selectedFiles.any((f) => f.path == file.path)) {
            selectedFiles.add(file);

            // Remove .pdf extension for editing
            final baseName = file.name.endsWith('.pdf')
                ? file.name.substring(0, file.name.length - 4)
                : file.name;

            fileNameControllers[file.identifier ?? file.path ?? file.name] =
                TextEditingController(text: baseName);
          }
        }
      });
    } else {
      print('File picking cancelled.');
    }
  }

  // ---------------------------------------------------------------------------
  // BUILD METHOD
  // ---------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: Colors.white,
      insetPadding: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.8,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildDialogHeader(),
                const SizedBox(height: 24),
                _buildFileSelectionArea(),
                const SizedBox(height: 16),
                _buildSelectedFilesList(),
                _buildNotificationCheckbox(),
                const SizedBox(height: 16),
                _buildSubmitButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // DIALOG COMPONENTS
  // ---------------------------------------------------------------------------

  Widget _buildDialogHeader() {
    return Row(
      children: [
        const Spacer(),
        Text(
          tr(LanguageKeys.uploadFile),
          style: stylePoppins(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        const Spacer(),
        GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: const Icon(Icons.close),
        ),
      ],
    );
  }

  Widget _buildFileSelectionArea() {
    return GestureDetector(
      onTap: pickPdfFile,
      child: DottedBorder(
        color: Colors.grey,
        strokeWidth: 1.5,
        borderType: BorderType.RRect,
        radius: const Radius.circular(6),
        dashPattern: const [5, 3],
        child: Container(
          height: 130,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.insert_drive_file,
                    size: 32, color: Colors.grey),
                const SizedBox(height: 8),
                Text(tr(LanguageKeys.browseFile)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSelectedFilesList() {
    if (selectedFiles.isEmpty) return const SizedBox.shrink();

    return SizedBox(
      height: 160,
      child: Scrollbar(
        thumbVisibility: true,
        child: ListView(
          children: selectedFiles.map((file) {
            return _buildFileListItem(file);
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildFileListItem(PlatformFile file) {
    final key = file.identifier ?? file.path ?? file.name;
    final isEditing = editingFiles.contains(key);

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      child: Row(
        children: [
          Image.asset(AppAssets.imgPdf, height: 28.h, width: 28.w),
          const SizedBox(width: 10),
          Expanded(child: _buildFileNameField(key, isEditing)),
          const SizedBox(width: 8),
          const Text('.pdf', style: TextStyle(fontSize: 15)),
          const SizedBox(width: 8),
          _buildEditButton(key),
          const SizedBox(width: 8),
          _buildDeleteButton(file, key),
        ],
      ),
    );
  }

  Widget _buildFileNameField(String key, bool isEditing) {
    if (isEditing) {
      return FocusScope(
        child: Focus(
          onFocusChange: (hasFocus) {
            if (!hasFocus) {
              setState(() {
                editingFiles.remove(key);
              });
            }
          },
          child: TextField(
            controller: fileNameControllers[key],
            autofocus: true,
            decoration: const InputDecoration(
              isDense: true,
              contentPadding: EdgeInsets.zero,
              border: InputBorder.none,
            ),
            style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
            onSubmitted: (_) {
              setState(() {
                editingFiles.remove(key);
              });
            },
          ),
        ),
      );
    }

    return GestureDetector(
      onTap: () {
        // Disabled tap to edit
      },
      child: Text(
        fileNameControllers[key]?.text ?? '',
        style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
      ),
    );
  }

  Widget _buildEditButton(String key) {
    return GestureDetector(
      onTap: () {
        setState(() {
          editingFiles.add(key);
        });
      },
      child: const Icon(Icons.edit, color: AppColors.primary, size: 20),
    );
  }

  Widget _buildDeleteButton(PlatformFile file, String key) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedFiles.remove(file);
          fileNameControllers[key]?.dispose();
          fileNameControllers.remove(key);
          editingFiles.remove(key);
        });
      },
      child: const Icon(Icons.delete, color: AppColors.primary, size: 20),
    );
  }

  Widget _buildNotificationCheckbox() {
    return Row(
      children: [
        Checkbox(
          value: notifyNetwork,
          onChanged: (val) => setState(() => notifyNetwork = val ?? true),
          activeColor: AppColors.primary,
        ),
        Obx(() => Text(tr(LanguageKeys.uploadAndNotify))),
      ],
    );
  }

  Widget _buildSubmitButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      onPressed: selectedFiles.isEmpty ? null : _handleSubmit,
      child: Obx(() => Text(
            tr(LanguageKeys.assignModalSubmit),
            style: stylePoppins(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          )),
    );
  }

  // ---------------------------------------------------------------------------
  // SUBMIT HANDLER
  // ---------------------------------------------------------------------------

  Future<void> _handleSubmit() async {
    Navigator.of(context).pop();

    // Collect all files with valid paths and apply new names
    final files = <File>[];
    final renamedFiles = <String, String>{};

    for (var file in selectedFiles) {
      if (file.path != null) {
        files.add(File(file.path!));
        final key = file.identifier ?? file.path ?? file.name;
        final newName = fileNameControllers[key]?.text?.trim();

        if (newName != null && newName.isNotEmpty) {
          renamedFiles[file.path!] =
              newName.endsWith('.pdf') ? newName : '$newName.pdf';
        } else {
          renamedFiles[file.path!] = file.name;
        }
      }
    }

    if (files.isNotEmpty) {
      await controller.uploadDocument(
        widget.id,
        notifyNetwork == true ? '1' : '0',
        files,
        renamedFiles: renamedFiles,
      );
    }
  }
}
