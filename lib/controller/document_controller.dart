import 'package:get/get.dart';
import 'package:referaly/apis/api_result.dart';
import 'package:referaly/apis/rest_auth.dart';
import 'package:referaly/languages/languagekeys.dart';
import 'package:referaly/models/model_common.dart';
import 'package:referaly/models/model_document_list.dart';
import 'package:referaly/models/model_upload_document.dart';
import 'package:referaly/utils/translations.dart';
import 'package:referaly/widgets/dialog/success_popup.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:path_provider/path_provider.dart';
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

  Future<void> openDocument(String documentUrl) async {
    final uri = Uri.parse(
        "https://docs.google.com/gview?embedded=true&url=" + documentUrl);
    if (await canLaunchUrl(uri)) {
      await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
    } else {
      Get.snackbar(
        tr(LanguageKeys.error),
        tr(LanguageKeys.couldNotOpenDocument),
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  final RxBool isUploading = false.obs;
  final RxString uploadError = ''.obs;

  Future<void> uploadDocument(
      String id, String uploadNotify, List<File> pdfFiles) async {
    try {
      isUploading.value = true;
      uploadError.value = '';

      final response =
          await RESTAuth.uploadDocument(id, uploadNotify, pdfFiles);
      if (response is ApiSuccess<ModelUploadDocument>) {
        if (response.data.status == true) {
          await getDocumentList(id);
          // Show success popup
          if (Get.context != null) {
            await showDialog(
              context: Get.context!,
              builder: (context) => SuccessPopup(
                message: response.data.message ?? '',
                onOk: () {

              },
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
}
