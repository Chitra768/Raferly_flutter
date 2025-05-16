import 'package:get/get.dart';
import 'package:referaly/controller/controller_connected_card.dart';

class BindingConnectedCard extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ControllerConnectedCard>(() => ControllerConnectedCard());
  }
}
