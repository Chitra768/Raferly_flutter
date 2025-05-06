import 'package:get/get.dart';

import '../controller/controller_main_professional.dart';


class BindingMain implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ControllerMainProfessional>(() => ControllerMainProfessional());
  }
}
