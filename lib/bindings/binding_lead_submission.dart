import 'package:get/get.dart';
import '../controller/add_lead_controller.dart';

class LeadSubmissionBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AddLeadController>(() => AddLeadController());
  }
}
