import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
              color: Colors.black,
              borderRadius: BorderRadius.circular(6),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  e.companyName != null ? e.companyName! : "",
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
            children: [
              PopupMenuButton<String>(
                color: Colors.white,
                icon: Icon(Icons.more_vert, color: AppColors.blackColor),
                onSelected: (value) {},
                itemBuilder: (context) => [
                  PopupMenuItem(
                    padding: EdgeInsets.all(0),
                    height: 20,
                    value: 'delete',
                    child: Center(
                      child: Text(tr(LanguageKeys.delete)),
                    ),
                  ),
                ],
              ),
              GestureDetector(
                onTap: () => {
                  Get.dialog(
                    SharePopup(
                      title: e?.dealName ?? '',
                      link: e?.inviteLink ?? '',
                    ),
                  )
                },
                child: const Padding(
                  padding: EdgeInsets.all(3.0),
                  child: Icon(
                    Icons.share,
                    size: 20,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMoreInfoHeader(
    int index,
  ) {
    return GestureDetector(
      onTap: () {
        if (controller.isExpanded.value) {
          controller.isExpanded.value = false;
          controller.expandedIndices.remove(index);
        } else {
          controller.isExpanded.value = true;
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
                controller.isExpanded.value ? Icons.remove : Icons.add,
                color: AppColors.blackColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMoreInfo(Data e, int index) {
    controller.isExpanded.value = controller.expandedIndices.contains(index);
    return Column(
      children: [
        _buildMoreInfoHeader(
          index,
        ),
        Obx(
          () => controller.isExpanded.value
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
                      const Text("Description",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      Text(
                        e.companyDescription != null
                            ? e.companyDescription!
                            : "",
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      const Text("Commission",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      Text(
                        e?.commissionType == "no_commission"
                            ? tr(LanguageKeys.no_commission)
                            : e?.commissionType == "fix_commission"
                                ? tr(LanguageKeys.fix_commission)
                                : (e?.commissionType ?? ""),
                      ),
                      // Add more details as needed
                    ],
                  ),
                )
              : SizedBox.shrink(),
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
                  });
                },
                style: OutlinedButton.styleFrom(
                  backgroundColor: Colors.white,
                  side: BorderSide(color: AppColors.primary, width: 1.5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 8),
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
                    'first': e?.createdDetail!.firstName,
                    'last': e?.createdDetail!.lastName,
                    'email': e?.createdDetail!.email,
                    'phone': e?.createdDetail!.phoneNumber,
                    'id': e?.createdDetail!.id,
                    'deal_id': e?.createdDetail!.id,
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
        margin: EdgeInsets.all(16),
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
                  ? Center(
                      child: SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          color: AppColors.primary,
                          strokeWidth: 2.5,
                        ),
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
                            final isExpanded =
                                controller.expandedIndices.contains(index);
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
