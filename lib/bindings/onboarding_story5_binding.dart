import 'package:get/get.dart';
import 'package:referaly/controller/onboarding_story5_controller.dart';

class OnboardingStory5Binding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OnboardingStory5Controller>(() => OnboardingStory5Controller());
  }
}
