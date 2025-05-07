import 'package:get/get.dart';

enum PlanType { independent, agencyPremium }

class MembershipController extends GetxController {
  final RxBool isYearly = true.obs;
  final Rx<PlanType> planType = PlanType.independent.obs;

  void togglePlan(bool isYearly) => this.isYearly.value = isYearly;

  void togglePlanType(PlanType planType) => this.planType.value = planType;
}
