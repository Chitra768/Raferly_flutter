import 'package:get/get.dart';
import 'package:referaly/controller/complete_profile_onboarding_controller.dart';

class BindingCompleteProfileOnboarding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => CompleteProfileOnboardingController());
  }
}

