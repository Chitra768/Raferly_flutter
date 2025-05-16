import 'package:get/get.dart';

import '../controller/controller_story.dart';

class StoryBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<StoryController>(() => StoryController());
  }
}
