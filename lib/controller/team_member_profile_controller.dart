import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:referaly/apis/api_result.dart';
import 'package:referaly/apis/rest_team_management.dart';
import 'package:referaly/languages/languagekeys.dart';
import 'package:referaly/models/model_team_member.dart';
import 'package:referaly/screens/dashboard/team_member_content_screen.dart';
import 'package:referaly/utils/translations.dart';
import 'package:referaly/widgets/dialog/success_popup.dart';

class TeamMemberProfileController extends GetxController {
  final RxBool isLoading = false.obs;
  final RxBool isSwitching = false.obs;
  final RxString error = ''.obs;
  final Rx<TeamMemberProfileModel?> profile = Rx<TeamMemberProfileModel?>(null);

  int? memberId;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args is Map) {
      memberId = args['memberId'] as int? ?? int.tryParse('${args['memberId']}');
    }
    if (memberId != null) {
      loadProfile();
    } else {
      error.value = tr(LanguageKeys.somethingWentWrong);
    }
  }

  Future<void> loadProfile() async {
    if (memberId == null) return;
    isLoading.value = true;
    error.value = '';
    try {
      final response = await RESTTeamManagement.getTeamMemberProfile(memberId!);
      if (response is ApiSuccess<TeamMemberProfileResponse>) {
        final data = response.data.data;
        if (data != null) {
          profile.value = data;
        } else {
          error.value = response.data.message ?? tr(LanguageKeys.somethingWentWrong);
        }
      } else if (response is ApiFailure) {
        error.value = response.error.message ?? tr(LanguageKeys.somethingWentWrong);
      }
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> openContent(TeamMemberContentTab tab) async {
    if (memberId == null) return;
    await Get.toNamed(
      TeamMemberContentScreen.pageId,
      arguments: {
        'memberId': memberId,
        'userId': profile.value?.userId,
        'initialTab': tab.index,
      },
    );
  }

  Future<void> switchToAgency() async {
    if (memberId == null) return;
    final confirmed = await Get.dialog<bool>(
      AlertDialog(
        title: Text(tr(LanguageKeys.teamMemberProfileSwitchAgencyTitle)),
        content: Text(tr(LanguageKeys.teamMemberProfileSwitchAgencyBody)),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: Text(tr(LanguageKeys.cancel)),
          ),
          TextButton(
            onPressed: () => Get.back(result: true),
            child: Text(tr(LanguageKeys.confirm)),
          ),
        ],
      ),
    );
    if (confirmed != true) return;

    isSwitching.value = true;
    try {
      final response = await RESTTeamManagement.switchTeamMemberToAgency(memberId!);
      if (response is ApiSuccess<Map<String, dynamic>>) {
        final message = response.data['message']?.toString();
        if (Get.context != null) {
          await showDialog(
            context: Get.context!,
            barrierDismissible: false,
            builder: (context) => SuccessPopup(
              message: message ?? tr(LanguageKeys.teamMemberProfileSwitchAgencySuccess),
              onOk: () {},
            ),
          );
        }
        Get.back(result: true);
      } else if (response is ApiFailure) {
        error.value = response.error.message ?? tr(LanguageKeys.somethingWentWrong);
      }
    } catch (e) {
      error.value = e.toString();
    } finally {
      isSwitching.value = false;
    }
  }
}
