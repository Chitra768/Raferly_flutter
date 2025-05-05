import 'package:get/get.dart';
import '../controller/controller_welcome.dart';


class BindingWelcome implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<WelcomeController>(() => WelcomeController());
  }
}
