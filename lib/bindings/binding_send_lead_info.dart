import 'package:get/get.dart';
import 'package:referaly/controller/send_lead_info_controller.dart';

class BindingSendLeadInfo implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SendLeadInfoController>(() => SendLeadInfoController());
  }
}
