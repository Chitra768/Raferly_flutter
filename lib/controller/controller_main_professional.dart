// ignore_for_file: empty_catches

import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:referaly/apis/api_result.dart' show ApiFailure, ApiSuccess;
import 'package:referaly/apis/rest_auth.dart' show RESTAuth;
import 'package:referaly/controller/controller_choose_language.dart';
import 'package:referaly/controller/language_controller.dart';
import 'package:referaly/languages/languagekeys.dart';
import 'package:referaly/utils/translations.dart';
import 'package:referaly/models/model_common.dart';
import 'package:referaly/models/model_company_detail.dart';
import 'package:referaly/models/model_dashboard.dart'
    show DealDocuments, ModelDashboardResponse;
import 'package:referaly/models/model_profile.dart' show ModelProfile;
import 'package:referaly/resources/app_helper.dart';
import 'package:referaly/resources/app_log.dart';
import 'package:referaly/resources/app_preference.dart';
import 'package:referaly/widgets/custom_toast_msg.dart';
import 'package:referaly/widgets/dialog/discover_referaly_finder_dialog.dart';
import 'package:referaly/widgets/dialog/show_deal_share_dialog.dart';
import 'package:referaly/widgets/dialog/show_out_of_referaly_commission_dialogs.dart';

import '../widgets/dialog/show_commission_dialogs.dart';
import '../widgets/dialog/show_out_off_referaly_dialog.dart';
import '../widgets/dialog/success_popup.dart';
import 'package:referaly/screens/home/screen_main.dart';

class ControllerMainProfessional extends GetxController {
  RxInt pageIndex = 0.obs;
  final Rx<ModelProfile?> profile = Rx<ModelProfile?>(null);
  RxString profileImagePath = "".obs;
  final RxBool isLoadingDashboard = false.obs;
  final RxBool isLoadingProfile = false.obs;
  var isLoading = false.obs;

  Rx<ModelDealDetail> dealDetailData = ModelDealDetail().obs;
  final args = Get.arguments as Map<String, dynamic>?;
  final RxBool isCheckedContract = false.obs;

  /// args
  late String? dealId;
  late String? campaign;
  late String? stage;

  void getArguments() {
    dealId = args?['dealId'];
    campaign = args?['campaign'];
    stage = args?['stage'];

    debugPrint('Deal ID: $dealId, Campaign: $campaign, Stage: $stage');
  }

  void changeTab(int index) {
    pageIndex.value = index;
  }

  @override
  Future<void> onInit() async {
    super.onInit();
    getArguments();

    // // Handle initial deal ID
    // handleDealId(dealId);

    getProfile();
    getDashboard();

    if (AppPreference.readInt(AppPreference.isFirstTime) == 0) {
      AppPreference.writeInt(AppPreference.isFirstTime, 1);
    }
  }

  Future<void> handleDealId(
      String? dealId, String? campaign, String? stage) async {
    if (dealId != null) {
      debugPrint('Handling deal $dealId');
      campaign = campaign;
      stage = stage;

      debugPrint('Deal ID: $dealId, Campaign: $campaign, Stage: $stage');
      await getDealDetail(id: dealId, campaign: campaign, stage: stage);
    } else {
      debugPrint('No deal ID to handle');
    }
  }

  Future<void> getProfile() async {
    if (isLoadingProfile.value) return; // Prevent multiple simultaneous calls

    try {
      isLoadingProfile.value = true;
      final response = await RESTAuth.getProfile();

      if (response is ApiSuccess<ModelProfile>) {
        if (response.data.status == true) {
          // Update profile data
          profile.value = response.data;
          profile.refresh(); // Force UI refresh

          debugPrint('Profile data updated: ${response.data.toJson()}');

          // Update preferences
          await AppPreference.writeString(
              AppPreference.isPaid, response.data.data!.isPaid.toString());
          await AppPreference.writeString(AppPreference.productId,
              response.data.data!.productId.toString());

          // Update profile image
          profileImagePath.value = response.data.data!.avatarUrl ?? "";
          profileImagePath.refresh(); // Force UI refresh

          // Update language
          final lang = response.data.data!.lang ?? "en";
          await LanguageController.to.changeLanguage(lang);
          Get.updateLocale(Locale(lang));
        } else {
          debugPrint(
              'Profile API returned false status: ${response.data.message}');
        }
      } else if (response is ApiFailure) {
        debugPrint('Profile API failed: ${response.error.message}');
      }
    } catch (e) {
      debugPrint('Error fetching profile: $e');
    } finally {
      isLoadingProfile.value = false;
    }
  }

