import 'package:get/get.dart';
import '../controller/add_business_referrer_controller.dart';

class AddBusinessReferrerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AddBusinessReferrerController>(
        () => AddBusinessReferrerController());
  }
}
