import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:referaly/apis/api_result.dart';
import 'package:referaly/apis/rest_auth.dart';
import 'package:referaly/models/model_contact_response.dart';
import 'package:referaly/models/model_coworkerlist_deal.dart';
import 'package:referaly/models/model_network_response.dart';
import 'package:referaly/models/model_receive_lead_delete.dart';
import 'package:referaly/widgets/dialog/success_popup.dart';

class MyActivityController extends GetxController {
  // Observable variables
  final RxBool isMyContractsSelected = true.obs;
  final RxInt selectedNavIndex = 1.obs;
  final RxList<String> referrerNames = <String>[].obs;

  // Toggle tab selection
  void toggleTabSelection(bool isFirst) {
    isMyContractsSelected.value = isFirst;
  }

  // Set selected navigation item
  void setNavIndex(int index) {
    selectedNavIndex.value = index;
  }

  // Add a new referrer
  void addReferrer(String name) {
    if (referrerNames.length < 5) {
      referrerNames.add(name);
    }
  }

  // Remove a referrer
  void removeReferrer(int index) {
    if (index >= 0 && index < referrerNames.length) {
      referrerNames.removeAt(index);
    }
  }

  @override
  void onInit() {
    super.onInit();
    updateInit();
  }

  updateInit() {
    getNetworkList();
    getContactList();
    getUserDealList();
  }

  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;
  final Rx<ModelNetworkResponse?> networkList = Rx<ModelNetworkResponse?>(null);
  Future<void> getNetworkList() async {
    try {
      isLoading.value = true;
      error.value = '';

      final response = await RESTAuth.getNetworkList();

      if (response is ApiSuccess<ModelNetworkResponse>) {
        if (response.data.status == true) {
          networkList.value = response.data;
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

  final RxBool isContactLoading = false.obs;
  final RxString contactError = ''.obs;
  final Rx<ModelContactResponse?> contactList = Rx<ModelContactResponse?>(null);

  Future<void> getContactList() async {
    try {
      isContactLoading.value = true;
      contactError.value = '';

      final response = await RESTAuth.getContactList();

      if (response is ApiSuccess<ModelContactResponse>) {
        if (response.data.status == true) {
          contactList.value = response.data;
        } else {
          contactError.value = response.data.message ?? 'Failed to get Leads';
        }
      } else if (response is ApiFailure) {
        contactError.value = response.error.message ?? 'Something went wrong';
      }
    } catch (e) {
      contactError.value = e.toString();
    } finally {
      isContactLoading.value = false;
    }
  }

  Future<void> deleteContract(String id) async {
    final response = await RESTAuth.deleteDeal(id: id);
    if (response is ApiSuccess<ModelReceiveLeadDelete>) {
      if (response.data.status == true) {
        await getContactList();
        // Show success popup
        if (Get.context != null) {
          showDialog(
            context: Get.context!,
            builder: (context) => SuccessPopup(
              message: response.data.message ?? 'Contract deleted successfully',
              onOk: () {
                Get.back();
              },
            ),
            barrierDismissible: false,
          );
        }
      } else {
        contactError.value = response.data.message ?? 'Failed to get Leads';
      }
    }
  }

  final RxBool isUserDealLoading = false.obs;
  final RxString userDealError = ''.obs;
  final Rx<ModelCoworkerlistDeal?> userDealList =
      Rx<ModelCoworkerlistDeal?>(null);

  Future<void> getUserDealList() async {
    try {
      isUserDealLoading.value = true;
      userDealError.value = '';

      final response = await RESTAuth.getUserDealList();

      if (response is ApiSuccess<ModelCoworkerlistDeal>) {
        if (response.data.status == true) {
          userDealList.value = response.data;
        } else {
          userDealError.value = response.data.message ?? 'Failed to get Leads';
        }
      } else if (response is ApiFailure) {
        userDealError.value = response.error.message ?? 'Something went wrong';
      }
    } catch (e) {
      userDealError.value = e.toString();
    } finally {
      isUserDealLoading.value = false;
    }
  }
}
