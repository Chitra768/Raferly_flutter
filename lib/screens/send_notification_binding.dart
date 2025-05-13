import 'package:get/get.dart';
import 'send_notification_controller.dart';

class SendNotificationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SendNotificationController>(() => SendNotificationController());
  }
}
