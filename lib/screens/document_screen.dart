import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:referaly/languages/languagekeys.dart';
import 'package:referaly/resources/app_assets.dart';
import 'package:referaly/resources/text_style.dart';
import 'package:referaly/utils/translations.dart';
import '../controller/document_controller.dart';

class DocumentScreen extends GetView<DocumentController> {
  static String pageId = "/documents";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        title: Text(
          tr(LanguageKeys.viewDocuments),
          style: stylePoppins(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: Obx(() => ListView.builder(
            itemCount: controller.documentList.value?.data?.length ?? 0,
            itemBuilder: (context, index) {
              final doc = controller.documentList.value?.data?[index];
              return ListTile(
                leading: Icon(Icons.picture_as_pdf, color: Colors.red),
                title: Text(doc?.name ?? '',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: stylePoppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    )),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.purple,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Image.asset(
                        AppAssets.imgAddDoc,
                        height: 18,
                        width: 18,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(width: 8),
                    GestureDetector(
                      onTap: () {
                        Get.bottomSheet(
                          shareBottomSheet(context),
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                        );
                      },
                      child: Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.purple,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Image.asset(
                          AppAssets.imgShare,
                          height: 18,
                          width: 18,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          )),
    );
  }

  Widget shareBottomSheet(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Spacer(),
              Text(tr(LanguageKeys.share),
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              Spacer(),
              GestureDetector(
                onTap: () => Get.back(),
                child: Icon(Icons.close, size: 24),
              ),
            ],
          ),
          SizedBox(height: 24),
          Container(
            padding: EdgeInsets.all(24),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.purple, width: 1.5),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Image.asset(
              AppAssets.imgShare,
              height: 56,
              width: 56,
              color: Colors.purple,
            ),
          ),
          SizedBox(height: 12),
          Text(tr(LanguageKeys.shareDirect),
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
          SizedBox(height: 24),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                IconButton(
                    icon: Image.asset(AppAssets.imgAddDoc),
                    iconSize: 26,
                    onPressed: () {}),
                IconButton(
                    icon: Image.asset(AppAssets.imgAddDoc),
                    iconSize: 26,
                    onPressed: () {}),
                IconButton(
                    icon: Image.asset(AppAssets.imgAddDoc),
                    iconSize: 26,
                    onPressed: () {}),
                IconButton(
                    icon: Image.asset(AppAssets.imgAddDoc),
                    iconSize: 26,
                    onPressed: () {}),
                IconButton(
                    icon: Image.asset(AppAssets.imgAddDoc),
                    iconSize: 26,
                    onPressed: () {}),
                IconButton(
                    icon: Image.asset(AppAssets.imgAddDoc),
                    iconSize: 26,
                    onPressed: () {}),
              ],
            ),
          ),
          SizedBox(height: 16),
        ],
      ),
    );
  }
}
