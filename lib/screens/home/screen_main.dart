import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:referaly/controller/track_lead.dart';
import 'package:referaly/resources/app_colors.dart';
import 'package:referaly/screens/dashboard/track_leads_screen.dart' show TrackLeadsScreen;
import 'package:referaly/screens/home/professional_home.dart';
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
          child: Obx(
            () {
              AppHelper.showLog("++++++++++PageCount: ${controllerr.pageIndex.value}");
              if (controllerr.pageIndex.value == 0) {
                return ProfessionalHome(
                  controller: controller,
                  trackLeadCntrl: trackLeadCntrl,
                );
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
      padding: EdgeInsets.fromLTRB(
          62, btmpadding != 0.0 ? btmpadding : 20, 62, btmpadding != 0.0 ? btmpadding : 20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
      ),
      child: Obx(() => Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              navItem(
                icon: Icons.home,
                label: 'Home',
                isSelected: controller.pageIndex.value == 0,
                onTap: () {
                  if (controller.pageIndex.value != 0) controller.changeTab(0);
                },
              ),
              navItem(
                icon: Icons.search,
                label: 'Track',
                isSelected: controller.pageIndex.value == 1,
                onTap: () {
                  if (controller.pageIndex.value != 1) {
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
    required IconData icon,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: isSelected ? AppColors.primary : Colors.grey),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: isSelected ? AppColors.primary : Colors.grey,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
