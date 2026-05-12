import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:referaly/controller/controller_main_professional.dart' show ControllerMainProfessional;
import 'package:referaly/controller/track_lead_controller.dart';
import 'package:referaly/languages/languagekeys.dart';
import 'package:referaly/models/model_dashboard.dart';
import 'package:referaly/resources/app_helper.dart';
import 'package:referaly/resources/app_log.dart';
import 'package:referaly/resources/text_style.dart';
import 'package:referaly/screens/activity/activity_category_screen.dart';
import 'package:referaly/screens/archeive/archeive_list.dart';
import 'package:referaly/screens/dashboard/add_business_referrer_screen.dart';
import 'package:referaly/screens/deals/invited_deals_screen.dart';
import 'package:referaly/screens/document_screen.dart';
import 'package:referaly/utils/translations.dart';
import 'package:referaly/widgets/dialog/send_lead_bottom_sheet.dart';

import '../../resources/app_assets.dart';
import '../../resources/app_colors.dart';
import '../../resources/app_preference.dart';
import '../../widgets/app_drawer.dart';
import '../deals/referral_tracking_screen.dart';

class IndividualHome extends StatefulWidget {
  static String pageId = "/homeWithoutPrimum";
  final ControllerMainProfessional controller;
  final TrackLeadsController trackLeadCntrl;
  const IndividualHome({super.key, required this.controller, required this.trackLeadCntrl});

  @override
  State<IndividualHome> createState() => _IndividualHomeState();
}

