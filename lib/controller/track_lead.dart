import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:referaly/apis/api_result.dart';
import 'package:referaly/apis/rest_auth.dart';
import 'package:referaly/controller/controller_main_professional.dart';
import 'package:referaly/languages/languagekeys.dart';
import 'package:referaly/models/model_receive_lead_delete.dart';
import 'package:referaly/models/model_received_lead.dart';
import 'package:referaly/models/model_send_lead.dart';
import 'package:referaly/resources/app_helper.dart';
import 'package:referaly/resources/app_preference.dart';
import 'package:referaly/utils/translations.dart';
import 'package:referaly/widgets/dialog/success_popup.dart';

class TrackLeadsController extends GetxController {
  RxBool isLeadsReceived = true.obs;
  final RxString isPaid = '0'.obs;
  RxDouble buttonScale = 1.0.obs;

  RxInt currentStep = RxInt(0);
  final mainController = Get.find<ControllerMainProfessional>();
  void toggleLeadType(bool isReceived) {
    isLeadsReceived.value = isReceived;
    getLeads();
    getSendLeads();
  }

  @override
  void onInit() {
    super.onInit();
    isPaid.value = AppPreference.readString(AppPreference.isPaid) ?? '0';
    print('isPaid: $isPaid');
    getLeads();
    getSendLeads();
  }

  @override
  void onClose() {
    super.onClose();
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
          errorSendLeads.value =
              response.data.message ?? tr(LanguageKeys.somethingWentWrong);
        }
      } else if (response is ApiFailure) {
        errorSendLeads.value =
            response.error.message ?? tr(LanguageKeys.somethingWentWrong);
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
          
          // await getLeads();
        } else {
          errorDeleteLead.value =
              response.data.message ?? tr(LanguageKeys.somethingWentWrong);
        }
      } else if (response is ApiFailure) {
        errorDeleteLead.value =
            response.error.message ?? tr(LanguageKeys.somethingWentWrong);
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
    required int leadLength,
    required int parentIndex,
  }) async {
    try {
      isLoadingComment.value = true;
      errorComment.value = '';
      print('id: $id');
      print('comment: $comment');
      print('leadId: $leadId');
      print('name: $name');
      print('leadLength: $leadLength');
      print('parentIndex: $parentIndex');

      final response = await RESTAuth.sendLeadComment(
        id: id,
        comment: comment,
        leadId: leadId,
        name: name,
      );

      if (response is ApiSuccess) {
        if (response.data.status == true) {
          // Refresh the leads list after successful comment
             isLoadingComment.value = false;

          if (Get.context != null) {
            if(leadLength-1 == parentIndex){
                          showDialog(
              context: Get.context!,
              builder: (context) => SuccessPopup(
                message: response.data.message ?? '',
                onOk: () {
                  getLeads();
                  Get.back();
                },
              ),
              barrierDismissible: false,
            );
            }

          }

          await getLeads();
        } else {
          errorComment.value =
              response.data.message ?? tr(LanguageKeys.somethingWentWrong);
        }
      } else if (response is ApiFailure) {
        errorComment.value =
            response.error.message ?? tr(LanguageKeys.somethingWentWrong);
      }
    } catch (e) {
      errorComment.value = e.toString();
    } finally {
      isLoadingComment.value = false;
    }
  }

  Future<void> editLeadComment({
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

      final response = await RESTAuth.editLeadComment(
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
                message: response.data.message ?? '',
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
              response.data.message ?? tr(LanguageKeys.somethingWentWrong);
        }
      } else if (response is ApiFailure) {
        errorComment.value =
            response.error.message ?? tr(LanguageKeys.somethingWentWrong);
      }
    } catch (e) {
      errorComment.value = e.toString();
    } finally {
      isLoadingComment.value = false;
    }
  }

    Future<void> addCommisionAmount({
    required int id,
    required String amount,
    required int leadId,
    String? name,
  }) async {
    try {
      isLoadingComment.value = true;
      errorComment.value = '';
      print('id: $id');
      print('amount: $amount');
      print('leadId: $leadId');
      print('name: $name');

      final response = await RESTAuth.addCommisionAmount(
        id: id,
        amount: amount,
        leadId: leadId,
        name: "Payment received",
      );

      if (response is ApiSuccess) {
        if (response.data.status == true) {
          // Refresh the leads list after successful comment
          

          if (Get.context != null) {
                          showDialog(
              context: Get.context!,
              builder: (context) => SuccessPopup(
                message: response.data.message ?? '',
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
              response.data.message ?? tr(LanguageKeys.somethingWentWrong);
        }
      } else if (response is ApiFailure) {
        errorComment.value =
            response.error.message ?? tr(LanguageKeys.somethingWentWrong);
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
              response.data.message ?? tr(LanguageKeys.somethingWentWrong);
        }
      } else if (response is ApiFailure) {
        errorComment.value =
            response.error.message ?? tr(LanguageKeys.somethingWentWrong);
      }
    } catch (e) {
      errorComment.value = e.toString();
    } finally {
      isLoadingComment.value = false;
    }
  }
}
