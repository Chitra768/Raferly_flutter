import 'dart:async';

import 'package:get/get.dart';
import 'package:referaly/widgets/dialog/discover_referaly_finder_dialog.dart';

class ControllerMainProfessional extends GetxController {
  RxInt pageIndex = 0.obs;

  void changeTab(int index) {
    pageIndex.value = index;
  }

  @override
  void onInit() {
    super.onInit();
    Future.delayed(const Duration(seconds: 2), () {
      Get.dialog(
        DiscoverReferalyFinderDialog(
          onLetsGo: () {
            Get.back();
          },
        ),
      );
    });
  }
}
