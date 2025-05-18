import 'package:get/get.dart';
import 'package:referaly/controller/activity_category_controller.dart';

class BindingActivityCategory implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ActivityCategoryController>(() => ActivityCategoryController());
  }
}
