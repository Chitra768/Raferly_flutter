import 'package:get/get.dart';
import 'package:referaly/controller/complete_profile_controller.dart';

class BindingCompleteProfile extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => CompleteProfileController());
  }
}
