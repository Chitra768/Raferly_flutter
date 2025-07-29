import 'package:get/get.dart';
import 'package:referaly/controller/busniess_referrers_controller.dart';

class BusinessReferrersBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BusinessReferrersController>(() => BusinessReferrersController());
  }
}
