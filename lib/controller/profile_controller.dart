import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:referaly/apis/api_result.dart';
import 'package:referaly/apis/rest_auth.dart';
import 'package:referaly/controller/controller_main_professional.dart';
import 'package:referaly/controller/controller_registration.dart';
import 'package:referaly/controller/track_lead_controller.dart';
import 'package:referaly/languages/languagekeys.dart';
import 'package:referaly/models/model_common.dart';
import 'package:referaly/models/model_profile.dart';
import 'package:referaly/models/model_user_profile.dart';
import 'package:referaly/helpers/agency_colleague_access_helper.dart';
import 'package:referaly/helpers/premium_helper.dart';
import 'package:referaly/resources/app_helper.dart';
import 'package:referaly/resources/app_preference.dart';
import 'package:referaly/screens/auth/screen_initial_language.dart';
import 'package:referaly/screens/home/screen_main.dart';
import 'package:referaly/screens/onboarding/complete_profile_screen.dart';
import 'package:referaly/screens/profile/my_profile_screen.dart';
import 'package:referaly/utils/translations.dart';
import 'package:referaly/widgets/custom_toast_msg.dart';
import 'package:referaly/widgets/dialog/show_welcome_to_professional_dialog.dart';
import 'package:referaly/widgets/dialog/success_popup.dart';

class ProfileController extends GetxController {
  // ==================== Form Keys and Controllers ====================
  final formKey = GlobalKey<FormState>();

  // User profile form controllers
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final jobController = TextEditingController();
  final RxString selectedJobId = ''.obs;
  final cityController = TextEditingController();
  final languageController = TextEditingController();

  // Company profile form controllers
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final addressController = TextEditingController();
  final businessCodeController = TextEditingController();

  // ==================== Profile Data Observables ====================
  final Rx<ModelProfile?> profile = Rx<ModelProfile?>(null);
  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;
  final RxBool isProfileLoaded = false.obs;

  // ==================== Image Handling ====================
  final Rx<File?> pickedImage = Rx<File?>(null); // For user avatar
  final Rx<File?> pickedCompanyLogo = Rx<File?>(null); // For company logo
  final RxString imageUrl = ''.obs; // For user avatar
  final RxString companyLogoUrl = ''.obs; // For company logo
  final ImagePicker _picker = ImagePicker();
  final RxBool isImageChanged = false.obs; // For avatar
  final RxBool isCompanyLogoChanged = false.obs; // For company logo
  final RxString errorMessage = ''.obs;

  // ==================== User Type and Profile Settings ====================
  RxString userType = 'Professional'.obs;
  RxBool isEditUserType = false.obs;
  RxInt isPaid = 0.obs;

  // Allowed values for the `ui_type` field on the profile API.
  static const String uiTypeNormal = 'Normal';
  static const String uiTypeSimplified = 'Simplified';
  static const List<String> uiTypeOptions = <String>[
    uiTypeNormal,
    uiTypeSimplified,
  ];

  /// Current `ui_type` from the profile; defaults to [uiTypeNormal] until
  /// hydrated from the API (see [_updateFormControllersFromProfile]).
  RxString uiType = uiTypeNormal.obs;

  // ==================== Country Selection ====================
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

  // ==================== Update Profile Observables ====================
  final RxBool isUpdateLoading = false.obs;
  final RxString updateErrorMessage = ''.obs;

  // ==================== Delete Account Observables ====================
  final RxBool isDeleteAccountLoading = false.obs;
  final RxString deleteAccountErrorMessage = ''.obs;

  // ==================== Controller References ====================
  late final ControllerMainProfessional mainController =
      Get.isRegistered<ControllerMainProfessional>()
          ? Get.find<ControllerMainProfessional>()
          : Get.put(ControllerMainProfessional());

  @override
  void onInit() {
    super.onInit();
    getProfile();
  }

  // ==================== Profile Management ====================

