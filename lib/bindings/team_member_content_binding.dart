import 'package:get/get.dart';
import 'package:referaly/controller/team_member_content_controller.dart';

class TeamMemberContentBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TeamMemberContentController>(() => TeamMemberContentController());
  }
}
