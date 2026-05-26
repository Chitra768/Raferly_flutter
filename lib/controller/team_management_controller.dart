import 'package:get/get.dart';
import 'package:referaly/apis/api_result.dart';
import 'package:referaly/apis/rest_team_management.dart';
import 'package:referaly/languages/languagekeys.dart';
import 'package:referaly/models/model_team_member.dart';
import 'package:referaly/screens/dashboard/co_user_settings_screen.dart';
import 'package:referaly/screens/dashboard/team_member_profile_screen.dart';
import 'package:referaly/widgets/team_management/add_colleague_bottom_sheet.dart';
import 'package:referaly/utils/translations.dart';

class TeamManagementController extends GetxController {
  final RxList<TeamMemberData> members = <TeamMemberData>[].obs;
  final Rx<TeamMemberBilling?> billing = Rx<TeamMemberBilling?>(null);
  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadTeamMembers();
  }

  Future<void> loadTeamMembers() async {
    isLoading.value = true;
    error.value = '';
    try {
      final response = await RESTTeamManagement.getTeamMembers();
      if (response is ApiSuccess<TeamMemberListModel>) {
        if (response.data.status == true) {
          members.value = response.data.members;
          billing.value = response.data.billing;
        } else {
          error.value = response.data.message ?? tr(LanguageKeys.somethingWentWrong);
          members.clear();
          billing.value = null;
        }
      } else if (response is ApiFailure) {
        error.value = response.error.message ?? tr(LanguageKeys.somethingWentWrong);
        members.clear();
        billing.value = null;
      }
    } catch (e) {
      error.value = e.toString();
      members.clear();
      billing.value = null;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> onAddColleague() async {
    await AddColleagueBottomSheet.show();
  }

  Future<void> onMemberTap(TeamMemberData member) async {
    if (member.id == null) return;

    final args = {
      'memberId': member.id,
      'userId': member.userId,
    };

    dynamic result;
    switch (member.type) {
      case TeamMemberType.agency:
        result = await Get.toNamed(CoUserSettingsScreen.pageId, arguments: args);
        break;
      case TeamMemberType.independent:
        result = await Get.toNamed(TeamMemberProfileScreen.pageId, arguments: args);
        break;
      case TeamMemberType.unknown:
        result = await Get.toNamed(
          TeamMemberProfileScreen.pageId,
          arguments: args,
        );
        break;
    }

    if (result == true) {
      await loadTeamMembers();
    }
  }
}
