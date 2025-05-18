import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart' as webview;

class CustomWebViewController extends GetxController {
  final webViewController = webview.WebViewController().obs;
  final url = 'https://calendly.com/hugo-referaly'.obs;
  final isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    initializeWebView();
  }

  void initializeWebView() {
    webViewController.value = webview.WebViewController()
      ..setJavaScriptMode(webview.JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        webview.NavigationDelegate(
          onPageStarted: (String url) {
            isLoading.value = true;
          },
          onPageFinished: (String url) {
            isLoading.value = false;
          },
          onWebResourceError: (webview.WebResourceError error) {
            isLoading.value = false;
          },
        ),
      )
      ..loadRequest(Uri.parse(url.value));
  }

  void loadUrl(String newUrl) {
    url.value = newUrl;
    initializeWebView();
  }
}
