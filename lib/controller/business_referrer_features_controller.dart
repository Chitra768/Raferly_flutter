import 'package:get/get.dart';

import '../apis/api_result.dart';
import '../apis/rest_auth.dart';
import '../models/model_how_it_works_list.dart';
import '../resources/app_helper.dart';
import '../screens/activity/send_lead_info_screen.dart';

class BusinessReferrerFeaturesController extends GetxController {
  void onFeatureTap(int index) {
    // TODO: Implement navigation or logic for each feature item
    // TODO: Implement navigation or logic for each activity item
    AppHelper.showLog("Activity: ${activityList[index].title}");
    Get.toNamed(SendLeadInfoScreen.pageId, arguments: {
      'activity': activityList[index],
    });
  }
  var isLoading = false.obs;
  var activityList = <HowItWorksList>[].obs;
  var type = "".obs;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    type.value = Get.arguments['type'];
    // You can initialize any data or state here if needed
    if(type.value == "business_refer"){
      getActivity();
    }else if(type.value == "tutorial_trainings"){
       getActivity();
    }
  

  }

  Future<void> getActivity() async {
    try {
      isLoading.value = true;
      // error.value = '';

      final response = await RESTAuth.getHowItWorksList(type.value, "");

      if (response is ApiSuccess<ModelHowItWorksList>) {
        if (response.data.status == true) {
          activityList.value = response.data.activity ?? [];
        } else {
          // error.value = response.data.message ?? 'Failed to get Leads';
        }
      } else if (response is ApiFailure) {
        // error.value = response.error.message ?? 'Something went wrong';
      }
    } catch (e) {
      // error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

}
