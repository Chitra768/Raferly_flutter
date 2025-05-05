import 'dart:async';
import 'package:get/get.dart';
import 'package:referaly/get/screens.dart';


class ControllerMainProfessional extends GetxController {
  RxInt pageIndex = 2.obs;
  @override
  void onInit() {
    super.onInit();

  }

  void changeTab(int index) {
    pageIndex.value = index;
  }
}
