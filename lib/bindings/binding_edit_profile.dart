import 'package:get/get.dart';
import 'package:referaly/controller/edit_profile_controller.dart';

class BindingEditProfile extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<EditProfileController>(() => EditProfileController());
  }
}
