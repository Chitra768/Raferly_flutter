import 'package:get/get.dart';
import '../controller/controller_registration.dart';

class BindingRegistration implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RegistrationController>(() => RegistrationController());
  }
}