  String formatCompact(num? value) {
    if (value == null) return '0';

    if (value >= 1e12) return '${(value / 1e12).toStringAsFixed(1)}T';
    if (value >= 1e9) return '${(value / 1e9).toStringAsFixed(1)}B';
    if (value >= 1e6) return '${(value / 1e6).toStringAsFixed(1)}M';
    if (value >= 1e3) return '${(value / 1e3).toStringAsFixed(1)}K';
    return value.toString();
  }

  // Suman : Get Dashboard Api
  final Rx<ModelDashboardResponse?> dashboard =
      Rx<ModelDashboardResponse?>(null);
  final Rx<List<DealDocuments>> documentList = Rx<List<DealDocuments>>([]);
  Future<void> getDashboard() async {
    try {
      isLoadingDashboard.value = true;
      final response = await RESTAuth.getDashboard();
      if (response is ApiSuccess<ModelDashboardResponse>) {
        if (response.data.status == true) {
          dashboard.value = response.data;
          dashboard.refresh();
          // Add static document at first position
          // final staticDocument = DealDocuments(
          //     name: "Main Document",
          //     document: response.data.data?.documentUrl ?? "");
          // documentList.value = [
          //   staticDocument,
          //   ...(response.data.data?.dealDocuments ?? [])
          // ];

          documentList.value = response.data.data?.dealDocuments ?? [];
          documentList.refresh();
          AppHelper.showLog(
              'Dashboard data updated: ${response.data.toJson()}'); // Debug log
        } else {
          AppHelper.showLog(
              'Dashboard API returned false status: ${response.data.message}'); // Debug log
        }
      } else if (response is ApiFailure) {
        AppHelper.showLog(
            'Dashboard API failed: ${response.error.message}'); // Debug log
      }
    } catch (e) {
      AppHelper.showLog('Error fetching dashboard: $e'); // Debug log
    } finally {
      isLoadingDashboard.value = false;
    }
  }

  // Api for get deal detail show dialogue

