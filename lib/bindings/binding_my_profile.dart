import 'package:get/get.dart';
import 'package:referaly/controller/profile_controller.dart';

class BindingMyProfile extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProfileController>(() => ProfileController());
  }
}
