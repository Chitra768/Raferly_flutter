import 'package:get/get.dart';
import 'package:referaly/apis/api_result.dart';
import 'package:referaly/apis/rest_auth.dart';
import 'package:referaly/languages/languagekeys.dart';
import 'package:referaly/models/model_document_list.dart';
import 'package:referaly/utils/translations.dart';
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

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args is Map<String, dynamic>) {
      id = args['id'] ?? '';
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
    final uri = Uri.parse(documentUrl);
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
}
