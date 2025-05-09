import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:referaly/apis/rest_auth.dart';
import '../models/model_user_profile.dart';
import 'package:get/get.dart';

class EditProfileController extends GetxController {
  final formKey = GlobalKey<FormState>();

  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final jobController = TextEditingController();
  final cityController = TextEditingController();
  final languageController = TextEditingController();
  final Rx<File?> pickedImage = Rx<File?>(null);
  final RxString imageUrl = ''.obs;
  final ImagePicker _picker = ImagePicker();
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final RxBool isImageChanged = false.obs;
  var userType = 'Professional'.obs;

  // Country code dropdown support
  final countryCodes = ['+1', '+91', '+44']; // Add more as needed
  var selectedCountryCode = '+1'.obs;

  void setUserType(String value) => userType.value = value;

  String get fullPhoneNumber =>
      '${selectedCountryCode.value} ${phoneController.text}';

  bool validateAndSave() {
    final form = formKey.currentState;
    if (form != null && form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  void setCompanyData({
    required String firstName,
    required String lastName,
    required String email,
    required String phone,
    required String image,
    required String job,
    required String city,
    required String language,
  }) {
    firstNameController.text = firstName;
    lastNameController.text = lastName;
    emailController.text = email;
    phoneController.text = phone;
    jobController.text = job;
    cityController.text = city;
    languageController.text = language;
  }

  UserProfile getUserProfile() {
    return UserProfile(
      firstName: firstNameController.text,
      lastName: lastNameController.text,
      email: emailController.text,
      phone: fullPhoneNumber,
      userType: userType.value,
      job: jobController.text,
      city: cityController.text,
      language: languageController.text,
    );
  }

  @override
  void onClose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    jobController.dispose();
    cityController.dispose();
    languageController.dispose();
    super.onClose();
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

  Future<bool> updateProfile() async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      File? imageFile;
      if (isImageChanged.value && pickedImage.value != null) {
        imageFile = pickedImage.value;
      } else if (imageUrl.value.isNotEmpty) {
        imageFile = await _downloadImageFile(imageUrl.value);
      }

      final response = await RESTAuth.updateProfile(
        firstName: firstNameController.text,
        lastName: lastNameController.text,
        city: cityController.text,
        email: emailController.text,
        phone: phoneController.text,
        job: jobController.text,
        language: languageController.text,
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
}
