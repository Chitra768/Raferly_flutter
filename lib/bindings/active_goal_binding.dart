import 'package:get/get.dart';
import '../controllers/active_goal_controller.dart';

class ActiveGoalBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ActiveGoalController>(() => ActiveGoalController());
  }
}
