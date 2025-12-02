import 'package:get/get.dart';
import '../controller/add_lead_source_controller.dart';

class AddLeadSourceBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AddLeadSourceController>(() => AddLeadSourceController());
  }
}

