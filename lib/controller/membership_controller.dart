import 'package:get/get.dart';

class MembershipController extends GetxController {
  final RxBool isYearly = true.obs;

  void togglePlan(bool yearly) => isYearly.value = yearly;
}
