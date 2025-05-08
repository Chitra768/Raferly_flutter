import 'package:get/get.dart';
import 'package:referaly/controller/controller_verification.dart';

class BindingVerificationPassword implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<VerificationController>(() => VerificationController());
  }
}
