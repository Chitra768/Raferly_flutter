import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:referaly/apis/rest_auth.dart';
import 'package:referaly/languages/languagekeys.dart';
import 'package:referaly/models/model_busniess_referral_lead.dart';
import 'package:referaly/apis/api_result.dart' show ApiFailure, ApiSuccess;
import 'package:referaly/models/model_collaboratorList.dart';
import 'package:referaly/utils/translations.dart';

import '../models/model_common.dart';
import '../models/model_referral_list.dart';
import '../widgets/dialog/success_popup.dart';

class ReferrersController extends GetxController {
  RxList<ReferrelData> referrers = <ReferrelData>[].obs;
  RxBool isLoading = false.obs;
  RxString error = ''.obs;
  RxInt expandedIndex = (-1).obs;
  TextEditingController searchController = TextEditingController();
  List<String> id = [];
  var isSearching = false.obs;
  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args != null) {
      // referrers.value = args["coworkers"] ?? [];
      id = args["id"] ?? [];
      fetchReferrers(search: "");
    }
    // fetchReferrers();
  }

  Future<ModelReferralList?> fetchReferrers({
    String search = '',
  }) async {
    isLoading.value = true;
    error.value = '';
    try {
      final response = await RESTAuth.getCoworkerSearchList(search, id);
      if (response != null) {
        referrers.value = response.data ?? [];
      }
      return response;
      // if (response.status == true) {
      //   referrers.value = response.data ?? [];
      // } else if (response is ApiFailure) {
      //   // error.value = response.error.message ?? tr(LanguageKeys.somethingWentWrong);
      // }
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addCoworker({
    String userID = '',
  }) async {
    error.value = '';
    try {
      final response = await RESTAuth.addCoworker(userID, id);
      if (response is ApiSuccess<ModelCommon>) {
        if (Get.context != null) {
          showDialog(
            context: Get.context!,
            builder: (context) => SuccessPopup(
              message: response.data.message ?? '',
              onOk: () {
              },
            ),
            barrierDismissible: false,
          );
        }
      } else if (response is ApiFailure) {
        error.value =
            response.error.message ?? tr(LanguageKeys.somethingWentWrong);
      }
    } catch (e) {
      error.value = e.toString();
    } finally {}
  }

  Future<void> deleteCoworker({
    String userID = '',
  }) async {
    error.value = '';
    try {
      final response = await RESTAuth.deleteCoworker(userID);
      if (response is ApiSuccess<ModelReferralList>) {
        if (Get.context != null) {
          showDialog(
            context: Get.context!,
            builder: (context) => SuccessPopup(
              message: response.data.message ?? '',
              onOk: () {
                Get.back();
              },
            ),
            barrierDismissible: false,
          );
        }
      } else if (response is ApiFailure) {
        error.value =
            response.error.message ?? tr(LanguageKeys.somethingWentWrong);
      }
    } catch (e) {
      error.value = e.toString();
    } finally {}
  }

  void onSearchChanged(String value) {
    fetchReferrers(search: value);
  }

  void refreshList() {
    searchController.clear();
    fetchReferrers(search: '');
  }

  void clearSearch() {
    searchController.clear();
    fetchReferrers(search: '');
  }

  void toggleExpand(int index) {
    expandedIndex.value = expandedIndex.value == index ? -1 : index;
  }
}
