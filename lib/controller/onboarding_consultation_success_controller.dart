import 'package:get/get.dart';
import 'package:referaly/screens/home/screen_main.dart';

class OnboardingConsultationSuccessController extends GetxController {
  void onBookConsultation() {
    // TODO: Implement navigation or logic for booking consultation
    // Example: Get.toNamed('/consultation_booking');
    Get.offAndToNamed(ScreenMain.pageId);
  }
}
