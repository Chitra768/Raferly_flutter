import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:referaly/languages/languagekeys.dart';
import 'package:referaly/resources/app_assets.dart';
import 'package:referaly/resources/app_colors.dart';
import 'package:referaly/resources/text_style.dart';
import 'package:referaly/utils/translations.dart';
import 'package:referaly/widgets/share_popup.dart';
import '../controller/document_controller.dart';
import 'package:dotted_border/dotted_border.dart';

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
      floatingActionButton: controller.type.value != "active"
          ? null
          : FloatingActionButton(
              backgroundColor: AppColors.primary,
              shape: const CircleBorder(),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => UploadFilePopup(
                    id: controller.id ?? '',
                  ),
                );
              },
              child: const Icon(Icons.add, color: Colors.white),
            ),
      body: Obx(() => ListView.builder(
            itemCount: controller.documentList.value?.data?.length ?? 0,
            itemBuilder: (context, index) {
              final doc = controller.documentList.value?.data?[index];
              return ListTile(
                leading: const Icon(Icons.picture_as_pdf, color: Colors.red),
                title: Text(doc?.name ?? '',
                    style: stylePoppins(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    )),
                onTap: () => controller.openDocument((doc?.document!) ?? ''),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (index != 0)
                      GestureDetector(
                        onTap: () {
                          // TODO: Implement delete functionality
                          controller.deleteDocument(doc?.id ?? '');
                        },
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(3),
                          ),
                          child: Icon(
                            Icons.delete,
                            size: 22.sp,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    if (index != 0) SizedBox(width: 8.w),
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(3),
                      ),
                      child: Image.asset(
                        AppAssets.imgAddDoc,
                        height: 22.h,
                        width: 22.w,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: () {
                        Get.dialog(
                          SharePopup(
                            title: controller
                                    .documentList.value?.data?[index].name ??
                                '',
                            link: controller.documentList.value?.data?[index]
                                    .document ??
                                '',
                          ),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(3),
                        ),
                        child: Image.asset(
                          AppAssets.imgShare,
                          height: 22.h,
                          width: 22.w,
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
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              const Spacer(),
              Text(tr(LanguageKeys.share),
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 18)),
              const Spacer(),
              GestureDetector(
                onTap: () => Get.back(),
                child: const Icon(Icons.close, size: 24),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.primary, width: 1.5),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Image.asset(
              AppAssets.imgShare,
              height: 56,
              width: 56,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 12),
          Text(tr(LanguageKeys.shareDirect),
              style:
                  const TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
          const SizedBox(height: 24),
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
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

// UploadFilePopup widget for uploading PDF files only
class UploadFilePopup extends StatefulWidget {
  final String id;
  const UploadFilePopup({Key? key, required this.id}) : super(key: key);

  @override
  State<UploadFilePopup> createState() => _UploadFilePopupState();
}

class _UploadFilePopupState extends State<UploadFilePopup> {
  List<PlatformFile> selectedFiles = [];
  bool notifyNetwork = true;
  final DocumentController controller = Get.find();
  Future<void> pickPdfFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
      allowMultiple: true,
    );

    if (result != null && result.files.isNotEmpty) {
      setState(() {
        selectedFiles.addAll(result.files
            .where((file) => !selectedFiles.any((f) => f.path == file.path)));
      });
    } else {
      print('File picking cancelled.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: Colors.white,
      insetPadding: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                const Spacer(),
                Text(tr(LanguageKeys.uploadFile),
                    style: stylePoppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.black)),
                const Spacer(),
                GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: const Icon(Icons.close),
                ),
              ],
            ),
            const SizedBox(height: 24),
            // File selection area
            GestureDetector(
              onTap: pickPdfFile,
              child: DottedBorder(
                color: Colors.grey,
                strokeWidth: 1.5,
                borderType: BorderType.RRect,
                radius: const Radius.circular(6),
                dashPattern: const [5, 3],
                child: Container(
                  height: 130,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.insert_drive_file,
                            size: 32, color: Colors.grey),
                        const SizedBox(height: 8),
                        Text(tr(LanguageKeys.browseFile)),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            if (selectedFiles.isNotEmpty)
              SizedBox(
                height: 160,
                child: Scrollbar(
                  thumbVisibility: true,
                  child: ListView(
                    children: selectedFiles
                        .map((file) => Container(
                              margin: const EdgeInsets.only(bottom: 8),
                              padding: const EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 12),
                              child: Row(
                                children: [
                                  const Icon(Icons.picture_as_pdf,
                                      color: Colors.red, size: 28),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                      file.name,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 15),
                                    ),
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.delete,
                                        color: AppColors.primary, size: 20),
                                    onPressed: () {
                                      setState(() {
                                        selectedFiles.remove(file);
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ))
                        .toList(),
                  ),
                ),
              ),
            Row(
              children: [
                Checkbox(
                  value: notifyNetwork,
                  onChanged: (val) =>
                      setState(() => notifyNetwork = val ?? true),
                  activeColor: AppColors.primary,
                ),
                Obx(() => Text(tr(LanguageKeys.uploadAndNotify))),
              ],
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
              ),
              onPressed: selectedFiles.isEmpty
                  ? null
                  : () async {
                      // Close the popup immediately when button is pressed
                      Navigator.of(context).pop();

                      // Collect all files with valid paths
                      final files = selectedFiles
                          .where((file) => file.path != null)
                          .map((file) => File(file.path!))
                          .toList();

                      if (files.isNotEmpty) {
                        await controller.uploadDocument(
                          widget.id,
                          notifyNetwork == true ? '1' : '0',
                          files,
                        );
                      }
                    },
              child: Obx(() => Text(
                    tr(LanguageKeys.assignModalSubmit),
                    style: stylePoppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white),
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
