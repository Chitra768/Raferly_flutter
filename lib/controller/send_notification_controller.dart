import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:referaly/apis/api_result.dart';
import 'package:referaly/apis/rest_auth.dart';
import 'package:referaly/languages/languagekeys.dart';
import 'package:referaly/models/model_common.dart';
import 'package:referaly/models/model_coworkerlist_deal.dart';
import 'package:referaly/models/model_network_response.dart';
import 'package:referaly/widgets/dialog/success_popup.dart';
import 'package:referaly/widgets/send_notification/notification_deal_picker_sheet.dart';
import 'package:referaly/widgets/send_notification/notification_user_picker_sheet.dart';
import 'package:referaly/utils/translations.dart';

enum SendNotificationRecipientMode {
  allNetwork,
  specificDeals,
  specificUsers,
}

class SendNotificationController extends GetxController {
  static const int titleMax = 60;
  static const int descMax = 300;

  final formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  final RxBool isLoading = false.obs;
  final RxInt titleLen = 0.obs;
  final RxInt descLen = 0.obs;

  final Rx<SendNotificationRecipientMode> recipientMode =
      SendNotificationRecipientMode.allNetwork.obs;

  final RxList<CoworkerlistDealData> deals = <CoworkerlistDealData>[].obs;
  final RxList<int> selectedDealIds = <int>[].obs;

  final RxList<BusinessReferrers> activeReferrers = <BusinessReferrers>[].obs;
  final RxList<int> selectedUserIds = <int>[].obs;

  final RxBool dealsLoading = false.obs;
  final RxBool referrersLoading = false.obs;

  final RxString error = ''.obs;

  void _syncLengths() {
    titleLen.value = titleController.text.length;
    descLen.value = descriptionController.text.length;
  }

  @override
  void onInit() {
    super.onInit();
    titleController.addListener(_syncLengths);
    descriptionController.addListener(_syncLengths);
    _syncLengths();
  }

  @override
  void onClose() {
    titleController.removeListener(_syncLengths);
    descriptionController.removeListener(_syncLengths);
    titleController.dispose();
    descriptionController.dispose();
    super.onClose();
  }

  void setRecipientMode(SendNotificationRecipientMode mode) {
    recipientMode.value = mode;
    if (mode == SendNotificationRecipientMode.allNetwork) {
      selectedDealIds.clear();
      selectedUserIds.clear();
      return;
    }
    if (mode == SendNotificationRecipientMode.specificDeals) {
      selectedUserIds.clear();
      openDealPicker();
      return;
    }
    if (mode == SendNotificationRecipientMode.specificUsers) {
      selectedDealIds.clear();
      openUserPicker();
    }
  }

  /// Re-open picker when user taps the same mode row (e.g. to edit deals).
  void reopenPickerForCurrentMode() {
    if (recipientMode.value == SendNotificationRecipientMode.specificDeals) {
      openDealPicker();
    } else if (recipientMode.value ==
        SendNotificationRecipientMode.specificUsers) {
      openUserPicker();
    }
  }

  Future<void> loadDeals() async {
    dealsLoading.value = true;
    error.value = '';
    try {
      final response = await RESTAuth.getUserDealList();
      if (response is ApiSuccess<ModelCoworkerlistDeal>) {
        if (response.data.status == true) {
          deals.assignAll(response.data.data ?? []);
        }
      } else if (response is ApiFailure) {
        error.value = response.error.message ?? '';
      }
    } catch (e) {
      error.value = e.toString();
    } finally {
      dealsLoading.value = false;
    }
  }

  Future<void> loadActiveReferrers() async {
    referrersLoading.value = true;
    error.value = '';
    try {
      final response = await RESTAuth.getNetworkList();
      if (response is ApiSuccess<ModelNetworkResponse>) {
        if (response.data.status == true) {
          final list = response.data.data?.businessReferrers ?? [];
          activeReferrers.assignAll(
            list.where((b) => !(b.isPendingInvitation ?? false)).toList(),
          );
        }
      } else if (response is ApiFailure) {
        error.value = response.error.message ?? '';
      }
    } catch (e) {
      error.value = e.toString();
    } finally {
      referrersLoading.value = false;
    }
  }

