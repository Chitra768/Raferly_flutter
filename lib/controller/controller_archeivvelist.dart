import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:referaly/apis/api_result.dart';
import 'package:referaly/apis/rest_auth.dart';
import 'package:referaly/languages/languagekeys.dart';
import 'package:referaly/models/model_archeive_receive_recover.dart';
import 'package:referaly/models/model_archive_list_receive.dart';
import 'package:referaly/models/model_received_lead.dart';
import 'package:referaly/utils/translations.dart';
import 'package:referaly/widgets/dialog/success_popup.dart';

class ArcheiveListController extends GetxController {
  RxBool isAssending = false.obs;
  final Rx<ModelArchiveListReceive?> archiveList =
      Rx<ModelArchiveListReceive?>(null);
  final RxMap<String, bool> loadingStates = <String, bool>{}.obs;

  void changeSorting() {
    isAssending.value = !isAssending.value;
  }

  @override
  void onInit() {
    super.onInit();
    getArchiveList();
  }

  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;
  Future<void> getArchiveList({String order = "asc"}) async {
    try {
      isLoading.value = true;
      error.value = '';

      final response = await RESTAuth.getArchiveList(order: order);

      if (response is ApiSuccess<ModelArchiveListReceive>) {
        if (response.data.status == true) {
          archiveList.value = response.data;
        } else {
          error.value =
              response.data.message ?? tr(LanguageKeys.somethingWentWrong);
        }
      } else if (response is ApiFailure) {
        error.value =
            response.error.message ?? tr(LanguageKeys.somethingWentWrong);
      }
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  final RxBool isLoadingRecover = false.obs;
  final RxString errorRecover = ''.obs;
  final Rx<ModelArcheiveReceiveRecover?> recoverReceivedLead =
      Rx<ModelArcheiveReceiveRecover?>(null);
  Future<void> recoverArchiveLead({required String leadId}) async {
    try {
      loadingStates[leadId] = true;
      errorRecover.value = '';

      final response = await RESTAuth.recoverArchiveLead(leadId: leadId);

      if (response is ApiSuccess<ModelArcheiveReceiveRecover>) {
        if (response.data.status == true) {
          recoverReceivedLead.value = response.data;
          if (Get.context != null) {
            showDialog(
              context: Get.context!,
              builder: (context) => SuccessPopup(
                message: recoverReceivedLead.value?.message ?? '',
                onOk: () {
                  Get.back();
                },
              ),
              barrierDismissible: false,
            );
          }
        } else {
          errorRecover.value =
              response.data.message ?? tr(LanguageKeys.leadRecoveredFailed);
        }
      } else if (response is ApiFailure) {
        errorRecover.value =
            response.error.message ?? tr(LanguageKeys.leadRecoveredFailed);
      }
    } catch (e) {
      error.value = e.toString();
    } finally {
      loadingStates[leadId] = false;
    }
  }
}
