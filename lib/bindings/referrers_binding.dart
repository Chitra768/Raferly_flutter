import 'package:get/get.dart';
import 'package:referaly/controller/referrers_controller.dart';

class ReferrersBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ReferrersController>(() => ReferrersController());
  }
}
