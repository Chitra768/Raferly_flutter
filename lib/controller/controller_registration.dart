import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:referaly/languages/languagekeys.dart';
import 'package:referaly/models/model_register.dart';
import 'package:referaly/resources/app_helper.dart';
import 'package:referaly/screens/auth/screen_profile_type.dart';
import 'package:referaly/utils/translations.dart' show tr;

import '../apis/api_result.dart';
import '../apis/rest_auth.dart';
import '../fcm/push_notification_service.dart';
import '../resources/app_preference.dart';
import '../resources/validation_helper.dart';
import '../widgets/custom_toast_msg.dart';

class RegistrationController extends GetxController {
  // Text editing controllers
  final tcFirstNameController = TextEditingController();
  final tcLastNameController = TextEditingController();
  final tcEmailController = TextEditingController();
  final tcPasswordController = TextEditingController();
  final tcPhoneNumberController = TextEditingController();
  final tcJobController = TextEditingController();
  final tcCity = TextEditingController();

  // Country and job selection
  final Rx<Country> selectedCountry = Country(
          name: 'United States', emoji: '🇺🇸', code: '+1', languageCode: 'en')
      .obs;

  final RxString selectedJob = ''.obs;
  final RxString selectedJobId = ''.obs;

  // Flags
  final isProfessional = true.obs;
  final isPasswordVisible = false.obs;
  final isAccepted = false.obs;
  final isLoadingRegister = false.obs;
  final isSendLeadEnabled = false.obs;

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
  RxString lang = "".obs;
  final fcmTokenAPI = ''.obs;
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    regenerateFCMToken();
    lang.value = AppPreference.getLanguage();
    AppHelper.showLog("lang: $lang");
  }

  regenerateFCMToken() async {
    try {
      final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
      String? fcmToken = await AppPreference.readString(AppPreference.fcmToken);

      if (!ValidationHelper.isValidString(fcmToken)) {
        // Request permission first
        NotificationSettings settings =
            await _firebaseMessaging.requestPermission(
          alert: true,
          badge: true,
          sound: true,
          provisional: false,
        );

        if (settings.authorizationStatus == AuthorizationStatus.authorized) {
          // Get the token
          fcmToken = await _firebaseMessaging.getToken();

          if (fcmToken != null) {
            // Store the token
            await AppPreference.writeString(AppPreference.fcmToken, fcmToken);
            print("FCM token retrieved: $fcmToken");
          } else {
            // Handle simulator case
            print("Running on simulator - using mock token for testing");
            fcmToken =
                "SIMULATOR_MOCK_TOKEN_${DateTime.now().millisecondsSinceEpoch}";
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
    String? fcmToken = await AppPreference.readString(AppPreference.fcmToken);

    try {
      final response = await RESTAuth.register(
        firstName: tcFirstNameController.text.trim(),
        lastName: tcLastNameController.text.trim(),
        email: tcEmailController.text.toLowerCase().trim(),
        password: tcPasswordController.text.trim(),
        phoneNumber: tcPhoneNumberController.text.trim(),
        city: tcCity.text.trim(),
        countryCode: selectedCountry.value.code,
        fcmToken: fcmToken!,
        lang: lang.value,
        job: tcJobController.text.trim(),
        jobId: selectedJobId.value,
        sendLeadOut: isSendLeadEnabled.value ? "true" : "false",
      );

      isLoadingRegister.value = false;

      if (response is ApiSuccess<ModelRegister>) {
        // Print the full response for debugging
        print("Register Response: ${response.data.toJson()}");

        if (response.data.data == null) {
          // Show the exact message from API
          if (Get.context != null) {
            Get.snackbar(
              tr(LanguageKeys.error),
              tr(response.data.message ?? LanguageKeys.somethingWentWrong),
              snackPosition: SnackPosition.BOTTOM,
            );
          } else {
            Get.snackbar(
              tr(LanguageKeys.error),
              response.data.message ?? tr(LanguageKeys.somethingWentWrong),
              snackPosition: SnackPosition.BOTTOM,
            );
          }
        } else {
          // Success case
          clearFields();
          if (response.data.data?.accessToken != null) {
            await AppPreference.writeString(
              AppPreference.accessToken,
              response.data.data!.accessToken!,
            );

            await AppPreference.writeString(
                AppPreference.accessToken, response.data.data!.accessToken!);
            await AppPreference.writeString(
                AppPreference.email, response.data.data!.user!.email!);

            await AppPreference.writeInt(AppPreference.isLoggedIn, 1);
            await AppPreference.writeString(AppPreference.isPaid,
                response.data.data!.user!.isPaid.toString());
            await AppPreference.writeString(AppPreference.productId,
                response.data.data!.user!.productId.toString());

            Get.snackbar(
              tr(LanguageKeys.success),
              response.data.message ?? tr(LanguageKeys.leadCreatedSuccessfully),
              snackPosition: SnackPosition.BOTTOM,
            );
            Get.offAllNamed(ScreenProfileType.pageId);
          }
        }

        return response.data;
      } else if (response is ApiFailure) {
        // Print the error for debugging
        print("Register Error: ${response.error.message}");

        if (Get.context != null) {
        } else {
          Get.snackbar(
            tr(LanguageKeys.error),
            response.error.message ?? tr(LanguageKeys.somethingWentWrong),
            snackPosition: SnackPosition.BOTTOM,
          );
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
    tcPhoneNumberController.clear();
    tcJobController.clear();
    tcCity.clear();
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
