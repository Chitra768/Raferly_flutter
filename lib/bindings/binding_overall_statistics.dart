import 'package:get/get.dart';
import 'package:referaly/controller/overall_statistics_controller.dart';

class BindingOverallStatistics extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OverallStatisticsController>(
        () => OverallStatisticsController());
  }
}
