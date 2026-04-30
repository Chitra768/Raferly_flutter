import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:referaly/apis/rest_auth.dart';
import 'package:referaly/languages/languagekeys.dart';
import 'package:referaly/apis/api_result.dart' show ApiFailure, ApiSuccess;
import 'package:referaly/models/model_network_response.dart';
import 'package:referaly/utils/translations.dart';
import 'dart:async';

import '../models/model_common.dart';
import '../resources/app_log.dart';
import '../widgets/dialog/success_popup.dart';

class BusinessReferrersController extends GetxController {
  RxList<BusinessReferrers> referrers = <BusinessReferrers>[].obs;
  RxList<BusinessReferrers> arrSearchReferrers = <BusinessReferrers>[].obs;
  RxBool isLoading = false.obs;
  RxString error = ''.obs;
  RxInt expandedIndex = (-1).obs;
  TextEditingController searchController = TextEditingController();
  List<String> id = [];
  var isSearching = false.obs;
  final RxString filterBy = ''.obs;
  final RxString searchText = ''.obs;

  // Debounce timer for search
  Timer? _searchDebounce;

  @override
  void onInit() {
    AppLog.d("BusinessReferrersController onInit");
    super.onInit();
    final args = Get.arguments;
    if (args != null) {
      referrers.value = args["coworkers"] ?? [];
      // Refresh from API so filter can work reliably.
      unawaited(fetchReferrers());
    } else {
      // If no arguments, fetch data
      unawaited(fetchReferrers());
    }
  }

  @override
  void onClose() {
    _searchDebounce?.cancel();
    searchController.dispose();
    super.onClose();
  }

  void onSearchChanged(String value) {
    // Cancel previous timer
    _searchDebounce?.cancel();
    searchText.value = value;

    if (value.isEmpty) {
      isSearching.value = false;
      arrSearchReferrers.clear();
      print("Search cleared - showing all referrers");
      return;
    }

    // Set a small delay to avoid excessive filtering
    _searchDebounce = Timer(const Duration(milliseconds: 300), () {
      isSearching.value = true;

      // Perform local search
      final searchQuery = value.toLowerCase().trim();
      print("Searching for: '$searchQuery' in ${referrers.length} referrers");

      final filteredList = referrers.where((referrer) {
        // Search in first name
        final firstName = referrer.firstName?.toLowerCase() ?? '';
        if (firstName.contains(searchQuery)) {
          print("Found match in firstName: ${referrer.firstName}");
          return true;
        }

        // Search in last name
        final lastName = referrer.lastName?.toLowerCase() ?? '';
        if (lastName.contains(searchQuery)) {
          print("Found match in lastName: ${referrer.lastName}");
          return true;
        }

        // Search in full name
        final fullName =
            '${referrer.firstName ?? ''} ${referrer.lastName ?? ''}'
                .toLowerCase()
                .trim();
        if (fullName.contains(searchQuery)) {
          print("Found match in fullName: $fullName");
          return true;
        }

        // Search in email
        final email = referrer.email?.toLowerCase() ?? '';
        if (email.contains(searchQuery)) {
          print("Found match in email: ${referrer.email}");
          return true;
        }

        // Search in phone number
        final phone = referrer.phoneNumber?.toLowerCase() ?? '';
        if (phone.contains(searchQuery)) {
          print("Found match in phone: ${referrer.phoneNumber}");
          return true;
        }

        return false;
      }).toList();

      arrSearchReferrers.value = filteredList;
      print("Search completed - found ${filteredList.length} results");
    });
  }

  void refreshList() {
    searchController.clear();
    searchText.value = '';
    isSearching.value = false;
    arrSearchReferrers.clear();
  }

  void clearSearch() {
    searchController.clear();
    searchText.value = '';
    isSearching.value = false;
    arrSearchReferrers.clear();
  }

  void toggleExpand(int index) {
    expandedIndex.value = expandedIndex.value == index ? -1 : index;
  }

  int activeCount() => referrers.where((b) => !(b.isPendingInvitation ?? false)).length;
  int pendingCount() => referrers.where((b) => b.isPendingInvitation ?? false).length;

  Future<void> setFilterBy(String value) async {
    filterBy.value = value.trim();
    await fetchReferrers();
  }

  Future<void> fetchReferrers() async {
    try {
      isLoading.value = true;
      error.value = '';

      final response = await RESTAuth.getNetworkList(filterBy: filterBy.value);
      if (response is ApiSuccess<ModelNetworkResponse>) {
        if (response.data.status == true) {
          final list = response.data.data?.businessReferrers ?? <BusinessReferrers>[];
          referrers.value = list;
          if (isSearching.value) {
            onSearchChanged(searchController.text);
          } else {
            arrSearchReferrers.clear();
          }
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

  final RxBool isDeleting = false.obs;
  final RxString deleteError = ''.obs;

  Future<void> deleteBusinessReferrer(int refererId) async {
    try {
      isDeleting.value = true;
      deleteError.value = '';

      final response = await RESTAuth.deleteNetwork(refererId: refererId);
      if (response is ApiSuccess<ModelCommon>) {
        if (response.data.status == true) {
          // Remove the referrer from the list
          referrers.removeWhere((referrer) => referrer.id == refererId);
          arrSearchReferrers.removeWhere((referrer) => referrer.id == refererId);
          
          if (Get.context != null) {
            await showDialog(
              context: Get.context!,
              builder: (context) => SuccessPopup(
                message: response.data.message ?? 'Network deleted successfully',
                onOk: () {},
              ),
              barrierDismissible: false,
            );
          }
        } else {
          deleteError.value =
              response.data.message ?? tr(LanguageKeys.somethingWentWrong);
        }
      } else if (response is ApiFailure) {
        deleteError.value =
            response.error.message ?? tr(LanguageKeys.somethingWentWrong);
      }
    } catch (e) {
      deleteError.value = e.toString();
    } finally {
      isDeleting.value = false;
    }
  }
}
