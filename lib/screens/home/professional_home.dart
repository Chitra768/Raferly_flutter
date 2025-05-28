import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:referaly/controller/controller_main_professional.dart';
import 'package:referaly/controller/my_activity_controller.dart';
import 'package:referaly/controller/track_lead.dart';
import 'package:referaly/languages/languagekeys.dart';
import 'package:referaly/resources/app_assets.dart';
import 'package:referaly/resources/app_colors.dart';
import 'package:referaly/resources/app_helper.dart';
import 'package:referaly/screens/activity/activity_category_screen.dart';
import 'package:referaly/screens/dashboard/home_without_primum.dart';
import 'package:referaly/screens/dashboard/my_activity_screen.dart';
import 'package:referaly/screens/deals/invited_deals_screen.dart';
import 'package:referaly/screens/onboarding/onboarding_story.dart';
import 'package:referaly/screens/webview/webview_screen.dart';
import 'package:referaly/utils/translations.dart';
import 'package:referaly/widgets/app_drawer.dart';

import '../story/screen_story.dart';

class ProfessionalHome extends StatefulWidget {
  final ControllerMainProfessional controller;
  final TrackLeadsController trackLeadCntrl;

  const ProfessionalHome(
      {super.key, required this.controller, required this.trackLeadCntrl});

  @override
  State<ProfessionalHome> createState() => _ProfessionalHomeState();
}

class _ProfessionalHomeState extends State<ProfessionalHome> {
  final myActivityCntrl = Get.put(MyActivityController());

  @override
  Widget build(BuildContext context) {
    final drawerKey = GlobalKey<ScaffoldState>();
    return Scaffold(
      drawer: const AppDrawer(),
      key: drawerKey,
      body: RefreshIndicator(
        onRefresh: () async {
          await widget.controller.getDashboard();
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              header(drawerKey),
              const SizedBox(
                height: 10,
              ),
              buildSectionTiles(),
              const SizedBox(
                height: 10,
              ),
              buildReferralBanner(),
              const SizedBox(
                height: 10,
              ),
              buildConnectedSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget card({
    required String label,
    required String imagePath,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 155,
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
                  imagePath,
                  height: 148,
                  width: 155,
                  fit: BoxFit.cover,
                )),
            const SizedBox(height: 8),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10),
              child: Text(
                label,
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

  Widget buildConnectedSection() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Align(
              alignment: Alignment.centerLeft,
              child: Text(tr(LanguageKeys.LetsGetYouConnected),
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                      color: AppColors.fontBlack))),
        ),
        const SizedBox(height: 12),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              card(
                label: tr(LanguageKeys.connectedcard),
                imagePath: AppAssets.imgFrame1,
                onTap: () {
                  Get.toNamed(StoryScreen.pageId);
                },
              ),
              card(
                label: tr(LanguageKeys.Consultingcallwithanexpert),
                imagePath: AppAssets.imgFrame2,
                onTap: () {
                  // Handle tap for consulting call
                  if (widget.controller.isLoadingDashboard.value) {
                    Get.snackbar(
                      'Loading',
                      'Please wait while we load the consultation URL...',
                      snackPosition: SnackPosition.BOTTOM,
                    );
                    return;
                  }
                  final calendlyUrl =
                      widget.controller.dashboard.value?.data?.calendly_url;
                  AppHelper.showLog('calendlyUrl: ' + calendlyUrl.toString());
                  if (calendlyUrl == null || calendlyUrl.isEmpty) {
                    Get.snackbar(
                      'Error',
                      'Consultation URL is not available. Please try again later.',
                      snackPosition: SnackPosition.BOTTOM,
                    );
                    return;
                  }
                  Get.toNamed(WebViewScreen.pageId, arguments: {
                    'url': calendlyUrl,
                  });
                },
              ),
              card(
                label: tr(LanguageKeys.Howitworks),
                imagePath: AppAssets.imgFrame3,
                onTap: () {
                  Get.toNamed(ActivityCategoryScreen.pageId);

                  // Handle tap for how it works
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: 30),
      ],
    );
  }

