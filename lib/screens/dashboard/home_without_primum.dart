import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart' show Get;
import 'package:http/http.dart' as http;
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:referaly/controller/controller_main_professional.dart'
    show ControllerMainProfessional;
import 'package:referaly/controller/track_lead.dart';
import 'package:referaly/languages/languagekeys.dart';
import 'package:referaly/models/model_dashboard.dart';
import 'package:referaly/resources/app_helper.dart';
import 'package:referaly/resources/text_style.dart';
import 'package:referaly/screens/activity/activity_category_screen.dart';
import 'package:referaly/screens/archeive/archeive_list.dart';
import 'package:referaly/screens/dashboard/my_activity_screen.dart';
import 'package:referaly/screens/deals/invited_deals_screen.dart';
import 'package:referaly/utils/translations.dart';
import 'package:referaly/widgets/share_popup.dart';

import '../../resources/app_assets.dart';
import '../../resources/app_colors.dart';
import '../../widgets/app_drawer.dart';

class IndividualHome extends StatefulWidget {
  static String pageId = "/homeWithoutPrimum";
  final ControllerMainProfessional controller;
  final TrackLeadsController trackLeadCntrl;
  const IndividualHome(
      {super.key, required this.controller, required this.trackLeadCntrl});

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
          await controller.getProfile();
          await controller.getDashboard();
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              _buildCompanyOverview(),
              _buildConnectionSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 60, 20, 20),
      decoration: const BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.gradientStart, AppColors.gradientEnd],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          CmnAppBar(scaffoldKey: _scaffoldKey),
          _buildAnalyticsCards(),
        ],
      ),
    );
  }

  Widget _buildAnalyticsCards() {
    return Padding(
      padding: const EdgeInsets.only(top: 25),
      child: Row(
        children: [
          Expanded(
            child: _buildAnalyticsCard(
              title: tr(LanguageKeys.leadSent),
              value: widget.controller.dashboard.value?.data?.totalLeads
                      ?.toString() ??
                  '0',
              iconPath: AppAssets.imgHomeSent,
              onTap: () {
                widget.trackLeadCntrl.toggleLeadType(false);
                widget.controller.changeTab(1);
              },
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: _buildAnalyticsCard(
              title: tr(LanguageKeys.commissionReceived),
              value: widget.controller.formatCompact(int.parse(widget
                      .controller.dashboard.value?.data?.incomeGenerated
                      ?.toString() ??
                  '0')),
              iconPath: AppAssets.imgHomeReceived,
              onTap: () {
                Get.toNamed(ArchiveList.pageId, arguments: {"type": "send"});
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget tile(String title, String? value, String? icon1, String? icon,
      VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 159,
          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
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
                        if (icon != null && icon.isNotEmpty)
                          SvgPicture.asset(icon, height: 20, width: 20),
                        if (title == tr(LanguageKeys.invitedDealsHomePage))
                          Positioned(
                            child: Obx(() =>
                                widget.controller.isLoadingDashboard.value ||
                                        widget.controller.dashboard.value?.data
                                                ?.notificationsCount ==
                                            "0"
                                    ? const SizedBox.shrink()
                                    : Container(
                                        constraints: const BoxConstraints(
                                          minWidth: 20,
                                          minHeight: 20,
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 6, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: Colors.red,
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                              color: Colors.red, width: 1),
                                        ),
                                        child: Center(
                                          child: Text(
                                            widget.controller.dashboard.value
                                                    ?.data?.notificationsCount
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
                  if (icon1 != null && icon1.isNotEmpty)
                    SvgPicture.asset(icon1, height: 78, width: 92),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAnalyticsCard(
      {required String title,
      required String value,
      required String iconPath,
      required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 120,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 110,
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  value,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 22,
                    color: AppColors.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(width: 8),
                SvgPicture.asset(iconPath, height: 36, width: 36),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCompanyOverview() {
    return Obx(
      () => widget.controller.documentList.value.length > 1
          ? Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Obx(
                  () => tile(
                      tr(LanguageKeys.invitedDealsHomePage),
                      widget.controller.dashboard.value?.data?.invitedDealsCount
                              ?.toString() ??
                          '0',
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
              padding: const EdgeInsets.all(16),
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.whiteColor,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.5),
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Obx(
                    () => widget.controller.dashboard.value?.data?.activeDeals
                                ?.isNotEmpty ??
                            false
                        ? const SizedBox.shrink()
                        : SvgPicture.asset(
                            AppAssets.imgAppLgo,
                            height: 30.h,
                            width: 30.w,
                          ),
                  ),
                  Obx(
                    () => widget
                                .controller
                                .dashboard
                                .value
                                ?.data
                                ?.activeDeals
                                ?.isNotEmpty ??
                            false
                        ? Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Obx(() {
                                final companyLogoUrl = widget
                                    .controller
                                    .dashboard
                                    .value
                                    ?.data
                                    ?.activeDeals
                                    ?.first
                                    .createdDetail
                                    ?.companyLogoUrl;
                                AppHelper.showLog(
                                    "companyLogoUrl: $companyLogoUrl");
                                return companyLogoUrl?.isNotEmpty == true
                                    ? Container(
                                        height: 60,
                                        width: 60,
                                        decoration: BoxDecoration(
                                          color: AppColors.whiteColor,
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        child: Image.network(
                                          widget
                                                  .controller
                                                  .dashboard
                                                  .value
                                                  ?.data
                                                  ?.activeDeals
                                                  ?.first
                                                  .createdDetail
                                                  ?.companyLogoUrl ??
                                              '',
                                          width: 42,
                                          height: 42,
                                          fit: BoxFit.cover,
                                        ),
                                      )
                                    : const SizedBox.shrink();
                              }),
                              const SizedBox(width: 15),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      widget
                                              .controller
                                              .dashboard
                                              .value
                                              ?.data
                                              ?.activeDeals
                                              ?.first
                                              .createdDetail
                                              ?.companyName ??
                                          '',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      widget
                                              .controller
                                              .dashboard
                                              .value
                                              ?.data
                                              ?.activeDeals
                                              ?.first
                                              .createdDetail
                                              ?.companyNumber ??
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
                          )
                        : const SizedBox(height: 10),
                  ),
                  Obx(
                    () => widget
                                .controller
                                .dashboard
                                .value
                                ?.data
                                ?.activeDeals
                                ?.isNotEmpty ??
                            false
                        ? Padding(
                            padding: const EdgeInsets.fromLTRB(5, 15, 0, 10),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                widget
                                        .controller
                                        .dashboard
                                        .value
                                        ?.data
                                        ?.activeDeals
                                        ?.first
                                        .createdDetail
                                        ?.companyDescription ??
                                    '',
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: AppColors.k6B7280,
                                ),
                              ),
                            ),
                          )
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                tr(LanguageKeys
                                    .youAreNotCurrentlyPartOfAnyBusinessReferralProgram),
                                textAlign: TextAlign.center,
                                style: stylePoppins(
                                  fontSize: 14,
                                  color: AppColors.blackColor,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                tr(LanguageKeys
                                    .askYourProfessionalToInviteYouUsingTheirLinkOrQRCode),
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: AppColors.textTitleHint,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                  ),
                  const SizedBox(height: 15),
                  widget.controller.documentList.value.isNotEmpty
                      ? _buildSendLeadButton()
                      : const SizedBox(),
                ],
              ),
            ),
    );
  }

  Widget _buildDocumentRow(DealDocuments object) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
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
          const SizedBox(width: 15),
          Expanded(
            child: Text(
              object.name ?? '',
              style: const TextStyle(
                fontSize: 14,
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              AppHelper.showLog('object.url ?? ${object.document}');
              downloadAndOpenPdf(object.document ?? '');
            },
            child: Container(
                height: 40,
                width: 40,
                margin: const EdgeInsets.only(right: 10),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: SvgPicture.asset(
                  AppAssets.imgDocIcon,
                  height: 20,
                  width: 20,
                )),
          ),
          GestureDetector(
            onTap: () {
              Get.dialog(
                SharePopup(
                  title: object.name ?? '',
                  link: object.document ?? '',
                ),
              );
            },
            child: Container(
                height: 40,
                width: 40,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: SvgPicture.asset(
                  AppAssets.imgShareIcon,
                  height: 20,
                  width: 20,
                )),
          ),
        ],
      ),
    );
  }

  Widget _buildSendLeadButton() {
    return SizedBox(
      width: double.infinity,
      height: 40,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          padding: const EdgeInsets.symmetric(vertical: 5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        onPressed: () {
          widget.trackLeadCntrl.toggleLeadType(false);
          widget.controller.changeTab(1);
        },
        child: Obx(
          () => Text(
            tr(LanguageKeys.sendLead),
            style: stylePoppins(
              color: AppColors.whiteColor,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildConnectionSection() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(tr(LanguageKeys.LetsGetYouConnected),
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                  color: AppColors.fontBlack)),
          const SizedBox(height: 15),
          Row(
            children: [
              Expanded(
                child: _buildConnectionCard(
                  title: tr(LanguageKeys.areYouAProfessional),
                  icon: AppAssets.imgProfessionalIcon,
                  onTap: () {
                    // if (widget.controller.documentList.value.isEmpty) {
                    //   _showProfessionalDialog2();
                    // } else if (widget.controller.profile.value?.data?.isPaid ==
                    //     0) {
                    //   _showProfessionalDialog2();
                    // } else {
                    _showProfessionalDialog();
                    // }
                  },
                ),
              ),
              Expanded(
                child: _buildConnectionCard(
                  title: tr(LanguageKeys.Howitworks),
                  icon: AppAssets.imgHowItWorksIcon,
                  onTap: () {
                    Get.toNamed(ActivityCategoryScreen.pageId);
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildConnectionCard(
      {required String title,
      required String icon,
      required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 178,
        height: 235,
        margin: const EdgeInsets.symmetric(horizontal: 5),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            ClipRRect(
                borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(8), topLeft: Radius.circular(8)),
                child: Image.asset(
                  icon,
                  height: 148,
                  width: 178,
                  fit: BoxFit.cover,
                )),
            const SizedBox(height: 8),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10),
              child: Text(
                title,
                textAlign: TextAlign.center,
                style:
                    const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
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
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
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
                Obx(
                  () => Text(
                    tr(LanguageKeys
                        .ifYouAreAProfessionalYouWillGainAccessToADifferentInterfaceNotOnlyToSendLeadsButAlsoToReceiveThemForYourOwnBusiness),
                    textAlign: TextAlign.center,
                    style:
                        stylePoppins(fontSize: 16, color: AppColors.fontBlack),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("⚠️", style: TextStyle(fontSize: 18)),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Obx(
                        () => Text(
                          tr(LanguageKeys
                              .onlySwitchIfYouAreLookingToReceiveClientsThroughReferaly),
                          textAlign: TextAlign.center,
                          style: stylePoppins(
                              fontSize: 15, color: AppColors.fontBlack),
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
                        () => Text(tr(LanguageKeys.okay),
                            style: stylePoppins(color: AppColors.whiteColor)),
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

  void _showProfessionalDialog2() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          insetPadding: const EdgeInsets.symmetric(horizontal: 16),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
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
                Obx(
                  () => Text(
                    tr(LanguageKeys.individualTitle),
                    textAlign: TextAlign.center,
                    style:
                        stylePoppins(fontSize: 16, color: AppColors.fontBlack),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Obx(
                        () => Text(
                          tr(LanguageKeys.individualDescription1),
                          textAlign: TextAlign.center,
                          style: stylePoppins(
                              fontSize: 15, color: AppColors.fontBlack),
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
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Obx(
                        () => Text(tr(LanguageKeys.okay),
                            style: stylePoppins(color: AppColors.whiteColor)),
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

  final ControllerMainProfessional controllerr =
      Get.find<ControllerMainProfessional>();

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
                            errorBuilder: (context, error, stackTrace) =>
                                Image.asset(
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
