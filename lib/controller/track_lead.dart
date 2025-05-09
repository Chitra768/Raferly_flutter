import 'package:get/get.dart';

class TrackLeadsController extends GetxController {
  RxBool isLeadsReceived = true.obs;

  void toggleLeadType(bool isReceived) {
    isLeadsReceived.value = isReceived;
  }

  @override
  void onClose() {
    super.onClose();
    isLeadsReceived.value = true;
  }
}