class _IndividualHomeState extends State<IndividualHome> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  Future<void> downloadAndOpenPdf(String url) async {
    try {
      final response = await http.get(Uri.parse(url));
      final tempDir = await getTemporaryDirectory();
      final file = File('${tempDir.path}/temp.pdf');
      await file.writeAsBytes(response.bodyBytes);

      final result = await OpenFilex.open(file.path);

      if (result.type != ResultType.done) {
        // handle error
        debugPrint('Failed to open: ${result.message}');
      }
    } catch (e) {
      debugPrint('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppColors.grey100,
      drawer: const AppDrawer(),
      body: RefreshIndicator(
        onRefresh: () async {
          final controller = Get.find<ControllerMainProfessional>();
          await controller.getDashboard();
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              _buildHeader(),
              const SizedBox(height: 20),
              _buildCompanyOverview(),
              const SizedBox(height: 20),
              _buildConnectionSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      child: Stack(
        children: [
          Container(
            height: 250,
            width: double.infinity,
            decoration: const BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(2)),
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(16, 20 + (kToolbarHeight - 15), 16, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Profile and greeting section
                Row(
                  children: [
                    // Profile picture with refresh icon
                    Stack(
                      children: [
                        Obx(
                          () => widget.controller.profileImagePath.isNotEmpty
                              ? Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Colors.white,
                                      width: 2.0,
                                    ),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(25.w),
                                    child: SizedBox(
                                      width: 50.w,
                                      height: 50.w,
                                      child: Image.network(
                                        widget.controller.profileImagePath.value,
                                        fit: BoxFit.cover,
                                        errorBuilder: (context, error, stackTrace) => Image.asset(
                                          AppAssets.imgDefaultPerson,
                                          width: 50.w,
                                          height: 50.w,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              : Container(
                                  width: 50.w,
                                  height: 50.w,
                                  decoration: BoxDecoration(
                                    color: AppColors.primary,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Image.asset(
                                    AppAssets.imgDefaultPerson,
                                    width: 50.w,
                                    height: 50.w,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            width: 16,
                            height: 16,
                            decoration: const BoxDecoration(
                              color: Colors.transparent,
                              shape: BoxShape.circle,
                            ),
                            child: SvgPicture.asset(
                              AppAssets.imgRefresh,
                              width: 10,
                              height: 10,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 12),
                    // Greeting text
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            tr(LanguageKeys.hi),
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white.withOpacity(0.8),
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          Text(
                            "${widget.controller.profile.value?.data?.firstName ?? ''} ${widget.controller.profile.value?.data?.lastName ?? ''}",
                            style: const TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Hamburger menu
                    GestureDetector(
                      onTap: () => _scaffoldKey.currentState?.openDrawer(),
                      child: const Icon(
                        Icons.menu,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                // Dashboard section
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            tr(LanguageKeys.dashboard),
                            style: stylePoppins(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: AppColors.blackColor,
                            ),
                          ),
                          const Spacer(),
                          SvgPicture.asset(
                            AppAssets.imgDashboardTrack,
                            height: 30,
                            width: 30,
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      GridView.count(
                        crossAxisCount: 2,
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        padding: EdgeInsets.zero,
                        mainAxisSpacing: 6,
                        crossAxisSpacing: 10,
                        childAspectRatio: 1.3,
                        children: [
                          Obx(
                            () => dashboardStatCardWithGradient(
                                tr(LanguageKeys.leadSent),
                                widget.controller.dashboard.value?.data?.totalLeads?.toString() ?? '0',
                                const Color(0xFFEFF6FF), // ECFDF5
                                const Color(0xFFDBEAFE), // D1FAE5
                                const Color(0xFFBFDBFE), // A7F3D0 stroke
                                const Color(0xFF1E40AF), // 065F46 label
                                const Color(0xFF2563EB), // 059669 value
                                AppAssets.imgHomeSent,
                                "",
                                "svg",
                                () {
                              widget.trackLeadCntrl.toggleLeadType(false);
                              widget.controller.changeTab(1);
                            }),
                          ),
                          Obx(
                            () => dashboardStatCardWithGradient(
                              tr(LanguageKeys.commissionReceived),
                              widget.controller.formatEuroCompactPrecise(
                                num.tryParse(
                                      widget.controller.dashboard.value?.data?.currentMonthIncomeGenerated ??
                                          '',
                                    ) ??
                                    num.tryParse(
                                      widget.controller.dashboard.value?.data?.incomeGenerated?.toString() ??
                                          '0',
                                    ) ??
                                    0,
                              ),
                              const Color(0xFFFFFBEB), // ECFDF5
                              const Color(0xFFFEF3C7), // D1FAE5
                              const Color(0xFFFDE68A), // A7F3D0 stroke
                              const Color(0xFF92400E), // 065F46 label
                              const Color(0xFFD97706), // 059669 value
                              AppAssets.imgHomeReceived1,
                              "",
                              "png",
                              () {
                                Get.toNamed(ArchiveList.pageId, arguments: {"type": "send"});
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget tile(String title, String? value, String? icon1, String? icon, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 159,
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      child: Text(
                        title,
                        textAlign: TextAlign.start,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          height: 1.2,
                        ),
                      ),
                    ),
                    Stack(
                      children: [
                        if (icon != null && icon.isNotEmpty) SvgPicture.asset(icon, height: 20, width: 20),
                        if (title == tr(LanguageKeys.invitedDealsHomePage))
                          Positioned(
                            child: Obx(() => widget.controller.isLoadingDashboard.value ||
                                    widget.controller.dashboard.value?.data?.notificationsCount == "0"
                                ? const SizedBox.shrink()
                                : Container(
                                    constraints: const BoxConstraints(
                                      minWidth: 20,
                                      minHeight: 20,
                                    ),
                                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: Colors.red,
                                      shape: BoxShape.circle,
                                      border: Border.all(color: Colors.red, width: 1),
                                    ),
                                    child: Center(
                                      child: Text(
                                        widget.controller.dashboard.value?.data?.notificationsCount
                                                ?.toString() ??
                                            '0',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  )),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
                    child: Text(
                      value!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 28,
                        color: Colors.transparent,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  if (icon1 != null && icon1.isNotEmpty) SvgPicture.asset(icon1, height: 78, width: 92),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget dashboardStatCardWithGradient(String label, String value, Color gradientStart, Color gradientEnd,
      Color strokeColor, Color labelColor, Color valueColor, String icon, String icon1, String imgType, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.only(left: 12, right: 0, top: 12, bottom: 8),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [gradientStart, gradientEnd],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: strokeColor, width: 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: labelColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                if (icon1.trim().isNotEmpty) imgType == "png" ? Image.asset(icon1, height: 20, width: 20) : SvgPicture.asset(icon1, height: 20, width: 20),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text(
                    value,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 26.sp,
                      color: valueColor,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                if (icon.trim().isNotEmpty) imgType == "png" ? Image.asset(icon, height: 36, width: 36) : SvgPicture.asset(icon, height: 36, width: 36),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCompanyOverview() {
    return Obx(
      () => (widget.controller.dashboard.value?.data?.activeDeals?.length ?? 0) > 2
          ? Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Obx(
                  () => tile(
                      tr(LanguageKeys.invitedDealsHomePage),
                      widget.controller.dashboard.value?.data?.invitedDealsCount?.toString() ?? '0',
                      AppAssets.imgHomeVector2,
                      AppAssets.imgHomeVector2, () {
                    Get.toNamed(InvitedDealsScreen.pageId)?.then((value) {
                      widget.controller.getDashboard();
                    });
                  }),
                ),
              ],
            )
          : Container(
              margin: const EdgeInsets.fromLTRB(16, 20, 16, 0),
              padding: const EdgeInsets.all(20),
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.whiteColor,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Obx(
                        () => widget.controller.dashboard.value?.data?.activeDeals?.isEmpty ?? true
                            ? Center(
                                child: SvgPicture.asset(
                                  AppAssets.imgAppLgo,
                                  height: 30.h,
                                  width: 30.w,
                                ),
                              )
                            : const SizedBox.shrink(),
                      ),

                      // Company header with icon and name (FinSpain style)
                      Obx(
                        () => widget.controller.dashboard.value?.data?.activeDeals?.isEmpty ?? true
                            ? const SizedBox.shrink()
                            : Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Obx(() {
                                    final companyLogoUrl = widget.controller.dashboard.value?.data
                                        ?.activeDeals?.first.createdDetail?.companyLogoUrl;
                                    AppHelper.showLog("companyLogoUrl: $companyLogoUrl");
                                    return companyLogoUrl?.isNotEmpty == true
                                        ? Container(
                                            height: 50,
                                            width: 50,
                                            decoration: BoxDecoration(
                                              color: AppColors.whiteColor,
                                              borderRadius: BorderRadius.circular(16),
                                            ),
                                            child: Image.network(
                                              widget.controller.dashboard.value?.data?.activeDeals?.first
                                                      .createdDetail?.companyLogoUrl ??
                                                  '',
                                              width: 42,
                                              height: 42,
                                              fit: BoxFit.cover,
                                            ),
                                          )
                                        : const SizedBox.shrink();
                                  }),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          widget.controller.dashboard.value?.data?.activeDeals?.isNotEmpty ??
                                                  false
                                              ? (widget.controller.dashboard.value?.data?.activeDeals?.first
                                                      .createdDetail?.companyName ??
                                                  '')
                                              : '',
                                          style: const TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          widget.controller.dashboard.value?.data?.activeDeals?.first
                                                  .dealName ??
                                              '',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: AppColors.grey600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                      ),

                      const SizedBox(height: 20),

                      // Commission rate display (FinSpain style)
                      Obx(
                        () {
                          final activeDeals = widget.controller.dashboard.value?.data?.activeDeals;
                          final hasActiveDeals = activeDeals?.isNotEmpty ?? false;

                          if (!hasActiveDeals) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  tr(LanguageKeys.youAreNotCurrentlyPartOfAnyBusinessReferralProgram),
                                  textAlign: TextAlign.center,
                                  style: stylePoppins(
                                    fontSize: 14,
                                    color: AppColors.blackColor,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  tr(LanguageKeys.askYourProfessionalToInviteYouUsingTheirLinkOrQRCode),
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: AppColors.textTitleHint,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  tr(LanguageKeys
                                      .askAProfessionalToSendYouAnInvitationToJoinTheirReferralNetwork),
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            );
                          }

                          final activeDeal = activeDeals!.first;
                          final commissionType = activeDeal.commissionType;

                          if (commissionType == "no_commission") {
                            return const SizedBox.shrink();
                          }

                          final commissionValue = activeDeal.commissionValue;
                          String formattedCommissionValue = '';
                          if (commissionValue != null && commissionValue != "null") {
                            final value = commissionValue.toString();
                            String symbol = '';

                            if (commissionType == "percentage_commission") {
                              symbol = '%';
                            } else if (commissionType == "fix_commission") {
                              symbol = '€';
                            }

                            formattedCommissionValue = '$value$symbol';
                          }

                          final multiLevelReferral = activeDeal.multiLevelReferral;
                          final level2CommissionPercentage = activeDeal.level2CommissionPercentage;
                          final showLevel2Commission = multiLevelReferral == "1" &&
                              level2CommissionPercentage != null &&
                              level2CommissionPercentage != "null" &&
                              level2CommissionPercentage.toString().trim().isNotEmpty;

                          final formattedLevel2Commission = showLevel2Commission
                              ? (() {
                                  final raw = level2CommissionPercentage.toString().trim();
                                  return raw.endsWith('%') ? raw : '$raw%';
                                })()
                              : '';

                          return Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Row(
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.all(8),
                                            decoration: BoxDecoration(
                                              color: AppColors.primary,
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                            child: Text(
                                              commissionType == "percentage_commission"
                                                  ? '%'
                                                  : commissionType == "fix_commission"
                                                      ? '€'
                                                      : '',
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                          commissionType == "no_commission"
                                              ? Flexible(
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                      Text(
                                                        tr(LanguageKeys.nocommisonText),
                                                        style: const TextStyle(
                                                          fontSize: 12,
                                                          color: Color(0xFF666666),
                                                          fontWeight: FontWeight.w500,
                                                          letterSpacing: 0.2,
                                                        ),
                                                      ),
                                                      const SizedBox(height: 12),
                                                      Text(
                                                        tr(LanguageKeys.noCommissionPriorityText),
                                                        textAlign: TextAlign.center,
                                                        style: const TextStyle(
                                                          fontSize: 13,
                                                          color: Color(0xFF2D2D2D),
                                                          fontWeight: FontWeight.w400,
                                                          letterSpacing: 0.2,
                                                          height: 1.4,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                )
                                              : Flexible(
                                                  child: Text(
                                                    tr(LanguageKeys.commissionRate),
                                                    style: const TextStyle(
                                                      fontSize: 16,
                                                      fontWeight: FontWeight.w600,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                ),
                                        ],
                                      ),
                                    ),
                                    // const Spacer(),
                                    const SizedBox(width: 10),
                                    Text(
                                      formattedCommissionValue,
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.primary,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  tr(LanguageKeys.forEveryReferralBecomeClient),
                                  style: stylePoppins(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: const Color(0xFF6B7280),
                                  ),
                                ),
                                if (showLevel2Commission) ...[
                                  Divider(
                                    color: const Color(0xFFDDD6FE).withOpacity(0.5),
                                    thickness: 1,
                                    height: 24,
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Row(
                                          children: [
                                            Container(
                                              padding: const EdgeInsets.all(8),
                                              decoration: BoxDecoration(
                                                color: AppColors.primary,
                                                borderRadius: BorderRadius.circular(8),
                                              ),
                                              child: const Text(
                                                '%',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 12),
                                            Flexible(
                                              child: Text(
                                                tr(LanguageKeys.multiLevelCommission),
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w600,
                                                  color: AppColors.grey700,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      // const Spacer(),
                                      const SizedBox(width: 10),
                                      Text(
                                        formattedLevel2Commission,
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700,
                                          color: AppColors.grey700,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    tr(LanguageKeys.onCommissionsFromBusinessContributorsYouAdded),
                                    style: stylePoppins(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: const Color(0xFF6B7280),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          );
                        },
                      ),

                      const SizedBox(height: 16),

                      // Service description
                      Obx(
                        () => widget.controller.dashboard.value?.data?.activeDeals?.isNotEmpty ?? false
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    tr(LanguageKeys.description),
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    widget.controller.dashboard.value?.data?.activeDeals?.first.createdDetail
                                            ?.companyDescription ??
                                        '',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: AppColors.grey600,
                                      height: 1.4,
                                    ),
                                  ),
                                ],
                              )
                            : const SizedBox.shrink(),
                      ),

                      // Documents section
                      Obx(
                        () => widget.controller.dashboard.value?.data?.activeDeals?.isEmpty ?? true
                            ? const SizedBox.shrink()
                            : Text(
                                tr(LanguageKeys.documentsAvailable),
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.primary,
                                ),
                              ),
                      ),
                      Obx(
                        () => widget.controller.dashboard.value?.data?.activeDeals?.isEmpty ?? true
                            ? const SizedBox.shrink()
                            : ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: widget.controller.documentList.value.length > 2
                                    ? 2
                                    : widget.controller.documentList.value.length,
                                itemBuilder: (context, index) {
                                  AppLog.d(
                                      'documentList: ${widget.controller.documentList.value[index].document}');
                                  return _buildDocumentRow(widget.controller.documentList.value[index]);
                                },
                              ),
                      ),
                      const SizedBox(height: 16),

                      // See all documents button
                      Obx(
                        () => widget.controller.dashboard.value?.data?.activeDeals?.isEmpty ?? true
                            ? const SizedBox.shrink()
                            : widget.controller.documentList.value.length > 2
                                ? GestureDetector(
                                    onTap: () {
                                      Get.toNamed(DocumentScreen.pageId, arguments: {
                                        'id': widget.controller.dashboard.value?.data?.activeDeals?.first.id
                                            .toString(),
                                        'type': 'active',
                                      });
                                    },
                                    child: Container(
                                      width: double.infinity,
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: AppColors.primary.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(color: AppColors.primary.withOpacity(0.1)),
                                      ),
                                      child: Row(
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                              color: AppColors.primary,
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                            padding: const EdgeInsets.all(8),
                                            child: SvgPicture.asset(
                                              AppAssets.imgFolderImage,
                                              height: 20,
                                              width: 20,
                                              colorFilter: ColorFilter.mode(
                                                AppColors.whiteColor,
                                                BlendMode.srcIn,
                                              ),
                                            ),
                                          ),
                                          const Spacer(),
                                          Text(
                                            tr(LanguageKeys.seeAllDocuments),
                                            style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                              color: AppColors.primary,
                                            ),
                                          ),
                                          const Spacer(),
                                          const Icon(
                                            Icons.arrow_forward_ios,
                                            color: AppColors.primary,
                                            size: 16,
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                : const SizedBox.shrink(),
                      ),

                      // const SizedBox(height: 20),

                      // Track Added Referrers
                      Obx(() {
                        if (widget.controller.dashboard.value?.data?.activeDeals?.isEmpty ?? true) {
                          return const SizedBox.shrink();
                        }
                        if (widget.controller.dashboard.value?.data?.activeDeals?.first.multiLevelReferral ==
                                null ||
                            widget.controller.dashboard.value?.data?.activeDeals?.first.multiLevelReferral ==
                                "0") {
                          return const SizedBox.shrink();
                        }
                        return _buildTrackAndAddSection(
                            widget.controller.dashboard.value?.data?.activeDeals?.first ?? ActiveDeals());
                      }),
                      // const SizedBox(height: 20),

                      // Send contact button (FinSpain style)
                      Obx(
                        () => widget.controller.dashboard.value?.data?.activeDeals?.isEmpty ?? true
                            ? const SizedBox.shrink()
                            : GestureDetector(
                                onTap: () {
                                  showModalBottomSheet(
                                    context: Get.context!,
                                    isScrollControlled: true,
                                    backgroundColor: Colors.transparent,
                                    builder: (context) {
                                      return SendLeadBottomSheet(
                                        dealId:
                                            (widget.controller.dashboard.value?.data?.activeDeals?.first.id ??
                                                    '')
                                                .toString(),
                                        companyName: widget.controller.dashboard.value?.data?.activeDeals
                                                ?.first.createdDetail?.companyName ??
                                            '',
                                        commissionValue: widget.controller.dashboard.value?.data?.activeDeals
                                                ?.first.commissionValue ??
                                            '',

                                        // Use sharingTempLink or deepLink if formUrl isn't provided in this list
                                        formUrl: widget.controller.dashboard.value?.data?.activeDeals?.first
                                            .contactFormUrl,
                                      );
                                    },
                                  );
                                  // Get.toNamed(LeadSubmissionScreen.pageId,
                                  //     arguments: {
                                  //       'lead_assign_type': "",
                                  //       'first': "",
                                  //       'last': "",
                                  //       'email': "",
                                  //       'phone': "",
                                  //       'id': widget
                                  //           .controller
                                  //           .dashboard
                                  //           .value
                                  //           ?.data
                                  //           ?.activeDeals
                                  //           ?.first
                                  //           .createdDetail!
                                  //           .id,
                                  //       'deal_id': widget.controller.dashboard.value
                                  //           ?.data?.activeDeals?.first.id,
                                  //       'deal_name': widget
                                  //           .controller
                                  //           .dashboard
                                  //           .value
                                  //           ?.data
                                  //           ?.activeDeals
                                  //           ?.first
                                  //           .dealName,
                                  //       'type': '',
                                  //     });
                                },
                                child: Container(
                                  width: double.infinity,
                                  height: 48,
                                  decoration: BoxDecoration(
                                    color: AppColors.primary,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Center(
                                    child: Text(
                                      tr(LanguageKeys.sendALead),
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                      ),
                    ],
                  ),
                  // 3 vertically aligned dots on the right side
                  Positioned(
                    top: -10,
                    right: -10,
                    child: PopupMenuButton<String>(
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
                          widget.controller.getDealLeave(
                              widget.controller.dashboard.value?.data?.activeDeals?.first.id.toString() ??
                                  '');
                        }
                      },
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          value: 'delete',
                          child: Row(
                            children: [
                              const Icon(Icons.delete_outline, size: 18, color: Colors.red),
                              const SizedBox(width: 8),
                              Text(tr(LanguageKeys.deleteIamReferrer),
                                  style: const TextStyle(color: Colors.red)),
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

  Widget _buildTrackAndAddSection(ActiveDeals e) {
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
                'dealId': e.id,
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
                'deal_id': e.id,
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

  Widget _buildDocumentRow(DealDocuments object) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.textFieldBorderColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.textFieldBorderColor),
      ),
      child: Row(
        children: [
          // PDF icon with different colors based on document type
          Container(
            height: 40,
            width: 40,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.pdfBg,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Text(
              'PDF',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              object.name?.replaceAll('-', ' ') ?? '',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
          ),
          // Copy/duplicate icon
          GestureDetector(
            onTap: () async {
              String? accessToken = AppPreference.readString(AppPreference.accessToken);
              var currentLocale = AppPreference.getLanguage();
              AppHelper.showLog("currentLocale: $currentLocale");

              var headers = {
                'Accept': 'application/json',
                'Authorization': 'Bearer $accessToken',
                'app-language': currentLocale,
              };
              widget.controller.openPdfBottomSheet(context, object.document ?? '', headers);
            },
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFFF3E8FF),
                borderRadius: BorderRadius.circular(8),
              ),
              height: 32,
              width: 32,
              alignment: Alignment.center,
              child: const Icon(
                Icons.remove_red_eye,
                color: AppColors.primary,
                size: 18,
              ),
            ),
          ),
          const SizedBox(width: 4),
          // Share icon
          //   GestureDetector(
          //     onTap: () {
          //       Get.dialog(
          //         SharePopup(
          //           title: object.name ?? '',
          //           link: object.document ?? '',
          //         ),
          //       );
          //     },
          //     child: Container(
          //       height: 32,
          //       width: 32,
          //       decoration: BoxDecoration(
          //         color: const Color(0xFFF3E8FF),
          //         borderRadius: BorderRadius.circular(8),
          //       ),
          //       alignment: Alignment.center,
          //       child: const Icon(
          //         Icons.share,
          //         color: AppColors.primary,
          //         size: 18,
          //       ),
          //     ),
          //   ),
        ],
      ),
    );
  }

  Widget _buildConnectionSection() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            tr(LanguageKeys.letGo),
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 16,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 15),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildLetsGoFurtherCard(
                  title: tr(LanguageKeys.modeProfessional),
                  subtitle: tr(LanguageKeys.receiveLeadsViaReferaly),
                  icon: Icons.person,
                  color: AppColors.primary,
                  onTap: () {
                    _showProfessionalDialog();
                  },
                ),
                const SizedBox(width: 12),
                _buildLetsGoFurtherCard(
                  title: tr(LanguageKeys.faqAndTuto),
                  subtitle: tr(LanguageKeys.learnToUseReferalyEfficiently),
                  icon: Icons.school,
                  color: Colors.red,
                  onTap: () {
                    Get.toNamed(ActivityCategoryScreen.pageId);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLetsGoFurtherCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 180,
        height: 180,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Stack(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        icon,
                        color: Colors.white,
                        size: 30,
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              left: 0,
              bottom: 0,
              child: Opacity(
                opacity: 0.6,
                child: SvgPicture.asset(
                  width: 40,
                  height: 40,
                  AppAssets.imgHalfCircleLeftDown,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Positioned(
              right: 0,
              top: 0,
              child: Opacity(
                opacity: 0.6,
                child: SvgPicture.asset(
                  width: 100,
                  height: 40,
                  AppAssets.imgHalfCircleRightTop,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showProfessionalDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          insetPadding: const EdgeInsets.symmetric(horizontal: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Container(
            width: MediaQuery.of(context).size.width * 0.9,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Obx(
                //   () => Text(
                //     tr(LanguageKeys
                //         .ifYouAreAProfessionalYouWillGainAccessToADifferentInterfaceNotOnlyToSendLeadsButAlsoToReceiveThemForYourOwnBusiness),
                //     textAlign: TextAlign.center,
                //     style:
                //         stylePoppins(fontSize: 16, color: AppColors.fontBlack),
                //   ),
                // ),
                // const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("⚠️", style: TextStyle(fontSize: 18)),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Obx(
                        () => Text(
                          tr(LanguageKeys.onlySwitchIfYouAreLookingToReceiveClientsThroughReferaly),
                          textAlign: TextAlign.center,
                          style: stylePoppins(fontSize: 15, color: AppColors.fontBlack),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Center(
                  child: SizedBox(
                    width: 120,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF8E2DE2),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () {
                        widget.controller.showIndividualHome();
                        Navigator.of(context).pop();
                      },
                      child: Obx(
                        () => Text(tr(LanguageKeys.okay), style: stylePoppins(color: AppColors.whiteColor)),
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
  }
}

class CmnAppBar extends StatelessWidget {
  CmnAppBar({
    super.key,
    required GlobalKey<ScaffoldState> scaffoldKey,
  }) : _scaffoldKey = scaffoldKey;

  final GlobalKey<ScaffoldState> _scaffoldKey;

  final ControllerMainProfessional controllerr = Get.find<ControllerMainProfessional>();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Row(
            children: [
              Obx(
                () => controllerr.profileImagePath.isNotEmpty
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(8.r),
                        child: SizedBox(
                          width: 50.w,
                          height: 50.w,
                          child: Image.network(
                            controllerr.profileImagePath.value,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => Image.asset(
                              AppAssets.imgDefaultPerson,
                              width: 50.w,
                              height: 50.w,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      )
                    : Container(
                        width: 50.w,
                        height: 50.w,
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Image.asset(
                          AppAssets.imgDefaultPerson,
                          width: 50.w,
                          height: 50.w,
                          fit: BoxFit.cover,
                        ),
                      ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${tr(LanguageKeys.hi)},",
                      style: TextStyle(
                        color: AppColors.whiteColor,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Obx(
                          () => Flexible(
                            child: Text(
                              "${controllerr.profile.value?.data?.firstName ?? ''} ${controllerr.profile.value?.data?.lastName ?? ''}",
                              style: TextStyle(
                                color: AppColors.whiteColor,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        // Text(
                        //   ",",
                        //   style: TextStyle(
                        //     color: AppColors.whiteColor,
                        //     fontSize: 18,
                        //     fontWeight: FontWeight.bold,
                        //   ),
                        // ),
                        // Expanded(
                        //   child: Obx(
                        //     () => Text(
                        //       '${controllerr.profile.value?.data?.firstName ?? ''} ${controllerr.profile.value?.data?.lastName ?? ''}',
                        //       style: TextStyle(
                        //         color: AppColors.whiteColor,
                        //         fontSize: 18,
                        //         fontWeight: FontWeight.bold,
                        //       ),
                        //     ),
                        //   ),
                        // ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {
            _scaffoldKey.currentState?.openDrawer();
          },
          child: Icon(
            Icons.menu,
            color: AppColors.whiteColor,
            size: 40,
          ),
        ),
      ],
    );
  }
}
