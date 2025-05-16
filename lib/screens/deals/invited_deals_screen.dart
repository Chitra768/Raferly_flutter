import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:referaly/controller/invited_deals_controller.dart';
import 'package:referaly/languages/languagekeys.dart';
import 'package:referaly/models/model_accept_list.dart';
import 'package:referaly/resources/app_colors.dart';
import 'package:referaly/resources/text_style.dart';
import 'package:referaly/screens/deals/out_of_referaly_dialog.dart';
import 'package:referaly/screens/document_screen.dart';
import 'package:referaly/screens/lead_submission_screen.dart';
import 'package:referaly/utils/translations.dart';

class InvitedDealsScreen extends GetView<InvitedDealsController> {
  static String pageId = "/invitedDeals";

  const InvitedDealsScreen({super.key});

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
                  ? const Center(child: CircularProgressIndicator())
                  : ListView(
                      padding: const EdgeInsets.all(16),
                      children: [
                        ...controller.acceptList.value?.data
                                ?.map((e) => _buildDealCard(e)) ??
                            [],
                        const SizedBox(height: 20),
                        _buildSendLeadBanner(),
                      ],
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderButton() {
    return GestureDetector(
      onTap: () {},
      child: Container(
        height: 50,
        width: Get.width * 0.4,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          tr(LanguageKeys.invitedDeals),
          style: stylePoppins(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildDealCard(Data e) {
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
          _buildMoreInfo(e),
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
              color: Colors.green,
              borderRadius: BorderRadius.circular(6),
            ),
            child: const Center(
              child: Icon(
                Icons.person,
                color: Colors.white,
                size: 30,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  e.dealName != null ? e.dealName! : "",
                  style: stylePoppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  e.commissionType != null ? e.commissionType! : "",
                  style: stylePoppins(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: [
              GestureDetector(
                onTap: () => controller.showMoreOptions(e.id ?? 0),
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Icon(Icons.more_vert),
                ),
              ),
              GestureDetector(
                onTap: () => controller.shareDeal(e.id ?? 0),
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

  Widget _buildMoreInfo(Data e) {
    return InkWell(
      onTap: () => {},
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(10)),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              tr(LanguageKeys.companyDetails),
            
              style: stylePoppins(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const Icon(Icons.add),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons(Data e) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () {
                Get.toNamed(DocumentScreen.pageId, arguments: {
                  'id': e.id,
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
              child: Text(
                tr(LanguageKeys.viewDocuments),
                style: stylePoppins(
                  color: AppColors.primary,
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
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
                  'id': "",
                  'deal_id': e.id,
                });
              },
              child: Text(
                tr(LanguageKeys.submitALead),
                style: stylePoppins(
                  color: Colors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
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
}
