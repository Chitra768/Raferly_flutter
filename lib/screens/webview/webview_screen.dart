import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:referaly/resources/app_colors.dart';
import 'package:referaly/resources/text_style.dart';
import 'package:referaly/utils/translations.dart';
import 'package:referaly/languages/languagekeys.dart';
import 'package:referaly/controller/webview_controller.dart';

class WebViewScreen extends GetView<CustomWebViewController> {
  static const String pageId = '/WebViewScreen';
  final CustomWebViewController controller = Get.put(CustomWebViewController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        foregroundColor: AppColors.whiteColor,
        backgroundColor: Colors.white,
        surfaceTintColor: AppColors.whiteColor,
        elevation: 1,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        centerTitle: true,
        title: Obx(
            () => Text(
            controller.title.value.isEmpty ? tr(LanguageKeys.bookAConsultation) : controller.title.value,
            style: stylePoppins(
                color: AppColors.blackColor,
                fontWeight: FontWeight.w500,
                fontSize: 16),
          ),
        ),
      ),
      body: Stack(
        children: [
          Obx(() => WebViewWidget(
                controller: controller.webViewController.value,
              )),
          Obx(() => controller.isLoading.value
              ? Container(
                  color: Colors.white,
                  child: Center(
                    child: SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        color: AppColors.primary,
                        strokeWidth: 2.5,
                      ),
                    ),
                  ),
                )
              : const SizedBox.shrink()),
        ],
      ),
    );
  }
}
