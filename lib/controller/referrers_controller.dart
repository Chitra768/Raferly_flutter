import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:referaly/apis/rest_auth.dart';
import 'package:referaly/models/model_busniess_referral_lead.dart';
import 'package:referaly/apis/api_result.dart' show ApiFailure, ApiSuccess;

class ReferrersController extends GetxController {
  RxList<BusinessReferralLeadData> referrers = <BusinessReferralLeadData>[].obs;
  RxBool isLoading = false.obs;
  RxString error = ''.obs;
  RxInt expandedIndex = (-1).obs;
  TextEditingController searchController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    fetchReferrers();
  }

  Future<void> fetchReferrers({String search = '', String id = ''}) async {
    isLoading.value = true;
    error.value = '';
    try {
      final response = await RESTAuth.businessReferralLead(search, id);
      if (response is ApiSuccess<ModelBusinessReferralLead>) {
        referrers.value = response.data.data ?? [];
      } else if (response is ApiFailure) {
        error.value = response.error.message ?? 'Something went wrong';
      }
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  void onSearchChanged(String value) {
    fetchReferrers(search: value);
  }

  void refreshList() {
    searchController.clear();
    fetchReferrers();
  }

  void toggleExpand(int index) {
    expandedIndex.value = expandedIndex.value == index ? -1 : index;
  }
}
