import 'package:get/get.dart';
import '../controller/send_notification_controller.dart';

class SendNotificationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SendNotificationController>(() => SendNotificationController());
  }
}
