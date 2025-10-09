import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:referaly/controller/controller_main_professional.dart';
import 'package:referaly/controller/my_activity_controller.dart';
import 'package:referaly/controller/track_lead.dart';
import 'package:referaly/languages/languagekeys.dart';
import 'package:referaly/resources/app_assets.dart';
import 'package:referaly/resources/app_colors.dart';
import 'package:referaly/resources/app_helper.dart';
import 'package:referaly/resources/app_preference.dart';
import 'package:referaly/screens/activity/activity_category_screen.dart';
import 'package:referaly/screens/archeive/archeive_list.dart';

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
              const SizedBox(height: 20),
              buildActionCards(),
              const SizedBox(height: 20),
              buildReferralBanner(),
              const SizedBox(height: 20),
              buildLetsGoFurtherSection(),
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

  Widget buildActionCards() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                myActivityCntrl.toggleTabSelection(true);
                myActivityCntrl.updateInit();
                Get.toNamed(MyActivityScreen.pageId)?.then((value) {
                  widget.controller.getDashboard();
                });
              },
              child: Container(
                height: 160,
                width: 160,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Stack(
                  children: [
                    // Background graphics using original SVG
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: Opacity(
                        opacity: 0.9,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 150.0),
                          child: Transform.rotate(
                            angle: -30 *
                                (3.14159 /
                                    180), // -30 degrees in radians (left rotation)
                            child: SvgPicture.asset(
                              AppAssets.imgActivity1,
                              height: 110,
                              width: 140,
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  tr(LanguageKeys.myDeal),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ),
                            if (AppPreference.readString(
                                    AppPreference.isPaid) ==
                                "0")
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: SvgPicture.asset(
                                    AppAssets.imgHDashboardCrown,
                                    height: 20,
                                    width: 20),
                              ),
                          ],
                        ),
                        const Spacer(),
                        const Align(
                          alignment: Alignment.centerRight,
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Icon(
                              Icons.arrow_forward,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: GestureDetector(
              onTap: () {
                Get.toNamed(InvitedDealsScreen.pageId)?.then((value) {
                  widget.controller.getDashboard();
                });
              },
              child: Container(
                height: 160,
                width: 160,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Stack(
                  children: [
                    // Background graphics using original SVG
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: Opacity(
                        opacity: 0.8,
                        child: Transform.rotate(
                          angle: 25 *
                              (3.14159 /
                                  180), // -30 degrees in radians (left rotation)
                          child: SvgPicture.asset(
                            AppAssets.imgActivity2,
                            height: 90,
                            width: 90,
                          ),
                        ),
                      ),
                    ),
                    Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  tr(LanguageKeys.invitedDealsHomePage),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ),
                            Obx(() => widget
                                        .controller.isLoadingDashboard.value ||
                                    widget
                                            .controller
                                            .dashboard
                                            .value
                                            ?.data
                                            ?.allNotification
                                            ?.referrerNotifications
                                            ?.count ==
                                        0
                                ? const SizedBox.shrink()
                                : Container(
                                    constraints: const BoxConstraints(
                                      minWidth: 20,
                                      minHeight: 20,
                                    ),
                                    margin:
                                        const EdgeInsets.only(right: 8, top: 8),
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
                                        widget
                                                .controller
                                                .dashboard
                                                .value
                                                ?.data
                                                ?.allNotification
                                                ?.referrerNotifications
                                                ?.count
                                                .toString() ??
                                            '0',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  )),
                          ],
                        ),
                        const Spacer(),
                        const Align(
                          alignment: Alignment.centerRight,
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Icon(
                              Icons.arrow_forward,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
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

  Widget buildLetsGoFurtherSection() {
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
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  onTap: () {
                    Get.toNamed(StoryScreen.pageId);
                  },
                  child: Container(
                    width: 180,
                    height: 180,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
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
                                  SvgPicture.asset(
                                    AppAssets.imgBottomimage1,
                                    width: 30,
                                    height: 30,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Text(
                                tr(LanguageKeys.connectedcard),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                tr(LanguageKeys.ConnectedCardDescription),
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
                ),
                const SizedBox(width: 12),
                GestureDetector(
                  onTap: () {
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
                      'title': tr(LanguageKeys.setupCard),
                    });
                  },
                  child: Container(
                    width: 180,
                    height: 180,
                    decoration: BoxDecoration(
                      color: Colors.blue,
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
                                  SvgPicture.asset(
                                    AppAssets.imgBottomimage2,
                                    width: 30,
                                    height: 30,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Text(
                                tr(LanguageKeys.Consultingcallwithanexpert),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                tr(LanguageKeys
                                    .ConsultingcallwithanexpertDescription),
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
                ),
                const SizedBox(width: 12),
                GestureDetector(
                  onTap: () {
                    Get.toNamed(ActivityCategoryScreen.pageId);
                    // Handle tap for third card
                  },
                  child: Container(
                    width: 180,
                    height: 180,
                    decoration: BoxDecoration(
                      color: AppColors.Darkorange,
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
                                  SvgPicture.asset(
                                    AppAssets.imgBottomimage3,
                                    width: 30,
                                    height: 30,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Text(
                                tr(LanguageKeys.Howitworks),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Obx(
                                () => Text(
                                  tr(LanguageKeys.HowitworksDescription),
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.8),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 4),
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
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 30),
      ],
    );
  }

  Widget buildReferralBanner() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Stack(
        children: [
          // Background graphics using original SVG

          Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Wrap(
                  alignment: WrapAlignment.center,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 4,
                  runSpacing: 4,
                  children: [
                    const Text(
                      "Referaly",
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w500),
                    ),
                    GestureDetector(
                      onTap: () {
                        Get.toNamed(OnboardingPager.pageId);
                      },
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                            borderRadius: const BorderRadius.only(
                                topRight: Radius.circular(5.0),
                                bottomRight: Radius.circular(5.0),
                                topLeft: Radius.circular(5.0),
                                bottomLeft: Radius.circular(5.0)),
                            color: AppColors.whiteColor),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 5),
                          child: Text(
                            "Finder",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: AppColors.fontBlue,
                                fontSize: 17,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                      ),
                    ),
                    Obx(
                      () => Text(
                        tr(LanguageKeys.matchyourleadswith1),
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                // Text(
                //   tr(LanguageKeys.trustedprofessionals),
                //   textAlign: TextAlign.center,
                //   style: const TextStyle(color: Colors.white, fontSize: 13),
                // ),
                // const SizedBox(height: 20),
                GestureDetector(
                  onTap: () {
                    Get.toNamed(OnboardingPager.pageId);
                  },
                  child: Container(
                    width: double.infinity,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Center(
                      child: Text(
                        tr(LanguageKeys.FindReferalers),
                        style: const TextStyle(
                          color: AppColors.primary,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            left: 0,
            top: 0,
            child: Opacity(
              opacity: 0.6,
              child: SvgPicture.asset(
                width: 100,
                height: 40,
                AppAssets.imgHalfCircle,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            right: 0,
            bottom: 0,
            child: Opacity(
              opacity: 0.6,
              child: SvgPicture.asset(
                width: 100,
                height: 40,
                AppAssets.imgHalfCircleDown,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Container header(GlobalKey<ScaffoldState> drawerKey) {
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
            padding: const EdgeInsets.fromLTRB(
                16, 20 + (kToolbarHeight - 15), 16, 0),
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
                                        widget
                                            .controller.profileImagePath.value,
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (context, error, stackTrace) =>
                                                Image.asset(
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
                            (widget.controller.profile.value?.data?.firstName ??
                                    '') +
                                " " +
                                (widget.controller.profile.value?.data
                                        ?.lastName ??
                                    ''),
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
                      onTap: () => drawerKey.currentState?.openDrawer(),
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
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            tr(LanguageKeys.dashboard),
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
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
                        mainAxisSpacing: 8,
                        crossAxisSpacing: 12,
                        childAspectRatio: 1.3,
                        children: [
                          Obx(
                            () => dashboardStatCardWithGradient(
                                tr(LanguageKeys.leadRecieved),
                                widget.controller.dashboard.value?.data
                                        ?.totalReceivedLeads
                                        ?.toString() ??
                                    '0',
                                const Color(0xFFECFDF5), // ECFDF5
                                const Color(0xFFD1FAE5), // D1FAE5
                                const Color(0xFFA7F3D0), // A7F3D0 stroke
                                const Color(0xFF065F46), // 065F46 label
                                const Color(0xFF059669), // 059669 value
                                AppAssets.imgHomeLead,
                                AppPreference.readString(
                                            AppPreference.isPaid) ==
                                        "0"
                                    ? AppAssets.imgHDashboardCrown
                                    : "", () {
                              widget.trackLeadCntrl.toggleLeadType(true);
                              widget.controller.changeTab(1);
                            }),
                          ),
                          Obx(
                            () => dashboardStatCardWithGradient(
                              tr(LanguageKeys.leadSent),
                              widget.controller.dashboard.value?.data
                                      ?.totalLeads
                                      ?.toString() ??
                                  '0',
                              const Color(0xFFEFF6FF), // ECFDF5
                              const Color(0xFFDBEAFE), // D1FAE5
                              const Color(0xFFBFDBFE), // A7F3D0 stroke
                              const Color(0xFF1E40AF), // 065F46 label
                              const Color(0xFF2563EB), // 059669 value
                              AppAssets.imgHomeSent,
                              "",
                              () {
                                widget.trackLeadCntrl.toggleLeadType(false);
                                widget.controller.changeTab(1);
                              },
                            ),
                          ),
                          Obx(
                            () => dashboardStatCardWithGradient(
                              tr(LanguageKeys.numberOfPartners),
                              widget.controller.dashboard.value?.data
                                      ?.numberOfPartner
                                      ?.toString() ??
                                  '0',
                              const Color(0xFFFAF5FF), // ECFDF5
                              const Color(0xFFF3E8FF), // D1FAE5
                              const Color(0xFFE9D5FF), // A7F3D0 stroke
                              const Color(0xFF6B21A8), // 065F46 label
                              const Color(0xFF9333EA), // 059669 value
                              AppAssets.imgHomePartner,
                              AppPreference.readString(AppPreference.isPaid) ==
                                      "0"
                                  ? AppAssets.imgHDashboardCrown
                                  : "",
                              () {
                                myActivityCntrl.initialPage = 1;
                                myActivityCntrl.toggleTabSelection(false);
                                myActivityCntrl.updateInit();
                                Get.toNamed(MyActivityScreen.pageId,
                                        arguments: {'initialPage': 1})
                                    ?.then((value) {
                                  widget.controller.getDashboard();
                                });
                              },
                            ),
                          ),
                          Obx(
                            () => dashboardStatCardWithGradient(
                              tr(LanguageKeys.commissionReceived),
                              widget.controller.formatEuroCompactPrecise(
                                  int.parse(widget.controller.dashboard.value
                                          ?.data?.incomeGenerated
                                          ?.toString() ??
                                      '0')),
                              const Color(0xFFFFFBEB), // ECFDF5
                              const Color(0xFFFEF3C7), // D1FAE5
                              const Color(0xFFFDE68A), // A7F3D0 stroke
                              const Color(0xFF92400E), // 065F46 label
                              const Color(0xFFD97706), // 059669 value
                              AppAssets.imgHomeReceived,
                              "",
                              () {
                                Get.toNamed(ArchiveList.pageId,
                                    arguments: {"type": "send"});
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
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

  Widget dashboardStatCardWithGradient(
      String label,
      String value,
      Color gradientStart,
      Color gradientEnd,
      Color strokeColor,
      Color labelColor,
      Color valueColor,
      String icon,
      String icon1,
      VoidCallback onTap) {
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
                SvgPicture.asset(icon1, height: 20, width: 20),
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
                SvgPicture.asset(icon, height: 36, width: 36),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget dashboardStatCard(String label, String value, Color backgroundColor,
      String icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: backgroundColor.withOpacity(0.2),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 16.sp,
                color: backgroundColor,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              value,
              style: TextStyle(
                fontSize: 20,
                color: backgroundColor,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
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
                    style: const TextStyle(
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
