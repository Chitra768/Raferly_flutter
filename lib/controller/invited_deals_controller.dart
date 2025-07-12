import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:referaly/apis/api_result.dart';
import 'package:referaly/apis/rest_auth.dart';
import 'package:referaly/languages/languagekeys.dart';
import 'package:referaly/models/model_accept_list.dart';
import 'package:referaly/models/model_common.dart';
import 'package:referaly/models/model_read_otification.dart';
import 'package:referaly/utils/translations.dart';
import 'package:referaly/widgets/dialog/success_popup.dart';

class DealModel {
  final String name;
  final String referralInfo;
  final String profileColor;
  final RxBool isExpanded;

  DealModel({
    required this.name,
    required this.referralInfo,
    required this.profileColor,
    bool expanded = false,
  }) : isExpanded = expanded.obs;
}

class InvitedDealsController extends GetxController {
  // Observable variables
  final RxList<DealModel> deals = <DealModel>[].obs;
  final RxInt selectedNavIndex = 1.obs;
  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;
  final RxSet<int> expandedIndices = <int>{}.obs;
  @override
  void onInit() {
    super.onInit();
    // loadDeals();
    getAcceptList();
    readNotification();
  }

  // Initialize with dummy data

  final Rx<ModelAcceptList?> acceptList = Rx<ModelAcceptList?>(null);

  get handleDocuments => null;
  Future<void> getAcceptList() async {
    try {
      isLoading.value = true;
      error.value = '';

      final response = await RESTAuth.getAcceptList();

      if (response is ApiSuccess<ModelAcceptList>) {
        if (response.data.status == true) {
          acceptList.value = response.data;
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
  // void loadDeals() {
  //   deals.value = [
  //     DealModel(
  //       name: "Darshan",
  //       referralInfo: "Business referral - (Kavan Solanki)",
  //       profileColor: "4CAF50", // Green
  //     ),
  //     DealModel(
  //       name: "Hetal",
  //       referralInfo: "Business referral - (Rahul Patel)",
  //       profileColor: "2196F3", // Blue
  //     ),
  //     DealModel(
  //       name: "Sanjay",
  //       referralInfo: "Business referral - (Arjun Shah)",
  //       profileColor: "9C27B0", // Purple
  //     ),
  //   ];
  // }

  // Toggle expansion of deal info
  void toggleDealExpansion(int index) {
    deals[index].isExpanded.value = !deals[index].isExpanded.value;
  }

  // Set selected navigation item
  void setNavIndex(int index) {
    selectedNavIndex.value = index;
  }

  // Method to share a deal
  void shareDeal(int index) {
    // Implementation for sharing functionality
    if (index >= 0 && index < deals.length) {
      final deal = deals[index];
      // Share logic would go here
    }
  }

  // Method to show more options
  void showMoreOptions(int index) {
    // Implementation for more options
    if (index >= 0 && index < deals.length) {
      Get.bottomSheet(
        Container(
          padding: const EdgeInsets.all(20),
          color: Colors.white,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.edit),
                title: Text(tr(LanguageKeys.editDeal)),
                onTap: () {
                  Get.back();
                  // Edit logic would go here
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete),
                title: Text(tr(LanguageKeys.deleteDeal)),
                onTap: () {
                  Get.back();
                  // Delete logic would go here
                },
              ),
            ],
          ),
        ),
      );
    }
  }

  Future<void> readNotification() async {
    try {
      isLoading.value = true;
      error.value = '';

      final response = await RESTAuth.readNotification(type: "referrer");

      if (response is ApiSuccess<ModelReadNotification>) {
        if (response.data.status == true) {
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

  Future<void> getDealLeave(String dealId) async {
    try {
      isLoading.value = true;
      error.value = '';

      final response = await RESTAuth.getDealLeave(dealId);
      if (response is ApiSuccess<ModelCommon>) {
        if (response.data.status == true) {
          await getAcceptList();
          if (Get.context != null) {
            await showDialog(
              context: Get.context!,
              builder: (context) => SuccessPopup(
                message: response.data.message ?? '',
                onOk: () {},
              ),
              barrierDismissible: false,
            );
          }
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
}
