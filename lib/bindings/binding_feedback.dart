import 'package:get/get.dart';

import '../controller/controller_feedback.dart';

class BindingFeedback implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FeedbackController>(() => FeedbackController());
  }
}
