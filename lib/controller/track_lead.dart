import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:referaly/apis/api_result.dart';
import 'package:referaly/apis/rest_auth.dart';
import 'package:referaly/languages/languagekeys.dart';
import 'package:referaly/models/model_receive_lead_delete.dart';
import 'package:referaly/models/model_received_lead.dart';
import 'package:referaly/models/model_send_lead.dart';
import 'package:referaly/resources/app_preference.dart';
import 'package:referaly/utils/translations.dart';
import 'package:referaly/widgets/dialog/success_popup.dart';

class TrackLeadsController extends GetxController {
  RxBool isLeadsReceived = true.obs;
  final RxString isPaid = '0'.obs;
    RxInt currentStep = RxInt(0);
  void toggleLeadType(bool isReceived) {
    isLeadsReceived.value = isReceived;
    getLeads();
    getSendLeads();
  }

  @override
  void onInit() {
    super.onInit();
    isLeadsReceived.value = true;
    isPaid.value = AppPreference.readString(AppPreference.isPaid) ?? '0';
    print('isPaid: $isPaid');
    getLeads();
    getSendLeads();
  }

  @override
  void onClose() {
    super.onClose();
    isLeadsReceived.value = true;
  }

  final Rx<ModelReceivedLead?> receivedLead = Rx<ModelReceivedLead?>(null);
  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;
  Future<void> getLeads() async {
    try {
      isLoading.value = true;
      error.value = '';

      final response = await RESTAuth.getLeads();

      if (response is ApiSuccess<ModelReceivedLead>) {
        if (response.data.status == true) {
          receivedLead.value = response.data;
        } else {
          error.value = response.data.message ?? 'Failed to get Leads';
        }
      } else if (response is ApiFailure) {
        error.value = response.error.message ?? 'Something went wrong';
      }
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  final Rx<ModelSendLead?> sendLead = Rx<ModelSendLead?>(null);
  final RxBool isLoadingSendLeads = false.obs;
  final RxString errorSendLeads = ''.obs;

  final RxBool isLoadingComment = false.obs;
  final RxString errorComment = ''.obs;

  Future<void> getSendLeads() async {
    try {
      isLoadingSendLeads.value = true;
      errorSendLeads.value = '';

      final response = await RESTAuth.getSendLeads();

      if (response is ApiSuccess<ModelSendLead>) {
        if (response.data.status == true) {
          sendLead.value = response.data;
        } else {
          errorSendLeads.value = response.data.message ?? 'Failed to get Leads';
        }
      } else if (response is ApiFailure) {
        errorSendLeads.value = response.error.message ?? 'Something went wrong';
      }
    } catch (e) {
      errorSendLeads.value = e.toString();
    } finally {
      isLoadingSendLeads.value = false;
    }
  }

  final RxBool isLoadingDeleteLead = false.obs;
  final RxString errorDeleteLead = ''.obs;
  final Rx<ModelReceiveLeadDelete?> receiveLeadDelete =
      Rx<ModelReceiveLeadDelete?>(null);

  Future<void> deleteReceivedLead(
      {int? leadId, required List<Map<String, Object?>> lostReasons}) async {
    try {
      isLoadingDeleteLead.value = true;
      errorDeleteLead.value = '';

      final response = await RESTAuth.deleteReceivedLead(
        leadId: leadId,
        lostReasons: lostReasons,
      );

      if (response is ApiSuccess<ModelReceiveLeadDelete>) {
        if (response.data.status == true) {
          receiveLeadDelete.value = response.data;
          await getLeads();
        } else {
          errorDeleteLead.value =
              response.data.message ?? 'Failed to get Leads';
        }
      } else if (response is ApiFailure) {
        errorDeleteLead.value =
            response.error.message ?? 'Something went wrong';
      }
    } catch (e) {
      errorDeleteLead.value = e.toString();
    } finally {
      isLoadingDeleteLead.value = false;
    }
  }

  Future<void> sendLeadComment({
    required int id,
    required String comment,
    required int leadId,
    String? name,
  }) async {
    try {
      isLoadingComment.value = true;
      errorComment.value = '';
      print('id: $id');
      print('comment: $comment');
      print('leadId: $leadId');
      print('name: $name');

      final response = await RESTAuth.sendLeadComment(
        id: id,
        comment: comment,
        leadId: leadId,
        name: name,
      );

      if (response is ApiSuccess) {
        if (response.data.status == true) {
          // Refresh the leads list after successful comment

         if (Get.context != null) {
          showDialog(
            context: Get.context!,
            builder: (context) => SuccessPopup(
              message: tr(LanguageKeys.successTheLead),
              onOk: () {
                getLeads();
                Get.back();
              },
            ),
            barrierDismissible: false,
          );
        }

          await getLeads();
        } else {
          errorComment.value =
              response.data.message ?? 'Failed to send comment';
        }
      } else if (response is ApiFailure) {
        errorComment.value = response.error.message ?? 'Something went wrong';
      }
    } catch (e) {
      errorComment.value = e.toString();
    } finally {
      isLoadingComment.value = false;
    }
  }

  Future<void> updateLeadStatus({
    required int leadId,
    required int currentStep,
  }) async {
    try {
      isLoadingComment.value = true;
      errorComment.value = '';

      final response = await RESTAuth.updateLeadStatus(
        leadId: leadId,
        currentStep: currentStep + 1, // Move to next step
      );

      if (response is ApiSuccess) {
        if (response.data.status == true) {
          // Refresh the leads list after successful status update
          await getLeads();
          await getSendLeads();
        } else {
          errorComment.value =
              response.data.message ?? 'Failed to update lead status';
        }
      } else if (response is ApiFailure) {
        errorComment.value = response.error.message ?? 'Something went wrong';
      }
    } catch (e) {
      errorComment.value = e.toString();
    } finally {
      isLoadingComment.value = false;
    }
  }
}
