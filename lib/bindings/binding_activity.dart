import 'package:get/get.dart';
import 'package:referaly/controller/my_activity_controller.dart' show MyActivityController;



class BindingActivity implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MyActivityController>(() => MyActivityController());
  }
}
