import 'package:get/get.dart';
import '../controller/onboarding_business_network_controller.dart';

class OnboardingBusinessNetworkBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OnboardingBusinessNetworkController>(
        () => OnboardingBusinessNetworkController());
  }
}
