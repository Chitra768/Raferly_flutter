import 'package:get/get.dart';
import 'package:referaly/controller/lead_tracking_controller.dart';

class LeadTrackingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LeadTrackingController>(() => LeadTrackingController());
  }
}