  Future<void> getProfile() async {
    if (isLoading.value) return; // Prevent multiple simultaneous calls

    try {
      isLoading.value = true;
      error.value = '';

      final response = await RESTAuth.getProfile();

      if (response is ApiSuccess<ModelProfile>) {
        if (response.data.status == true) {
          profile.value = response.data;
          // Hydrate form controllers before isProfileLoaded so onboarding
          // screens that sync on that flag receive populated fields.
          _updateFormControllersFromProfile();
          await AppPreference.writeString(
              AppPreference.isPaid, response.data.data!.isPaid.toString());
          await PremiumHelper.persistRoleNames(response.data.data!.roleNames);
          await AgencyColleagueAccessHelper.persistFromData(response.data.data);
          await AppPreference.writeString(AppPreference.productId,
              response.data.data!.productId.toString());
          isProfileLoaded.value = true;
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

  void _updateFormControllersFromProfile() {
    if (profile.value?.data != null) {
      final profileData = profile.value!.data!;

      // Update form controllers with current profile data
      firstNameController.text = profileData.firstName ?? '';
      lastNameController.text = profileData.lastName ?? '';
      emailController.text = profileData.email ?? '';
      phoneController.text = profileData.phoneNumber ?? '';
      jobController.text = profileData.job ?? '';
      selectedJobId.value = profileData.jobId?.trim() ?? '';
      cityController.text = profileData.city ?? '';

      // Set language controller with proper format
      final lang = profileData.lang?.toLowerCase() ?? '';
      languageController.text =
          lang == 'es' || lang == 'spanish' || lang == 'Spanish'
              ? 'Español'
              : lang == 'en' || lang == 'english' || lang == 'English'
                  ? 'English'
                  : lang == 'fr' || lang == 'french' || lang == 'French'
                      ? 'Français'
                      : 'English';

      // Set country selection
      final profileCountryCode = profileData.countryCode ?? '+1';
      final Country? matchedCountry = countries.firstWhereOrNull(
        (country) => country.code == profileCountryCode,
      );
      if (matchedCountry != null) {
        selectedCountry.value = matchedCountry;
        selectedCountryCode.value = profileCountryCode;
      }

      // Set user type
      final type = profileData.companyType?.toLowerCase() ?? '';
      print(type);
      userType.value = (type == 'professional') ? 'professional' : 'individual';

      uiType.value = _normalizeUiTypeForUserType(profileData.uiType, userType.value);

      isPaid.value = profileData.isPaid ?? 0;

      // Update image URLs separately
      imageUrl.value = profileData.avatarUrl ?? '';
      companyLogoUrl.value = profileData.companyLogoUrl ?? '';

      setCompanyData(
          name: profileData.companyName ?? '',
          desc: profileData.companyDescription ?? '',
          addr: profileData.companyAddress ?? '',
          code: profileData.companyNumber ?? '',
          image: profileData.companyLogoUrl ?? '',
          id: profileData.companyId ?? '',
          countryCode: profileData.countryCode ?? '',
          ind: profileData.industry ?? '',
          cntry: profileData.country ?? '');
    }
  }

  // ==================== Profile Data Getters ====================

  String get firstName => profile.value?.data?.firstName ?? '';
  String get lastName => profile.value?.data?.lastName ?? '';
  String get email => profile.value?.data?.email ?? '';
  String get phone => profile.value?.data?.phoneNumber ?? '';
  String get userTypeDisplay {
    final type = profile.value?.data?.companyType?.toLowerCase() ?? '';
    final lang = profile.value?.data?.lang?.toLowerCase() ?? '';
    if (lang == 'fr' || lang == 'french') {
      if (type == 'professional') return tr(LanguageKeys.professional);
      if (type == 'individual') return tr(LanguageKeys.individual);
    } else if (lang == 'es' || lang == 'spanish') {
      if (type == 'professional') return tr(LanguageKeys.professional);
      if (type == 'individual') return 'Particular';
    } else {
      // Default to English
      if (type == 'professional') return tr(LanguageKeys.professional);
      if (type == 'individual') return tr(LanguageKeys.individual);
    }
    return type;
  }

  String get job => profile.value?.data?.job ?? '';
  String get city => profile.value?.data?.city ?? '';
  String get language {
    final lang = profile.value?.data?.lang?.toLowerCase() ?? '';
    if (lang == 'es' || lang == 'spanish' || lang == 'Spanish') {
      return 'Español';
    } else if (lang == 'en' || lang == 'english' || lang == 'English') {
      return 'English';
    } else if (lang == 'fr' || lang == 'french' || lang == 'French') {
      return 'Français';
    }
    return lang;
  }

  String get profileImage => profile.value?.data?.avatarUrl ?? '';
  String get countryCode => profile.value?.data?.countryCode ?? '';
  int get isPaidValue => profile.value?.data?.isPaid ?? 0;

  // ==================== User Type Management ====================

  void setUserType(String value) {
    userType.value =
        value == tr(LanguageKeys.professional) ? "professional" : "individual";
    uiType.value = _normalizeUiTypeForUserType(uiType.value, userType.value);
    if (userType.value == 'individual') {
      _clearJobSelection();
    }
  }

  void onJobSelected(int id, String title) {
    selectedJobId.value = id.toString();
  }

  void _clearJobSelection() {
    jobController.clear();
    selectedJobId.value = '';
  }

  int? get selectedJobIdAsInt => int.tryParse(selectedJobId.value);

  /// Snaps any incoming value to one of the supported [uiTypeOptions],
  /// defaulting to [uiTypeNormal] for unknown / null / empty input.
  String _normalizeUiType(String? raw) {
    if (raw == null) return uiTypeNormal;
    final trimmed = raw.trim();
    if (trimmed.isEmpty) return uiTypeNormal;
    for (final option in uiTypeOptions) {
      if (option.toLowerCase() == trimmed.toLowerCase()) return option;
    }
    return uiTypeNormal;
  }

  String _normalizeUiTypeForUserType(String? raw, String selectedUserType) {
    final normalized = _normalizeUiType(raw);
    if (selectedUserType.toLowerCase() == 'individual' &&
        normalized == uiTypeNormal) {
      return uiTypeSimplified;
    }
    return normalized;
  }

  void setUiType(String? value) {
    uiType.value = _normalizeUiTypeForUserType(value, userType.value);
  }

  String get fullPhoneNumber =>
      '${selectedCountryCode.value} ${phoneController.text}';

  // ==================== Form Validation ====================

  bool validateAndSave() {
    final form = formKey.currentState;
    if (form != null && form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  // ==================== Data Setup Methods ====================

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
    companyLogoUrl.value = image;
    isCompanyLogoChanged.value = false;
    pickedCompanyLogo.value = null;
    updateErrorMessage.value = '';
  }

  void setUserProfileData({
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
    AppHelper.showLog("userType1: $userType1");
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
    userType.value = userType1 == tr(LanguageKeys.professional)
        ? "professional"
        : "individual";
    languageController.text = language == "en" || language == "English"
        ? "English"
        : language == "es" || language == "Spanish" || language == "Español"
            ? "Español"
            : language == "fr" || language == "French" || language == "Français"
                ? "Français"
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

  // ==================== Change Detection ====================

  bool get hasPersonalChanges {
    final data = profile.value?.data;
    if (data == null) return false;

    // Compute display language the same way controllers were initialized
    final profileLang = (data.lang?.toLowerCase() ?? '');
    final expectedLanguageDisplay = profileLang == 'es' ||
            profileLang == 'spanish' ||
            profileLang == 'spanish'
        ? 'Español'
        : profileLang == 'en' ||
                profileLang == 'english' ||
                profileLang == 'english'
            ? 'English'
            : profileLang == 'fr' ||
                    profileLang == 'french' ||
                    profileLang == 'french'
                ? 'Français'
                : 'English';

    final expectedUserType =
        (data.companyType?.toLowerCase() ?? '') == 'professional'
            ? 'professional'
            : 'individual';

    final expectedUiType = _normalizeUiType(data.uiType);

    return isImageChanged.value ||
        firstNameController.text != (data.firstName ?? '') ||
        lastNameController.text != (data.lastName ?? '') ||
        emailController.text != (data.email ?? '') ||
        phoneController.text != (data.phoneNumber ?? '') ||
        jobController.text != (data.job ?? '') ||
        selectedJobId.value != (data.jobId?.trim() ?? '') ||
        cityController.text != (data.city ?? '') ||
        languageController.text != expectedLanguageDisplay ||
        selectedCountry.value.code !=
            (data.countryCode ?? selectedCountry.value.code) ||
        userType.value != expectedUserType ||
        uiType.value != expectedUiType;
  }

  bool get hasCompanyChanges {
    final data = profile.value?.data;
    if (data == null) return false;

    return isCompanyLogoChanged.value ||
        nameController.text != (data.companyName ?? '') ||
        descriptionController.text != (data.companyDescription ?? '') ||
        addressController.text != (data.companyAddress ?? '') ||
        businessCodeController.text != (data.companyNumber ?? '');
  }

  // ==================== Image Handling ====================

  Future<void> pickImageFromCamera({bool isCompanyLogo = false}) async {
    try {
      final pickedFile = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 80,
      );
      if (pickedFile != null) {
        if (isCompanyLogo) {
          pickedCompanyLogo.value = File(pickedFile.path);
          isCompanyLogoChanged.value = true;
        } else {
          pickedImage.value = File(pickedFile.path);
          isImageChanged.value = true;
        }
        errorMessage.value = '';
      }
    } catch (e) {
      errorMessage.value = tr(LanguageKeys.somethingWentWrong);
    }
  }

  Future<void> pickImageFromGallery({bool isCompanyLogo = false}) async {
    try {
      final pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );
      if (pickedFile != null) {
        if (isCompanyLogo) {
          pickedCompanyLogo.value = File(pickedFile.path);
          isCompanyLogoChanged.value = true;
        } else {
          pickedImage.value = File(pickedFile.path);
          isImageChanged.value = true;
        }
        errorMessage.value = '';
      }
    } catch (e) {
      errorMessage.value = tr(LanguageKeys.somethingWentWrong);
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

  String getDisplayImage({bool isCompanyLogo = false}) {
    if (isCompanyLogo) {
      if (pickedCompanyLogo.value != null) {
        return pickedCompanyLogo.value!.path;
      }
      return companyLogoUrl.value.isNotEmpty
          ? companyLogoUrl.value
          : (profile.value?.data?.companyLogoUrl ?? '');
    } else {
      if (pickedImage.value != null) {
        return pickedImage.value!.path;
      }
      return imageUrl.value.isNotEmpty
          ? imageUrl.value
          : (profile.value?.data?.avatarUrl ?? '');
    }
  }

  void clearImage({bool isCompanyLogo = false}) {
    if (isCompanyLogo) {
      pickedCompanyLogo.value = null;
      isCompanyLogoChanged.value = false;
    } else {
      pickedImage.value = null;
      isImageChanged.value = false;
    }
  }

  // ==================== Profile Update Methods ====================

  Future<bool> updateCompanyProfile() async {
    isUpdateLoading.value = true;
    updateErrorMessage.value = '';

    try {
      File? imageFile;
      if (isCompanyLogoChanged.value && pickedCompanyLogo.value != null) {
        imageFile = pickedCompanyLogo.value;
      } else if (companyLogoUrl.value.isNotEmpty) {
        imageFile = await _downloadImageFile(companyLogoUrl.value);
      }

      final response = await RESTAuth.updateCompanyProfile(
        name: nameController.text,
        description: descriptionController.text,
        address: addressController.text,
        businessCode: businessCodeController.text,
        image: imageFile,
        imageUrl: companyLogoUrl.value,
      );

      if (response.isSuccess && response.data != null) {
        // Update company logo URL from response
        companyLogoUrl.value = response.data!.data.companyLogoUrl;
        isCompanyLogoChanged.value = false;
        pickedCompanyLogo.value = null;

        // Refresh profile data after successful update
        await getProfile();

        await Get.dialog(
          SuccessPopup(
            message: response.message,
            onOk: () {
              Get.back(); // Close the dialog
            },
          ),
          barrierDismissible: false,
        );
        return true;
      } else {
        updateErrorMessage.value = response.error ?? response.message;
        return false;
      }
    } catch (e) {
      updateErrorMessage.value = tr(LanguageKeys.somethingWentWrong);
      return false;
    } finally {
      isUpdateLoading.value = false;
    }
  }

  /// Updates company profile with explicit values (e.g. from onboarding screen
  /// that uses its own TextEditingControllers to avoid disposed-controller issues).
  Future<bool> updateCompanyProfileWithData({
    required String name,
    required String description,
    required String address,
    required String businessCode,
  }) async {
    isUpdateLoading.value = true;
    updateErrorMessage.value = '';

    try {
      File? imageFile;
      if (isCompanyLogoChanged.value && pickedCompanyLogo.value != null) {
        imageFile = pickedCompanyLogo.value;
      } else if (companyLogoUrl.value.isNotEmpty) {
        imageFile = await _downloadImageFile(companyLogoUrl.value);
      }

      final response = await RESTAuth.updateCompanyProfile(
        name: name,
        description: description,
        address: address,
        businessCode: businessCode,
        image: imageFile,
        imageUrl: companyLogoUrl.value,
      );

      if (response.isSuccess && response.data != null) {
        companyLogoUrl.value = response.data!.data.companyLogoUrl;
        isCompanyLogoChanged.value = false;
        pickedCompanyLogo.value = null;
        await getProfile();
        await Get.dialog(
          SuccessPopup(
            message: response.message,
            onOk: () {
              Get.back();
            },
          ),
          barrierDismissible: false,
        );
        return true;
      } else {
        updateErrorMessage.value = response.error ?? response.message;
        return false;
      }
    } catch (e) {
      updateErrorMessage.value = tr(LanguageKeys.somethingWentWrong);
      return false;
    } finally {
      isUpdateLoading.value = false;
    }
  }

  /// When [onSuccessNavigate] is provided (e.g. from referral onboarding),
  /// it is called instead of navigating to main after success.
  Future<bool> updateProfile({void Function()? onSuccessNavigate}) async {
    isLoading.value = true;
    errorMessage.value = '';

    selectedCountry.refresh();

    try {
      final profileData = profile.value?.data;
      final blockedDowngrade =
          userType.value.toLowerCase() == 'individual' &&
              profileData?.premiumProfessional == true;

      if (blockedDowngrade) {
        final message = tr(LanguageKeys.cannotSwitchToIndividualProfile);
        errorMessage.value = message;
        final ctx = Get.overlayContext;
        if (ctx != null) {
          CustomToast.show(ctx, message);
        }
        return false;
      }

      final apiUiType = _normalizeUiTypeForUserType(uiType.value, userType.value);
      uiType.value = apiUiType;

      File? imageFile;
      if (isImageChanged.value && pickedImage.value != null) {
        imageFile = pickedImage.value;
      } else if (imageUrl.value.isNotEmpty) {
        imageFile = await _downloadImageFile(imageUrl.value);
      }

      String languageCode = languageController.text == "English" ||
              languageController.text == "English"
          ? "en"
          : languageController.text == "Spanish" ||
                  languageController.text == "Español"
              ? "es"
              : languageController.text == "French" ||
                      languageController.text == "Français"
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
        jobId: userType.value == 'professional' && selectedJobId.value.isNotEmpty
            ? selectedJobId.value
            : null,
        language: languageCode,
        image: imageFile,
        imageUrl: imageUrl.value,
        userType: userType.value.toLowerCase(),
        uiType: apiUiType,
      );

      if (response.isSuccess && response.data != null) {
        // Update avatar URL from response
        imageUrl.value = response.data!.data.avatarUrl;
        isImageChanged.value = false;
        pickedImage.value = null;

        await getProfile();

        await Get.dialog(
          SuccessPopup(
            message: response.message,
            onOk: () {
              isLoading.value = false;
              mainController.getProfile();
              if (onSuccessNavigate != null) {
                onSuccessNavigate();
              } else {
                Get.offAllNamed(ScreenMain.pageId);
              }
            },
          ),
          barrierDismissible: false,
        );
        // After success popup is dismissed, show professional welcome popup
        if (userType.value.toLowerCase() == "professional" ||
            userType.value.toLowerCase() == "profesional" ||
            userType.value.toLowerCase() == "professionnel") {
          if (isEditUserType.value) {
            await showDialog(
              context: Get.overlayContext!,
              builder: (_) => const ShowWelcomeToProfessionalDialog(),
            );
          }
        }
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

  // ==================== Account Deletion ====================

  Future<void> deleteAccount() async {
    try {
      isDeleteAccountLoading.value = true;
      deleteAccountErrorMessage.value = '';

      final response = await RESTAuth.deleteAccount();

      if (response is ApiSuccess<ModelCommon>) {
        if (response.data.status == true) {
          if (Get.context != null) {
            await Get.dialog(
              SuccessPopup(
                message: response.data.message ?? '',
                onOk: () async {
                  isDeleteAccountLoading.value = false;
                  // Clear all SharedPreferences data
                  // Clear controller cached data first
                  if (Get.isRegistered<ControllerMainProfessional>()) {
                    if (Get.isRegistered<ControllerMainProfessional>()) {
                      Get.find<ControllerMainProfessional>().clearCachedData();
                    }
                  }
                  if (Get.isRegistered<TrackLeadsController>()) {
                    Get.delete<TrackLeadsController>();
                  }

                  final preserveRememberMe =
                      AppPreference.readBool(AppPreference.rememberMe);
                  await AppPreference.clearSession(
                    preserveRememberMe: preserveRememberMe,
                  );

                  // Clear all routes and navigate to initial language screen
                  Get.until((route) => false);
                  Get.offAllNamed(ScreenInitialLanguage.pageId);
                  Get.back();
                },
              ),
              barrierDismissible: false,
            );
          }
        } else {
          deleteAccountErrorMessage.value =
              response.data.message ?? tr(LanguageKeys.somethingWentWrong);
        }
      } else if (response is ApiFailure) {
        deleteAccountErrorMessage.value =
            response.error.message ?? tr(LanguageKeys.somethingWentWrong);
      }
    } catch (e) {
      deleteAccountErrorMessage.value = e.toString();
    } finally {
      isDeleteAccountLoading.value = false;
    }
  }

  // ==================== Utility Methods ====================

  void refreshProfile() {
    getProfile();
  }

  // Check if company details are empty
  bool get hasEmptyCompanyDetails {
    final data = profile.value?.data;
    if (data == null) return true;

    final companyName = data.companyName?.trim() ?? '';
    final companyDescription = data.companyDescription?.trim() ?? '';
    final companyAddress = data.companyAddress?.trim() ?? '';

    return companyName.isEmpty ||
        companyDescription.isEmpty ||
        companyAddress.isEmpty;
  }

  void resetForm() {
    // Reset user profile form
    firstNameController.clear();
    lastNameController.clear();
    emailController.clear();
    phoneController.clear();
    jobController.clear();
    cityController.clear();
    languageController.clear();

    // Reset company profile form
    nameController.clear();
    descriptionController.clear();
    addressController.clear();
    businessCodeController.clear();

    clearImage();
    clearImage(isCompanyLogo: true);
    errorMessage.value = '';
    updateErrorMessage.value = '';
  }

  bool get hasUnsavedChanges {
    return isImageChanged.value ||
        isCompanyLogoChanged.value ||
        firstNameController.text.isNotEmpty ||
        lastNameController.text.isNotEmpty ||
        emailController.text.isNotEmpty ||
        phoneController.text.isNotEmpty ||
        jobController.text.isNotEmpty ||
        cityController.text.isNotEmpty ||
        languageController.text.isNotEmpty ||
        nameController.text.isNotEmpty ||
        descriptionController.text.isNotEmpty ||
        addressController.text.isNotEmpty ||
        businessCodeController.text.isNotEmpty;
  }

  // ==================== Navigation Based on Completion Status ====================

  /// Navigates to the appropriate screen based on profile completion status.
  /// Priority:
  /// 1. If isProfileCompleted is not true, navigate to profile screen with profile tab (tab 0)
  /// 2. If isCompanyCompleted is not true, navigate to company tab in profile (tab 1)
  /// 3. If isFinderCompleted is not true, navigate to CompleteProfileScreen
  void navigateBasedOnCompletionStatus() {
    final profileData = profile.value?.data;
    if (profileData == null) {
      print("profileData is null");
      // If profile is not loaded, try to load it first
      getProfile().then((_) => navigateBasedOnCompletionStatus());
      return;
    }

    final isProfileCompleted = profileData.isProfileCompleted ?? false;
    final isCompanyCompleted = profileData.isCompanyCompleted ?? false;
    final isFinderCompleted = profileData.isFinderCompleted ?? false;

    if (!isProfileCompleted) {
      // Navigate to profile screen with profile tab (tab 0)
      Get.toNamed(MyProfileScreen.pageId, arguments: {'initialTab': 0});
    } else if (!isCompanyCompleted) {
      // Navigate to company tab in profile (tab 1)
      Get.toNamed(MyProfileScreen.pageId, arguments: {'initialTab': 1});
    } else if (!isFinderCompleted) {
      // Navigate to CompleteProfileScreen
      Get.toNamed(CompleteProfileScreen.pageId);
    }
  }

  // ==================== Cleanup ====================

  @override
  void onClose() {
    // Dispose user profile controllers
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    jobController.dispose();
    cityController.dispose();
    languageController.dispose();

    // Dispose company profile controllers
    nameController.dispose();
    descriptionController.dispose();
    addressController.dispose();
    businessCodeController.dispose();

    clearImage();
    clearImage(isCompanyLogo: true);
    super.onClose();
  }
}
