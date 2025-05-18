import 'package:get/get.dart';
import 'package:referaly/controller/business_referrer_features_controller.dart';

class BindingBusinessReferrerFeatures implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BusinessReferrerFeaturesController>(
        () => BusinessReferrerFeaturesController());
  }
}
