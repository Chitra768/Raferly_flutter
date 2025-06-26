// ignore_for_file: empty_catches

import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:referaly/apis/api_result.dart' show ApiFailure, ApiSuccess;
import 'package:referaly/apis/rest_auth.dart' show RESTAuth;
import 'package:referaly/controller/controller_choose_language.dart';
import 'package:referaly/controller/edit_company_profile_controller.dart';
import 'package:referaly/controller/language_controller.dart';
import 'package:referaly/languages/languagekeys.dart';
import 'package:referaly/resources/app_assets.dart';
import 'package:referaly/resources/app_colors.dart';
import 'package:referaly/resources/text_style.dart';
import 'package:referaly/screens/company_profile/edit_company_profile.dart';
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

  void _showProfessionalDialog2() {
    showDialog(
      context: Get.context!,
      builder: (BuildContext context) {
        return Dialog(
          insetPadding: const EdgeInsets.symmetric(horizontal: 16),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Container(
            width: MediaQuery.of(context).size.width * 0.9,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  AppAssets.imgCongratulation,
                  height: 60.h,
                  width: 60.w,
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Obx(
                        () => Text(
                          tr(LanguageKeys.congratulations),
                          textAlign: TextAlign.center,
                          style: stylePoppins(
                              fontSize: 15, color: AppColors.fontBlack),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Center(
                  child: SizedBox(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                        if (!Get.isRegistered<EditCompanyProfileController>()) {
                          Get.put(EditCompanyProfileController());
                        }
                        final companyController =
                            Get.find<EditCompanyProfileController>();
                        companyController.setCompanyData(
                          name: profile.value?.data?.companyName ?? "",
                          desc: profile.value?.data?.companyDescription ?? "",
                          addr: profile.value?.data?.companyAddress ?? "",
                          code: profile.value?.data?.companyNumber ?? "",
                          image: profile.value?.data?.companyLogoUrl ?? "",
                          id: profile.value?.data?.companyId ?? "",
                          countryCode: profile.value?.data?.countryCode ?? "",
                          ind: profile.value?.data?.industry ?? "",
                          cntry: profile.value?.data?.country ?? "",
                        );
                        Get.toNamed(EditCompanyProfileScreen.pageId)
                            ?.then((value) => {
                                  getProfile(),
                                  if (profile.value?.data?.companyName != null)
                                    {
                                      Future.delayed(
                                          const Duration(milliseconds: 100),
                                          () {
                                        showCommissionDialog(
                                            dealDetailData.value.data);
                                      })
                                    }
                                });
                      },
                      child: Obx(
                        () => Text(tr(LanguageKeys.fillCompany),
                            style: stylePoppins(color: AppColors.whiteColor)),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showProfessionalDialogFail(String? message) {
    showDialog(
      context: Get.context!,
      builder: (BuildContext context) {
        return Dialog(
          insetPadding: const EdgeInsets.symmetric(horizontal: 16),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Container(
            width: MediaQuery.of(context).size.width * 0.9,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  tr(LanguageKeys.whoops), // Use dynamic title here
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Text(
                        message ?? "",
                        textAlign: TextAlign.center,
                        style: stylePoppins(
                            fontSize: 15, color: AppColors.fontBlack),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Center(
                  child: SizedBox(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text(tr(LanguageKeys.okay),
                          style: stylePoppins(color: AppColors.whiteColor)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
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
          if (profile.value?.data?.companyName != null) {
            Future.delayed(const Duration(milliseconds: 100), () async {
              if (profile.value?.data?.id.toString() ==
                  dealDetailData.value.data?.createdBy.toString()) {
                final response = await RESTAuth.dealDetail(
                    id: id,
                    leadId: dealDetailData.value.data?.createdBy.toString(),
                    sendLeadOut:
                        dealDetailData.value.data?.sendLeadOut.toString());
                if (response is ApiSuccess<ModelDealDetail>) {
                  if (response.data.status == true &&
                      response.data.data != null) {
                    dealDetailData.value = response.data;
                    debugPrint(
                        "dealName : ${dealDetailData.value.data!.dealName}");
                  } else {
                    _showProfessionalDialogFail(response.data.message);
                  }
                }
              } else {
                showCommissionDialog(
                    dealDetailData.value.data);
              }
            });
          } else {
            _showProfessionalDialog2();
          }
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
  void showCommissionDialog( DealDetailData? data) {
    // Get.dialog(ShowOutOffReferalyDialog());
    AppLog.d("sendLeadOut: ${data?.sendLeadOut}");
    switch (data?.sendLeadOut.toString()) {
      case "0":
        Get.dialog(ShowCommissionDialogs(data));
        break;
      case "1":
        Get.dialog(ShowOutOfReferalyCommissionDialogs(data));
        break;
    
    
      default:
        // Optional: handle unknown or null commissionType
        break;
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
