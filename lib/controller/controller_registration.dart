import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:referaly/models/model_register.dart';
import 'package:referaly/screens/auth/screen_profile_type.dart';

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
  final Rx<Country> selectedCountry =
      Country(name: 'United States', emoji: '🇺🇸', code: '+1').obs;
  final RxString selectedJob = ''.obs;
  final RxString selectedJobId = ''.obs;

  // Flags
  final isProfessional = true.obs;
  final isPasswordVisible = false.obs;
  final isAccepted = false.obs;
  final isLoadingRegister = false.obs;
  final isSendLeadEnabled = false.obs;

  final List<Country> countries = [
    Country(name: 'United States', emoji: '🇺🇸', code: '+1'),
    Country(name: 'Spain', emoji: '🇪🇸', code: '+34'),
    Country(name: 'Belgium', emoji: '🇧🇪', code: '+32'),
    Country(name: 'France', emoji: '🇫🇷', code: '+33'),
    Country(name: 'Luxembourg', emoji: '🇱🇺', code: '+352'),
    Country(name: 'Switzerland', emoji: '🇨🇭', code: '+41'),
  ];
  final fcmTokenAPI = ''.obs;
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    regenerateFCMToken();
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

      // Initialize push notification service
      final pushNotificationService =
          PushNotificationService(_firebaseMessaging);
      await pushNotificationService.initialise(Get.context!);

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
    // Fetch FCM token

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
        lang: 'en',
        job: selectedJob.value,
        jobId: selectedJobId.value,
        sendLeadOut: isSendLeadEnabled.value ? "true" : "false",
      );

      isLoadingRegister.value = false;

      if (response is ApiSuccess<ModelRegister>) {
        // Checking if status is false and displaying the error message in toast
        if (response.data.status == false) {
          // Display custom toast with the error message
          CustomToast.show(
            Get.context!,
            response.data.message!,
          );
        } else {
          // Store the access token
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

            CustomToast.show(
              Get.overlayContext!,
              response.data.message ?? 'Registration successful!',
            );
            Get.offAllNamed(ScreenProfileType.pageId);
          }

          // Success message in custom toast
        }
        clearFields();
        return response.data;
      } else if (response is ApiFailure) {
        print("Failure occurred");

        // Use the message directly from the API response to show the error message
        final errorMsg = response.error.message ?? 'Unknown error';

        // Display custom toast with the error message
        CustomToast.show(
          Get.overlayContext!,
          errorMsg, // Error message from API failure
        );
      }
    } catch (e) {
      print("Error occurred: $e");
      CustomToast.show(
        Get.overlayContext!,
        'An error occurred during registration',
      );
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

  Country({required this.name, required this.emoji, required this.code});

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
