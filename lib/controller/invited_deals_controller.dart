import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DealModel {
  final String name;
  final String referralInfo;
  final String profileColor;
  final RxBool isExpanded;

  DealModel({
    required this.name,
    required this.referralInfo,
    required this.profileColor,
    bool expanded = false,
  }) : isExpanded = expanded.obs;
}

class InvitedDealsController extends GetxController {
  // Observable variables
  final RxList<DealModel> deals = <DealModel>[].obs;
  final RxInt selectedNavIndex = 1.obs;

  @override
  void onInit() {
    super.onInit();
    loadDeals();
  }

  // Initialize with dummy data
  void loadDeals() {
    deals.value = [
      DealModel(
        name: "Darshan",
        referralInfo: "Business referral - (Kavan Solanki)",
        profileColor: "4CAF50", // Green
      ),
      DealModel(
        name: "Hetal",
        referralInfo: "Business referral - (Rahul Patel)",
        profileColor: "2196F3", // Blue
      ),
      DealModel(
        name: "Sanjay",
        referralInfo: "Business referral - (Arjun Shah)",
        profileColor: "9C27B0", // Purple
      ),
    ];
  }

  // Toggle expansion of deal info
  void toggleDealExpansion(int index) {
    deals[index].isExpanded.value = !deals[index].isExpanded.value;
  }

  // Set selected navigation item
  void setNavIndex(int index) {
    selectedNavIndex.value = index;
  }

  // Method to share a deal
  void shareDeal(int index) {
    // Implementation for sharing functionality
    if (index >= 0 && index < deals.length) {
      final deal = deals[index];
      // Share logic would go here
      Get.snackbar(
        "Sharing Deal",
        "Sharing ${deal.name}'s deal information",
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  // Method to show more options
  void showMoreOptions(int index) {
    // Implementation for more options
    if (index >= 0 && index < deals.length) {
      Get.bottomSheet(
        Container(
          padding: const EdgeInsets.all(20),
          color: Colors.white,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.edit),
                title: const Text("Edit Deal"),
                onTap: () {
                  Get.back();
                  // Edit logic would go here
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete),
                title: const Text("Delete Deal"),
                onTap: () {
                  Get.back();
                  // Delete logic would go here
                },
              ),
            ],
          ),
        ),
      );
    }
  }
}
