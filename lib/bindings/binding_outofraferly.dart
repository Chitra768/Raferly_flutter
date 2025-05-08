import 'package:get/get.dart';
import 'package:referaly/controller/conroller_outofraferly.dart' show ConrollerOutofraferly;



class BindingOutofraferly implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ConrollerOutofraferly>(() => ConrollerOutofraferly());
  }
}
