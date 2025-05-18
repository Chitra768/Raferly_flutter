import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OnboardingBusinessNetworkController extends GetxController {
  final activityController = TextEditingController();
  final referrerTypeController = TextEditingController();
  final canReferController = TextEditingController();

  final RxList<String> referrerTypes = <String>[].obs;
  final RxList<String> canReferList = <String>[].obs;
  final RxBool shareCommission = false.obs;
  final RxString clientLocation = 'Online'.obs;

  void addReferrerType() {
    final value = referrerTypeController.text.trim();
    if (value.isNotEmpty && !referrerTypes.contains(value)) {
      referrerTypes.add(value);
      referrerTypeController.clear();
    }
  }

  void removeReferrerType(String value) {
    referrerTypes.remove(value);
  }

  void addCanRefer() {
    final value = canReferController.text.trim();
    if (value.isNotEmpty && !canReferList.contains(value)) {
      canReferList.add(value);
      canReferController.clear();
    }
  }

  void removeCanRefer(String value) {
    canReferList.remove(value);
  }

  @override
  void onClose() {
    activityController.dispose();
    referrerTypeController.dispose();
    canReferController.dispose();
    super.onClose();
  }
}
