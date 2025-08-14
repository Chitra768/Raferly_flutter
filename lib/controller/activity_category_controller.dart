import 'package:get/get.dart';
import 'package:referaly/screens/activity/business_referrer_features_screen.dart';

import 'package:referaly/screens/activity/your_activity_screen.dart';

class ActivityCategoryController extends GetxController {
  void onActivityTap() {
    // TODO: Implement navigation or logic for 'Your Activity'
    Get.toNamed(YourActivityScreen.pageId);
  }

  void onBusinessReferrerTap() {
    // TODO: Implement navigation or logic for 'Business Referrer Features'
    Get.toNamed(BusinessReferrerFeaturesScreen.pageId,arguments:{"type":"business_refer"});
  }
 void onTutorialTrainingTap() {
    // TODO: Implement navigation or logic for 'Business Referrer Features'
    Get.toNamed(BusinessReferrerFeaturesScreen.pageId,arguments: {"type":"tutorial_trainings"});
  }

}
