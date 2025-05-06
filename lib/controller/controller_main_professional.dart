import 'dart:async';
import 'package:get/get.dart';
import 'package:referaly/get/screens.dart';


class ControllerMainProfessional extends GetxController {
  RxInt pageIndex = 0.obs;

  void changeTab(int index) {
    pageIndex.value = index;
  }
}
