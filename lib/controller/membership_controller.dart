import 'package:get/get.dart';

class MembershipController extends GetxController {
  final RxBool isYearly = true.obs;
  final RxBool isIndependent = true.obs;

  void togglePlan(bool data) => isYearly.value = data;

  void togglePlanType(bool data) => isIndependent.value = data;
}
