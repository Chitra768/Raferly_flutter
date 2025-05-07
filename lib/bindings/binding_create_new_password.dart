import 'package:get/get.dart';
import 'package:referaly/controller/controller_create_new_password.dart';

import '../controller/controller_login.dart';


class BindingCreateNewPassword implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ControllerCreateNewPassword>(() => ControllerCreateNewPassword());
  }
}
