import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:referaly/controller/track_lead.dart';
import 'package:referaly/languages/languagekeys.dart';
import 'package:referaly/resources/app_assets.dart';
import 'package:referaly/resources/app_colors.dart';
import 'package:referaly/screens/dashboard/track_leads_screen.dart'
    show TrackLeadsScreen;
import 'package:referaly/screens/home/professional_home.dart';
import 'package:referaly/screens/dashboard/home_without_primum.dart'
    show IndividualHome;
import 'package:referaly/utils/translations.dart';
import 'package:referaly/widgets/dialog/send_contact_dialog.dart';

import '../../controller/controller_main_professional.dart';
import '../../resources/app_helper.dart';

class ScreenMain extends GetView<ControllerMainProfessional> {
  ScreenMain({super.key});

  static String pageId = '/screenMain';
  final controllerr = Get.put(ControllerMainProfessional());
  final trackLeadCntrl = Get.put(TrackLeadsController());

  double btmpadding = 0.0;

  @override
  Widget build(BuildContext context) {
    btmpadding = MediaQuery.of(context).padding.bottom;
    return WillPopScope(
      onWillPop: () async {
        return exit(0);
      },
      child: Scaffold(
        backgroundColor: AppColors.whiteColor,
        body: SafeArea(
          top: false,
          child: Obx(
            () {
              AppHelper.showLog(
                  "++++++++++PageCount: ${controllerr.pageIndex.value}");
              if (controllerr.pageIndex.value == 0) {
                // Show loading indicator while profile is being fetched
                if (controllerr.profile.value == null) {
                  return Center(
                    child: SizedBox(
                      width: 24,
                      height: 24,
                      child: LoadingIndicator(
                        indicatorType: Indicator.lineSpinFadeLoader,
                        colors: [AppColors.primary],
                      ),
                    ),
                  );
                }
                // Check company type from profile data
                final companyType =
                    controllerr.profile.value?.data?.companyType?.toLowerCase();
                if (companyType == 'individual') {
                  return IndividualHome(
                      controller: controller, trackLeadCntrl: trackLeadCntrl);
                } else {
                  return ProfessionalHome(
                    controller: controller,
                    trackLeadCntrl: trackLeadCntrl,
                  );
                }
              } else if (controllerr.pageIndex.value == 1) {
                return TrackLeadsScreen(controller: trackLeadCntrl);
              } else {
                return Container();
              }
            },
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: flbtn(),
        bottomNavigationBar: customBottomSheet(context),
      ),
    );
  }

  GestureDetector flbtn() {
    return GestureDetector(
      onTap: () {
        print("Test");
        Get.dialog(SendContactDialog(
          onCreateReferral: () {},
        ));
      },
      child: Container(
        height: 64,
        width: 64,
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: const Icon(Icons.add, color: Colors.white, size: 32),
      ),
    );
  }

  Widget customBottomSheet(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(),
      padding: EdgeInsets.fromLTRB(20, btmpadding != 0.0 ? btmpadding : 20, 20,
          btmpadding != 0.0 ? btmpadding : 20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
      ),
      child: Obx(() => Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              navItem(
                svgAsset: AppAssets.imgBottomNavHome,
                label: tr(LanguageKeys.home),
                isSelected: controller.pageIndex.value == 0,
                onTap: () {
                  if (controller.pageIndex.value != 0) controller.changeTab(0);
                  controller.getProfile();
                },
              ),
              navItem(
                svgAsset: AppAssets.imgBottomNavSearch,
                label: tr(LanguageKeys.track),
                isSelected: controller.pageIndex.value == 1,
                onTap: () {
                  if (controller.profile.value?.data?.companyType ==
                      "individual") {
                    trackLeadCntrl.toggleLeadType(false);
                    controller.changeTab(1);
                  } else {
                    trackLeadCntrl.toggleLeadType(true);
                    controller.changeTab(1);
                  }
                },
              ),
            ],
          )),
    );
  }

  Widget navItem({
    required String svgAsset,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset(
            svgAsset,
            height: 25,
            colorFilter: ColorFilter.mode(
              isSelected ? AppColors.primary : Colors.grey,
              BlendMode.srcIn,
            ),
          ),
          const SizedBox(height: 4),
          SizedBox(
            width: 84.w,
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: isSelected ? AppColors.primary : Colors.grey,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                fontSize: 12.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
