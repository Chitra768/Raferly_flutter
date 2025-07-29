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
  RxList<CoworkerlistData> referrers = <CoworkerlistData>[].obs;
  RxList<ReferrelData> arrSearchReferrers = <ReferrelData>[].obs;
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
      referrers.value = args["coworkers"] ?? [];
      id = args["id"] ?? [];
      // If no initial data, fetch it
      if (referrers.isEmpty) {
        fetchReferrers(search: "");
      }
    } else {
      // If no arguments, fetch data
      fetchReferrers(search: "");
    }
  }

  Future<ModelReferralList?> fetchReferrers({
    String search = '',
  }) async {
    isLoading.value = true;
    error.value = '';
    try {
      if (search.isEmpty) {
        // If search is empty, call getAgencyCoworkerList
        await getAgencyCoworkerList(id);
        return null;
      } else {
        // If search has content, call the search API
        final response = await RESTAuth.getCoworkerSearchList(search, id);
        if (response != null) {
          arrSearchReferrers.value = response.data ?? [];
          print("Search results: ${arrSearchReferrers.length} items");
        }
        return response;
      }
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> getAgencyCoworkerList(List<String> id) async {
    try {
      isLoading.value = true;
      error.value = '';

      final response = await RESTAuth.getAgencyCoworkerList(id);
      if (response is ApiSuccess<CollaboratorListModel>) {
        if (response.data.status == true) {
          referrers.value = response.data.data ?? [];
          print("Regular results: ${referrers.length} items");
        } else {}
      } else if (response is ApiFailure) {}
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
              onOk: () {},
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
      if (response is ApiSuccess<ModelCommon>) {
        if (Get.context != null) {
          showDialog(
            context: Get.context!,
            builder: (context) => SuccessPopup(
              message: response.data.message ?? '',
              onOk: () async {
                await getAgencyCoworkerList(id);
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
    if (value.length > 3) {
      isSearching.value = true;
      fetchReferrers(search: value);
    } else if (value.isEmpty) {
      isSearching.value = false;
      fetchReferrers(search: '');
    } else {
      // For 1-3 characters, just update the search state but don't trigger API call
      // isSearching.value = false;
    }
  }

  void refreshList() {
    searchController.clear();
    isSearching.value = false;
    fetchReferrers(search: '');
  }

  void clearSearch() {
    searchController.clear();
    isSearching.value = false;
    fetchReferrers(search: '');
  }

  void toggleExpand(int index) {
    expandedIndex.value = expandedIndex.value == index ? -1 : index;
  }
}
