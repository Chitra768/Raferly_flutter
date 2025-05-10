// ignore_for_file: empty_catches

import 'dart:async';

import 'package:get/get.dart';
import 'package:referaly/apis/api_result.dart' show ApiFailure, ApiSuccess;
import 'package:referaly/apis/rest_auth.dart' show RESTAuth;
import 'package:referaly/models/model_dashboard.dart'
    show ModelDashboardResponse;
import 'package:referaly/models/model_profile.dart' show ModelProfile;
import 'package:referaly/resources/app_preference.dart';
import 'package:referaly/widgets/dialog/discover_referaly_finder_dialog.dart';

class ControllerMainProfessional extends GetxController {
  RxInt pageIndex = 0.obs;
  final Rx<ModelProfile?> profile = Rx<ModelProfile?>(null);
  void changeTab(int index) {
    pageIndex.value = index;
  }

  @override
  void onInit() {
    super.onInit();
    getProfile();
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
          getDashboard();
        } else {}
      } else if (response is ApiFailure) {}
    } catch (e) {
    } finally {}
  }

  // Suman : Get Dashboard Api
  final Rx<ModelDashboardResponse?> dashboard =
      Rx<ModelDashboardResponse?>(null);
  Future<void> getDashboard() async {
    try {
      final response = await RESTAuth.getDashboard();
      if (response is ApiSuccess<ModelDashboardResponse>) {
        if (response.data.status == true) {
          dashboard.value = response.data;
        } else {}
      }
    } catch (e) {}
  }
}
