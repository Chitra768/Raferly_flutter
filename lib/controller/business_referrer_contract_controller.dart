import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http show get;
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:referaly/apis/api_result.dart';
import 'package:referaly/apis/rest_auth.dart';
import 'package:referaly/languages/languagekeys.dart';
import 'package:referaly/models/model_contact_response.dart'
    as ModelContactResponse;
import 'package:referaly/models/model_create_deal.dart' as ModelCreateDeal;
import 'package:referaly/resources/app_helper.dart';
import 'package:referaly/utils/translations.dart';
import 'package:referaly/widgets/dialog/success_popup.dart';
import 'package:referaly/resources/app_preference.dart';

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
  File? contractFile;

  // Validation
  final RxBool isDealNameValid = false.obs;

  // Text controllers
  final TextEditingController dealNameController = TextEditingController();
  List<BusinessDealSteps>? dealSteps = [];

  /// Dynamic text fields for custom entries
  final RxList<TextEditingController> dynamicFields = <TextEditingController>[
    TextEditingController(text: tr(LanguageKeys.contactCalled)),
    TextEditingController(text: tr(LanguageKeys.contractSigned)),
    TextEditingController(text: tr(LanguageKeys.serviceDeleiverd)),
    TextEditingController(text: tr(LanguageKeys.paymentReceived)),
  ].obs;
  String selectedProgramType = tr(LanguageKeys.businessReferralProgram);

  final TextEditingController customProgramNameController =
  TextEditingController();
  RxBool isEditMode = false.obs;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args is Map<String, dynamic>) {
      // Edit mode
      isEditMode.value = args['is_edit'] ?? false;
      dealId.value = args['deal_id']?.toString() ?? '';
      AppHelper.showLog("deal_name: ${args['deal_name']}");
      selectedProgramType = (args['deal_name'] == tr(LanguageKeys.businessReferralProgram) ||
          args['deal_name'] == tr(LanguageKeys.ambassadorProgram))
          ? args['deal_name']
          : tr(LanguageKeys.writeACustomName);
      dealNameController.text = args['deal_name'] ?? '';
      commissionValueController.text = args['commission_value'] ?? '';
      selectedCommissionOption.value =
          mapApiCommissionTypeToUi(args['commission_type'] ?? '');

      // Set track names if provided for edit mode
      if (args['track_names'] != null && args['track_names'] is List) {
        final List<dynamic> trackNamesList =
            args['track_names'] as List<dynamic>;
        dealSteps = trackNamesList.map((e) {
          if (e is Map<String, dynamic>) {
            return BusinessDealSteps.fromJson(e);
          } else if (e is ModelContactResponse.DealSteps) {
            return BusinessDealSteps(
              id: e.id,
              dealId: e.dealId,
              name: e.name,
              createdAt: e.createdAt,
              updatedAt: e.updatedAt,
              deletedAt: e.deletedAt,
            );
          }
          return BusinessDealSteps(name: e.toString());
        }).toList();

        // Update dynamic fields with the track names
        dynamicFields.clear();
        for (var step in dealSteps!) {
          dynamicFields.add(TextEditingController(text: step.name));
        }
      }
    } else {


     dealNameController.text = selectedProgramType;
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
  final RxList<ModelCreateDeal.ModelCreateDeal> dealList =
      <ModelCreateDeal.ModelCreateDeal>[].obs;
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
        pdfFile: contractFile,
      );

      if (response is ApiSuccess<ModelCreateDeal.ModelCreateDeal>) {
        AppHelper.showLog("response.data.status: ${response.data.status}");
        if (response.data.status == true) {
          dealList.add(response.data);
          commissionValueController.text = '';
          // Refresh deals list
          // Show success popup
          if (Get.context != null) {
            showDialog(
              context: Get.context!,
              builder: (context) => SuccessPopup(
                message: response.data.message ?? '',
                onOk: () {
                  Get.back(result: true);
                },
              ),
              barrierDismissible: false,
            );
          }
        } else {
          AppHelper.showLog("response.data.message: ${response.data.message}");
          dealError.value = response.data.message ?? '';
          if (Get.context != null) {
            showDialog(
              context: Get.context!,
              builder: (context) => SuccessPopup(
                message: response.data.message ?? '',
                onOk: () {
                  Get.back(result: true);
                },
              ),
              barrierDismissible: false,
            );
          }
        }
      } else if (response is ApiFailure) {
        dealError.value = tr(LanguageKeys.dealCreatedFailed) ??
            tr(LanguageKeys.dealCreatedFailed);
      }
    } catch (e) {
      errorMessage.value = tr(LanguageKeys.dealCreatedFailed);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateDeal() async {
    isLoading.value = true;
    errorMessage.value = '';

    List<String> trackNameList =
        dynamicFields.map((field) => field.text).toList();
    String commissionType =
        mapUiCommissionTypeToApi(selectedCommissionOption.value);
    try {
      final response = await RESTAuth.updateDeal(
        dealNameController.text,
        commissionType,
        "description",
        dealId.value,
        commissionValueController.text,
        dealSteps ?? [],
      );

      if (response is ApiSuccess<ModelCreateDeal.ModelCreateDeal>) {
        if (response.data.status == true) {
          commissionValueController.text = '';
          // Get.back();
          if (Get.context != null) {
            showDialog(
              context: Get.context!,
              builder: (context) => SuccessPopup(
                message: response.data.message ?? '',
                onOk: () {
                  Get.back(result: true);
                },
              ),
            );
          }
        } else {
          dealError.value =
              response.data.message ?? tr(LanguageKeys.somethingWentWrong);
        }
      } else if (response is ApiFailure) {
        dealError.value =
            response.error.message ?? tr(LanguageKeys.somethingWentWrong);
      }
    } catch (e) {
      errorMessage.value = tr(LanguageKeys.somethingWentWrong);
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

class BusinessDealSteps {
  int? id;
  int? dealId;
  String? name;
  String? createdAt;
  String? updatedAt;
  Null? deletedAt;

  BusinessDealSteps(
      {this.id,
      this.dealId,
      this.name,
      this.createdAt,
      this.updatedAt,
      this.deletedAt});

  BusinessDealSteps.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    dealId = json['deal_id'];
    name = json['name'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this.id;
    data['deal_id'] = this.dealId;
    data['name'] = this.name;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['deleted_at'] = this.deletedAt;
    return data;
  }
}
