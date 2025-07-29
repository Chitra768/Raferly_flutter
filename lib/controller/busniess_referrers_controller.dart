import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:referaly/apis/rest_auth.dart';
import 'package:referaly/languages/languagekeys.dart';
import 'package:referaly/models/model_busniess_referral_lead.dart';
import 'package:referaly/apis/api_result.dart' show ApiFailure, ApiSuccess;
import 'package:referaly/models/model_collaboratorList.dart';
import 'package:referaly/models/model_network_response.dart';
import 'package:referaly/utils/translations.dart';
import 'dart:async';

import '../models/model_common.dart';
import '../models/model_referral_list.dart';
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

  // Debounce timer for search
  Timer? _searchDebounce;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args != null) {
      referrers.value = args["coworkers"] ?? [];
    } else {
      // If no arguments, fetch data
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
    isSearching.value = false;
    arrSearchReferrers.clear();
  }

  void clearSearch() {
    searchController.clear();
    isSearching.value = false;
    arrSearchReferrers.clear();
  }

  void toggleExpand(int index) {
    expandedIndex.value = expandedIndex.value == index ? -1 : index;
  }
}
