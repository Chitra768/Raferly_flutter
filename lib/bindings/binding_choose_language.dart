import 'package:get/get.dart';
import 'package:referaly/controller/controller_choose_language.dart';

class BindingChooseLanguage implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ControllerChooseLanguage>(() => ControllerChooseLanguage());
  }
}