  Future<void> getDealDetail(
      {String? id, String? campaign, String? stage}) async {
    try {
      isLoading.value = true;
      final response = await RESTAuth.dealDetail(id: id);

      if (response is ApiSuccess<ModelDealDetail>) {
        if (response.data.status == true && response.data.data != null) {
          dealDetailData.value = response.data;
          debugPrint("dealName : ${dealDetailData.value.data!.dealName}");
          // showDealShareOrOutOffReferalyDialog(campaign,stage);
          Future.delayed(const Duration(milliseconds: 100), () {
            showCommissionDialog(dealDetailData.value.data?.commissionType,
                dealDetailData.value.data);
          });
        } else {
          AppLog.d("getDealDetail API returned false status or null data");
        }
      } else if (response is ApiFailure) {
        AppLog.d(" getDealDetail API failure: ${response.error.message}");
      }
    } catch (e) {
      AppLog.d("getDealDetail error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  // Accept deal
  Future<void> acceptDeal(
    BuildContext context, {
    required String? id,
    required String? dealId,
    required String? sendLeadOut,
    required String? createdBy,
  }) async {
    isLoading.value = true;

    // Log the request details
    debugPrint('Sending acceptDeal API call:');
    debugPrint('id: $id');
    debugPrint('dealId: $dealId');
    debugPrint('sendLeadOut: $sendLeadOut');
    debugPrint('createdBy: $createdBy');

    try {
      final result = await RESTAuth.acceptDeal(
        id: id,
        dealId: dealId,
        sendLeadOut: sendLeadOut,
        createdBy: createdBy,
      );

      // Log the raw API response
      debugPrint('API Response: $result');

      if (result is ApiSuccess<ModelCommon>) {
        final data = result.data;

        debugPrint('API Success - Status: ${data.status}');
        debugPrint('Message: ${data.message}');

        // Close any open dialogs before opening new one
        if (Get.isDialogOpen ?? false) {
          Get.back();
        }

        if (data.status == true) {
          getDashboard();
          getProfile();
          

          // Show success dialog
          await Get.dialog(
            SuccessPopup(
              message: data.message ?? '',
              onOk: () {
                Get.back();
              },
            ),
            barrierDismissible: false,
          );
        } else {
          // Show "Whoops" dialog on failure
          await Get.dialog(
            SuccessPopup(
              message: data.message ?? '',
              onOk: () {
                Get.back();
              },
            ),
            barrierDismissible: false,
          );
        }

        Get.back(); // Close loading or any leftover bottom sheet
      } else if (result is ApiFailure) {
        debugPrint('API Failure: ${result.error.message}');

        Get.back();
      } else {
        debugPrint('Unexpected API result type.');

        Get.back();
      }
    } catch (e, stack) {
      debugPrint('Exception occurred: $e');
      debugPrint('Stack trace: $stack');

      Get.back();
    } finally {
      isLoading.value = false;
      debugPrint('acceptDeal() call ended');
    }
  }

  /// Show dialog after the first frame if dealId is present
  //Todo : Need to check condition on which flag or value we can display below dialog
  void showCommissionDialog(String? commissionType, DealDetailData? data) {
    // Get.dialog(ShowOutOffReferalyDialog());
    AppLog.d("commissionType: $commissionType");
    switch (commissionType.toString()) {
      case "fix_commission":
        Get.dialog(ShowCommissionDialogs(data));
        break;
      case "percentage_commission":
        Get.dialog(ShowCommissionDialogs(data));
        break;
      case "no_commission":
           Get.dialog(ShowOutOfReferalyCommissionDialogs());
        break;
      case "out_off_referellay":
        Get.dialog(ShowOutOfReferalyCommissionDialogs());
        break;
      default:
        // Optional: handle unknown or null commissionType
        break;
    }
  }

  /// Show dialog after the first frame if dealId is present
  //Todo : Need to check condition on which flag or value we can display below dialog
  void showDealShareOrOutOffReferalyDialog(String? campaign, String? stage) {
    debugPrint('Showing dialog');
    if (dealDetailData.value.data != null) {
      debugPrint('Deal data is not null, showing dialog');
      debugPrint('Stage: $stage, Campaign: $campaign');
      if (stage == 'invite to deal' || campaign == 'invite_deal_campaign') {
        Get.dialog(ShowOutOfReferalyCommissionDialogs());
      } else if (stage == 'sharing to deal' || campaign == 'Send a Lead') {
        Get.dialog(ShowDealShareDialog());
      } else {
        debugPrint('No dialog condition matched');
      }
    }
  }

  final RxBool isIndividualHome = false.obs;

  Future<void> showIndividualHome() async {
    isIndividualHome.value = true;
    try {
      final response = await RESTAuth.getIndividualHomeType("professional");
      if (response is ApiSuccess<ModelCommon>) {
        debugPrint('API Success - Status: ${response.data.status}');
        getProfile();
        isIndividualHome.value = false;
      } else if (response is ApiFailure) {
        debugPrint('API Failure: ${response.error.message}');
        isIndividualHome.value = false;
      }
    } catch (e) {
      debugPrint('Error fetching individual home: $e');
      isIndividualHome.value = false;
    }
  }
}
