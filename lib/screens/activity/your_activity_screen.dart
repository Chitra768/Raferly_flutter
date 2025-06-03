import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:referaly/resources/app_colors.dart';
import 'package:referaly/resources/app_assets.dart';
import 'package:referaly/resources/text_style.dart';
import 'package:referaly/utils/translations.dart';
import 'package:referaly/languages/languagekeys.dart';
import 'package:referaly/controller/your_activity_controller.dart';

class YourActivityScreen extends GetView<YourActivityController> {
  static const String pageId = '/YourActivityScreen';

  final YourActivityController controller = Get.put(YourActivityController());

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
        title: Text(
          tr(LanguageKeys.howItWorks),
          style: stylePoppins(
              color: AppColors.blackColor,
              fontWeight: FontWeight.w500,
              fontSize: 16),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Divider(
            color: AppColors.dividerColor,
            height: 1,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    tr(LanguageKeys.yourActivity),
                    style: stylePoppins(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      color: AppColors.blackColor,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Expanded(
                    child: Obx(
                      () => controller.isLoading.value
                          ? Center(
                              child: SizedBox(
                                  height: 24,
                                  width: 24,
                                  child: CircularProgressIndicator(
                                    color: AppColors.primary,
                                  )))
                          : GridView.builder(
                              itemCount: controller.activityList.length,
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 16,
                                mainAxisSpacing: 16,
                                childAspectRatio: 1.2,
                              ),
                              itemBuilder: (context, index) {
                                return InkWell(
                                  onTap: () =>
                                      controller.onActivityItemTap(index),
                                  borderRadius: BorderRadius.circular(16),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(16),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.05),
                                          blurRadius: 8,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 18),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Image.network(
                                            controller
                                                .activityList[index].icon!,
                                            width: 40,
                                            height: 40),
                                        const SizedBox(height: 16),
                                        Text(
                                          tr(controller.activityList[index]
                                                      .title !=
                                                  null
                                              ? controller
                                                  .activityList[index].title!
                                              : ''),
                                          maxLines: 2,
                                          style: stylePoppins(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                            color: AppColors.blackColor,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
