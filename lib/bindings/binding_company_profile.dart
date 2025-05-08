import 'package:get/get.dart';
import 'package:referaly/controller/company_profile_controller.dart';

class BindingCompanyProfile extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CompanyProfileController>(() => CompanyProfileController());
  }
}
