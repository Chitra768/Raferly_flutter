import 'package:get/get.dart';

class MyActivityController extends GetxController {

  var selectedTab = 1.obs; // 0 for My Contracts, 1 for My Network
  var referrersCount = 5.obs;

  var businessReferrers = [
    {"name": "Darshan Patel", "expanded": false},
    {"name": "Hetal-- Patel&+_", "expanded": false},
    {"name": "Test Text", "expanded": false},
  ].obs;

  void toggleReferrerExpansion(int index) {
    businessReferrers[index]['expanded'] =
    !(businessReferrers[index]['expanded'] as bool);
    businessReferrers.refresh();
  }

  void changeTab(int index) {
    selectedTab.value = index;
  }
}