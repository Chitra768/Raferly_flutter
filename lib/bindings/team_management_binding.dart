import 'package:get/get.dart';
import 'package:referaly/controller/team_management_controller.dart';

class TeamManagementBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TeamManagementController>(() => TeamManagementController());
  }
}
