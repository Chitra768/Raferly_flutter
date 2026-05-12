import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:referaly/languages/languagekeys.dart';
import 'package:referaly/resources/app_assets.dart';
import 'package:referaly/resources/app_colors.dart';
import 'package:referaly/controller/controller_main_professional.dart';
import 'package:referaly/helpers/premium_helper.dart';
import 'package:referaly/resources/app_helper.dart';
import 'package:referaly/resources/text_style.dart';
import 'package:referaly/utils/translations.dart';

import '../controller/document_controller.dart';
import '../models/model_document_list.dart';

class DocumentScreen extends GetView<DocumentController> {
  static String pageId = "/documents";

  const DocumentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
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
      title: Text(
        tr(LanguageKeys.viewDocuments),
        style: stylePoppins(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: Colors.black,
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // MAIN BODY
  // ---------------------------------------------------------------------------

  Widget _buildBody() {
    return Obx(() {
      final context = Get.context!;
      return Column(
        children: [
          // Upload Documents Section
          if (controller.type.value == "active") _buildUploadSection(context),
          // Document List
          Expanded(
            child: controller.documentList.value?.data?.isEmpty ?? true
                ? const SizedBox.shrink()
                : ListView.builder(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    itemCount: controller.documentList.value?.data?.length ?? 0,
                    itemBuilder: (context, index) {
                      final doc = controller.documentList.value?.data?[index];
                      var dotPosition = doc!.document!.lastIndexOf('.');
                      var extension = doc.document!
                          .substring(dotPosition + 1)
                          .toLowerCase();
                      return _buildDocumentListItem(
                          context,  index, extension,controller.documentList.value?.data![index],);
                    },
                  ),
          ),
        ],
      );
    });
  }

  // ---------------------------------------------------------------------------
  // UPLOAD SECTION
  // ---------------------------------------------------------------------------

  Widget _buildUploadSection(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      child: DottedBorder(
        color: AppColors.primary,
        strokeWidth: 2,
        borderType: BorderType.RRect,
        radius: const Radius.circular(12),
        dashPattern: const [8, 4],
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
          decoration: BoxDecoration(
            color: AppColors.primaryLightPink,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              // Cloud Icon
              Container(
                width: 64,
                height: 64,
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.cloud_upload,
                  color: Colors.white,
                  size: 32,
                ),
              ),
              const SizedBox(height: 16),
              // Title
              Text(
                tr(LanguageKeys.uploadDocuments),
                style: stylePoppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 8),
              // Subtitle
              Text(
                tr(LanguageKeys.shareWithYourBusinessNetwork),
                style: stylePoppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: AppColors.greyFontColor,
                ),
              ),
              const SizedBox(height: 20),
              // Add Document Button
              ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => UploadFilePopup(
                      id: controller.id,
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.add, color: Colors.white, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      tr(LanguageKeys.addDocument),
                      style: stylePoppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // DOCUMENT LIST ITEM
  // ---------------------------------------------------------------------------

  Widget _buildDocumentListItem(
      BuildContext context, int index, String extension, Data? data,) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          // File Type Icon
          _buildFileTypeIcon(extension),
          const SizedBox(width: 16),
          // Document Name
          Expanded(
            child: Text(
              data?.name ?? '',
              style: stylePoppins(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
          ),
          const SizedBox(width: 16),
          // Action Icons
          _buildActionIcons(context, data, index),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // FILE TYPE ICON
  // ---------------------------------------------------------------------------

  Widget _buildFileTypeIcon(String extension) {
    Color iconColor;
    Widget iconWidget;

    switch (extension.toLowerCase()) {
      case 'pdf':
        iconColor = const Color(0xFFFEE2E2);
        iconWidget =
            Icon(Icons.picture_as_pdf, color: AppColors.redColor, size: 24);
        break;
      case 'doc':
      case 'docx':
        iconColor = const Color(0xFFDBEAFE); // Blue for Word
        iconWidget = Icon(
          Icons.description,
          color: AppColors.buttonBlue,
          size: 24,
        );
        break;
      case 'xls':
      case 'xlsx':
        iconColor = const Color(0xFFDCFCE7); // Green for Excel
        iconWidget = Icon(
          Icons.table_chart,
          color: AppColors.success300,
          size: 24,
        );
        break;
      case 'ppt':
      case 'pptx':
        iconColor = const Color(0xFFF3ECFF); // Orange-red for PowerPoint
        iconWidget = const Icon(
          Icons.slideshow,
          color: Colors.white,
          size: 24,
        );
        break;
      case 'jpg':
      case 'jpeg':
      case 'png':
      case 'gif':
        iconColor = const Color(0xFFFF9800); // Orange for Images
        iconWidget = const Icon(
          Icons.image,
          size: 24,
        );
        break;
      default:
        iconColor = const Color(0xFFDBEAFE); // Blue for Word
        iconWidget = Icon(
          Icons.description,
          color: AppColors.buttonBlue,
          size: 24,
        );
        break;
    }

    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: iconColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: iconWidget,
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // ACTION ICONS
  // ---------------------------------------------------------------------------

  Widget _buildActionIcons(BuildContext context, Data? data, int index) {
    // LEGACY: edit/delete allowed when is_paid != '0'
    final isPremium = PremiumHelper.isPremiumUser(
      Get.isRegistered<ControllerMainProfessional>()
          ? Get.find<ControllerMainProfessional>().profile.value?.data
          : null,
    );
    AppHelper.showLog("document: ${data?.document!}");

    return Row(
      children: [
        // View Icon (always visible)
        GestureDetector(
          onTap: () => {
            AppHelper.showLog("document: ${data?.document!}"),
            controller.openPdfBottomSheet(context, (data?.document!) ?? '')
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Icon(
              Icons.visibility_outlined,
              color: AppColors.greyFontColor,
              size: 20,
            ),
          ),
        ),
        // Edit Icon (premium roles only)
        if (isPremium)
          GestureDetector(
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => EditDocumentNameDialog(
                  documentId: data?.id ?? '',
                  currentName: data?.name ?? '',
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Icon(
                Icons.edit_outlined,
                color: AppColors.greyFontColor,
                size: 20,
              ),
            ),
          ),
        // Delete Icon (premium roles only)
        if (isPremium)
          GestureDetector(
            onTap: () => controller.deleteDocument(data?.id ?? ''),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Icon(
                Icons.delete_outline,
                color: AppColors.greyFontColor,
                size: 20,
              ),
            ),
          ),
      ],
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
        final controller = fileNameControllers[key];
        final newName = controller?.text.trim();

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

// =============================================================================
// EDIT DOCUMENT NAME DIALOG
// =============================================================================

class EditDocumentNameDialog extends StatefulWidget {
  final String documentId;
  final String currentName;

  const EditDocumentNameDialog({
    Key? key,
    required this.documentId,
    required this.currentName,
  }) : super(key: key);

  @override
  State<EditDocumentNameDialog> createState() => _EditDocumentNameDialogState();
}

class _EditDocumentNameDialogState extends State<EditDocumentNameDialog> {
  late TextEditingController nameController;
  final DocumentController controller = Get.find();
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.currentName);
  }

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  Future<void> _handleSave() async {
    final newName = nameController.text.trim();

    // Validate name
    if (newName.isEmpty) {
      setState(() {
        errorMessage = 'Document name cannot be empty';
      });
      return;
    }

    if (newName.length > 255) {
      setState(() {
        errorMessage = 'Name should be upto 255 characters only.';
      });
      return;
    }

    // Clear error
    setState(() {
      errorMessage = null;
    });

    // Close dialog first
    Navigator.of(context).pop();

    // Call API
    await controller.updateDocumentName(widget.documentId, newName);

    // Show error if update failed
    if (controller.updateNameError.value.isNotEmpty) {
      if (Get.context != null) {
        await showDialog(
          context: Get.context!,
          builder: (context) => Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            backgroundColor: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    tr(LanguageKeys.whoops),
                    style: stylePoppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    controller.updateNameError.value,
                    style: stylePoppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Colors.black87,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text(
                        tr(LanguageKeys.okay),
                        style:
                            const TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          barrierDismissible: false,
        );
      }
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
            _buildDialogHeader(),
            const SizedBox(height: 24),
            _buildNameField(),
            if (errorMessage != null) ...[
              const SizedBox(height: 8),
              _buildErrorMessage(),
            ],
            const SizedBox(height: 24),
            _buildActionButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildDialogHeader() {
    return Row(
      children: [
        const Spacer(),
        Text(
          tr(LanguageKeys.edit),
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

  Widget _buildNameField() {
    return TextField(
      controller: nameController,
      autofocus: true,
      maxLength: 255,
      decoration: InputDecoration(
        labelText: tr(LanguageKeys.enterName),
        hintText: tr(LanguageKeys.enterName),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.red, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.red, width: 2),
        ),
      ),
      onChanged: (value) {
        if (errorMessage != null) {
          setState(() {
            errorMessage = null;
          });
        }
      },
    );
  }

  Widget _buildErrorMessage() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        errorMessage ?? '',
        style: stylePoppins(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: Colors.red,
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: () => Navigator.of(context).pop(),
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: AppColors.primary),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: Text(
              tr(LanguageKeys.cancel),
              style: stylePoppins(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Obx(
            () => ElevatedButton(
              onPressed: controller.isUpdatingName.value ? null : _handleSave,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: controller.isUpdatingName.value
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : Text(
                      tr(LanguageKeys.save),
                      style: stylePoppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
            ),
          ),
        ),
      ],
    );
  }
}
