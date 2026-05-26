import 'package:get/get.dart';
import 'package:referaly/controller/team_member_profile_controller.dart';

class TeamMemberProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TeamMemberProfileController>(() => TeamMemberProfileController());
  }
}
