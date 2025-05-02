import 'package:get/get.dart';
import 'package:referaly/controller/controller_forgot.dart';




class BindingForgotPassword implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ForgotPasswordController>(() => ForgotPasswordController());
  }
}
