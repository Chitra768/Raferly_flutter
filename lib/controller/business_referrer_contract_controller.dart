import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http show get;
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:referaly/apis/api_result.dart';
import 'package:referaly/apis/rest_auth.dart';
import 'package:referaly/languages/languagekeys.dart';
import 'package:referaly/models/model_contact_response.dart';
import 'package:referaly/models/model_create_deal.dart';
import 'package:referaly/utils/translations.dart';
import 'package:referaly/widgets/dialog/success_popup.dart';

class BusinessReferrerContractController extends GetxController {
  // Observable variables
  final RxString dealName = ''.obs;
  final RxBool isUniqueCommission = true.obs;
  final RxString selectedCommissionOption =
      tr(LanguageKeys.chooseOneoption).obs;
  final RxBool isGenerateContract = true.obs;
  final RxString dealId = ''.obs; // Add dealId for edit mode
  final commissionValueController = TextEditingController();
  // Track name and stage tracking
  final RxString trackName = 'Contact called'.obs;

  // Completion stages
  final RxBool isContractSigned = false.obs;
  final RxBool isServiceDelivered = false.obs;
  final RxBool isPaymentReceived = false.obs;
  final RxBool isCommissionPaid = false.obs;

  // Validation
  final RxBool isDealNameValid = false.obs;

  // Text controllers
  final TextEditingController dealNameController = TextEditingController();

