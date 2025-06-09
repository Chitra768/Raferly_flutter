import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:referaly/apis/rest_auth.dart';
import 'package:referaly/controller/controller_main_professional.dart';
import 'package:referaly/controller/controller_registration.dart';
import 'package:referaly/controller/my_profile_controller.dart';
import 'package:referaly/languages/languagekeys.dart';
import 'package:referaly/utils/translations.dart';
import 'package:referaly/widgets/dialog/success_popup.dart';
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
  RxString userType = 'Professional'.obs;
  RxInt isPaid = 0.obs;
  // Country and job selection

  final Rx<Country> selectedCountry = Country(
          name: 'United States', emoji: '🇺🇸', code: '+1', languageCode: 'en')
      .obs;

  final List<Country> countries = [
    Country(
        name: 'United States', emoji: '🇺🇸', code: '+1', languageCode: 'en'),
    Country(name: 'Spain', emoji: '🇪🇸', code: '+34', languageCode: 'es'),
    Country(name: 'Belgium', emoji: '🇧🇪', code: '+32', languageCode: 'es'),
    Country(name: 'France', emoji: '🇫🇷', code: '+33', languageCode: 'fr'),
    Country(
        name: 'Luxembourg', emoji: '🇱🇺', code: '+352', languageCode: 'es'),
    Country(
        name: 'Switzerland', emoji: '🇨🇭', code: '+41', languageCode: 'es'),
  ];

  // Country code dropdown support
  final countryCodes = ['+1', '+91', '+44']; // Add more as needed
  var selectedCountryCode = '+1'.obs;

  void setUserType(String value) => userType.value =
      value == tr(LanguageKeys.professional) ? "professional" : "individual";

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
    required String countryCode,
    required String city,
    required String language,
    required String userType1,
    required int isPaid,
  }) {
    firstNameController.text = firstName;
    lastNameController.text = lastName;
    emailController.text = email;
    phoneController.text = phone;
    this.isPaid.value = isPaid;
    // Set selectedCountry by finding the Country object from countryCode
    final Country? matchedCountry = countries.firstWhere(
      (country) => country.code == countryCode,
      orElse: () => countries.first,
    );
    selectedCountry.value = matchedCountry!;
    jobController.text = job;
    cityController.text = city;
    userType.value = userType1;
    languageController.text = language == "en" || language == "English"
        ? "English"
        : language == "es" || language == "Spanish"
            ? "Spanish"
            : language == "fr" || language == "French"
                ? "French"
                : "English";
    imageUrl.value = image;
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
      errorMessage.value = tr(LanguageKeys.somethingWentWrong);
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
      errorMessage.value = tr(LanguageKeys.somethingWentWrong);
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

    selectedCountry.refresh();

    try {
      File? imageFile;
      if (isImageChanged.value && pickedImage.value != null) {
        imageFile = pickedImage.value;
      } else if (imageUrl.value.isNotEmpty) {
        imageFile = await _downloadImageFile(imageUrl.value);
      }

      String languageCode = languageController.text == "English"
          ? "en"
          : languageController.text == "Spanish"
              ? "es"
              : languageController.text == "French"
                  ? "fr"
                  : "en";

      print("userType.value: ${userType.value}");

      final response = await RESTAuth.updateProfile(
        firstName: firstNameController.text,
        lastName: lastNameController.text,
        city: cityController.text,
        email: emailController.text,
        phone: phoneController.text,
        country: selectedCountry.value.name,
        countryCode: selectedCountry.value.code,
        job: jobController.text,
        language: languageCode ?? "en",
        image: imageFile,
        imageUrl: imageUrl.value,
        userType: userType.value,
      );

      if (response.isSuccess && response.data != null) {
        // Update image URL from response
        imageUrl.value = response.data!.data.companyLogoUrl;
        isImageChanged.value = false;
        isLoading.value = false;
        await Get.find<MyProfileController>().getProfile();

        await Get.dialog(
          SuccessPopup(
            message: tr(LanguageKeys.successMessage) ?? tr(LanguageKeys.successMessage),
            onOk: () {
              Get.back(); // Close the dialog
            },
          ),
          barrierDismissible: false,
        );
        return true;
      } else {
        errorMessage.value = response.error ?? response.message;
        return false;
      }
    } catch (e) {
      errorMessage.value = tr(LanguageKeys.somethingWentWrong);
      return false;
    } finally {
      isLoading.value = false;
    }
  }
}
