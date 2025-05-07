import 'package:get/get.dart';

import '../controller/controller_archeivvelist.dart';


class BindingArcheiveList implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ArcheiveListController>(() => ArcheiveListController());
  }
}
