// ignore_for_file: empty_catches

import 'dart:async';

import 'package:get/get.dart';
import 'package:referaly/apis/api_result.dart' show ApiFailure, ApiSuccess;
import 'package:referaly/apis/rest_auth.dart' show RESTAuth;
import 'package:referaly/models/model_dashboard.dart'
    show DealDocuments, ModelDashboardResponse;
import 'package:referaly/models/model_profile.dart' show ModelProfile;
import 'package:referaly/resources/app_helper.dart';
import 'package:referaly/resources/app_preference.dart';
import 'package:referaly/widgets/dialog/discover_referaly_finder_dialog.dart';

class ControllerMainProfessional extends GetxController {
  RxInt pageIndex = 0.obs;
  final Rx<ModelProfile?> profile = Rx<ModelProfile?>(null);
  RxString profileImagePath = "".obs;
  final RxBool isLoadingDashboard = false.obs;

  void changeTab(int index) {
    pageIndex.value = index;
  }

  @override
  void onInit() {
    super.onInit();
    getProfile();
    getDashboard();
    if (AppPreference.readInt(AppPreference.isFirstTime) == 0) {
      AppPreference.writeInt(AppPreference.isFirstTime, 1);
      Future.delayed(const Duration(seconds: 2), () {
        Get.dialog(DiscoverReferalyFinderDialog(onLetsGo: Get.back));
      });
    }
  }

  Future<void> getProfile() async {
    try {
      final response = await RESTAuth.getProfile();

      if (response is ApiSuccess<ModelProfile>) {
        if (response.data.status == true) {
          profile.value = response.data;
          print('Profile data updated: ${response.data.toJson()}'); // Debug log

          await AppPreference.writeString(
              AppPreference.isPaid, response.data.data!.isPaid.toString());
          await AppPreference.writeString(AppPreference.productId,
              response.data.data!.productId.toString());
          profileImagePath.value = response.data.data!.avatarUrl ?? "";
        } else {
          print(
              'Profile API returned false status: ${response.data.message}'); // Debug log
        }
      } else if (response is ApiFailure) {
        print('Profile API failed: ${response.error.message}'); // Debug log
      }
    } catch (e) {
      print('Error fetching profile: $e'); // Debug log
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
          final staticDocument = DealDocuments(
              name: "Main Document",
              document: response.data.data?.documentUrl ?? "");
          documentList.value = [
            staticDocument,
            ...(response.data.data?.dealDocuments ?? [])
          ];
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
}