  Widget buildReferralBanner() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 30),
      child: Stack(
        children: [
          // SVG background
          Positioned.fill(
            child: FittedBox(
              fit: BoxFit.cover,
              child: SvgPicture.asset(
                AppAssets.imgHomeBg,
              ),
            ),
          ),
          // Foreground content
          SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        "Referaly  ",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w500),
                      ),
                      DecoratedBox(
                        decoration: BoxDecoration(
                            borderRadius: const BorderRadius.only(
                                topRight: Radius.circular(5.0),
                                bottomRight: Radius.circular(5.0),
                                topLeft: Radius.circular(5.0),
                                bottomLeft: Radius.circular(5.0)),
                            color: AppColors.whiteColor),
                        child: Text(
                          " Finder ",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: AppColors.fontBlue,
                              fontSize: 14,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                      Obx(
                        () => Text(
                          ' ' + tr(LanguageKeys.matchyourleadswith),
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    tr(LanguageKeys.trustedprofessionals),
                    textAlign: TextAlign.start,
                    style: const TextStyle(color: Colors.white, fontSize: 14),
                  ),
                  const SizedBox(height: 20),
                  GestureDetector(
                    onTap: () {
                      Get.toNamed(OnboardingPager.pageId);
                    },
                    child: SizedBox(
                      width: 280,
                      height: 30,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                            borderRadius: const BorderRadius.only(
                                topRight: Radius.circular(5.0),
                                bottomRight: Radius.circular(5.0),
                                topLeft: Radius.circular(5.0),
                                bottomLeft: Radius.circular(5.0)),
                            color: AppColors.whiteColor),
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Center(
                            child: Text(
                              tr(LanguageKeys.FindReferalers),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: AppColors.fontBlue,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildSectionTiles() {
    return Row(
      children: [
        Obx(
          () => tile(
              tr(LanguageKeys.myDeal),
              widget.controller.dashboard.value?.data?.myDeals?.toString() ??
                  '0',
              AppAssets.imgHomeVector,
              AppAssets.imgHomeCrown, () {
            myActivityCntrl.toggleTabSelection(true);
            myActivityCntrl.updateInit();
            Get.toNamed(MyActivityScreen.pageId);
          }),
        ),
        Obx(
          () => tile(
              tr(LanguageKeys.invitedDealsHomePage),
              widget.controller.dashboard.value?.data?.invitedDealsCount
                      ?.toString() ??
                  '0',
              AppAssets.imgHomeVector2,
              "", () {
            myActivityCntrl.toggleTabSelection(false);
            Get.toNamed(InvitedDealsScreen.pageId);
          }),
        ),
      ],
    );
  }

  Widget tile(String title, String? value, String? icon1, String? icon,
      VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 159,
          margin: const EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(
            // gradient: const LinearGradient(
            //   colors: [AppColors.gradientStart, AppColors.gradientEnd],
            //   begin: Alignment.centerLeft,
            //   end: Alignment.centerRight,
            // ),
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
                      width: 105,
                      height: 60,
                      child: Text(
                        title,
                        textAlign: TextAlign.start,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Stack(
                      children: [
                        SvgPicture.asset(icon!, height: 20, width: 20),
                        if (title == tr(LanguageKeys.invitedDealsHomePage))
                          Positioned(
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
                                border: Border.all(color: Colors.red, width: 1),
                              ),
                              child: Center(
                                child: Text(
                                  widget.controller.dashboard.value?.data
                                          ?.notificationsCount
                                          ?.toString() ??
                                      '0',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
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
                  SvgPicture.asset(icon1!, height: 78, width: 92),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Container header(GlobalKey<ScaffoldState> drawerKey) {
    return Container(
      padding:
          const EdgeInsets.fromLTRB(16, 20 + (kToolbarHeight - 15), 16, 24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.gradientStart, AppColors.gradientEnd],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        // color: AppColors.primary,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(32)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CmnAppBar(scaffoldKey: drawerKey),
          const SizedBox(height: 20),
          GridView.count(
            crossAxisCount: 2,
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            mainAxisSpacing: 12,
            crossAxisSpacing: 8,
            childAspectRatio: 1.6,
            // try 0.7, 0.75, 0.8 depending on content height
            padding: EdgeInsets.zero,
            children: [
              Obx(
                () => statCard(
                  tr(LanguageKeys.leadRecieved),
                  widget.controller.dashboard.value?.data?.totalReceivedLeads
                          ?.toString() ??
                      '0',
                  AppAssets.imgHomeLead,
                  AppAssets.imgHomeCrown,
                  () {
                    widget.trackLeadCntrl.toggleLeadType(true);
                    widget.controller.changeTab(1);
                  },
                ),
              ),
              Obx(
                () => statCard(
                  tr(LanguageKeys.leadSent),
                  widget.controller.dashboard.value?.data?.totalLeads
                          ?.toString() ??
                      '0',
                  AppAssets.imgHomeSent,
                  "",
                  () {
                    widget.trackLeadCntrl.toggleLeadType(false);
                    widget.controller.changeTab(1);
                  },
                ),
              ),
              Obx(
                () => statCard(
                  tr(LanguageKeys.numberOfPartners),
                  widget.controller.dashboard.value?.data?.numberOfPartner
                          ?.toString() ??
                      '0',
                  AppAssets.imgHomePartner,
                  AppAssets.imgHomeCrown,
                  () {
                    myActivityCntrl.toggleTabSelection(false);
                    Get.toNamed(MyActivityScreen.pageId);
                  },
                ),
              ),
              Obx(
                () => statCard(
                  tr(LanguageKeys.commissionReceived),
                  widget.controller.formatCompact(int.parse(widget
                          .controller.dashboard.value?.data?.incomeGenerated
                          ?.toString() ??
                      '0')),
                  AppAssets.imgHomeReceived,
                  "",
                  () {
                    Get.toNamed(MyActivityScreen.pageId);
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget statCard(String label, String value, String icon, String icon1,
      VoidCallback onTap) {
    AppHelper.showLog("value: $value");
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    label,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                SvgPicture.asset(icon1, height: 20, width: 20),
              ],
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text(
                    value,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 22,
                      color: AppColors.primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                SvgPicture.asset(icon, height: 36, width: 36),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
