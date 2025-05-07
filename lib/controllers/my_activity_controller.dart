import 'package:get/get.dart';

class MyActivityController extends GetxController {
  // Observable variables
  final RxBool isMyContractsSelected = true.obs;
  final RxInt selectedNavIndex = 1.obs;
  final RxList<String> referrerNames = ["Darshan Patel", "Hetal-- Patel&-+_", "John Doe"].obs;
  final RxList<bool> expandedItems = [false, false, false].obs;

  // Toggle tab selection
  void toggleTabSelection(bool isFirst) {
    isMyContractsSelected.value = isFirst;
  }

  // Toggle expansion of referrer item
  void toggleReferrerExpansion(int index) {
    expandedItems[index] = !expandedItems[index];
  }

  // Set selected navigation item
  void setNavIndex(int index) {
    selectedNavIndex.value = index;
  }

  // Add a new referrer
  void addReferrer(String name) {
    if (referrerNames.length < 5) {
      referrerNames.add(name);
      expandedItems.add(false);
    }
  }

  // Remove a referrer
  void removeReferrer(int index) {
    if (index >= 0 && index < referrerNames.length) {
      referrerNames.removeAt(index);
      expandedItems.removeAt(index);
    }
  }
}
