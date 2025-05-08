import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:referaly/apis/rest_auth.dart';
import 'package:referaly/models/model_company_profile_update.dart';
import 'package:referaly/models/model_api_response.dart';
import 'package:referaly/resources/app_strings.dart';

class EditCompanyProfileController extends GetxController {
  final Rx<File?> pickedImage = Rx<File?>(null);
  final RxString imageUrl = ''.obs;
  final ImagePicker _picker = ImagePicker();
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final RxBool isImageChanged = false.obs;

  // Text controllers for form fields
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController businessCodeController = TextEditingController();

  void setCompanyData({
    required String name,
    required String desc,
    required String addr,
    required String code,
    required String image,
    required String id,
    required String countryCode,
    required String ind,
    required String cntry,
  }) {
    nameController.text = name;
    descriptionController.text = desc;
    addressController.text = addr;
    businessCodeController.text = code;
    imageUrl.value = image;
    isImageChanged.value = false;
  }

  Future<void> pickImageFromCamera() async {
    try {
      final pickedFile = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 80,
      );
      if (pickedFile != null) {
        pickedImage.value = File(pickedFile.path);
        isImageChanged.value = true;
        errorMessage.value = '';
      }
    } catch (e) {
      errorMessage.value = 'Failed to capture image';
    }
  }

  Future<void> pickImageFromGallery() async {
    try {
      final pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );
      if (pickedFile != null) {
        pickedImage.value = File(pickedFile.path);
        isImageChanged.value = true;
        errorMessage.value = '';
      }
    } catch (e) {
      errorMessage.value = 'Failed to pick image';
    }
  }
Future<File?> _downloadImageFile(String url) async {
  try {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final tempDir = await getTemporaryDirectory();
      final file = File('${tempDir.path}/company_logo.jpg');
      await file.writeAsBytes(response.bodyBytes);
      return file;
    }
  } catch (e) {
    // handle error
  }
  return null;
}

  Future<bool> updateCompanyProfile() async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
       File? imageFile;
    if (isImageChanged.value && pickedImage.value != null) {
      imageFile = pickedImage.value;
    } else if (imageUrl.value.isNotEmpty) {
      imageFile = await _downloadImageFile(imageUrl.value);
    }

      final response = await RESTAuth.updateCompanyProfile(
        name: nameController.text,
        description: descriptionController.text,
        address: addressController.text,
        businessCode: businessCodeController.text,
        image: imageFile,
        imageUrl: imageUrl.value, // <-- Add this
      );

      if (response.isSuccess && response.data != null) {
        // Update image URL from response
        imageUrl.value = response.data!.data.companyLogoUrl;
        isImageChanged.value = false;

        // Show success message
        Get.snackbar(
          'Success',
          response.message,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        return true;
      } else {
        errorMessage.value = response.error ?? response.message;
        return false;
      }
    } catch (e) {
      errorMessage.value = 'An unexpected error occurred';
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  String getDisplayImage() {
    if (pickedImage.value != null) {
      return pickedImage.value!.path;
    }
    return imageUrl.value;
  }

  void clearImage() {
    pickedImage.value = null;
    isImageChanged.value = false;
  }

  @override
  void onClose() {
    nameController.dispose();
    descriptionController.dispose();
    addressController.dispose();
    businessCodeController.dispose();
    clearImage();
    super.onClose();
  }
}
