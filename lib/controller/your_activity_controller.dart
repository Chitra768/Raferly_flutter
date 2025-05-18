import 'package:get/get.dart';
import 'package:referaly/screens/activity/send_lead_info_screen.dart';

class YourActivityController extends GetxController {
  void onActivityItemTap(int index) {
    // TODO: Implement navigation or logic for each activity item
    if (index == 0) {
      Get.toNamed(SendLeadInfoScreen.pageId);
    }
  }
}
