import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:referaly/languages/languagekeys.dart';
import 'package:referaly/resources/app_assets.dart';
import 'package:referaly/resources/app_colors.dart';
import 'package:referaly/resources/app_helper.dart';
import 'package:referaly/resources/text_style.dart';
import 'package:referaly/utils/translations.dart';
import 'package:referaly/widgets/dialog/share_document_bottom_sheet.dart';

import '../controller/document_controller.dart';

class DocumentScreen extends GetView<DocumentController> {
  static String pageId = "/documents";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      floatingActionButton: _buildFloatingActionButton(context),
      body: _buildBody(),
    );
  }

  // ---------------------------------------------------------------------------
  // APP BAR
  // ---------------------------------------------------------------------------

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      surfaceTintColor: Colors.transparent,
      backgroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
        onPressed: () => Get.back(),
      ),
      centerTitle: true,
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(
            AppAssets.imgFolder,
            height: 24.h,
            width: 24.w,
          ),
          const SizedBox(width: 8),
          Text(
            tr(LanguageKeys.viewDocuments),
            style: stylePoppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // FLOATING ACTION BUTTON
  // ---------------------------------------------------------------------------

  Widget? _buildFloatingActionButton(BuildContext context) {
    if (controller.type.value != "active") return null;

    return FloatingActionButton(
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
    );
  }

  // ---------------------------------------------------------------------------
  // MAIN BODY
  // ---------------------------------------------------------------------------

  Widget _buildBody() {
    return Obx(() => ListView.builder(
          itemCount: controller.documentList.value?.data?.length ?? 0,
          itemBuilder: (context, index) {
            // extract extension from the document URL or name if needed for different icons per
            // file.
            final doc = controller.documentList.value?.data?[index];

            print("name: ${doc?.document}");
            // get last occurrence of '.' and get substring after it
            var dotPosition = doc!.document!.lastIndexOf('.');
            print("dotPosition: $dotPosition");
            var extension = doc!.document!.substring(dotPosition + 1);
            print("extension: $extension");

            return _buildDocumentListItem(context, doc, index, extension);
          },
        ));
  }

  // ---------------------------------------------------------------------------
  // DOCUMENT LIST ITEM
  // ---------------------------------------------------------------------------

  Widget _buildDocumentListItem(
      BuildContext context, dynamic doc, int index, String extension) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Material(
        borderRadius: BorderRadius.circular(16),
        elevation: 3,
        child: Container(
          width: double.infinity,
          height: AppHelper.getScreenHeight(context) * 0.22,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 2,
                blurRadius: 5,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: extension == 'pdf'
                          ? AppColors.redColor.withOpacity(0.1)
                          : AppColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Image.asset(
                      // show different icon based on file type if needed
                      extension == 'pdf'
                          ? AppAssets.imgPdf
                          : AppAssets.imgDocFile,
                      height: 20.h,
                      width: 20.w,
                    ),
                  ),
                  title: Text(
                    doc?.name ?? '',
                    style: stylePoppins(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
                  ),
                  onTap: () => controller.openPdfBottomSheet(
                      context, (doc?.document!) ?? ''),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8.0, vertical: 4.0),
                  child: _buildActionButtons(context, doc, index),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // ACTION BUTTONS (DELETE, VIEW, SHARE)
  // ---------------------------------------------------------------------------

  Widget _buildActionButtons(BuildContext context, dynamic doc, int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Delete Button
          if (index != 0) ...[
            Expanded(
              child: _buildDeleteButton(doc, context),
            ),
            const SizedBox(width: 8),
          ],

          // View Document Button
          Expanded(
            child: _buildViewButton(context),
          ),
          const SizedBox(width: 8),

          // Share Button
          Expanded(
            child: _buildShareButton(index, context),
          ),
        ],
      ),
    );
  }

  Widget _buildDeleteButton(dynamic doc, context) {
    return GestureDetector(
      onTap: () {
        controller.deleteDocument(doc?.id ?? '');
      },
      child: Container(
        height: AppHelper.getScreenHeight(context) * 0.09,
        width: AppHelper.getScreenHeight(context) * 0.09,
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
    );
  }

  Widget _buildViewButton(BuildContext context) {
    return GestureDetector(
      onTap: () {
        controller.openPdfBottomSheet(
            context, controller.documentList.value?.data?[0].document ?? '');
      },
      child: Container(
        height: 65,
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(
              Icons.visibility,
              color: Colors.white,
              size: 22,
            ),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                tr(LanguageKeys.viewDocuments),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.visible,
                style: stylePoppins(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShareButton(int index, BuildContext context) {
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (context) => ShareDocumentBottomSheet(
            documentName:
                controller.documentList.value?.data?[index].name ?? '',
            documentUrl:
                controller.documentList.value?.data?[index].document ?? '',
          ),
        );
      },
      child: Container(
        height: 65,
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        decoration: BoxDecoration(
          color: const Color.fromRGBO(222, 196, 248, 1.0),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgPicture.asset(
              AppAssets.imgRevert,
              height: 22.h,
              width: 22.w,
            ),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                tr(LanguageKeys.shareDocument),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.visible,
                style: stylePoppins(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // SHARE BOTTOM SHEET (UNUSED - KEPT FOR REFERENCE)
  // ---------------------------------------------------------------------------

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
          _buildBottomSheetHeader(),
          const SizedBox(height: 24),
          _buildShareIcon(),
          const SizedBox(height: 12),
          _buildShareTitle(),
          const SizedBox(height: 24),
          _buildShareOptions(),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildBottomSheetHeader() {
    return Row(
      children: [
        const Spacer(),
        Text(
          tr(LanguageKeys.share),
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        const Spacer(),
        GestureDetector(
          onTap: () => Get.back(),
          child: const Icon(Icons.close, size: 24),
        ),
      ],
    );
  }

  Widget _buildShareIcon() {
    return Container(
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
    );
  }

  Widget _buildShareTitle() {
    return Text(
      tr(LanguageKeys.shareDirect),
      style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
    );
  }

  Widget _buildShareOptions() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(
          6,
          (index) => IconButton(
            icon: Image.asset(AppAssets.imgAddDoc),
            iconSize: 26,
            onPressed: () {},
          ),
        ),
      ),
    );
  }
}

// =============================================================================
// UPLOAD FILE POPUP
// =============================================================================

class UploadFilePopup extends StatefulWidget {
  final String id;

  const UploadFilePopup({Key? key, required this.id}) : super(key: key);

  @override
  State<UploadFilePopup> createState() => _UploadFilePopupState();
}

class _UploadFilePopupState extends State<UploadFilePopup> {
  // ---------------------------------------------------------------------------
  // STATE VARIABLES
  // ---------------------------------------------------------------------------

  List<PlatformFile> selectedFiles = [];
  Map<String, TextEditingController> fileNameControllers = {};
  Set<String> editingFiles = {};
  bool notifyNetwork = true;
  final DocumentController controller = Get.find();

  // ---------------------------------------------------------------------------
  // LIFECYCLE METHODS
  // ---------------------------------------------------------------------------

  @override
  void dispose() {
    for (var controller in fileNameControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  // ---------------------------------------------------------------------------
  // FILE PICKER METHOD
  // ---------------------------------------------------------------------------

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

  // ---------------------------------------------------------------------------
  // BUILD METHOD
  // ---------------------------------------------------------------------------

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
                _buildDialogHeader(),
                const SizedBox(height: 24),
                _buildFileSelectionArea(),
                const SizedBox(height: 16),
                _buildSelectedFilesList(),
                _buildNotificationCheckbox(),
                const SizedBox(height: 16),
                _buildSubmitButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // DIALOG COMPONENTS
  // ---------------------------------------------------------------------------

  Widget _buildDialogHeader() {
    return Row(
      children: [
        const Spacer(),
        Text(
          tr(LanguageKeys.uploadFile),
          style: stylePoppins(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        const Spacer(),
        GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: const Icon(Icons.close),
        ),
      ],
    );
  }

  Widget _buildFileSelectionArea() {
    return GestureDetector(
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
    );
  }

  Widget _buildSelectedFilesList() {
    if (selectedFiles.isEmpty) return const SizedBox.shrink();

    return SizedBox(
      height: 160,
      child: Scrollbar(
        thumbVisibility: true,
        child: ListView(
          children: selectedFiles.map((file) {
            return _buildFileListItem(file);
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildFileListItem(PlatformFile file) {
    final key = file.identifier ?? file.path ?? file.name;
    final isEditing = editingFiles.contains(key);

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      child: Row(
        children: [
          Image.asset(AppAssets.imgPdf, height: 28.h, width: 28.w),
          const SizedBox(width: 10),
          Expanded(child: _buildFileNameField(key, isEditing)),
          const SizedBox(width: 8),
          const Text('.pdf', style: TextStyle(fontSize: 15)),
          const SizedBox(width: 8),
          _buildEditButton(key),
          const SizedBox(width: 8),
          _buildDeleteButton(file, key),
        ],
      ),
    );
  }

  Widget _buildFileNameField(String key, bool isEditing) {
    if (isEditing) {
      return FocusScope(
        child: Focus(
          onFocusChange: (hasFocus) {
            if (!hasFocus) {
              setState(() {
                editingFiles.remove(key);
              });
            }
          },
          child: TextField(
            controller: fileNameControllers[key],
            autofocus: true,
            decoration: const InputDecoration(
              isDense: true,
              contentPadding: EdgeInsets.zero,
              border: InputBorder.none,
            ),
            style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
            onSubmitted: (_) {
              setState(() {
                editingFiles.remove(key);
              });
            },
          ),
        ),
      );
    }

    return GestureDetector(
      onTap: () {
        // Disabled tap to edit
      },
      child: Text(
        fileNameControllers[key]?.text ?? '',
        style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
      ),
    );
  }

  Widget _buildEditButton(String key) {
    return GestureDetector(
      onTap: () {
        setState(() {
          editingFiles.add(key);
        });
      },
      child: const Icon(Icons.edit, color: AppColors.primary, size: 20),
    );
  }

  Widget _buildDeleteButton(PlatformFile file, String key) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedFiles.remove(file);
          fileNameControllers[key]?.dispose();
          fileNameControllers.remove(key);
          editingFiles.remove(key);
        });
      },
      child: const Icon(Icons.delete, color: AppColors.primary, size: 20),
    );
  }

  Widget _buildNotificationCheckbox() {
    return Row(
      children: [
        Checkbox(
          value: notifyNetwork,
          onChanged: (val) => setState(() => notifyNetwork = val ?? true),
          activeColor: AppColors.primary,
        ),
        Obx(() => Text(tr(LanguageKeys.uploadAndNotify))),
      ],
    );
  }

  Widget _buildSubmitButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      onPressed: selectedFiles.isEmpty ? null : _handleSubmit,
      child: Obx(() => Text(
            tr(LanguageKeys.assignModalSubmit),
            style: stylePoppins(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          )),
    );
  }

  // ---------------------------------------------------------------------------
  // SUBMIT HANDLER
  // ---------------------------------------------------------------------------

  Future<void> _handleSubmit() async {
    Navigator.of(context).pop();

    // Collect all files with valid paths and apply new names
    final files = <File>[];
    final renamedFiles = <String, String>{};

    for (var file in selectedFiles) {
      if (file.path != null) {
        files.add(File(file.path!));
        final key = file.identifier ?? file.path ?? file.name;
        final newName = fileNameControllers[key]?.text?.trim();

        if (newName != null && newName.isNotEmpty) {
          renamedFiles[file.path!] =
              newName.endsWith('.pdf') ? newName : '$newName.pdf';
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
  }
}
