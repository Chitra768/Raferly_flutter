import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:referaly/controller/controller_main_professional.dart';
import 'package:referaly/controller/invited_deals_controller.dart';
import 'package:referaly/languages/languagekeys.dart';
import 'package:referaly/models/model_accept_list.dart';
import 'package:referaly/resources/app_colors.dart';
import 'package:referaly/resources/text_style.dart';
import 'package:referaly/screens/deals/out_of_referaly_dialog.dart';
import 'package:referaly/screens/document_screen.dart';
import 'package:referaly/screens/lead_submission_screen.dart';
import 'package:referaly/utils/translations.dart';
import 'package:referaly/resources/app_assets.dart';
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
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black.withAlpha(20), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildDealHeader(e),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Divider(
              height: .5,
            ),
          ),
          _buildMoreInfo(e, index),
          _buildActionButtons(e),
        ],
      ),
    );
  }

  Widget _buildDealHeader(Data e) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
            ),
            child: (e.companyLogoUrl != null && e.companyLogoUrl!.isNotEmpty)
                ? Image.network(
                    e.companyLogoUrl!,
                    errorBuilder: (context, error, stackTrace) => Image.asset(
                      AppAssets.imgDefaultPerson,
                      height: 40.h,
                      width: 40.w,
                    ),
                  )
                : Image.asset(AppAssets.imgDefaultPerson),
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
                  ),
                ),
                Text(
                  e.dealName != null ? e.dealName! : "",
                  style: stylePoppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: AppColors.k6B7280),
                ),
              ],
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              // Small spacing if needed

              // Wrap PopupMenuButton with SizedBox + Theme override
              SizedBox(
                height: 24,
                width: 24,
                child: Theme(
                  data: Theme.of(Get.context!).copyWith(
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    visualDensity: VisualDensity.compact,
                  ),
                  child: PopupMenuButton<String>(
                    padding: EdgeInsets.zero,
                    color: Colors.white,
                    icon: Icon(
                      Icons.more_vert,
                      size: 20,
                      color: AppColors.blackColor,
                    ),
                    onSelected: (value) {
                      controller.getDealLeave(e.id.toString());
                    },
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        padding: EdgeInsets.zero,
                        height: 32,
                        value: 'delete',
                        child: Center(
                          child: Text(tr(LanguageKeys.deleteIamReferrer)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Get.dialog(
                    SharePopup(
                      title: e?.dealName ?? '',
                      link: e?.deepLink ?? '',
                    ),
                  );
                },
                child: Icon(
                  Icons.share_outlined,
                  size: 20,
                  color: AppColors.blackColor,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildMoreInfoHeader(
    int index,
  ) {
    return GestureDetector(
      onTap: () {
        if (controller.expandedIndices.contains(index)) {
          // If this item is already expanded, collapse it
          controller.expandedIndices.remove(index);
        } else {
          // If this item is not expanded, first clear all expanded items, then expand this one
          controller.expandedIndices.clear();
          controller.expandedIndices.add(index);
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              tr(LanguageKeys.companyDetailsMydeal),
              style: stylePoppins(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            Obx(
              () => Icon(
                controller.expandedIndices.contains(index)
                    ? Icons.remove
                    : Icons.add,
                color: AppColors.blackColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMoreInfo(Data e, int index) {
    print(e.dealCommissionType);
    return Column(
      children: [
        _buildMoreInfoHeader(
          index,
        ),
        Obx(
          () => controller.expandedIndices.contains(index)
              ? Container(
                  width: double.infinity,
                  margin:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(tr(LanguageKeys.description),
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                      Text(
                        e.companyDescription != null &&
                                e.companyDescription != "null"
                            ? e.companyDescription!
                            : "N/A",
                        style: stylePoppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: AppColors.k6B7280,
                        ),
                      ),
                      if (e.dealCommissionType == 1 ||
                          (e.dealCommissionType == 2 &&
                              e.dealCases != null &&
                              e.dealCases!.isNotEmpty))
                        const SizedBox(
                          height: 10,
                        ),
                      Text(tr(LanguageKeys.commision),
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                      if (e.dealCommissionType == "1")
                        Text(
                          e.commissionType == "no_commission"
                              ? tr(LanguageKeys.no_commission)
                              : e.commissionType == "fix_commission"
                                  ? ("${tr(LanguageKeys.fix_commission)} : ${e.commissionValue ?? ""} €")
                                  : ("${tr(LanguageKeys.percentage_commission)}  : ${e.commissionValue ?? ""} % HT du montant facturé"),
                        ),

                      if (e.dealCommissionType == "2" &&
                          e.dealCases != null &&
                          e.dealCases!.isNotEmpty) ...[
                        const SizedBox(height: 8),
                        // Show first deal case
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                e.dealCases![0].commissionType ==
                                        "no_commission"
                                    ? tr(LanguageKeys.no_commission)
                                    : e.dealCases![0].commissionType ==
                                            "fix_commission"
                                        ? ("${tr(LanguageKeys.fix_commission)} : ${e.dealCases![0].commissionValue ?? ""} €")
                                        : ("${tr(LanguageKeys.percentage_commission)}  : ${e.dealCases![0].commissionValue ?? ""} % HT du montant facturé"),
                              ),
                            ],
                          ),
                        ),
                        // Show remaining deal cases if expanded
                        if (controller.expandedIndices.contains(index)) ...[
                          ...e.dealCases!
                              .skip(1)
                              .map(
                                (dealCase) => Padding(
                                  padding: const EdgeInsets.only(bottom: 8),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        dealCase.commissionType ==
                                                "no_commission"
                                            ? tr(LanguageKeys.no_commission)
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
                        if (e.dealCases!.length > 1) ...[
                          const SizedBox(height: 8),
                          GestureDetector(
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
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                        ],
                      ],
                      // Text(
                      //   e?.commissionType == "no_commission"
                      //       ? tr(LanguageKeys.no_commission)
                      //       : e?.commissionType == "fix_commission"
                      //           ? ("${tr(LanguageKeys.fix_commission)} : ${e?.commissionValue ?? ""} €")
                      //           : ("${tr(LanguageKeys.percentage_commission)}  : ${e?.commissionValue ?? ""} % HT du montant facturé"),
                      //   style: stylePoppins(
                      //     fontSize: 14,
                      //     fontWeight: FontWeight.w400,
                      //     color: AppColors.k6B7280,
                      //   ),
                      // ),
                      // Add more details as needed
                    ],
                  ),
                )
              : const SizedBox.shrink(),
        ),
      ],
    );
  }

  Widget _buildActionButtons(Data e) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 60,
              child: OutlinedButton(
                onPressed: () {
                  Get.toNamed(DocumentScreen.pageId, arguments: {
                    'id': e.id.toString(),
                    'type': 'invited',
                  });
                },
                style: OutlinedButton.styleFrom(
                  backgroundColor: Colors.white,
                  side: const BorderSide(color: AppColors.primary, width: 1.5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Text(
                    textAlign: TextAlign.center,
                    tr(LanguageKeys.viewDocuments),
                    style: stylePoppins(
                      color: AppColors.primary,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Container(
              height: 60,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
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
                    'id': e?.createdDetail!.id,
                    'deal_id': e?.id,
                    'deal_name': e?.dealName,
                    'type': '',
                  });
                },
                child: Text(
                  tr(LanguageKeys.submitALead),
                  textAlign: TextAlign.center,
                  style: stylePoppins(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
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
            Text(
              tr(LanguageKeys.sendLead),
              style: stylePoppins(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              tr(LanguageKeys.toAProfessional),
              style: stylePoppins(
                fontSize: 14,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
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
          _buildHeaderButton(),
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
