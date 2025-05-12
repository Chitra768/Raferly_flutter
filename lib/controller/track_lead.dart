import 'package:get/get.dart';
import 'package:referaly/apis/api_result.dart';
import 'package:referaly/apis/rest_auth.dart';
import 'package:referaly/models/model_receive_lead_delete.dart';
import 'package:referaly/models/model_received_lead.dart';
import 'package:referaly/models/model_send_lead.dart';

class TrackLeadsController extends GetxController {
  RxBool isLeadsReceived = true.obs;

  void toggleLeadType(bool isReceived) {
    isLeadsReceived.value = isReceived;
  }

  @override
  void onInit() {
    super.onInit();
    isLeadsReceived.value = true;
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
  Future<void> getSendLeads() async {
    try {
      isLoadingSendLeads.value = true;
      errorSendLeads.value = '';

      final response = await RESTAuth.getLeads();

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
  final Rx<ModelReceiveLeadDelete?> receiveLeadDelete = Rx<ModelReceiveLeadDelete?>(null);

  Future<void> deleteReceivedLead() async {
    try {
      isLoadingDeleteLead.value = true;
      errorDeleteLead.value = '';

      final response = await RESTAuth.deleteReceivedLead();

      if (response is ApiSuccess<ModelReceiveLeadDelete>) {
        if (response.data.status == true) {
          receiveLeadDelete.value = response.data;
        } else {
          errorDeleteLead.value = response.data.message ?? 'Failed to get Leads';
        }
      } else if (response is ApiFailure) {
        errorDeleteLead.value = response.error.message ?? 'Something went wrong';
      }
    } catch (e) {
      errorDeleteLead.value = e.toString();
    } finally {
      isLoadingDeleteLead.value = false;
    }
  }

}
