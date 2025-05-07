import 'package:get/get.dart';
import 'package:referaly/controller/business_referrer_contract_controller.dart' show BusinessReferrerContractController;
import 'package:referaly/controller/invited_deals_controller.dart' show InvitedDealsController;

export 'package:referaly/bindings/binding_choose_language.dart';
export 'package:referaly/bindings/binding_forgot_password.dart';
export 'package:referaly/bindings/binding_login.dart';
export 'package:referaly/bindings/binding_verification_password.dart';
export 'package:referaly/bindings/binding_welcome.dart';

// Binding for My Activity screen

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
