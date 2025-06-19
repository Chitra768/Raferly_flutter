import 'package:get/get.dart';
import 'package:referaly/controller/controller_main_professional.dart';
import 'package:referaly/resources/app_helper.dart';
import 'package:referaly/screens/home/screen_main.dart';
import 'package:referaly/screens/webview/webview_screen.dart';

import '../languages/languagekeys.dart';
import '../utils/translations.dart';

class OnboardingConsultationSuccessController extends GetxController {
  final ControllerMainProfessional controller = Get.find();
  void onBookConsultation() {
    // Handle tap for consulting call
    if (controller.isLoadingDashboard.value) {
      Get.snackbar(
        'Loading',
        'Please wait while we load the consultation URL...',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }
    final calendlyUrl = controller.dashboard.value?.data?.calendly_url;
    AppHelper.showLog('calendlyUrl: ' + calendlyUrl.toString());
    if (calendlyUrl == null || calendlyUrl.isEmpty) {
      Get.snackbar(
        'Error',
        'Consultation URL is not available. Please try again later.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }
    Get.toNamed(WebViewScreen.pageId, arguments: {
      'url': calendlyUrl.toString(),
      'title': tr(LanguageKeys.bookConsultation),
    })?.then((_) {
      // Navigate to main page when WebView is closed
      Get.offAllNamed(ScreenMain.pageId);
    });
  }
}
