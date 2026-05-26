import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:referaly/languages/languagekeys.dart';
import 'package:referaly/models/model_register.dart';
import 'package:referaly/resources/app_colors.dart';
import 'package:referaly/resources/app_helper.dart';
import 'package:referaly/resources/text_style.dart';
import 'package:referaly/utils/translations.dart' show tr;
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import '../apis/api_result.dart';
import '../apis/rest_auth.dart';
import '../resources/app_preference.dart';
import '../resources/validation_helper.dart';
import '../widgets/dialog/account_already_exists_dialog.dart';
import '../widgets/dialog/email_verification_dialog.dart';

class RegistrationController extends GetxController {
  // Text editing controllers
  final tcFirstNameController = TextEditingController();
  final tcLastNameController = TextEditingController();
  final tcEmailController = TextEditingController();
  final tcPasswordController = TextEditingController();
  final tcConfirmPasswordController = TextEditingController();
  final tcPhoneNumberController = TextEditingController();
  final tcJobController = TextEditingController();
  final tcCity = TextEditingController();

  // Country and job selection
  final Rx<Country> selectedCountry =
      Country(name: 'United States', emoji: '🇺🇸', code: '+1', languageCode: 'en').obs;

  final RxString selectedJob = ''.obs;
  final RxString selectedJobId = ''.obs;

  // Flags — null means no role selected yet
  final RxnBool isProfessional = RxnBool(null);
  final RxBool showRoleTypeError = false.obs;
  final isPasswordVisible = false.obs;
  final isAccepted = false.obs;
  final isLoadingRegister = false.obs;
  final isSendLeadEnabled = false.obs;

  final List<Country> countries = [
    Country(name: 'United States', emoji: '🇺🇸', code: '+1', languageCode: 'en'),
    Country(name: 'Spain', emoji: '🇪🇸', code: '+34', languageCode: 'es'),
    Country(name: 'Belgium', emoji: '🇧🇪', code: '+32', languageCode: 'es'),
    Country(name: 'France', emoji: '🇫🇷', code: '+33', languageCode: 'fr'),
    Country(name: 'Luxembourg', emoji: '🇱🇺', code: '+352', languageCode: 'es'),
    Country(name: 'Switzerland', emoji: '🇨🇭', code: '+41', languageCode: 'es'),
  ];
  RxString lang = "".obs;
  final fcmTokenAPI = ''.obs;

  bool get isJobRequired => isProfessional.value == true;

  void selectProfessional() {
    isProfessional.value = true;
    showRoleTypeError.value = false;
  }

  void selectIndividual() {
    isProfessional.value = false;
    showRoleTypeError.value = false;
    _clearJobSelection();
  }

  void _clearJobSelection() {
    tcJobController.clear();
    selectedJob.value = '';
    selectedJobId.value = '';
  }

  void onJobSelected(int id, String title) {
    selectedJob.value = title;
    selectedJobId.value = id.toString();
  }

  @override
  void onInit() {
    super.onInit();
    regenerateFCMToken();
    lang.value = AppPreference.getLanguage();
    AppHelper.showLog("lang: $lang");

    // Set country code based on language
    switch (lang.value) {
      case 'fr':
        selectedCountry.value = Country(name: 'France', emoji: '🇫🇷', code: '+33', languageCode: 'fr');
        break;
      case 'es':
        selectedCountry.value = Country(name: 'Spain', emoji: '🇪🇸', code: '+34', languageCode: 'es');
        break;
      case 'en':
      default:
        selectedCountry.value = Country(name: 'United States', emoji: '🇺🇸', code: '+1', languageCode: 'en');
        break;
    }
  }

