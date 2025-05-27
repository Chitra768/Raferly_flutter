import 'package:get/get.dart';
import 'package:referaly/screens/activity/send_lead_info_screen.dart';

import '../apis/api_result.dart';
import '../apis/rest_auth.dart';
import '../models/model_how_it_works_list.dart';

class YourActivityController extends GetxController {
  void onActivityItemTap(int index) {
    if (index >= 0 && index < activityList.length) {
      final activity = activityList[index];
      Get.toNamed(SendLeadInfoScreen.pageId, arguments: {
        'activity': activity,
      })?.then((_) {
        // Refresh the list when returning from SendLeadInfoScreen
      });
    }
  }

  var isLoading = false.obs;
  var activityList = <HowItWorksList>[].obs;

  @override
  void onInit() {
    super.onInit();
    getActivity();
  }

  Future<void> getActivity() async {
    try {
      isLoading.value = true;

      final response = await RESTAuth.getHowItWorksList("activity", "");

      if (response is ApiSuccess<ModelHowItWorksList>) {
        if (response.data.status == true) {
          activityList.value = response.data.activity ?? [];
        }
      }
    } catch (e) {
      // Handle error appropriately
    } finally {
      isLoading.value = false;
    }
  }
}
