import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:referaly/controller/controller_main_professional.dart';
import 'package:referaly/controller/invited_deals_controller.dart';
import 'package:referaly/languages/languagekeys.dart';
import 'package:referaly/models/model_accept_list.dart';
import 'package:referaly/resources/app_assets.dart';
import 'package:referaly/resources/app_colors.dart';
import 'package:referaly/resources/text_style.dart';
import 'package:referaly/screens/deals/out_of_referaly_dialog.dart';
import 'package:referaly/screens/document_screen.dart';
import 'package:referaly/screens/lead_submission_screen.dart';
import 'package:referaly/utils/translations.dart';
import 'package:referaly/widgets/logo_loader.dart';

import '../../widgets/share_popup.dart';

class InvitedDealsScreen extends GetView<InvitedDealsController> {
  static String pageId = "/invitedDeals";

  const InvitedDealsScreen({super.key});
  Widget _buildHeaderButton() {
    return GestureDetector(
      onTap: () {},
      child: Container(
        height: 50,
        width: Get.width * 0.56,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          tr(LanguageKeys.invitedDeal),
          textAlign: TextAlign.center,
          style: stylePoppins(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildDealCard(Data e, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
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
          _buildDealHeader(e),
          _buildDealContent(e, index),
          _buildActionButtons(e),
        ],
      ),
    );
  }

  Widget _buildDealHeader(Data e) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(
              color: const Color(0xFFE8F5E8),
              borderRadius: BorderRadius.circular(12),
            ),
            child: (e.companyLogoUrl != null && e.companyLogoUrl!.isNotEmpty)
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      e.companyLogoUrl!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => const Icon(
                        Icons.person,
                        size: 24,
                        color: AppColors.primary,
                      ),
                    ),
                  )
                : const Icon(
                    Icons.person,
                    size: 24,
                    color: AppColors.primary,
                  ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  e.companyName != null && e.companyName != "null"
                      ? e.companyName!
                      : "NA",
                  style: stylePoppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF1F2937),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  e.dealName != null ? e.dealName! : "",
                  style: stylePoppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: SvgPicture.asset(
                  AppAssets.imgActivityInfo,
                  height: 20,
                  width: 20,
                ),
              ),
              const SizedBox(width: 8),
              PopupMenuButton<String>(
                padding: EdgeInsets.zero,
                color: Colors.white,
                icon: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Icon(
                    Icons.more_vert,
                    size: 20,
                    color: Colors.grey[600],
                  ),
                ),
                onSelected: (value) {
                  if (value == 'delete') {
                    controller.getDealLeave(e.id.toString());
                  } else if (value == 'share') {
                    Get.dialog(
                      SharePopup(
                          title: e.dealName ?? '', link: e.deepLink ?? ''),
                    );
                  }
                },
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 'share',
                    child: Row(
                      children: [
                        Icon(Icons.share_outlined,
                            size: 18, color: Colors.grey[700]),
                        const SizedBox(width: 8),
                        const Text('Share'),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      children: [
                        const Icon(Icons.delete_outline,
                            size: 18, color: Colors.red),
                        const SizedBox(width: 8),
                        Text(tr(LanguageKeys.deleteIamReferrer),
                            style: const TextStyle(color: Colors.red)),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildDealContent(Data e, int index) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFFFAF5FF), // 0%
            Color(0xFFF3E8FF), // 100%
          ],
        ),
        border: Border.all(
          color: const Color(0xFFE9D5FF),
          width: 1,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Description
          Text(
            e.companyDescription != null && e.companyDescription != "null"
                ? e.companyDescription!
                : "",
            style: stylePoppins(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: const Color(0xFF374151),
            ),
          ),
          const SizedBox(height: 12),

          // Commission info
          if (e.dealCommissionType == "1") ...[
            Row(
              children: [
                // Commission amount
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        e.commissionType == "no_commission"
                            ? tr(LanguageKeys.no_commission)
                            : e.commissionType == "fix_commission"
                                ? "€ ${e.commissionValue ?? ""} commission"
                                : "€ ${e.commissionValue ?? ""}% commission",
                        style: stylePoppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                        ),
                      ),
                      // Commission description
                      Text(
                        e.commissionType == "percentage_commission"
                            ? "without VAT of the amount invoiced"
                            : e.commissionType == "fix_commission"
                                ? "fixed commission amount"
                                : "",
                        style: stylePoppins(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xFF6B7280),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                // View contact icon
                Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Icon(
                        Icons.person_outline,
                        size: 20,
                        color: AppColors.whiteColor,
                      ),
                    ),
                    Text(
                      "View Contact ",
                      style: stylePoppins(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFF6B7280),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ],

          if (e.dealCommissionType == "2" &&
              e.dealCases != null &&
              e.dealCases!.isNotEmpty) ...[
            // Show first deal case
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        e.dealCases![0].commissionType == "no_commission"
                            ? tr(LanguageKeys.no_commission)
                            : e.dealCases![0].commissionType == "fix_commission"
                                ? "€ ${e.dealCases![0].commissionValue ?? ""} commission"
                                : "€ ${e.dealCases![0].commissionValue ?? ""}% commission",
                        style: stylePoppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                        ),
                      ),
                      Text(
                        e.dealCases![0].commissionType ==
                                "percentage_commission"
                            ? "without VAT of the amount invoiced"
                            : e.dealCases![0].commissionType == "fix_commission"
                            ? "fixed commission amount"
                            : "",
                        style: stylePoppins(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xFF6B7280),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                // View contact icon
                Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Icon(
                        Icons.person_outline,
                        size: 20,
                        color: AppColors.whiteColor,
                      ),
                    ),
                    Text(
                      "View Contact ",
                      style: stylePoppins(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFF6B7280),
                      ),
                    )
                  ],
                ),
              ],
            ),

            // Show remaining deal cases if expanded
            Obx(() => controller.expandedIndices.contains(index)
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 8),
                      ...e.dealCases!
                          .skip(1)
                          .map(
                            (dealCase) => Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    dealCase.commissionType == "no_commission"
                                        ? tr(LanguageKeys.no_commission)
                                        : dealCase.commissionType ==
                                                "fix_commission"
                                            ? "€ ${dealCase.commissionValue ?? ""} commission"
                                            : "€ ${dealCase.commissionValue ?? ""}% commission",
                                    style: stylePoppins(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: const Color(0xFF374151),
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    dealCase.commissionType ==
                                            "percentage_commission"
                                        ? "without VAT of the amount invoiced"
                                        : dealCase.commissionType == "fix_commission"
                                        ? "fixed commission amount"
                                        : "",
                                    style: stylePoppins(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400,
                                      color: const Color(0xFF6B7280),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                          .toList(),
                    ],
                  )
                : const SizedBox.shrink()),

            // Show See more/See less button if there are multiple cases
            if (e.dealCases!.length > 1) ...[
              const SizedBox(height: 8),
              Obx(() => GestureDetector(
                    onTap: () {
                      if (controller.expandedIndices.contains(index)) {
                        controller.expandedIndices.remove(index);
                      } else {
                        controller.expandedIndices.add(index);
                      }
                    },
                    child: Text(
                      controller.expandedIndices.contains(index)
                          ? tr(LanguageKeys.seeLess)
                          : tr(LanguageKeys.seeMore),
                      style: stylePoppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF374151),
                      ),
                    ),
                  )),
            ],
          ],
        ],
      ),
    );
  }

  Widget _buildActionButtons(Data e) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Row(
        children: [
          Expanded(
            child: Container(
              child: OutlinedButton(
                onPressed: () {
                  Get.toNamed(DocumentScreen.pageId, arguments: {
                    'id': e.id.toString(),
                    'type': 'invited',
                  });
                },
                style: OutlinedButton.styleFrom(
                  backgroundColor: Color(0xFFF3F4F6),
                  side: const BorderSide(color: Color(0xFFE5E7EB), width: 1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      AppAssets.imgContractDocument,
                      width: 16,
                      height: 16,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      tr(LanguageKeys.contractAndDocument),
                      textAlign: TextAlign.center,
                      style: stylePoppins(
                        color: const Color(0xFF374151),
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
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
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                onPressed: () {
                  Get.toNamed(LeadSubmissionScreen.pageId, arguments: {
                    'lead_assign_type': "",
                    'first': "",
                    'last': "",
                    'email': "",
                    'phone': "",
                    'id': e.createdDetail!.id,
                    'deal_id': e.id,
                    'deal_name': e.dealName,
                    'type': '',
                  });
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(AppAssets.imgLeadArrow,
                        width: 16, height: 16, color: AppColors.whiteColor),
                    const SizedBox(width: 8),
                    Text(
                      tr(LanguageKeys.submitALead),
                      textAlign: TextAlign.center,
                      style: stylePoppins(
                        color: AppColors.whiteColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSendLeadBanner() {
    return GestureDetector(
      onTap: () {
        Get.toNamed(OutOfReferalyScreen.pageId);
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        margin: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(Icons.person_add_alt, color: Colors.white),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    "Send a lead to a professional who did not invite you",
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: stylePoppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            // const SizedBox(height: 6),
            // Text(
            //   tr(LanguageKeys.toAProfessional),
            //   style: stylePoppins(
            //     fontSize: 14,
            //     color: Colors.white,
            //   ),
            //   textAlign: TextAlign.center,
            // ),
          ],
        ),
      ),
    );
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
          onPressed: () {
            Get.find<ControllerMainProfessional>().getProfile();
            Get.back();
          },
        ),
        title: Text(
          tr(LanguageKeys.dealTabHeader),
          style: stylePoppins(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // _buildHeaderButton(),
          Expanded(
            child: Obx(
              () => controller.isLoading.value
                  ? const Center(
                      child: SizedBox(
                        width: 24,
                        height: 24,
                        child: LogoLoader(),
                      ),
                    )
                  : controller.acceptList.value?.data?.isEmpty ?? true
                      ? Center(
                          child: Text(
                            tr(LanguageKeys.becomeABusiness),
                            textAlign: TextAlign.center,
                            style: stylePoppins(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: AppColors.blackColor,
                            ),
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount:
                              controller.acceptList.value?.data?.length ?? 0,
                          itemBuilder: (context, index) {
                            final contract =
                                controller.acceptList.value?.data?[index];
                            return _buildDealCard(contract!, index);
                          },
                        ),
            ),
          ),
          _buildSendLeadBanner(),
        ],
      ),
    );
  }
}