  void openPdfBottomSheet(BuildContext context, String pdfUrl) {
    AppHelper.showLog("pdfUrl: $pdfUrl");
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
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
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
                child: SfPdfViewer.network(pdfUrl),
              ),
            ],
          ),
        );
      },
    );
  }

  regenerateFCMToken() async {
    try {
      final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
      String? fcmToken = AppPreference.readString(AppPreference.fcmToken);

      if (!ValidationHelper.isValidString(fcmToken)) {
        // Request permission first
        NotificationSettings settings = await firebaseMessaging.requestPermission(
          alert: true,
          badge: true,
          sound: true,
          provisional: false,
        );

        if (settings.authorizationStatus == AuthorizationStatus.authorized) {
          // Get the token
          fcmToken = await firebaseMessaging.getToken();

          if (fcmToken != null) {
            // Store the token
            await AppPreference.writeString(AppPreference.fcmToken, fcmToken);
            print("FCM token retrieved: $fcmToken");
          } else {
            // Handle simulator case
            print("Running on simulator - using mock token for testing");
            fcmToken = "SIMULATOR_MOCK_TOKEN_${DateTime.now().millisecondsSinceEpoch}";
            await AppPreference.writeString(AppPreference.fcmToken, fcmToken);
          }
        } else {
          print("Notification permission not granted");
          // Use a mock token if permission is not granted
          fcmToken = "MOCK_TOKEN_${DateTime.now().millisecondsSinceEpoch}";
          await AppPreference.writeString(AppPreference.fcmToken, fcmToken);
        }
      }

      // // Initialize push notification service
      // final pushNotificationService =
      //     PushNotificationService(_firebaseMessaging);
      // await pushNotificationService.initialise(Get.context!);

      return fcmToken;
    } catch (e) {
      print("Error getting FCM token: $e");
      // Provide a fallback token for testing
      String mockToken = "MOCK_TOKEN_${DateTime.now().millisecondsSinceEpoch}";
      await AppPreference.writeString(AppPreference.fcmToken, mockToken);
      return mockToken;
    }
  }

  /// API : Registration process

  Future<ModelRegister?> registerApi() async {
    isLoadingRegister.value = true;
    String? fcmToken = AppPreference.readString(AppPreference.fcmToken);

    try {
      final response = await RESTAuth.register(
        firstName: tcFirstNameController.text.trim(),
        lastName: tcLastNameController.text.trim(),
        email: tcEmailController.text.toLowerCase().trim(),
        password: tcPasswordController.text.trim(),
        phoneNumber: tcPhoneNumberController.text.trim(),
        city: tcCity.text.trim(),
        countryCode: selectedCountry.value.code,
        companyType: isProfessional.value == true ? 'professional' : 'individual',
        fcmToken: fcmToken!,
        lang: lang.value,
        job: isProfessional.value == true ? tcJobController.text.trim() : '',
        jobId: isProfessional.value == true && selectedJobId.value.isNotEmpty
            ? selectedJobId.value
            : null,
        sendLeadOut: isSendLeadEnabled.value ? "true" : "false",
      );

      isLoadingRegister.value = false;

      if (response is ApiSuccess<ModelRegister>) {
        // Print the full response for debugging
        print("Register Response: ${response.data.toJson()}");
        if (response.data.status == false) {
          final email = tcEmailController.text.trim().toLowerCase();
          final message = response.data.message?.toLowerCase() ?? '';

          // Check if this is an email already exists error
          bool isEmailExistsError = message.contains('email') &&
              (message.contains('already') ||
                  message.contains('exists') ||
                  message.contains('taken') ||
                  message.contains('registered') ||
                  message.contains('duplicate'));

          if (isEmailExistsError) {
            // Show the Account Already Exists dialog
            Get.dialog(
              AccountAlreadyExistsDialog(email: email),
              barrierDismissible: false,
            );
          } else {
            // Show regular error dialog for other errors
            Get.defaultDialog(
              backgroundColor: AppColors.whiteColor,
              title: tr(LanguageKeys.whoops),
              titleStyle: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 22,
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 0),
              radius: 12,
              content: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      response.data.message ?? '',
                      style: const TextStyle(fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 15),
                    Center(
                      child: SizedBox(
                        width: 120,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF8E2DE2),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onPressed: () {
                            // clearFields();
                            Get.back();
                          },
                          child: Obx(
                            () => Text(tr(LanguageKeys.okay),
                                style: stylePoppins(color: AppColors.whiteColor, fontSize: 12)),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
        } else {
          // Success case

          final email = tcEmailController.text.trim().toLowerCase();
          clearFields();
          // Show email verification dialog
          Get.dialog(
            EmailVerificationDialog(email: email),
            barrierDismissible: false,
          );

          // Note: User data will be saved after email verification
          // For now, we show the dialog and let user verify email first
        }

        return response.data;
      } else if (response is ApiFailure) {
        // Print the error for debugging
        print("Register Error: ${response.error.message}");
        print("Register Error Details: ${response.error.errors?.errorMap}");

        final email = tcEmailController.text.trim().toLowerCase();
        bool isEmailExistsError = false;

        // Check error message
        final errorMessage = response.error.message?.toLowerCase() ?? '';
        if (errorMessage.contains('email') &&
            (errorMessage.contains('already') ||
                errorMessage.contains('exists') ||
                errorMessage.contains('taken') ||
                errorMessage.contains('registered') ||
                errorMessage.contains('duplicate'))) {
          isEmailExistsError = true;
        }

        // Also check structured errors object (for 422 validation errors)
        if (!isEmailExistsError && response.error.errors != null) {
          final errors = response.error.errors!.errorMap;
          // Check if there's an 'email' field error
          if (errors.containsKey('email')) {
            final emailErrors = errors['email'] ?? [];
            for (var error in emailErrors) {
              final lowerError = error.toLowerCase();
              if (lowerError.contains('already') ||
                  lowerError.contains('exists') ||
                  lowerError.contains('taken') ||
                  lowerError.contains('registered') ||
                  lowerError.contains('duplicate')) {
                isEmailExistsError = true;
                break;
              }
            }
          }
        }

        // Show the Account Already Exists dialog ONLY during registration
        if (isEmailExistsError) {
          Get.dialog(
            AccountAlreadyExistsDialog(email: email),
            barrierDismissible: false,
          );
        } else {
          // Show regular error message for other errors
          if (Get.context != null) {
          } else {
            Get.snackbar(
              tr(LanguageKeys.error),
              response.error.message ?? tr(LanguageKeys.somethingWentWrong),
              snackPosition: SnackPosition.BOTTOM,
            );
          }
        }
      }
    } catch (e) {
      print("Error occurred: $e");
      if (Get.context != null) {
      } else {
        Get.snackbar(
          tr(LanguageKeys.error),
          tr(LanguageKeys.somethingWentWrong),
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } finally {
      isLoadingRegister.value = false;
    }
    return null;
  }

  /// Clear all input fields
  void clearFields() {
    tcFirstNameController.clear();
    tcLastNameController.clear();
    tcEmailController.clear();
    tcPasswordController.clear();
    tcConfirmPasswordController.clear();
    tcPhoneNumberController.clear();
    tcJobController.clear();
    tcCity.clear();
    isProfessional.value = null;
    showRoleTypeError.value = false;
    selectedJob.value = '';
    selectedJobId.value = '';
  }

  /// Toggle password visibility
  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  @override
  void dispose() {
    tcFirstNameController.dispose();
    tcLastNameController.dispose();
    tcEmailController.dispose();
    tcPasswordController.dispose();
    tcConfirmPasswordController.dispose();
    tcPhoneNumberController.dispose();
    tcJobController.dispose();
    tcCity.dispose();
    super.dispose();
  }
}

/// Country model class
class Country {
  final String name;
  final String emoji;
  final String code;
  final String? languageCode; // make nullable

  Country({
    required this.name,
    required this.emoji,
    required this.code,
    this.languageCode, // optional now
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Country &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          emoji == other.emoji &&
          code == other.code;

  @override
  int get hashCode => name.hashCode ^ emoji.hashCode ^ code.hashCode;
}