  /// Dynamic text fields for custom entries
  final RxList<TextEditingController> dynamicFields = <TextEditingController>[
    TextEditingController(text: tr(LanguageKeys.contactCalled)),
    TextEditingController(text: tr(LanguageKeys.contractSigned)),
    TextEditingController(text: tr(LanguageKeys.serviceDeleiverd)),
    TextEditingController(text: tr(LanguageKeys.paymentReceived)),
  ].obs;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args is Map<String, dynamic>) {
      // Edit mode
      dealId.value = args['deal_id']?.toString() ?? '';
      dealNameController.text = args['deal_name'] ?? '';
      selectedCommissionOption.value =
          mapApiCommissionTypeToUi(args['commission_type'] ?? '');

      // Set track names if provided for edit mode
      if (args['track_names'] != null && args['track_names'] is List) {
        dynamicFields.clear();
        for (var trackName in args['track_names']) {
          dynamicFields.add(TextEditingController(text: trackName));
        }
      }
    } else {
      // New deal mode - set default track names
      dynamicFields.clear();
      dynamicFields.addAll([
        TextEditingController(text: tr(LanguageKeys.contactCalled)),
        TextEditingController(text: tr(LanguageKeys.contractSigned)),
        TextEditingController(text: tr(LanguageKeys.serviceDeleiverd)),
        TextEditingController(text: tr(LanguageKeys.paymentReceived)),
      ]);
    }
  }

  @override
  void onClose() {
    for (var ctrl in dynamicFields) {
      ctrl.dispose();
    }
    dynamicFields.clear();
    dealNameController.dispose();
    super.onClose();
  }

  // Validate deal name
  void _validateDealName() {
    dealName.value = dealNameController.text;
    isDealNameValid.value = dealNameController.text.isNotEmpty;
  }

  // Toggle commission type
  void toggleCommissionType(bool isUnique) {
    isUniqueCommission.value = isUnique;
  }

  // Map API commission type to UI value
  String mapApiCommissionTypeToUi(String apiType) {
    switch (apiType.toLowerCase()) {
      case 'fix_commission':
        return tr(LanguageKeys.fix_commission);
      case 'no_commission':
        return tr(LanguageKeys.no_commission);
      default:
        return tr(LanguageKeys.percentage_commission);
    }
  }

  // Map UI commission type to API value
  String mapUiCommissionTypeToApi(String uiType) {
    if (uiType == tr(LanguageKeys.fix_commission)) {
      return 'fix_commission';
    } else if (uiType == tr(LanguageKeys.no_commission)) {
      return 'no_commission';
    } else {
      return 'percentage_commission';
    }
  }

  // Set commission option
  void setCommissionOption(String option) {
    selectedCommissionOption.value = option;
  }

  // Toggle contract generation type
  void toggleContractGeneration(bool isGenerate) {
    isGenerateContract.value = isGenerate;
  }

  // Update track name
  void updateTrackName(String name) {
    trackName.value = name;
  }

  // Toggle completion stages
  void toggleContractSigned() {
    isContractSigned.value = !isContractSigned.value;
  }

  void toggleServiceDelivered() {
    isServiceDelivered.value = !isServiceDelivered.value;
  }

  void togglePaymentReceived() {
    isPaymentReceived.value = !isPaymentReceived.value;
  }

  void toggleCommissionPaid() {
    isCommissionPaid.value = !isCommissionPaid.value;
  }

  // Check if form is valid for submission
  bool isFormValid() {
    return isDealNameValid.value;
  }

  // Submit deal
  void submitDeal() {
    if (dealId.value.isNotEmpty) {
      updateDeal();
    } else {
      createDeal();
    }
  }

  /// Add a new dynamic text field
  void addDynamicField() {
    dynamicFields.add(TextEditingController());
  }

  /// Remove a dynamic text field at [index]
  void removeDynamicField(int index) {
    if (index >= 0 && index < dynamicFields.length) {
      dynamicFields[index].dispose();
      dynamicFields.removeAt(index);
    }
  }

  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final RxList<ModelCreateDeal> dealList = <ModelCreateDeal>[].obs;
  final RxString dealError = ''.obs;

  Future<void> createDeal() async {
    isLoading.value = true;
    errorMessage.value = '';

    List<String> trackNameList =
        dynamicFields.map((field) => field.text).toList();

    String commissionType =
        mapUiCommissionTypeToApi(selectedCommissionOption.value);

    try {
      final response = await RESTAuth.createDeal(
        dealNameController.text,
        commissionType,
        dynamicFields.map((field) => field.text).join(', '),
        trackNameList,
        commissionValueController.text,
      );

      if (response is ApiSuccess<ModelCreateDeal>) {
        if (response.data.status == true) {
          dealList.add(response.data);
          // Refresh deals list
          // Show success popup
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
        } else {
          dealError.value = response.data.message ?? 'Failed to get Leads';
        }
      } else if (response is ApiFailure) {
        dealError.value = response.error.message ?? 'Something went wrong';
      }
    } catch (e) {
      errorMessage.value = 'An unexpected error occurred';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateDeal() async {
    isLoading.value = true;
    errorMessage.value = '';

    List<String> trackNameList =
        dynamicFields.map((field) => field.text).toList();

    try {
      final response = await RESTAuth.updateDeal(
        dealNameController.text,
        mapUiCommissionTypeToApi(selectedCommissionOption.value),
        dynamicFields.value.map((field) => field.text).join(', '),
        trackNameList,
        dealId.value,
      );

      if (response is ApiSuccess<ModelCreateDeal>) {
        if (response.data.status == true) {
          Get.back();
        } else {
          dealError.value = response.data.message ?? 'Failed to update deal';
        }
      } else if (response is ApiFailure) {
        dealError.value = response.error.message ?? 'Something went wrong';
      }
    } catch (e) {
      errorMessage.value = 'An unexpected error occurred';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> downloadAndOpenPdf(String url) async {
    try {
      final response = await http.get(Uri.parse(url));
      final tempDir = await getTemporaryDirectory();
      final file = File('${tempDir.path}/temp.pdf');
      await file.writeAsBytes(response.bodyBytes);

      final result = await OpenFilex.open(file.path);

      if (result.type != ResultType.done) {
        // handle error
        debugPrint('Failed to open: ${result.message}');
      }
    } catch (e) {
      debugPrint('Error: $e');
    }
  }
}
