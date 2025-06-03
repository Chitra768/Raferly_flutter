import 'package:get/get.dart';
import '../controller/controller_choose_language_initial.dart';

class BindingInitialLanguage extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ControllerChooseLanguageInitial>(() => ControllerChooseLanguageInitial());
  }
}
