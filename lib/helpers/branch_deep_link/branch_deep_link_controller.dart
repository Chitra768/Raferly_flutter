import 'package:get/get.dart';

class BranchDeepLinkController extends GetxController {
  // Observable map to hold Branch deep link data
  var branchData = <dynamic, dynamic>{}.obs;

  // Update the stored branch data
  void updateBranchData(Map<dynamic, dynamic> data) {
    branchData.value = data;
  }

  bool get hasValidDeepLink =>
      branchData['+clicked_branch_link'] == true &&
      branchData['send_lead_out'] == 0 &&
      branchData['deal_id'] != null;

  String? get dealId {
    final id = branchData['deal_id'];
    if (id == null) return null;

    // Remove decimal if it's a double like 1188.0 → '1188'
    if (id is double) {
      return id.toInt().toString();
    }

    // If it's already an int or string, return as string
    return id.toString();
  }

  // Optional: Clear branch data
  void clear() {
    branchData.clear();
  }
}
