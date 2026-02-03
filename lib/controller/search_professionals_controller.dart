import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:referaly/apis/api_result.dart';
import 'package:referaly/apis/rest_auth.dart';
import 'package:referaly/models/model_common.dart';
import 'package:referaly/models/model_ongoing_requests.dart';
import 'package:referaly/models/model_finder_suggestions.dart';
import 'package:referaly/languages/languagekeys.dart';
import 'package:referaly/utils/translations.dart';

class SearchProfessionalsController extends GetxController {
  final RxInt selectedTab = 1.obs; // 0 = Matchmaking, 1 = Search Professionals
  final RxString searchQuery = ''.obs;
  final RxInt availableCredits = 1.obs;
  final RxInt totalCredits = 2.obs;
  final RxBool isLoading = false.obs;
  final RxList<OngoingRequestData> ongoingRequests = <OngoingRequestData>[].obs;
  final RxString errorMessage = ''.obs;
  final RxList<FinderSuggestionData> finderSuggestions =
      <FinderSuggestionData>[].obs;
  final RxBool isLoadingSuggestions = false.obs;
  final RxString suggestionsErrorMessage = ''.obs;
  final Rxn<int> askingForNetworkingUserId = Rxn<int>(); // Track which userId is being processed
  final RxBool isRespondingToRequest = false.obs;

  Timer? _searchDebounceTimer;

  @override
  void onInit() {
    super.onInit();
    // Fetch finder suggestions when controller initializes (default tab is Search Professionals)
    fetchFinderSuggestions();
  }

  @override
  void onClose() {
    _searchDebounceTimer?.cancel();
    super.onClose();
  }

  void setSelectedTab(int tab) {
    selectedTab.value = tab;
    // Fetch ongoing requests when matchmaking tab is selected
    if (tab == 0) {
      fetchOngoingRequests();
    } else if (tab == 1) {
      // Fetch finder suggestions when search professionals tab is selected
      fetchFinderSuggestions();
    }
  }

  void setSearchQuery(String query) {
    searchQuery.value = query;
    // Debounce search API calls
    _searchDebounceTimer?.cancel();
    _searchDebounceTimer = Timer(const Duration(milliseconds: 500), () {
      fetchFinderSuggestions();
    });
  }

  void updateCredits(int available, int total) {
    availableCredits.value = available;
    totalCredits.value = total;
  }

  Future<void> fetchOngoingRequests() async {
    if (isLoading.value) return; // Prevent multiple simultaneous calls

    try {
      isLoading.value = true;
      errorMessage.value = '';

      final response = await RESTAuth.getOngoingRequests();

      if (response is ApiSuccess<ModelOngoingRequests>) {
        if (response.data.status == true) {
          ongoingRequests.value = response.data.data ?? [];
        } else {
          errorMessage.value =
              response.data.message ?? tr(LanguageKeys.somethingWentWrong);
        }
      } else if (response is ApiFailure) {
        errorMessage.value =
            response.error.message ?? tr(LanguageKeys.somethingWentWrong);
      }
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchFinderSuggestions() async {
    if (isLoadingSuggestions.value)
      return; // Prevent multiple simultaneous calls

    try {
      isLoadingSuggestions.value = true;
      suggestionsErrorMessage.value = '';

      final response = await RESTAuth.getFinderSuggestions(
        search: searchQuery.value.isNotEmpty ? searchQuery.value : null,
        limit: 10,
      );

      if (response is ApiSuccess<ModelFinderSuggestions>) {
        if (response.data.status == true) {
          finderSuggestions.value = response.data.data ?? [];
          updateCredits(response.data.pagination?.availableCredit ?? 0, response.data.pagination?.totalCredit ?? 0);
        } else {
          suggestionsErrorMessage.value =
              response.data.message ?? tr(LanguageKeys.somethingWentWrong);
        }
      } else if (response is ApiFailure) {
        suggestionsErrorMessage.value =
            response.error.message ?? tr(LanguageKeys.somethingWentWrong);
      }
    } catch (e) {
      suggestionsErrorMessage.value = e.toString();
    } finally {
      isLoadingSuggestions.value = false;
    }
  }

  Future<void> askForNetworking({required int userId}) async {
    if (askingForNetworkingUserId.value != null) {
      return; // Prevent multiple simultaneous calls
    }

    try {
      askingForNetworkingUserId.value = userId;

      final response = await RESTAuth.askForNetworking(userId: userId);

      if (response is ApiSuccess<ModelCommon>) {
        if (response.data.status == true) {
          // Show success message
          Get.snackbar(
            tr(LanguageKeys.success),
            response.data.message ?? tr(LanguageKeys.askForNetworking),
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
            colorText: Colors.white,
            duration: const Duration(seconds: 3),
          );
          // Refresh the list to update UI
          fetchFinderSuggestions();
        } else {
          // Show error message
          Get.snackbar(
            tr(LanguageKeys.error),
            response.data.message ?? tr(LanguageKeys.somethingWentWrong),
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white,
            duration: const Duration(seconds: 3),
          );
        }
      } else if (response is ApiFailure) {
        // Show error message
        Get.snackbar(
          tr(LanguageKeys.error),
          response.error.message ?? tr(LanguageKeys.somethingWentWrong),
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
        );
      }
    } catch (e) {
      // Show error message
      Get.snackbar(
        tr(LanguageKeys.error),
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
    } finally {
      askingForNetworkingUserId.value = null;
    }
  }

  Future<void> respondToFinderRequest({
    required int requestId,
    required int status, // 1 for accept, 0 for reject
  }) async {
    if (isRespondingToRequest.value)
      return; // Prevent multiple simultaneous calls

    try {
      isRespondingToRequest.value = true;

      final response = await RESTAuth.respondToFinderRequest(
        requestId: requestId,
        status: status,
      );

      if (response is ApiSuccess<ModelCommon>) {
        if (response.data.status == true) {
          // Show success message
          Get.snackbar(
            tr(LanguageKeys.success),
            response.data.message ?? 'Request processed successfully',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
            colorText: Colors.white,
            duration: const Duration(seconds: 3),
          );
          // Refresh the ongoing requests list to update UI
          fetchOngoingRequests();
        } else {
          // Show error message
          Get.snackbar(
            tr(LanguageKeys.error),
            response.data.message ?? tr(LanguageKeys.somethingWentWrong),
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white,
            duration: const Duration(seconds: 3),
          );
        }
      } else if (response is ApiFailure) {
        // Show error message
        Get.snackbar(
          tr(LanguageKeys.error),
          response.error.message ?? tr(LanguageKeys.somethingWentWrong),
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
        );
      }
    } catch (e) {
      // Show error message
      Get.snackbar(
        tr(LanguageKeys.error),
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
    } finally {
      isRespondingToRequest.value = false;
    }
  }
}
