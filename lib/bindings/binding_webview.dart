import 'package:get/get.dart';
import 'package:referaly/controller/webview_controller.dart';

class BindingWebView implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CustomWebViewController>(() => CustomWebViewController());
  }
}
