import 'package:get/get.dart';

class ArcheiveListController extends GetxController {
  RxBool isAssending = false.obs;

  void changeSorting() {
    isAssending.value = !isAssending.value;
  }
}
