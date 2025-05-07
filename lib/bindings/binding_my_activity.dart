import 'package:get/get.dart';

import '../controller/controller_my_activity.dart';


class BindingMyActivity implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MyActivityController>(() => MyActivityController());
  }
}
