import 'package:get/get.dart';
import 'package:referaly/controller/detailed_statistics_controller.dart';

class BindingDetailedStatistics extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DetailedStatisticsController>(
        () => DetailedStatisticsController());
  }
}
