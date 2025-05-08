import 'package:get/get.dart';


class ControllerMainProfessional extends GetxController {
  RxInt pageIndex = 0.obs;

  void changeTab(int index) {
    pageIndex.value = index;
  }
}
