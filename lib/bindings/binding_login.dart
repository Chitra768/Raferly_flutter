import 'package:get/get.dart';

import '../controller/controller_login.dart';


class BindingLogin implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ControllerLogin>(() => ControllerLogin());
  }
}
