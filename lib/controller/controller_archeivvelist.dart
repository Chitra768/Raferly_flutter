import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:referaly/apis/api_result.dart';
import 'package:referaly/apis/rest_auth.dart';
import 'package:referaly/languages/languagekeys.dart';
import 'package:referaly/models/model_archeive_receive_recover.dart';
import 'package:referaly/models/model_archive_list_receive.dart';
import 'package:referaly/models/model_archived_lead_statistics.dart';
import 'package:referaly/models/model_read_otification.dart';
import 'package:referaly/utils/translations.dart';
import 'package:referaly/widgets/dialog/success_popup.dart';

class ArcheiveListController extends GetxController {
  RxBool isAssending = false.obs;
  final Rx<ModelArchiveListReceive?> archiveList =
      Rx<ModelArchiveListReceive?>(null);
  final RxList<ArcheiveData> filteredArchiveLeads = <ArcheiveData>[].obs;
  final RxString searchQuery = ''.obs;
  final Rx<ModelArchivedLeadStatistics?> archivedLeadStatistics =
      Rx<ModelArchivedLeadStatistics?>(null);
  final RxMap<String, bool> loadingStates = <String, bool>{}.obs;
  final RxString selectedFilterType = 'all'.obs; // 'all', 'won', 'lost'

  void changeSorting() {
    isAssending.value = !isAssending.value;
  }

  var arguments = Get.arguments;
  var type = ''.obs;
  @override
  void onInit() {
    super.onInit();
    // Initial call to fetch the archive list
    arguments = Get.arguments;
    if (arguments != null && arguments is Map<String, dynamic>) {
      if (arguments['type'] != null) {
        type.value = arguments['type'] as String;
        getArchiveList();
      } else {
        getArchiveList();
      }
    } else {
      getArchiveList();
    }
    getArchivedLeadStatistics();
    readArchiveNotification();
  }

  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;
  Future<void> getArchiveList({String order = "asc", String? filterType}) async {
    try {
      isLoading.value = true;
      error.value = '';

      final response = await RESTAuth.getArchiveList(
        order: order,
        type: type.value,
        filterType: filterType ?? selectedFilterType.value,
      );

      if (response is ApiSuccess<ModelArchiveListReceive>) {
        if (response.data.status == true) {
          archiveList.value = response.data;
          _filterArchiveLeads();
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

  void setFilterType(String filterType) {
    // If clicking the same filter, reset to 'all', otherwise set the new filter
    if (selectedFilterType.value == filterType) {
      selectedFilterType.value = 'all';
    } else {
      selectedFilterType.value = filterType;
    }
    getArchiveList(order: isAssending.value ? "desc" : "asc");
  }

  final RxBool isLoadingStatistics = false.obs;
  final RxString errorStatistics = ''.obs;
  Future<void> getArchivedLeadStatistics() async {
    try {
      isLoadingStatistics.value = true;
      errorStatistics.value = '';

      final response = await RESTAuth.getArchivedLeadStatistics(
          type: type.value == "receive" ? "archived" : "sent");

      if (response is ApiSuccess<ModelArchivedLeadStatistics>) {
        if (response.data.status == true) {
          archivedLeadStatistics.value = response.data;
        } else {
          errorStatistics.value =
              response.data.message ?? tr(LanguageKeys.somethingWentWrong);
        }
      } else if (response is ApiFailure) {
        errorStatistics.value =
            response.error.message ?? tr(LanguageKeys.somethingWentWrong);
      }
    } catch (e) {
      errorStatistics.value = e.toString();
    } finally {
      isLoadingStatistics.value = false;
    }
  }

  final RxBool isLoadingRecover = false.obs;
  final RxString errorRecover = ''.obs;
  final Rx<ModelArcheiveReceiveRecover?> recoverReceivedLead =
      Rx<ModelArcheiveReceiveRecover?>(null);
  Future<void> recoverArchiveLead({required String leadId}) async {
    try {
      loadingStates[leadId] = true;
      errorRecover.value = '';

      final response = await RESTAuth.recoverArchiveLead(leadId: leadId);

      if (response is ApiSuccess<ModelArcheiveReceiveRecover>) {
        if (response.data.status == true) {
          recoverReceivedLead.value = response.data;
          if (Get.context != null) {
            showDialog(
              context: Get.context!,
              builder: (context) => SuccessPopup(
                message: recoverReceivedLead.value?.message ?? '',
                onOk: () {
                  Get.back();
                },
              ),
              barrierDismissible: false,
            );
          }
        } else {
          errorRecover.value =
              response.data.message ?? tr(LanguageKeys.leadRecoveredFailed);
        }
      } else if (response is ApiFailure) {
        errorRecover.value =
            response.error.message ?? tr(LanguageKeys.leadRecoveredFailed);
      }
    } catch (e) {
      error.value = e.toString();
    } finally {
      loadingStates[leadId] = false;
    }
  }

  Future<void> readArchiveNotification() async {
    try {
      isLoading.value = true;
      error.value = '';

      final response = await RESTAuth.readNotification(type: "archived");

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

  void updateSearchQuery(String query) {
    searchQuery.value = query;
    _filterArchiveLeads();
  }

  void _filterArchiveLeads() {
    final allLeads = archiveList.value?.data ?? [];
    if (allLeads.isEmpty) {
      filteredArchiveLeads.clear();
      return;
    }

    final query = searchQuery.value.trim().toLowerCase();
    if (query.isEmpty) {
      filteredArchiveLeads.assignAll(allLeads);
      return;
    }

    filteredArchiveLeads.assignAll(allLeads.where((lead) {
      final leadName =
          _normalize('${lead.firstName ?? ''} ${lead.lastName ?? ''}');
      final referrerName =
          _normalize('${lead.user?.firstName ?? ''} ${lead.user?.lastName ?? ''}');
      final companyName = _normalize(lead.user?.companyName);
      return leadName.contains(query) ||
          referrerName.contains(query) ||
          companyName.contains(query);
    }).toList());
  }

  String _normalize(String? value) {
    if (value == null) return '';
    final normalized = value.trim().toLowerCase();
    if (normalized == 'null') {
      return '';
    }
    return normalized;
  }
}
