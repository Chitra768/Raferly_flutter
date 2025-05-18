import 'package:get/get.dart';
import 'package:referaly/controller/controller_password_changed_success.dart';

class BindingPasswordChangedSuccess implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ControllerPasswordChangedSuccess>(
        () => ControllerPasswordChangedSuccess());
  }
}
