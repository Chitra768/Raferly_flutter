import 'package:get/get.dart';
import 'package:referaly/controller/my_profile_controller.dart';

class BindingMyProfile extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MyProfileController>(() => MyProfileController());
  }
}
