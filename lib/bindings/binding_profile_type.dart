import 'package:get/get.dart';
import 'package:referaly/controller/controller_profile_type.dart';

class BindingProfileType implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ControllerProfileType>(() => ControllerProfileType());
  }
}
