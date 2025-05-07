import 'package:get/get.dart';
import 'package:referaly/controllers/business_referrer_contract_controller.dart';
import 'package:referaly/controllers/invited_deals_controller.dart';
import 'package:referaly/controllers/my_activity_controller.dart';

export 'package:referaly/bindings/binding_choose_language.dart';
export 'package:referaly/bindings/binding_forgot_password.dart';
export 'package:referaly/bindings/binding_login.dart';
export 'package:referaly/bindings/binding_verification_password.dart';
export 'package:referaly/bindings/binding_welcome.dart';

// Binding for My Activity screen
class BindingMyActivity extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MyActivityController>(() => MyActivityController());
  }
}

// Binding for Invited Deals screen
class BindingInvitedDeals extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<InvitedDealsController>(() => InvitedDealsController());
  }
}

// Binding for Business Referrer Contract screen
class BindingBusinessReferrerContract extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BusinessReferrerContractController>(() => BusinessReferrerContractController());
  }
}
