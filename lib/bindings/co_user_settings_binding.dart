import 'package:get/get.dart';
import 'package:referaly/controller/co_user_settings_controller.dart';

class CoUserSettingsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CoUserSettingsController>(() => CoUserSettingsController());
  }
}
