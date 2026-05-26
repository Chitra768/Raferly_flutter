import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:referaly/apis/api_result.dart';
import 'package:referaly/apis/rest_team_management.dart';
import 'package:referaly/languages/languagekeys.dart';
import 'package:referaly/models/model_team_member.dart';
import 'package:referaly/models/model_team_member_invite.dart';
import 'package:referaly/controller/team_management_controller.dart';
import 'package:referaly/utils/translations.dart';
import 'package:referaly/widgets/dialog/success_popup.dart';

class AddColleagueController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final positionController = TextEditingController();
  final cityController = TextEditingController();

  final Rx<TeamMemberType> memberType = TeamMemberType.agency.obs;
  final RxString selectedJobId = ''.obs;
  final RxBool isSubmitting = false.obs;
  final RxString error = ''.obs;

  bool get isAgency => memberType.value == TeamMemberType.agency;

  @override
  void onClose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    positionController.dispose();
    cityController.dispose();
    super.onClose();
  }

  void selectMemberType(TeamMemberType type) {
    memberType.value = type;
    if (type == TeamMemberType.independent) {
      _clearJobSelection();
    }
  }

  void _clearJobSelection() {
    positionController.clear();
    selectedJobId.value = '';
  }

  void onJobSelected(int id, String title) {
    selectedJobId.value = id.toString();
  }

  String? validateRequired(String? value, String messageKey) {
    if (value == null || value.trim().isEmpty) {
      return tr(messageKey);
    }
    return null;
  }

  String? validateEmail(String? value) {
    final required = validateRequired(value, LanguageKeys.pleaseEnterEmail);
    if (required != null) return required;
    if (!GetUtils.isEmail(value!.trim())) {
      return tr(LanguageKeys.pleaseEnterValidEmail);
    }
    return null;
  }

  Future<void> sendInvitation() async {
    if (!(formKey.currentState?.validate() ?? false)) return;

    if (isAgency) {
      final job = positionController.text.trim();
      if (job.isEmpty || selectedJobId.value.isEmpty) {
        error.value = tr(LanguageKeys.jobRequired);
        return;
      }
    }

    isSubmitting.value = true;
    error.value = '';
    try {
      final isIndependent = memberType.value == TeamMemberType.independent;
      final type = isIndependent ? 'independent' : 'agency';

      final response = await RESTTeamManagement.inviteTeamMember(
        TeamMemberInviteRequest(
          firstName: firstNameController.text.trim(),
          lastName: lastNameController.text.trim(),
          email: emailController.text.trim(),
          phone: phoneController.text.trim(),
          jobTitle: isAgency ? positionController.text.trim() : '',
          city: cityController.text.trim(),
          memberType: type,
          jobId: isAgency && selectedJobId.value.isNotEmpty
              ? selectedJobId.value
              : null,
          successUrl:
              isIndependent ? RESTTeamManagement.teamSeatSuccessUrl : null,
          cancelUrl:
              isIndependent ? RESTTeamManagement.teamSeatCancelUrl : null,
          notifyOwnerByEmail: isIndependent ? true : null,
        ),
      );

      if (response is ApiSuccess<Map<String, dynamic>>) {
        final message = response.data['message']?.toString();
        if (Get.context != null) {
          await showDialog(
            context: Get.context!,
            barrierDismissible: false,
            builder: (context) => SuccessPopup(
              message: message ?? tr(LanguageKeys.teamManagementInvitationSent),
              onOk: () {},
            ),
          );
        }

        Get.back();
        if (Get.isRegistered<TeamManagementController>()) {
          await Get.find<TeamManagementController>().loadTeamMembers();
        }
      } else if (response is ApiFailure) {
        error.value = response.error.message ?? tr(LanguageKeys.somethingWentWrong);
      }
    } catch (e) {
      error.value = e.toString();
    } finally {
      isSubmitting.value = false;
    }
  }
}
