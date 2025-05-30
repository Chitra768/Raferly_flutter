import 'package:get/get.dart';
import 'package:referaly/controller/my_activity_info_controller.dart';

class BindingMyActivityInfo implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MyActivityInfoController>(() => MyActivityInfoController());
  }
}
