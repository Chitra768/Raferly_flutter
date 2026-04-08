import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:referaly/controller/controller_main_professional.dart';
import 'package:referaly/controller/invited_deals_controller.dart';
import 'package:referaly/languages/languagekeys.dart';
import 'package:referaly/models/model_accept_list.dart';
import 'package:referaly/resources/app_assets.dart';
import 'package:referaly/resources/app_colors.dart';
import 'package:referaly/resources/text_style.dart';
import 'package:referaly/screens/dashboard/add_business_referrer_screen.dart';
import 'package:referaly/screens/deals/out_of_referaly_dialog.dart';
import 'package:referaly/screens/deals/referral_tracking_screen.dart';
import 'package:referaly/screens/document_screen.dart';
import 'package:referaly/utils/translations.dart';
import 'package:referaly/widgets/dialog/send_lead_bottom_sheet.dart';
import 'package:referaly/widgets/logo_loader.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../widgets/share_popup.dart';

class InvitedDealsScreen extends GetView<InvitedDealsController> {
  static String pageId = "/invitedDeals";

  const InvitedDealsScreen({super.key});

  Widget _buildDealCard(Data e, int index, BuildContext context) {
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
          _buildDealHeader(e, context),
          _buildDealContent(e, index, context),
          if (_showMultiLevelReferralActions(e)) _buildTrackAndAddSection(e),
          _buildActionButtons(e),
        ],
      ),
    );
  }

  bool _showMultiLevelReferralActions(Data e) {
    return (e.multiLevelReferral ?? '') == "1";
  }

  Widget _buildDealHeader(Data e, BuildContext context) {
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
                  e.companyName != null && e.companyName != "null" ? e.companyName! : "NA",
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
              GestureDetector(
                onTap: () {
                  _showHowItWorksDialog(context);
                },
                child: Container(
                  width: 24,
                  height: 24,
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    shape: BoxShape.circle,
                  ),
                  child: SvgPicture.asset(
                    AppAssets.imgInfoActivity,
                    height: 11,
                    color: AppColors.grey700,
                  ),
                ),
              ),
              PopupMenuButton<String>(
                padding: EdgeInsets.zero,
                color: Colors.white,
                icon: Container(
                  width: 24,
                  height: 24,
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Icon(
                    Icons.more_vert,
                    size: 11,
                    color: Colors.grey[600],
                  ),
                ),
                onSelected: (value) {
                  if (value == 'delete') {
                    controller.getDealLeave(e.id.toString());
                  } else if (value == 'share') {
                    Get.dialog(
                      SharePopup(title: e.dealName ?? '', link: e.deepLink ?? ''),
                    );
                  }
                },
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 'share',
                    child: Row(
                      children: [
                        Icon(Icons.share_outlined, size: 18, color: Colors.grey[700]),
                        const SizedBox(width: 8),
                        const Text('Share'),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      children: [
                        const Icon(Icons.delete_outline, size: 18, color: Colors.red),
                        const SizedBox(width: 8),
                        Text(tr(LanguageKeys.deleteIamReferrer), style: const TextStyle(color: Colors.red)),
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

  Widget _buildDealContent(Data e, int index, BuildContext context) {
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
            e.companyDescription != null && e.companyDescription != "null" ? e.companyDescription! : "",
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
                                : "${e.commissionValue ?? ""}% commission",
                        style: stylePoppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                        ),
                      ),
                      // Commission description
                      Text(
                        e.commissionType == "percentage_commission"
                            ? tr(LanguageKeys.withoutVATOfTheAmountInvoiced)
                            : e.commissionType == "fix_commission"
                                ? tr(LanguageKeys.fixedCommissionAmount)
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
                GestureDetector(
                  onTap: () {
                    _showSaveContactDialog(context, e);
                  },
                  child: Column(
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
                        tr(LanguageKeys.viewContact),
                        style: stylePoppins(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xFF6B7280),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ],

          if (e.dealCommissionType == "2" && e.dealCases != null && e.dealCases!.isNotEmpty) ...[
            // Show first deal case with view contact icon
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
                                : "${e.dealCases![0].commissionValue ?? ""}% commission",
                        style: stylePoppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                        ),
                      ),
                      Text(
                        e.dealCases![0].commissionType == "percentage_commission"
                            ? tr(LanguageKeys.withoutVATOfTheAmountInvoiced)
                            : e.dealCases![0].commissionType == "fix_commission"
                                ? tr(LanguageKeys.fixedCommissionAmount)
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
                GestureDetector(
                  onTap: () {
                    _showSaveContactDialog(context, e);
                  },
                  child: Column(
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
                        tr(LanguageKeys.viewContact),
                        style: stylePoppins(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xFF6B7280),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),

            // Show remaining deal cases inline (no expand/collapse)
            if (e.dealCases!.length > 1) ...[
              const SizedBox(height: 8),
              ...e.dealCases!.skip(1).map(
                    (dealCase) => Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            dealCase.commissionType == "no_commission"
                                ? tr(LanguageKeys.no_commission)
                                : dealCase.commissionType == "fix_commission"
                                    ? "€ ${dealCase.commissionValue ?? ""} commission"
                                    : "${dealCase.commissionValue ?? ""}% commission",
                            style: stylePoppins(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF374151),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            dealCase.commissionType == "percentage_commission"
                                ? tr(LanguageKeys.withoutVATOfTheAmountInvoiced)
                                : dealCase.commissionType == "fix_commission"
                                    ? tr(LanguageKeys.fixedCommissionAmount)
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
                  ),
            ],
          ],
        ],
      ),
    );
  }

  Widget _buildTrackAndAddSection(Data e) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Track Added Referrers
          GestureDetector(
            onTap: () {
              Get.toNamed(ReferralTrackingScreen.pageId, arguments: {
                'dealId': e.id.toString(),
              });
            },
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
              decoration: BoxDecoration(
                color: const Color(0xFFF9FAFB),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFFE5E7EB), width: 1),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    AppAssets.imgActivityStatics,
                    width: 16,
                    height: 16,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    tr(LanguageKeys.trackAddedReferrers),
                    style: stylePoppins(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF374151),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          // Add a Referrer
          GestureDetector(
            onTap: () {
              // Send invitation via email - same share flow
              Get.toNamed(AddBusinessReferrerScreen.pageId, arguments: {
                'deal_id': e.id.toString(),
                'created_by_parent': "true",
              });
            },
            child: DottedBorder(
              color: const Color(0xFFE5E7EB),
              strokeWidth: 1,
              borderType: BorderType.RRect,
              radius: const Radius.circular(10),
              dashPattern: const [6, 3],
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                decoration: BoxDecoration(
                  color: const Color(0xFFF9FAFB),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Icon(
                        Icons.add,
                        size: 16,
                        color: AppColors.whiteColor,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      tr(LanguageKeys.addAReferrer),
                      style: stylePoppins(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF374151),
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
                  backgroundColor: const Color(0xFFF3F4F6),
                  side: const BorderSide(color: Color(0xFFE5E7EB), width: 1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SvgPicture.asset(
                      AppAssets.imgContractDocument,
                      width: 16,
                      height: 16,
                    ),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        tr(LanguageKeys.contractAndDocument),
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        style: stylePoppins(
                          color: const Color(0xFF374151),
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
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
                  showModalBottomSheet(
                    context: Get.context!,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (context) {
                      return SendLeadBottomSheet(
                        dealId: (e.id ?? '').toString(),
                        companyName: e.companyName ?? '',
                        commissionValue: e.commissionValue ?? '',

                        // Use sharingTempLink or deepLink if formUrl isn't provided in this list
                        formUrl: (e.contactFormUrl?.isNotEmpty ?? false)
                            ? e.contactFormUrl
                            : (e.contactFormUrl?.isNotEmpty ?? false)
                                ? e.contactFormUrl
                                : e.contactFormUrl,
                      );
                    },
                  );
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SvgPicture.asset(AppAssets.imgLeadArrow,
                        width: 16, height: 16, color: AppColors.whiteColor),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        tr(LanguageKeys.submitALead),
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        style: stylePoppins(
                          color: AppColors.whiteColor,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
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
                const Icon(Icons.person_add_alt, color: Colors.white),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    tr(LanguageKeys.sendALeadToAProfessionalWhoDidNotInviteYou),
                    textAlign: TextAlign.center,
                    style: stylePoppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
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
          tr(LanguageKeys.iAmABusinessReferrer),
          style: stylePoppins(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () => _showHowItWorksDialog(context),
            icon: Container(
              width: 24,
              height: 24,
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: Text(
                  '?',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ),
            ),
          ),
        ],
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
                      ? _buildNoDealsEmptyState(context)
                      : ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: controller.acceptList.value?.data?.length ?? 0,
                          itemBuilder: (context, index) {
                            final contract = controller.acceptList.value?.data?[index];
                            return _buildDealCard(contract!, index, context);
                          },
                        ),
            ),
          ),
          // _buildSendLeadBanner(),
        ],
      ),
    );
  }

  Widget _buildNoDealsEmptyState(BuildContext context) {
    const purpleDark = Color(0xFF7C3AED);
    const purpleLight = Color(0xFFF3E8FF);
    const cardGrey = Color(0xFFF5F5F5);
    final descStyle = stylePoppins(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      color: const Color(0xFF374151),
    );
    final boldStyle = stylePoppins(
      fontSize: 14,
      fontWeight: FontWeight.w600,
      color: purpleDark,
    );
    final headingStyle = stylePoppins(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      color: Colors.black,
    );

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      child: Column(
        children: [
          const SizedBox(height: 16),
          // Central illustration with overlay icons (handshake + grid top-right + link bottom-left)
          SizedBox(
            width: 200,
            height: 200,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 180,
                  height: 180,
                  decoration: const BoxDecoration(
                    color: purpleLight,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: SvgPicture.asset(
                      AppAssets.imgHandshake,
                      width: 72,
                      height: 72,
                      colorFilter: const ColorFilter.mode(
                        purpleDark,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 0,
                  right: 0,
                  child: Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: purpleLight,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.grid_4x4_rounded,
                        size: 22,
                        color: purpleDark,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  child: Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: purpleLight,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: Center(
                      child: SvgPicture.asset(
                        AppAssets.imgLink,
                        width: 22,
                        height: 22,
                        colorFilter: const ColorFilter.mode(
                          purpleDark,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          // "Already invited?" in light grey card with purple down-arrow icon
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: cardGrey,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: const BoxDecoration(
                    color: purpleDark,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.keyboard_arrow_down,
                    size: 20,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        tr(LanguageKeys.alreadyInvited),
                        style: headingStyle,
                      ),
                      const SizedBox(height: 8),
                      _buildDescriptionWithBold(
                        tr(LanguageKeys.alreadyInvitedDescription),
                        descStyle,
                        boldStyle,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(child: Divider(color: Colors.grey[300])),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Text(
                  tr(LanguageKeys.or),
                  style: stylePoppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[600],
                  ),
                ),
              ),
              Expanded(child: Divider(color: Colors.grey[300])),
            ],
          ),
          const SizedBox(height: 20),
          // "Start a new partnership" in light grey card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: cardGrey,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: const BoxDecoration(
                    color: purpleDark,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.keyboard_arrow_down,
                    size: 20,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        tr(LanguageKeys.startNewPartnership),
                        style: headingStyle,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        tr(LanguageKeys.startNewPartnershipDescription),
                        style: descStyle,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              onPressed: () {
                Get.toNamed(OutOfReferalyScreen.pageId)?.then((value) => controller.getAcceptList());

                // Get.toNamed(BusinessReferrerContractScreen.pageId)
                //     ?.then((value) => controller.getAcceptList());
              },
              icon: const Icon(Icons.add, size: 22),
              label: Text(
                tr(LanguageKeys.createReferralDealAsBusinessReferrer),
                textAlign: TextAlign.center,
                style: stylePoppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildDescriptionWithBold(
    String text,
    TextStyle normalStyle,
    TextStyle boldStyle,
  ) {
    final spans = <TextSpan>[];
    int start = 0;
    final regex = RegExp(r'\*\*(.+?)\*\*');
    for (final match in regex.allMatches(text)) {
      if (match.start > start) {
        spans.add(TextSpan(
          text: text.substring(start, match.start),
          style: normalStyle,
        ));
      }
      spans.add(TextSpan(
        text: match.group(1),
        style: boldStyle,
      ));
      start = match.end;
    }
    if (start < text.length) {
      spans.add(TextSpan(
        text: text.substring(start),
        style: normalStyle,
      ));
    }
    return RichText(
      textAlign: TextAlign.left,
      text: TextSpan(children: spans),
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
                    const Spacer(),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 28,
                          height: 28,
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: SvgPicture.asset(
                            AppAssets.imgHandshake,
                            width: 20,
                            height: 20,
                            colorFilter: const ColorFilter.mode(
                              Colors.white,
                              BlendMode.srcIn,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          tr(LanguageKeys.referralHubTitle),
                          style: stylePoppins(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
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
                      // Send a Lead Section
                      _buildHowItWorksSection(
                        icon: Container(
                          width: 48,
                          height: 48,
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: const Color(0xFEE9D5FF), // Purple
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: SvgPicture.asset(
                            AppAssets.imgSendActivity,
                            width: 8,
                          ),
                        ),
                        title: tr(LanguageKeys.LeadsTitle),
                        description: tr(LanguageKeys.LeadsDescription),
                      ),

                      const SizedBox(height: 24),

                      // Contract & Documents Section
                      _buildHowItWorksSection(
                        icon: Container(
                          width: 48,
                          height: 48,
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: const Color(0xFFBFDBFE), // Light blue
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: SvgPicture.asset(
                            AppAssets.imgDocument,
                            width: 8,
                          ),
                        ),
                        title: tr(LanguageKeys.ContractTitle),
                        description: tr(LanguageKeys.ContractDescription),
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
                          child: const Icon(
                            Icons.more_vert,
                            color: Color(0xFFDC2626),
                            size: 24,
                          ),
                        ),
                        title: tr(LanguageKeys.OptionsTitle),
                        description: tr(LanguageKeys.OptionsDescription),
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

  void _showSaveContactDialog(BuildContext context, Data data1Referrer) {
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
                      child: data1Referrer.createdDetail?.avatarUrl != null
                          ? ClipOval(
                              child: Image.network(
                                data1Referrer.createdDetail!.avatarUrl!,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    decoration: BoxDecoration(
                                      color: Colors.grey[400],
                                      shape: BoxShape.circle,
                                    ),
                                    child: Image.asset(AppAssets.imgDefaultPerson),
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
                data1Referrer.createdDetail?.companyName ?? "",
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
                            child: const Icon(
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
                                  data1Referrer.createdDetail?.phoneNumber ?? tr(LanguageKeys.notAvialble),
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
                              final Uri phoneUri =
                                  Uri(scheme: 'tel', path: data1Referrer.createdDetail?.companyNumber);
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
                            child: const Icon(
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
                                  data1Referrer.createdDetail?.email ?? tr(LanguageKeys.notAvialble),
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
                              final Uri emailUri =
                                  Uri(scheme: 'mailto', path: data1Referrer.createdDetail?.email);
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
                            tr(LanguageKeys.contactAddedSuccessfully),
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
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
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
                            tr(LanguageKeys.addContact),
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
