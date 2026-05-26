import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:referaly/apis/api_result.dart';
import 'package:referaly/apis/rest_team_management.dart';
import 'package:referaly/languages/languagekeys.dart';
import 'package:referaly/models/model_team_member.dart';
import 'package:referaly/utils/translations.dart';
import 'package:referaly/widgets/dialog/success_popup.dart';

class CoUserSettingsController extends GetxController {
  final RxBool isLoading = false.obs;
  final RxBool isSaving = false.obs;
  final RxString error = ''.obs;
  final Rx<TeamMemberSettingsModel?> settings = Rx<TeamMemberSettingsModel?>(null);
  final Rx<TeamMemberContentAccess?> draftAccess = Rx<TeamMemberContentAccess?>(null);
  TeamMemberContentAccess? _savedAccess;

  int? memberId;

  bool get isDirty {
    final draft = draftAccess.value;
    final saved = _savedAccess;
    if (draft == null || saved == null) return false;
    return !draft.matches(saved);
  }

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args is Map) {
      memberId = args['memberId'] as int? ?? int.tryParse('${args['memberId']}');
    }
    if (memberId != null) {
      loadSettings();
    } else {
      error.value = tr(LanguageKeys.somethingWentWrong);
    }
  }

  Future<void> loadSettings() async {
    if (memberId == null) return;
    isLoading.value = true;
    error.value = '';
    try {
      final response = await RESTTeamManagement.getTeamMemberSettings(memberId!);
      if (response is ApiSuccess<TeamMemberSettingsResponse>) {
        final data = response.data.data;
        if (data != null) {
          settings.value = data;
          _savedAccess = data.contentAccess.copy();
          draftAccess.value = data.contentAccess.copy();
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

  void updatePermission(
    void Function(TeamMemberContentAccess access) update,
  ) {
    final current = draftAccess.value?.copy();
    if (current == null) return;
    update(current);
    draftAccess.value = current;
    draftAccess.refresh();
  }

  bool get businessReferrersVisible =>
      draftAccess.value?.businessReferrers.visibility ?? false;

  bool get businessReferrersEdition =>
      draftAccess.value?.businessReferrers.edition ?? false;

  bool get leadsSentVisible => draftAccess.value?.leadsSent.visibility ?? false;

  bool get leadsSentEdition => draftAccess.value?.leadsSent.edition ?? false;

  bool get leadsReceivedVisible =>
      draftAccess.value?.leadsReceived.visibility ?? false;

  bool get leadsReceivedEdition => draftAccess.value?.leadsReceived.edition ?? false;

  bool get referralContractsVisible =>
      draftAccess.value?.referralContracts.visibility ?? false;

  bool get referralContractsEdition =>
      draftAccess.value?.referralContracts.edition ?? false;

  // bool get myNetworkVisible => draftAccess.value?.myNetworkVisible ?? false;

  bool get iAmReferrerVisible => draftAccess.value?.iAmReferrerVisible ?? false;

  void setBusinessReferrersVisible(bool value) {
    updatePermission((a) {
      a.businessReferrers.visibility = value;
      if (!value) a.businessReferrers.edition = false;
    });
  }

  void setBusinessReferrersEdition(bool value) {
    updatePermission((a) => a.businessReferrers.edition = value);
  }

  void setLeadsSentVisible(bool value) {
    updatePermission((a) {
      a.leadsSent.visibility = value;
      if (!value) a.leadsSent.edition = false;
    });
  }

  void setLeadsSentEdition(bool value) {
    updatePermission((a) => a.leadsSent.edition = value);
  }

  void setLeadsReceivedVisible(bool value) {
    updatePermission((a) {
      a.leadsReceived.visibility = value;
      if (!value) a.leadsReceived.edition = false;
    });
  }

  void setLeadsReceivedEdition(bool value) {
    updatePermission((a) => a.leadsReceived.edition = value);
  }

  void setReferralContractsVisible(bool value) {
    updatePermission((a) {
      a.referralContracts.visibility = value;
      if (!value) a.referralContracts.edition = false;
    });
  }

  void setReferralContractsEdition(bool value) {
    updatePermission((a) => a.referralContracts.edition = value);
  }

  // void setMyNetworkVisible(bool value) {
  //   updatePermission((a) => a.myNetworkVisible = value);
  // }

  void setIAmReferrerVisible(bool value) {
    updatePermission((a) => a.iAmReferrerVisible = value);
  }

  Future<void> saveSettings() async {
    if (memberId == null || draftAccess.value == null || !isDirty) return;
    isSaving.value = true;
    try {
      final response = await RESTTeamManagement.saveTeamMemberSettings(
        memberId: memberId!,
        contentAccess: draftAccess.value!,
      );
      if (response is ApiSuccess<TeamMemberSettingsResponse>) {
        final saved = response.data.data;
        if (saved != null) {
          settings.value = saved;
          _savedAccess = saved.contentAccess.copy();
          draftAccess.value = saved.contentAccess.copy();
        } else {
          _savedAccess = draftAccess.value!.copy();
        }
        if (Get.context != null) {
          await showDialog(
            context: Get.context!,
            barrierDismissible: false,
            builder: (context) => SuccessPopup(
              message: response.data.message ?? tr(LanguageKeys.coUserSettingsSaved),
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
      isSaving.value = false;
    }
  }

  Future<void> switchToIndependent() async {
    if (memberId == null) return;
    final confirmed = await Get.dialog<bool>(
      AlertDialog(
        title: Text(tr(LanguageKeys.coUserSettingsSwitchIndependentTitle)),
        content: Text(tr(LanguageKeys.coUserSettingsSwitchIndependentBody)),
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

    isSaving.value = true;
    try {
      final response = await RESTTeamManagement.saveTeamMemberSettings(
        memberId: memberId!,
        contentAccess: draftAccess.value ?? TeamMemberContentAccess(),
        switchToIndependent: true,
      );
      if (response is ApiSuccess<TeamMemberSettingsResponse>) {
        if (Get.context != null) {
          await showDialog(
            context: Get.context!,
            barrierDismissible: false,
            builder: (context) => SuccessPopup(
              message: response.data.message ?? tr(LanguageKeys.coUserSettingsSaved),
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
      isSaving.value = false;
    }
  }
}
