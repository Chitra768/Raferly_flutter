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
                leading: Image.asset(
                  AppAssets.imgPdf,
                  height: 40.h,
                  width: 40.w,
                ),
                title: Text(doc?.name ?? '',
                    style: stylePoppins(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    )),
                onTap: () => controller.openPdfBottomSheet(
                    context, (doc?.document!) ?? ''),
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
                        AppAssets.imgDocFile,
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
                          AppAssets.imgDocShare,
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
  Map<String, TextEditingController> fileNameControllers = {};
  Set<String> editingFiles = {};
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
        for (var file in result.files) {
          if (!selectedFiles.any((f) => f.path == file.path)) {
            selectedFiles.add(file);
            // Remove .pdf extension for editing
            final baseName = file.name.endsWith('.pdf')
                ? file.name.substring(0, file.name.length - 4)
                : file.name;
            fileNameControllers[file.identifier ?? file.path ?? file.name] =
                TextEditingController(text: baseName);
          }
        }
      });
    } else {
      print('File picking cancelled.');
    }
  }

  @override
  void dispose() {
    for (var controller in fileNameControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: Colors.white,
      insetPadding: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.8,
          ),
          child: SingleChildScrollView(
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
                        children: selectedFiles.map((file) {
                          final key = file.identifier ?? file.path ?? file.name;
                          final isEditing = editingFiles.contains(key);
                          return Container(
                            margin: const EdgeInsets.only(bottom: 8),
                            padding: const EdgeInsets.symmetric(
                                vertical: 8, horizontal: 12),
                            child: Row(
                              children: [
                                Image.asset(AppAssets.imgPdf,
                                    height: 28.h, width: 28.w),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: isEditing
                                      ? FocusScope(
                                          child: Focus(
                                            onFocusChange: (hasFocus) {
                                              if (!hasFocus) {
                                                setState(() {
                                                  editingFiles.remove(key);
                                                });
                                              }
                                            },
                                            child: TextField(
                                              controller:
                                                  fileNameControllers[key],
                                              autofocus: true,
                                              decoration: const InputDecoration(
                                                isDense: true,
                                                contentPadding: EdgeInsets.zero,
                                                border: InputBorder.none,
                                              ),
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 15),
                                              onSubmitted: (_) {
                                                setState(() {
                                                  editingFiles.remove(key);
                                                });
                                              },
                                            ),
                                          ),
                                        )
                                      : GestureDetector(
                                          onTap: () {
                                            // setState(() {
                                            //   editingFiles.add(key);
                                            // });
                                          },
                                          child: Text(
                                            fileNameControllers[key]?.text ??
                                                '',
                                            style: const TextStyle(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 15),
                                          ),
                                        ),
                                ),
                                const SizedBox(width: 8),
                                const Text('.pdf',
                                    style: TextStyle(fontSize: 15)),
                                const SizedBox(width: 8),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      editingFiles.add(key);
                                    });
                                  },
                                  child: const Icon(Icons.edit,
                                      color: AppColors.primary, size: 20),
                                ),
                                const SizedBox(width: 8),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      selectedFiles.remove(file);
                                      fileNameControllers[key]?.dispose();
                                      fileNameControllers.remove(key);
                                      editingFiles.remove(key);
                                    });
                                  },
                                  child: const Icon(Icons.delete,
                                      color: AppColors.primary, size: 20),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
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
                          Navigator.of(context).pop();
                          // Collect all files with valid paths and apply new names
                          final files = <File>[];
                          final renamedFiles = <String, String>{};
                          for (var file in selectedFiles) {
                            if (file.path != null) {
                              files.add(File(file.path!));
                              final key =
                                  file.identifier ?? file.path ?? file.name;
                              final newName =
                                  fileNameControllers[key]?.text?.trim();
                              if (newName != null && newName.isNotEmpty) {
                                renamedFiles[file.path!] =
                                    newName.endsWith('.pdf')
                                        ? newName
                                        : '$newName.pdf';
                              } else {
                                renamedFiles[file.path!] = file.name;
                              }
                            }
                          }
                          if (files.isNotEmpty) {
                            await controller.uploadDocument(
                              widget.id,
                              notifyNetwork == true ? '1' : '0',
                              files,
                              renamedFiles: renamedFiles,
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
        ),
      ),
    );
  }
}
