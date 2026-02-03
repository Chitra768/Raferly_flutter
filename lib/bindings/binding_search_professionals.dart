import 'package:get/get.dart';
import 'package:referaly/controller/search_professionals_controller.dart';

class BindingSearchProfessionals extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SearchProfessionalsController());
  }
}
