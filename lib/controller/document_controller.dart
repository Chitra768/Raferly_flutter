import 'package:get/get.dart';
import 'package:referaly/apis/api_result.dart';
import 'package:referaly/apis/rest_auth.dart';
import 'package:referaly/languages/languagekeys.dart';
import 'package:referaly/models/model_common.dart';
import 'package:referaly/models/model_document_list.dart';
import 'package:referaly/models/model_upload_document.dart';
import 'package:referaly/utils/translations.dart';
import 'package:referaly/widgets/dialog/success_popup.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'dart:io';
import 'package:flutter/material.dart';

class DocumentController extends GetxController {
  String id = '';
  final documents = [
    {'title': 'Business Referral Agreement', 'type': 'pdf'}
  ].obs;
  var type = "".obs;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args is Map<String, dynamic>) {
      id = args['id'] ?? '';
      type.value = args['type'] ?? '';
    }
    getDocumentList(id);
  }

  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;
  final Rx<ModelDocumentList?> documentList = Rx<ModelDocumentList?>(null);

  Future<void> getDocumentList(String id) async {
    try {
      isLoading.value = true;
      error.value = '';

      final response = await RESTAuth.getDocumentList(id);

      if (response is ApiSuccess<ModelDocumentList>) {
        if (response.data.status == true) {
          documentList.value = response.data;
        } else {
          error.value =
              response.data.message ?? tr(LanguageKeys.somethingWentWrong);
        }
      } else if (response is ApiFailure) {
        error.value =
            response.error.message ?? tr(LanguageKeys.somethingWentWrong);
      }
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  void openPdfBottomSheet(BuildContext context, String pdfUrl) {
    if (pdfUrl.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('PDF link is not available')),
      );
      return;
    }
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      enableDrag: false,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: [
              // Header
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                  color: Colors.white,
                  boxShadow: [BoxShadow(blurRadius: 4, color: Colors.black12)],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    )
                  ],
                ),
              ),
              // PDF Viewer
              const Divider(height: 1),
              Expanded(
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    bottom: Radius.circular(16),
                  ),
                  child: Container(
                    // Add iOS-specific scrolling behavior
                    child: SfPdfViewer.network(
                      pdfUrl,
                      // iOS-specific configurations for better scrolling
                      canShowScrollHead: true,
                      canShowScrollStatus: true,
                      enableDoubleTapZooming: true,
                      enableTextSelection: false,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  final RxBool isUploading = false.obs;
  final RxString uploadError = ''.obs;

  Future<void> uploadDocument(
      String id, String uploadNotify, List<File> pdfFiles,
      {Map<String, String>? renamedFiles}) async {
    try {
      isUploading.value = true;
      uploadError.value = '';

      final response = await RESTAuth.uploadDocument(id, uploadNotify, pdfFiles,
          renamedFiles: renamedFiles);
      if (response is ApiSuccess<ModelUploadDocument>) {
        if (response.data.status == true) {
          await getDocumentList(id);
          // Show success popup
          if (Get.context != null) {
            await showDialog(
              context: Get.context!,
              builder: (context) => SuccessPopup(
                message: response.data.message ?? '',
                onOk: () {},
              ),
              barrierDismissible: false,
            );
          }
        } else {
          uploadError.value =
              response.data.message ?? tr(LanguageKeys.somethingWentWrong);
        }
      } else if (response is ApiFailure) {
        uploadError.value =
            response.error.message ?? tr(LanguageKeys.somethingWentWrong);
      }
    } catch (e) {
      uploadError.value = e.toString();
    } finally {
      isUploading.value = false;
    }
  }

  Future<void> deleteDocument(String documentId) async {
    try {
      isLoading.value = true;
      error.value = '';

      final response = await RESTAuth.deleteDocument(documentId);
      if (response is ApiSuccess<ModelCommon>) {
        if (response.data.status == true) {
          await getDocumentList(id);
          if (Get.context != null) {
            await showDialog(
              context: Get.context!,
              builder: (context) => SuccessPopup(
                message: response.data.message ?? '',
                onOk: () {},
              ),
              barrierDismissible: false,
            );
          }
        } else {
          error.value =
              response.data.message ?? tr(LanguageKeys.somethingWentWrong);
        }
      } else if (response is ApiFailure) {
        error.value =
            response.error.message ?? tr(LanguageKeys.somethingWentWrong);
      }
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  final RxBool isUpdatingName = false.obs;
  final RxString updateNameError = ''.obs;

  Future<void> updateDocumentName(String documentId, String name) async {
    try {
      isUpdatingName.value = true;
      updateNameError.value = '';

      final response = await RESTAuth.updateDocumentName(documentId, name);
      if (response is ApiSuccess<ModelCommon>) {
        if (response.data.status == true) {
          await getDocumentList(id);
          if (Get.context != null) {
            await showDialog(
              context: Get.context!,
              builder: (context) => SuccessPopup(
                message: response.data.message ?? '',
                onOk: () {},
              ),
              barrierDismissible: false,
            );
          }
        } else {
          updateNameError.value =
              response.data.message ?? tr(LanguageKeys.somethingWentWrong);
        }
      } else if (response is ApiFailure) {
        // Handle validation errors
        String errorMessage =
            response.error.message ?? tr(LanguageKeys.somethingWentWrong);
        if (response.error.errors != null &&
            response.error.errors!.errorMap.isNotEmpty) {
          // Get the first error from the errors map
          final firstError = response.error.errors!.firstError;
          if (firstError != null) {
            errorMessage = firstError;
          }
        }
        updateNameError.value = errorMessage;
      }
    } catch (e) {
      updateNameError.value = e.toString();
    } finally {
      isUpdatingName.value = false;
    }
  }
}
