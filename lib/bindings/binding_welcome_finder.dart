import 'package:get/get.dart';
import 'package:referaly/controller/profile_controller.dart';

class BindingWelcomeFinder extends Bindings {
  @override
  void dependencies() {
    // Register ProfileController if not already registered
    if (!Get.isRegistered<ProfileController>()) {
      Get.lazyPut<ProfileController>(() => ProfileController());
    }
  }
}
