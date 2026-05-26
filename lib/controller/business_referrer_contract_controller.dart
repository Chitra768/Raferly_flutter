import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http show get;
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:referaly/apis/api_result.dart';
import 'package:referaly/apis/rest_auth.dart';
import 'package:referaly/controller/controller_main_professional.dart';
import 'package:referaly/helpers/agency_colleague_access_helper.dart';
import 'package:referaly/languages/languagekeys.dart';
import 'package:referaly/models/model_contact_response.dart'
    as ModelContactResponse;
import 'package:referaly/models/model_create_deal.dart' as ModelCreateDeal;
import 'package:referaly/models/model_receive_lead_delete.dart';
import 'package:referaly/resources/app_colors.dart';
import 'package:referaly/resources/app_helper.dart';
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
  final RxBool isMultiLevelReferralEnabled = false.obs;
  final RxString level2CommissionPercentage = ''.obs;
  final RxBool isDeleting = false.obs;
  // Track name and stage tracking
  final RxString trackName = 'Contact called'.obs;
  final mainController = Get.find<ControllerMainProfessional>();

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
  RxList<TextEditingController> commisionPaidFields =
      <TextEditingController>[].obs;

  // Track default field names to identify newly added fields
  final List<String> defaultFieldNames = [
    tr(LanguageKeys.contactCalled),
    tr(LanguageKeys.contractSigned),
    tr(LanguageKeys.serviceDeleiverd),
    tr(LanguageKeys.paymentReceived),
  ];
  String selectedProgramType = tr(LanguageKeys.businessReferralProgram);

  final TextEditingController customProgramNameController =
      TextEditingController();
  RxBool isEditMode = false.obs;
  List<Map<String, String>> cases = [
    {
      "id": "0",
      "deal_id": "0",
      "name": "",
      "created_at": "",
      "updated_at": "",
      "lead_type": "",
      "commission_type": tr(LanguageKeys.chooseOneoption),
      "commission_value": "0"
    }
  ];

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args is Map<String, dynamic>) {
      // Edit mode
      isEditMode.value = args['is_edit'] ?? false;
      dealId.value = args['deal_id']?.toString() ?? '';

      final multi = args['multi_level_referral'] ?? args['multiLevelReferral'];
      isMultiLevelReferralEnabled.value = multi?.toString() == '1';

      final level2 = args['level_2_commission_percentage'] ??
          args['level2_commission_percentage'] ??
          args['level2CommissionPercentage'];
      level2CommissionPercentage.value =
          (level2 ?? '').toString().trim();

      AppHelper.showLog("deal_name: ${args['deal_name']}");
      selectedProgramType =
          (args['deal_name'] == tr(LanguageKeys.businessReferralProgram) ||
                  args['deal_name'] == tr(LanguageKeys.ambassadorProgram))
              ? args['deal_name']
              : tr(LanguageKeys.writeACustomName);

      AppHelper.showLog("selectedProgramType: $selectedProgramType");
      dealNameController.text = args['deal_name'] ?? '';
      commissionValueController.text = args['commission_value'] ?? '';
      selectedCommissionOption.value =
          mapApiCommissionTypeToUi(args['commission_type'] ?? '');
      isUniqueCommission.value =
          args['deal_commission_type'] == 2 ? false : true;
      AppHelper.showLog("isUniqueCommission: $isUniqueCommission");
      // Set track names if provided for edit mode
      if (args['deal_cases'] != null && args['deal_cases'] is List) {
        final List<dynamic> trackNamesList =
            args['deal_cases'] as List<dynamic>;
        cases = trackNamesList.map((e) {
          final map = e.toJson();
          return {
            "id": map["id"].toString(),
            "deal_id": map["deal_id"]?.toString() ?? dealId.value,
            "name": map["lead_type"].toString(),
            "created_at": map["created_at"]?.toString() ?? "",
            "updated_at": map["updated_at"]?.toString() ?? "",
            "lead_type": map["lead_type"].toString(),
            "commission_type": map["commission_type"].toString(),
            "commission_value": map["commission_value"].toString(),
          };
        }).toList();

        AppHelper.showLog("Cases: ${cases}");
        // Update dynamic fields with the track names
      }

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
      selectedProgramType = tr(LanguageKeys.businessReferralProgram);
      dealNameController.text = selectedProgramType;
      isMultiLevelReferralEnabled.value = false;
      level2CommissionPercentage.value = '';
      // Default program type
      AppHelper.showLog("selectedProgramType: $selectedProgramType");
      // New deal mode - set default track names
      dynamicFields.clear();
      dynamicFields.addAll([
        TextEditingController(text: tr(LanguageKeys.contactCalled)),
        TextEditingController(text: tr(LanguageKeys.contractSigned)),
        TextEditingController(text: tr(LanguageKeys.serviceDeleiverd)),
        TextEditingController(text: tr(LanguageKeys.paymentReceived)),
      ]);
    }

    // Initialize commisionPaidFields to match dynamicFields
    _initializeCommissionPaidFields();
  }

  Future<bool> deleteContract(String id) async {
    if (!AgencyColleagueAccessHelper.guardEdit(
        mainController.profile.value?.data,
        AgencyPermission.referralContracts)) {
      return false;
    }
    if (isDeleting.value) return false;
    isDeleting.value = true;
    try {
      print("Starting delete contract for ID: $id");
      final response = await RESTAuth.deleteDeal(id: id);
      print("Delete response received: $response");

      if (response is ApiSuccess<ModelReceiveLeadDelete>) {
        if (response.data.status == true) {
          print("Delete successful, showing popup");
          // Show success popup
          if (Get.context != null) {
            print("Context is available, showing dialog");
            showDialog(
              context: Get.context!,
              builder: (context) => SuccessPopup(
                message: response.data.message ??
                    tr(LanguageKeys.dealDeletedSuccessfully),
                onOk: () {
                  Navigator.of(context).pop(); // Close the popup
                  // Navigate back or refresh the list
                  Get.back();
                },
              ),
              barrierDismissible: false,
            );
          } else {
            print("Context is null, cannot show dialog");
          }
          return true; // Return true to indicate successful deletion
        } else {
          print("Delete failed: ${response.data.message}");
          dealError.value =
              response.data.message ?? tr(LanguageKeys.somethingWentWrong);
          Get.snackbar(
            tr(LanguageKeys.error),
            dealError.value,
            snackPosition: SnackPosition.BOTTOM,
            // backgroundColor: AppColors.redColor,
            // colorText: AppColors.whiteColor,
          );
          return false;
        }
      } else if (response is ApiFailure) {
        print("API failure: ${response.error.message}");
        dealError.value =
            response.error.message ?? tr(LanguageKeys.somethingWentWrong);
        Get.snackbar(
          tr(LanguageKeys.error),
          dealError.value,
          snackPosition: SnackPosition.BOTTOM,
          // backgroundColor: AppColors.redColor,
          // colorText: AppColors.whiteColor,
        );
        return false;
      }
    } catch (e) {
      print("Exception during delete: $e");
      dealError.value = tr(LanguageKeys.somethingWentWrong);
      Get.snackbar(
        tr(LanguageKeys.error),
        dealError.value,
        snackPosition: SnackPosition.BOTTOM,
        // backgroundColor: AppColors.redColor,
        // colorText: AppColors.whiteColor,
      );
      return false;
    } finally {
      isDeleting.value = false;
    }
    return false;
  }

  @override
  void onClose() {
    for (var ctrl in dynamicFields) {
      ctrl.dispose();
    }
    for (var ctrl in commisionPaidFields) {
      ctrl.dispose();
    }
    dynamicFields.clear();
    commisionPaidFields.clear();
    dealNameController.dispose();
    super.onClose();
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
    } else if (uiType == tr(LanguageKeys.percentage_commission)) {
      return 'percentage_commission';
    } else {
      return 'no_commission';
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
  void submitDeal(
    List<Map<String, String>> cases, {
    int multiLevelReferral = 0,
    String? level2CommissionPercentage,
  }) {
    if (dealId.value.isNotEmpty) {
      updateDeal(
        multiLevelReferral: multiLevelReferral,
        level2CommissionPercentage: level2CommissionPercentage,
      );
    } else {
      createDeal(
        cases,
        multiLevelReferral: multiLevelReferral,
        level2CommissionPercentage: level2CommissionPercentage,
      );
    }
  }

  /// Initialize commission paid fields to match dynamic fields
  void _initializeCommissionPaidFields() {
    commisionPaidFields.clear();
    for (int i = 0; i < dynamicFields.length; i++) {
      commisionPaidFields.add(TextEditingController());
    }
  }

  /// Check if a field at given index is newly added (not a default field)
  bool isNewlyAddedField(int index) {
    if (index < 0 || index >= dynamicFields.length) return false;
    String fieldText = dynamicFields[index].text;
    return !defaultFieldNames.contains(fieldText);
  }

  /// Get all newly added field names
  List<String> getNewlyAddedFieldNames() {
    List<String> newlyAdded = [];
    for (int i = 0; i < dynamicFields.length; i++) {
      if (isNewlyAddedField(i)) {
        newlyAdded.add(dynamicFields[i].text);
      }
    }
    return newlyAdded;
  }

  /// Get commission paid values for newly added fields only
  List<String> getCommissionPaidValuesForNewFields() {
    List<String> commissionValues = [];
    for (int i = 0; i < dynamicFields.length; i++) {
      if (isNewlyAddedField(i) && i < commisionPaidFields.length) {
        commissionValues.add(commisionPaidFields[i].text);
      }
    }
    return commissionValues;
  }

  /// Add a new dynamic text field
  void addDynamicField() {
    dynamicFields.add(TextEditingController());
    commisionPaidFields.add(TextEditingController());
  }

  /// Remove a dynamic text field at [index]
  void removeDynamicField(int index) {
    if (index >= 0 &&
        index < dynamicFields.length &&
        index >= 0 &&
        index < commisionPaidFields.length) {
      dynamicFields[index].dispose();
      dynamicFields.removeAt(index);
      commisionPaidFields[index].dispose();
      commisionPaidFields.removeAt(index);
    }
  }

  /// Reorder dynamic fields and keep matching commission field indexes aligned
  void reorderDynamicFields(int oldIndex, int newIndex) {
    if (newIndex > oldIndex) {
      newIndex -= 1;
    }
    if (oldIndex < 0 ||
        oldIndex >= dynamicFields.length ||
        newIndex < 0 ||
        newIndex > dynamicFields.length) {
      return;
    }
    final TextEditingController movedField = dynamicFields.removeAt(oldIndex);
    dynamicFields.insert(newIndex, movedField);
    if (oldIndex < commisionPaidFields.length &&
        newIndex <= commisionPaidFields.length) {
      final TextEditingController movedCommissionField =
          commisionPaidFields.removeAt(oldIndex);
      commisionPaidFields.insert(newIndex, movedCommissionField);
    }
  }

  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final RxList<ModelCreateDeal.ModelCreateDeal> dealList =
      <ModelCreateDeal.ModelCreateDeal>[].obs;
  final RxString dealError = ''.obs;

  Future<void> createDeal(
    List<Map<String, String>> cases, {
    int multiLevelReferral = 0,
    String? level2CommissionPercentage,
  }) async {
    if (!AgencyColleagueAccessHelper.guardEdit(
        mainController.profile.value?.data,
        AgencyPermission.referralContracts)) {
      return;
    }
    isLoading.value = true;
    errorMessage.value = '';
    if (selectedCommissionOption.value != tr(LanguageKeys.no_commission) &&
        selectedCommissionOption.value != tr(LanguageKeys.chooseOneoption)) {
      dynamicFields
          .add(TextEditingController(text: tr(LanguageKeys.commisionPaid)));
    } else {
      dynamicFields
          .removeWhere((field) => field.text == tr(LanguageKeys.commisionPaid));
    }
    List<String> trackNameList =
        dynamicFields.map((field) => field.text).toList();
    AppHelper.showLog('trackNameList: $trackNameList');
    AppHelper.showLog('dealNameController: ${dealNameController.text}');
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
        isUniqueCommission: isUniqueCommission.value,
        cases: cases,
        multiLevelReferral: multiLevelReferral,
        level2CommissionPercentage: level2CommissionPercentage,
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
        dealError.value = tr(LanguageKeys.dealCreatedFailed);
      }
    } catch (e) {
      errorMessage.value = tr(LanguageKeys.dealCreatedFailed);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateDeal({
    int multiLevelReferral = 0,
    String? level2CommissionPercentage,
  }) async {
    if (!AgencyColleagueAccessHelper.guardEdit(
        mainController.profile.value?.data,
        AgencyPermission.referralContracts)) {
      return;
    }
    isLoading.value = true;
    errorMessage.value = '';

    List<String> commisionPaidList =
        dynamicFields.map((field) => field.text).toList();

    // Merge dealSteps with commission paid list based on name matching
    List<BusinessDealSteps> mergedDealSteps = mergeDealStepsWithCommission();

    AppHelper.showLog('commisionPaidList: $commisionPaidList');
    AppHelper.showLog('dealNameController: ${dealNameController.text}');
    AppHelper.showLog('cases: ${cases}');
    AppHelper.showLog('dealSteps: ${dealSteps}');
    AppHelper.showLog('mergedDealSteps: $mergedDealSteps');
    AppHelper.showLog('isUniqueCommission: $isUniqueCommission');

    String commissionType =
        mapUiCommissionTypeToApi(selectedCommissionOption.value);
    try {
      final response = await RESTAuth.updateDeal(
        dealNameController.text,
        commissionType,
        "description",
        dealId.value,
        commissionValueController.text,
        mergedDealSteps,
        isUniqueCommission.value,
        pdfFile: contractFile,
        cases: cases,
        multiLevelReferral: multiLevelReferral,
        level2CommissionPercentage: level2CommissionPercentage,
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
          Get.snackbar(
            tr(LanguageKeys.error),
            dealError.value,
            snackPosition: SnackPosition.BOTTOM,
          );
        }
      } else if (response is ApiFailure) {
        dealError.value =
            response.error.message ?? tr(LanguageKeys.somethingWentWrong);
        Get.snackbar(
          tr(LanguageKeys.error),
          dealError.value,
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      errorMessage.value = tr(LanguageKeys.somethingWentWrong);
      Get.snackbar(
        tr(LanguageKeys.error),
        errorMessage.value,
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Build the list of deal steps to send to API based on the UI state.
  ///
  /// Rules:
  /// - Preserve the original step `id`/metadata by POSITION when possible.
  /// - New steps (beyond the original length) are sent with just `name`.
  /// - Deleted steps (present in original but removed from UI) are omitted.
  /// - Renamed steps keep their original `id` but with the updated `name`.
  List<BusinessDealSteps> mergeDealStepsWithCommission() {
    final List<String> currentNames = dynamicFields
        .map((field) => field.text.trim())
        .where((name) => name.isNotEmpty)
        .toList();

    final List<BusinessDealSteps> original =
        List<BusinessDealSteps>.from((dealSteps ?? <BusinessDealSteps>[]));

    final int commonLength = original.length < currentNames.length
        ? original.length
        : currentNames.length;

    final List<BusinessDealSteps> mergedList = [];

    // Keep ids for positions that still exist; update names to the new text
    for (int i = 0; i < commonLength; i++) {
      final BusinessDealSteps existing = original[i];
      mergedList.add(BusinessDealSteps(
        id: existing.id,
        dealId: existing.dealId,
        name: currentNames[i],
        createdAt: existing.createdAt,
        updatedAt: existing.updatedAt,
      ));
    }

    // Any extra names are newly added steps
    for (int i = commonLength; i < currentNames.length; i++) {
      mergedList.add(BusinessDealSteps(name: currentNames[i]));
    }

    // Note: We intentionally DO NOT append leftover original steps.
    // Those are considered deleted by the user.

    return mergedList;
  }

  /// Get the current commission paid list from dynamic fields
  List<String> getCommissionPaidList() {
    return dynamicFields.map((field) => field.text).toList();
  }

  /// Update dealSteps with merged data
  void updateDealStepsWithMergedData() {
    dealSteps = mergeDealStepsWithCommission();
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

  BusinessDealSteps({
    this.id,
    this.dealId,
    this.name,
    this.createdAt,
    this.updatedAt,
  });

  BusinessDealSteps.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    dealId = json['deal_id'];
    name = json['name'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this.id;
    data['deal_id'] = this.dealId;
    data['name'] = this.name;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

class BusniessDealCases {
  int? id;
  int? dealId;
  String? leadType;
  String? commissionType;
  int? commissionValue;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;

  BusniessDealCases(
      {this.id,
      this.dealId,
      this.leadType,
      this.commissionType,
      this.commissionValue,
      this.createdAt,
      this.updatedAt,
      this.deletedAt});

  BusniessDealCases.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    dealId = json['deal_id'];
    leadType = json['lead_type'];
    commissionType = json['commission_type'];
    commissionValue = json['commission_value'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['deal_id'] = this.dealId;
    data['lead_type'] = this.leadType;
    data['commission_type'] = this.commissionType;
    data['commission_value'] = this.commissionValue;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['deleted_at'] = this.deletedAt;
    return data;
  }
}