  Future<void> openDealPicker() async {
    final ctx = Get.context;
    if (ctx == null) return;
    await loadDeals();
    if (!ctx.mounted) return;
    await showModalBottomSheet<void>(
      context: ctx,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetCtx) => NotificationDealPickerSheet(
        deals: List<CoworkerlistDealData>.from(deals),
        initialSelectedIds: List<int>.from(selectedDealIds),
        onApply: (ids) {
          selectedDealIds.assignAll(ids);
        },
      ),
    );
  }

  Future<void> openUserPicker() async {
    final ctx = Get.context;
    if (ctx == null) return;
    await loadActiveReferrers();
    if (!ctx.mounted) return;
    await showModalBottomSheet<void>(
      context: ctx,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetCtx) => NotificationUserPickerSheet(
        referrers: List<BusinessReferrers>.from(activeReferrers),
        initialSelectedIds: List<int>.from(selectedUserIds),
        onApply: (ids) {
          selectedUserIds.assignAll(ids);
        },
      ),
    );
  }

  String recipientSummaryText() {
    switch (recipientMode.value) {
      case SendNotificationRecipientMode.allNetwork:
        return tr(LanguageKeys.sendNotifSummaryAll);
      case SendNotificationRecipientMode.specificDeals:
        if (selectedDealIds.isEmpty) {
          return tr(LanguageKeys.sendNotifSummaryEmpty);
        }
        return tr(LanguageKeys.sendNotifSummaryDeals)
            .replaceFirst('%s', '${selectedDealIds.length}');
      case SendNotificationRecipientMode.specificUsers:
        if (selectedUserIds.isEmpty) {
          return tr(LanguageKeys.sendNotifSummaryEmpty);
        }
        return tr(LanguageKeys.sendNotifSummaryUsers)
            .replaceFirst('%s', '${selectedUserIds.length}');
    }
  }

  String? validateTitle(String? v) {
    if (v == null || v.trim().isEmpty) {
      return tr(LanguageKeys.sendNotifTitleRequired);
    }
    return null;
  }

  String? validateDescription(String? v) {
    if (v == null || v.trim().isEmpty) {
      return tr(LanguageKeys.sendNotifDescRequired);
    }
    return null;
  }

  bool _validateRecipients() {
    switch (recipientMode.value) {
      case SendNotificationRecipientMode.allNetwork:
        return true;
      case SendNotificationRecipientMode.specificDeals:
        if (selectedDealIds.isEmpty) {
          Get.snackbar(
            tr(LanguageKeys.error),
            tr(LanguageKeys.sendNotifSelectDealsError),
            snackPosition: SnackPosition.BOTTOM,
          );
          return false;
        }
        return true;
      case SendNotificationRecipientMode.specificUsers:
        if (selectedUserIds.isEmpty) {
          Get.snackbar(
            tr(LanguageKeys.error),
            tr(LanguageKeys.sendNotifSelectUsersError),
            snackPosition: SnackPosition.BOTTOM,
          );
          return false;
        }
        return true;
    }
  }

  Future<void> _onSendSuccess(String? message) async {
    if (Get.context != null) {
      await showDialog<void>(
        context: Get.context!,
        barrierDismissible: false,
        builder: (context) => SuccessPopup(
          message: message ?? '',
          onOk: () {
            Get.back();
          },
        ),
      );
    }
  }

  Future<void> submit() async {
    FocusManager.instance.primaryFocus?.unfocus();
    if (!(formKey.currentState?.validate() ?? false)) return;
    if (!_validateRecipients()) return;

    final title = titleController.text.trim();
    final description = descriptionController.text.trim();

    isLoading.value = true;
    error.value = '';
    try {
      switch (recipientMode.value) {
        case SendNotificationRecipientMode.allNetwork:
          // "All users" = send to every deal the user owns.
          // Load fresh deal list, then fire sendNotificationInDeals with all ids.
          await loadDeals();
          final allDealIds =
              deals.map((d) => d.id.toString()).toList();
          if (allDealIds.isEmpty) {
            Get.snackbar(
              tr(LanguageKeys.error),
              tr(LanguageKeys.sendNotifNoDeals),
              snackPosition: SnackPosition.BOTTOM,
            );
            return;
          }
          await sendNotificationInDeals(allDealIds);
          break;
        case SendNotificationRecipientMode.specificDeals:
          await sendNotificationInDeals(
            selectedDealIds.map((e) => e.toString()).toList(),
          );
          break;
        case SendNotificationRecipientMode.specificUsers:
          final userRes =
              await RESTAuth.sendNotificationToBusinessReferrers(
            title,
            description,
            List<int>.from(selectedUserIds),
          );
          if (userRes is ApiSuccess<ModelCommon>) {
            if (userRes.data.status == true) {
              await _onSendSuccess(userRes.data.message);
            } else {
              Get.snackbar(
                tr(LanguageKeys.error),
                userRes.data.message ?? tr(LanguageKeys.sendNotifApiError),
                snackPosition: SnackPosition.BOTTOM,
              );
            }
          } else if (userRes is ApiFailure) {
            Get.snackbar(
              tr(LanguageKeys.error),
              userRes.error.message ?? tr(LanguageKeys.sendNotifApiError),
              snackPosition: SnackPosition.BOTTOM,
            );
          }
          break;
      }
    } catch (e) {
      error.value = e.toString();
      Get.snackbar(
        tr(LanguageKeys.error),
        tr(LanguageKeys.sendNotifApiError),
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> sendNotificationInDeals(List<String> id) async {
    try {
      isLoading.value = true;
      error.value = '';

      final response = await RESTAuth.sendNotificationInDeals(
        titleController.text.trim(),
        descriptionController.text.trim(),
        id,
      );
      if (response is ApiSuccess<ModelCommon>) {
        if (response.data.status == true) {
          await _onSendSuccess(response.data.message);
        } else {
          Get.snackbar(
            tr(LanguageKeys.error),
            response.data.message ?? tr(LanguageKeys.sendNotifApiError),
            snackPosition: SnackPosition.BOTTOM,
          );
        }
      } else if (response is ApiFailure) {
        Get.snackbar(
          tr(LanguageKeys.error),
          response.error.message ?? tr(LanguageKeys.sendNotifApiError),
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      error.value = e.toString();
      Get.snackbar(
        tr(LanguageKeys.error),
        tr(LanguageKeys.sendNotifApiError),
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
