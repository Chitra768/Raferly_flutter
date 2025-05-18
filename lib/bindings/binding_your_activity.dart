import 'package:get/get.dart';
import 'package:referaly/controller/your_activity_controller.dart';

class BindingYourActivity implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<YourActivityController>(() => YourActivityController());
  }
}
