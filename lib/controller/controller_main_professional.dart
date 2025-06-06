// ignore_for_file: empty_catches

import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:referaly/apis/api_result.dart' show ApiFailure, ApiSuccess;
import 'package:referaly/apis/rest_auth.dart' show RESTAuth;
import 'package:referaly/controller/controller_choose_language.dart';
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

class ControllerMainProfessional extends GetxController {
  RxInt pageIndex = 0.obs;
  final Rx<ModelProfile?> profile = Rx<ModelProfile?>(null);
  RxString profileImagePath = "".obs;
  final RxBool isLoadingDashboard = false.obs;
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
    final dealId = args?['dealId'];

    getProfile();
    getDashboard();
    if (AppPreference.readInt(AppPreference.isFirstTime) == 0) {
      AppPreference.writeInt(AppPreference.isFirstTime, 1);
      // Future.delayed(const Duration(seconds: 2), () {
      //   Get.dialog(DiscoverReferalyFinderDialog(onLetsGo: Get.back));
      // });
    }

  
    // Show showDealShareOrOutOffReferalyDialog as per campaign and stage
    if (dealId != null) {
      debugPrint('on init deal $dealId');
      await getDealDetail(id: dealId);
      showDealShareOrOutOffReferalyDialog();
    } else {
      debugPrint('on init NULL deal $dealId');
    }
  }

  Future<void> getProfile() async {
    try {
      final response = await RESTAuth.getProfile();

      if (response is ApiSuccess<ModelProfile>) {
        if (response.data.status == true) {
          profile.value = response.data;
          debugPrint(
              'Profile data updated: ${response.data.toJson()}'); // Debug log

          await AppPreference.writeString(
              AppPreference.isPaid, response.data.data!.isPaid.toString());
          await AppPreference.writeString(AppPreference.productId,
              response.data.data!.productId.toString());
          profileImagePath.value = response.data.data!.avatarUrl ?? "";
          Get.find<ControllerChooseLanguage>().changeLanguage(response.data.data!.lang ?? "en");
        } else {
          debugPrint(
              'Profile API returned false status: ${response.data.message}'); // Debug log
        }
      } else if (response is ApiFailure) {
        debugPrint(
            'Profile API failed: ${response.error.message}'); // Debug log
      }
    } catch (e) {
      debugPrint('Error fetching profile: $e'); // Debug log
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

  Future<void> getDealDetail({String? id}) async {
    try {
      isLoading.value = true;
      final response = await RESTAuth.dealDetail(id: id);

      if (response is ApiSuccess<ModelDealDetail>) {
        if (response.data.status == true && response.data.data != null) {
          dealDetailData.value = response.data;
          debugPrint("dealName : ${dealDetailData.value.data!.dealName}");
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
  }) async {
    isLoading.value = true;

    // Log the request details
    debugPrint('Sending acceptDeal API call:');
    debugPrint('id: $id');
    debugPrint('dealId: $dealId');
    debugPrint('sendLeadOut: $sendLeadOut');

    try {
      final result = await RESTAuth.acceptDeal(
        id: id,
        dealId: dealId,
        sendLeadOut: sendLeadOut,
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
          // Show success dialog
          await Get.dialog(
            SuccessPopup(
              title: 'Success',
              message: data.message ?? 'Deal accepted successfully.',
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
              title: 'Whoops',
              message: data.message ??
                  'This deal has already been accepted or is inactive.',
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
  void showCommissionDialog() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final commissionType = dealDetailData.value.data?.commissionType;

      // Get.dialog(ShowOutOffReferalyDialog());
      switch (commissionType) {
        case "fix_commission":
          Get.dialog(ShowCommissionDialogs());
          break;
        case "percent_commission":
          Get.dialog(ShowCommissionDialogs());
          break;
        case "out_off_referellay":
          Get.dialog(ShowOutOffReferalyDialog());
          break;
        default:
          // Optional: handle unknown or null commissionType
          break;
      }
    });
  }

  /// Show dialog after the first frame if dealId is present
  //Todo : Need to check condition on which flag or value we can display below dialog
  void showDealShareOrOutOffReferalyDialog() {
    debugPrint('Showing dialog');
    if (dealDetailData.value.data != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (stage == 'invite to deal' || campaign == 'invite_deal_campaign') {
          Get.dialog(ShowOutOfReferalyCommissionDialogs());
        } else if (stage == 'sharing to deal' || campaign == 'Send a Lead') {
          Get.dialog(ShowDealShareDialog());
        } else {
          debugPrint('No dialog condition matched');
        }
      });
    }
  }
  
}
