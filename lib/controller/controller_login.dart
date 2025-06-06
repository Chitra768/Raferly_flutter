import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:referaly/apis/api_result.dart';
import 'package:referaly/resources/app_preference.dart';
import 'package:referaly/screens/home/screen_main.dart';

import '../apis/rest_auth.dart';
import '../fcm/push_notification_service.dart';
import '../models/model_login.dart';
import '../resources/app_helper.dart';
import '../resources/validation_helper.dart';
import '../widgets/custom_toast_msg.dart';
import '../resources/app_preference.dart';

class ControllerLogin extends GetxController {
  final tcEmail = TextEditingController();
  final tcPassword = TextEditingController();
  final isPasswordVisible = false.obs;
  final isLoadingLogin = false.obs;
  final fcmTokenAPI = ''.obs;
  final loginFormKey = GlobalKey<FormState>();


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

      // // Initialize push notification service
      // final pushNotificationService =
      //     PushNotificationService(_firebaseMessaging);
      // await pushNotificationService.initialise(Get.context!);context

      return fcmToken;
    } catch (e) {
      print("Error getting FCM token: $e");
      // Provide a fallback token for testing
      String mockToken = "MOCK_TOKEN_${DateTime.now().millisecondsSinceEpoch}";
      await AppPreference.writeString(AppPreference.fcmToken, mockToken);
      return mockToken;
    }
  }


  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  Future<void> loginApi() async {
    AppHelper.hideKeyboard(Get.overlayContext!);
    await FirebaseMessaging.instance.requestPermission();
    // String? fcmToken = await FirebaseMessaging.instance.getToken();
    // if (fcmToken != null) {
    //   await AppPreference.writeString(AppPreference.fcmToken, fcmToken);
    // }
      String? fcmToken = await AppPreference.readString(AppPreference.fcmToken);
    if (!loginFormKey.currentState!.validate()) return;




    final email = tcEmail.text.trim();
    final password = tcPassword.text.trim();

    isLoadingLogin.value = true;

    // Fetch FCM token
    // final fcmToken= await FirebaseMessaging.instance.getToken() ?? '';

    try {
      final response = await RESTAuth.login(
        email: email.toLowerCase(),
        password: password,
        fcmToken: fcmToken!,
      );

      if (response is ApiSuccess<ModelLogin>) {
        if (response.data.status == true) {
          // Store the access token
          if (response.data.data?.accessToken != null) {
            await AppPreference.writeString(
              AppPreference.accessToken,
              response.data.data!.accessToken!,
            );
          }

          await AppPreference.writeString(AppPreference.accessToken, response.data.data!.accessToken!);
          await AppPreference.writeString(AppPreference.email, response.data.data!.user!.email!);

          await AppPreference.writeInt(AppPreference.isLoggedIn, 1);
          await AppPreference.writeString(AppPreference.isPaid, response.data.data!.user!.isPaid.toString());
          await AppPreference.writeString(AppPreference.productId, response.data.data!.user!.productId.toString());



          Get.offAllNamed(ScreenMain.pageId);
        } else {
         
        }
      } else if (response is ApiFailure) {
        final errorMsg = response.error.message ?? 'Something went wrong';
      }
    } catch (e) {
      debugPrint('Login Error: $e');
    } finally {
      isLoadingLogin.value = false;
    }
  }

  @override
  void dispose() {
    tcEmail.dispose();
    tcPassword.dispose();
    super.dispose();
  }
}
