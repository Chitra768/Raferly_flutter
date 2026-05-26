import 'package:get/get.dart';
import 'package:referaly/controller/team_member_select_deals_controller.dart';

class TeamMemberSelectDealsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TeamMemberSelectDealsController>(
      () => TeamMemberSelectDealsController(),
    );
  }
}
