import 'package:get/get.dart';
import '../controller/onboarding_consultation_success_controller.dart';

class OnboardingConsultationSuccessBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OnboardingConsultationSuccessController>(
        () => OnboardingConsultationSuccessController());
  }
}
