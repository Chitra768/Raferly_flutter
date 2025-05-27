import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart' as webview;
import 'package:flutter/foundation.dart';

class CustomWebViewController extends GetxController {
  final webViewController = webview.WebViewController().obs;
  final url = ''.obs;
  final isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    final arguments = Get.arguments;
    if (arguments != null && arguments['url'] != null) {
      url.value = arguments['url'];
      debugPrint('WebView URL: ${url.value}'); // Debug log
    } else {
      debugPrint('No URL provided in arguments'); // Debug log
    }
    initializeWebView();
  }

  void initializeWebView() {
    try {
      String urlToLoad = url.value;
      if (urlToLoad.isEmpty) {
        debugPrint('URL is empty'); // Debug log
        return;
      }

      if (!urlToLoad.startsWith('http://') &&
          !urlToLoad.startsWith('https://')) {
        urlToLoad = 'https://$urlToLoad';
      }
      debugPrint('Loading URL: $urlToLoad'); // Debug log

      webViewController.value = webview.WebViewController()
        ..setJavaScriptMode(webview.JavaScriptMode.unrestricted)
        ..setNavigationDelegate(
          webview.NavigationDelegate(
            onPageStarted: (String url) {
              debugPrint('Page started loading: $url'); // Debug log
              isLoading.value = true;
            },
            onPageFinished: (String url) {
              debugPrint('Page finished loading: $url'); // Debug log
              isLoading.value = false;
            },
            onWebResourceError: (webview.WebResourceError error) {
              debugPrint('WebView error: ${error.description}'); // Debug log
              isLoading.value = false;
            },
            onNavigationRequest: (webview.NavigationRequest request) {
              debugPrint('Navigation request: ${request.url}'); // Debug log
              return webview.NavigationDecision.navigate;
            },
          ),
        )
        ..loadRequest(Uri.parse(urlToLoad));
    } catch (e) {
      debugPrint('Error initializing WebView: $e'); // Debug log
      isLoading.value = false;
    }
  }

  void loadUrl(String newUrl) {
    debugPrint('Loading new URL: $newUrl'); // Debug log
    url.value = newUrl;
    initializeWebView();
  }
}
