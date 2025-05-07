import 'package:flutter/material.dart';

class CompanyProfileController extends ChangeNotifier {
  String? companyName;
  String? description;
  String? address;
  String? businessCode;
  String? imagePath;

  void updateCompanyName(String value) {
    companyName = value;
    notifyListeners();
  }

  void updateDescription(String value) {
    description = value;
    notifyListeners();
  }

  void updateAddress(String value) {
    address = value;
    notifyListeners();
  }

  void updateBusinessCode(String value) {
    businessCode = value;
    notifyListeners();
  }

  void updateImagePath(String path) {
    imagePath = path;
    notifyListeners();
  }

  Future<void> submitProfile() async {
    // TODO: Implement submission logic (API call, validation, etc.)
  }
} 