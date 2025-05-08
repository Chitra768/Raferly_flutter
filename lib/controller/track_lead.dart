import 'package:get/get.dart';

class TrackLeadsController extends GetxController {
  RxBool isLeadsReceived = true.obs;
  RxList<int> expandedItems = <int>[].obs;

  void toggleLeadType(bool isReceived) {
    isLeadsReceived.value = isReceived;
  }

  void toggleExpanded(int index) {
    if (expandedItems.contains(index)) {
      expandedItems.remove(index);
    } else {
      expandedItems.add(index);
    }
  }

  bool isExpanded(int index) {
    return expandedItems.contains(index);
  }
}
