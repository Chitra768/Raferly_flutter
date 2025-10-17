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
import 'package:referaly/screens/deals/invited_deals_screen.dart';
import 'package:referaly/screens/deals/out_of_referaly_dialog.dart';
import 'package:referaly/screens/home/professional_home.dart';
import 'package:referaly/screens/dashboard/home_without_primum.dart'
    show IndividualHome;
import 'package:referaly/utils/translations.dart';
import 'package:referaly/widgets/dialog/invite_contact_dialog.dart';
import 'package:referaly/widgets/dialog/send_contact_dialog.dart';
import 'package:referaly/widgets/logo_loader.dart';

import '../../controller/controller_main_professional.dart';
import '../../resources/app_helper.dart';
import '../../apis/rest_auth.dart';

class ScreenMain extends GetView<ControllerMainProfessional> {
  ScreenMain({super.key});

  static String pageId = '/screenMain';
  final controllerr = Get.find<ControllerMainProfessional>();

  TrackLeadsController get trackLeadCntrl {
    if (!Get.isRegistered<TrackLeadsController>()) {
      return Get.put(TrackLeadsController());
    }
    return Get.find<TrackLeadsController>();
  }

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
                  return const Center(
                    child: SizedBox(
                      width: 24,
                      height: 24,
                      child: LogoLoader(),
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
        Get.dialog(InviteContactDialog(
          onOutOfReferaly: () {
            Get.toNamed(OutOfReferalyScreen.pageId, arguments: {
              'title': tr(LanguageKeys.sendAContact),
            });
          },
          onDealList: () {
            Get.toNamed(InvitedDealsScreen.pageId);
          },
          onCreateDeal: () {
            Get.toNamed(OutOfReferalyScreen.pageId);
          },
        ));
      },
      child: Container(
        margin: const EdgeInsets.only(top: 30),
        height: 64,
        width: 64,
        decoration: BoxDecoration(
          color: AppColors.primary,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withOpacity(0.3),
              blurRadius: 12,
              spreadRadius: 2,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: const Icon(Icons.add, color: Colors.white, size: 32),
      ),
    );
  }

  Widget customBottomSheet(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(62),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            blurRadius: 14,
            offset: const Offset(2, 2),
          ),
        ],
      ),
      child: Obx(() => Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Home tab on the left
              navItem(
                svgAsset: AppAssets.imgBottomNavHome,
                label: tr(LanguageKeys.home),
                isSelected: controller.pageIndex.value == 0,
                onTap: () {
                  if (controller.pageIndex.value != 0) controller.changeTab(0);
                  controller.getProfile();
                },
              ),
              // Empty space in the center (for the floating action button)
              const SizedBox(width: 80),
              // Lead tab on the right
              navItem(
                svgAsset: AppAssets.imgBottomNavSearch,
                label: tr(LanguageKeys.track),
                isSelected: controller.pageIndex.value == 1,
                onTap: () async {
                  controller.getDashboard();
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

  Widget customBottomSheetOld(BuildContext context) {
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
                onTap: () async {
                  controller.getDashboard();
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
      child: Stack(
        children: [
          Column(
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
                    fontWeight:
                        isSelected ? FontWeight.bold : FontWeight.normal,
                    fontSize: 12.sp,
                  ),
                ),
              ),
            ],
          ),
          // Notification badge
          label == tr(LanguageKeys.track)
              ? Positioned(
                  right: 10,
                  top: 2,
                  child: Obx(() {
                    final trackingNotifications = controller
                            .dashboard
                            .value
                            ?.data
                            ?.allNotification
                            ?.trackingNotifications
                            ?.count ??
                        0;
                    if (trackingNotifications > 0) {
                      return Container(
                        constraints: const BoxConstraints(
                          minWidth: 10,
                          minHeight: 10,
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.red,
                            width: 1,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            trackingNotifications.toString(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      );
                    }
                    return const SizedBox.shrink();
                  }),
                )
              : const SizedBox.shrink(),
        ],
      ),
    );
  }
}
