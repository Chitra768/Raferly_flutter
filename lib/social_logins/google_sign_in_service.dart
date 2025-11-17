import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:referaly/controller/controller_main_professional.dart';
import 'package:referaly/resources/app_helper.dart';
import 'package:referaly/resources/validation_helper.dart';
import 'package:referaly/screens/auth/screen_profile_type.dart';
import 'package:referaly/screens/home/screen_main.dart';
import 'package:referaly/widgets/custom_toast_msg.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import '../apis/api_result.dart';
import '../apis/rest_auth.dart';
import '../models/model_login.dart';
import '../resources/app_preference.dart';

// import 'package:the_apple_sign_in/the_apple_sign_in.dart';

class GoogleSignInService {
  static final RESTAuth _object = RESTAuth();

  static final _firebaseAuth = FirebaseAuth.instance;

  static ModelLogin? _lastLoginResponse;
  static ModelLogin? get lastLoginResponse => _lastLoginResponse;

  var isLoadingLogin = false.obs;

  /// Api : socialSignUpLoginApi
  // Future<void> socialSignUpLoginApi({
  //   required String firstName,
  //   required String lastName,
  //   required String socialType, // 'google' or 'facebook'
  //   required String tokenId,
  // }) async {
  //   AppHelper.hideKeyboard(Get.overlayContext!);
  //   isLoadingLogin.value = true;
  //
  //   String? deviceId = await _object.getDeviceID();
  //   String fcmToken = await FirebaseMessaging.instance.getToken() ?? '';
  //
  //   try {
  //     final response = await RESTAuth.socialSignUpLogin(
  //       deviceId: deviceId.toString(),
  //       deviceType: Platform.isAndroid
  //           ? 'android'
  //           : Platform.isIOS
  //               ? 'ios'
  //               : "unknown", // Simplified platform check
  //       fcmToken: fcmToken,
  //       firstName: firstName,
  //       lastName: lastName,
  //       socialType: socialType.toLowerCase(),
  //       tokenId: tokenId,
  //     );
  //
  //     if (response is ApiSuccess<ModelCommon>) {
  //       if (response.data.status == true) {
  //         // Directly save the login status
  //         await AppPreference.writeInt(AppPreference.isLoggedIn, 1);
  //         CustomToast.show(
  //             Get.overlayContext!, response.data.message ?? 'Login successful');
  //         Get.offAllNamed(ScreenMain.pageId);
  //       } else {
  //         CustomToast.show(
  //             Get.overlayContext!, response.data.message ?? 'Login failed');
  //       }
  //     } else if (response is ApiFailure) {
  //       final errorMsg = response.error.message ?? 'Something went wrong';
  //       CustomToast.show(Get.overlayContext!, errorMsg);
  //     }
  //   } catch (e) {
  //     CustomToast.show(Get.overlayContext!, 'Something went wrong');
  //     debugPrint('Social Login Error: $e');
  //   } finally {
  //     isLoadingLogin.value = false;
  //   }
  // }

  /// LoginWithGoogle
  // static Future<User?> loginWithGoogle() async {
  //   try {
  //     final GoogleSignInAccount? googleAccount = await GoogleSignIn().signIn();
  //
  //     if (googleAccount == null) {
  //       CustomToast.show(
  //           Get.overlayContext!, "Google login cancelled by the user.");
  //       return null;
  //     }
  //
  //     final GoogleSignInAuthentication googleAuth =
  //         await googleAccount.authentication;
  //
  //     if (googleAuth.accessToken == null || googleAuth.idToken == null) {
  //       debugPrint("Google authentication failed: Missing tokens.");
  //       return null;
  //     }
  //
  //     final credential = GoogleAuthProvider.credential(
  //       accessToken: googleAuth.accessToken,
  //       idToken: googleAuth.idToken,
  //     );
  //
  //     final userCredential =
  //         await _firebaseAuth.signInWithCredential(credential);
  //
  //     return userCredential.user;
  //   } catch (e) {
  //     debugPrint("Exception during Google login: $e");
  //     CustomToast.show(Get.overlayContext!, "Google login error occurred.");
  //     return null;
  //   }
  // }

  /// Debug method to print the current key hash being used
  static void debugKeyHash() {
    debugPrint("🔑 Debug Key Hash Information:");
    debugPrint("📱 Debug Key Hash: 1JfVaAL0qSjLMBg6WYXskACCg0s=");
    debugPrint("📱 Release Key Hash: nq25BZyv+KXeyw2DOSbBToMoiXE=");
    debugPrint("📦 Package Name: com.referaly");
    debugPrint("⚠️  Make sure these hashes are added to Google Cloud Console!");
  }

  /// Test method to verify Google Sign-In email selection popup
  static Future<void> testGoogleSignInEmailSelection() async {
    try {
      debugPrint("🧪 Testing Google Sign-In email selection popup...");

      // First, debug the current configuration
      await debugGoogleSignIn();

      // Then try the comprehensive sign-in method
      final user = await loginWithGoogleComprehensive();

      if (user != null) {
        debugPrint("✅ Test successful! User signed in: ${user.email}");
        // Sign out after test
        await logOutGoogle();
        debugPrint("✅ Test completed successfully");
      } else {
        debugPrint("❌ Test failed - no user returned");
      }
    } catch (e) {
      debugPrint("❌ Test error: $e");
    }
  }

  /// Debug method to test Google Sign-In configuration
  static Future<void> debugGoogleSignIn() async {
    try {
      debugPrint("🔍 Debugging Google Sign-In configuration...");

      // Print key hash information
      debugKeyHash();

      final googleSignIn = GoogleSignIn(
        scopes: ['email', 'profile'],
        clientId: Platform.isIOS
            ? '985082913550-7fje7ug1b6t9j8d9i8brqcu79tra6tq9.apps.googleusercontent.com'
            : null,
      );

      // Check if user is currently signed in
      final currentUser = await googleSignIn.signInSilently();
      if (currentUser != null) {
        debugPrint("✅ User is currently signed in: ${currentUser.email}");
        debugPrint("✅ User ID: ${currentUser.id}");
        debugPrint("✅ Display Name: ${currentUser.displayName}");
      } else {
        debugPrint("ℹ️ No user currently signed in");
      }

      // Check if Google Play Services are available (Android only)
      if (Platform.isAndroid) {
        debugPrint("📱 Platform: Android");
        // Note: Google Play Services availability is handled by the plugin
      } else if (Platform.isIOS) {
        debugPrint("📱 Platform: iOS");
        debugPrint(
            "📱 Client ID: 985082913550-7fje7ug1b6t9j8d9i8brqcu79tra6tq9.apps.googleusercontent.com");
      }

      debugPrint("✅ Google Sign-In configuration appears correct");
    } catch (e) {
      debugPrint("❌ Error during Google Sign-In debug: $e");
    }
  }

  /// Force sign out from Google to ensure email selection popup appears
  static Future<void> forceSignOutGoogle() async {
    try {
      debugPrint("🔄 Force signing out from Google...");
      await GoogleSignIn().signOut();
      await _firebaseAuth.signOut();
      debugPrint("✅ Force sign out completed");
    } catch (e) {
      debugPrint("⚠️ Error during force sign out: $e");
    }
  }

  /// Alternative Google Sign-In method that ensures email selection popup
  static Future<User?> loginWithGoogleAlternative() async {
    try {
      debugPrint("🔍 Starting Alternative Google Sign-In process...");

      // First, sign out completely
      await forceSignOutGoogle();

      final googleSignIn = GoogleSignIn(
        scopes: ['email', 'profile'],
        clientId: Platform.isIOS
            ? '985082913550-7fje7ug1b6t9j8d9i8brqcu79tra6tq9.apps.googleusercontent.com'
            : null,
      );

      // Use a different approach - try to get current user first
      final currentUser = await googleSignIn.signInSilently();
      if (currentUser != null) {
        debugPrint(
            "✅ Found existing user, signing out to force email selection");
        await googleSignIn.signOut();
        // Add a small delay to ensure sign out is complete
        await Future.delayed(Duration(milliseconds: 500));
      }

      debugPrint("🔐 Initiating Google Sign-In with email selection...");
      final GoogleSignInAccount? googleAccount = await googleSignIn.signIn();

      if (googleAccount == null) {
        debugPrint("❌ Google Sign-In cancelled by user");
        return null;
      }

      debugPrint("✅ Google Sign-In successful for: ${googleAccount.email}");

      final GoogleSignInAuthentication googleAuth =
          await googleAccount.authentication;

      if (googleAuth.idToken == null || googleAuth.accessToken == null) {
        debugPrint("❌ Google Sign-In failed: Missing tokens");
        return null;
      }

      debugPrint("✅ Tokens received successfully");

      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential =
          await _firebaseAuth.signInWithCredential(credential);

      if (userCredential.user == null) {
        debugPrint("❌ Firebase authentication failed");
        return null;
      }

      debugPrint("✅ Firebase authentication successful");

      return userCredential.user;
    } catch (e, stackTrace) {
      debugPrint("❌ Exception during alternative Google login: $e");
      debugPrint("Stack trace: $stackTrace");
      return null;
    }
  }

  /// Comprehensive Google Sign-In method that ensures email selection popup
  static Future<User?> loginWithGoogleComprehensive() async {
    try {
      debugPrint("🔍 Starting Comprehensive Google Sign-In process...");

      // Step 1: Force sign out from all services
      await forceSignOutGoogle();

      // Step 2: Add a delay to ensure sign out is complete
      await Future.delayed(Duration(milliseconds: 1000));

      // Step 3: Initialize Google Sign-In with proper configuration
      final googleSignIn = GoogleSignIn(
        scopes: ['email', 'profile'],
        clientId: Platform.isIOS
            ? '985082913550-7fje7ug1b6t9j8d9i8brqcu79tra6tq9.apps.googleusercontent.com'
            : null,
        // Add additional configuration for better email selection
        hostedDomain: "", // Empty string to show all accounts
        signInOption: SignInOption.standard, // Use standard sign-in flow
      );

      // Step 4: Check if there's a current user and handle appropriately
      try {
        final currentUser = await googleSignIn.signInSilently();
        if (currentUser != null) {
          debugPrint(
              "✅ Found existing user, signing out to force email selection");
          await googleSignIn.signOut();
          await Future.delayed(Duration(milliseconds: 500));
        }
      } catch (e) {
        debugPrint("ℹ️ No existing user found or error checking: $e");
      }

      // Step 5: Initiate the sign-in process
      debugPrint("🔐 Initiating Google Sign-In with email selection...");
      final GoogleSignInAccount? googleAccount = await googleSignIn.signIn();

      if (googleAccount == null) {
        debugPrint("❌ Google Sign-In cancelled by user");
        return null;
      }

      debugPrint("✅ Google Sign-In successful for: ${googleAccount.email}");
      debugPrint("✅ User ID: ${googleAccount.id}");
      debugPrint("✅ Display Name: ${googleAccount.displayName}");

      // Step 6: Get authentication tokens
      final GoogleSignInAuthentication googleAuth =
          await googleAccount.authentication;

      if (googleAuth.idToken == null || googleAuth.accessToken == null) {
        debugPrint("❌ Google Sign-In failed: Missing tokens");
        debugPrint(
            "❌ ID Token: ${googleAuth.idToken != null ? 'Present' : 'Missing'}");
        debugPrint(
            "❌ Access Token: ${googleAuth.accessToken != null ? 'Present' : 'Missing'}");
        return null;
      }

      debugPrint("✅ Tokens received successfully");

      // Step 7: Create Firebase credential
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Step 8: Sign in to Firebase
      final userCredential =
          await _firebaseAuth.signInWithCredential(credential);

      if (userCredential.user == null) {
        debugPrint("❌ Firebase authentication failed");
        return null;
      }

      debugPrint("✅ Firebase authentication successful");
      debugPrint("✅ Firebase User Email: ${userCredential.user?.email}");
      debugPrint("✅ Firebase User UID: ${userCredential.user?.uid}");

      return userCredential.user;
    } catch (e, stackTrace) {
      debugPrint("❌ Exception during comprehensive Google login: $e");
      debugPrint("Stack trace: $stackTrace");

      // Provide specific error messages based on the exception
      if (e.toString().contains('network')) {
        debugPrint("🌐 Network error - check internet connection");
      } else if (e.toString().contains('cancelled')) {
        debugPrint("🚫 User cancelled the sign-in process");
      } else if (e.toString().contains('configuration')) {
        debugPrint("⚙️ Configuration error - check GoogleService-Info.plist");
      } else if (e.toString().contains('sign_in_failed')) {
        debugPrint("🔐 Sign-in failed - check Google Cloud Console setup");
      } else if (e.toString().contains('developer_error')) {
        debugPrint("👨‍💻 Developer error - check OAuth client configuration");
      } else if (e.toString().contains('invalid_account')) {
        debugPrint("👤 Invalid account - user account not found");
      }

      return null;
    }
  }

  static Future<User?> loginWithGoogle() async {
    // Use the comprehensive method that ensures email selection popup
    return await loginWithGoogleComprehensive();
  }

  // static Future<void> signInWithApple() async {
  //   final credential = await SignInWithApple.getAppleIDCredential(
  //     scopes: [
  //       AppleIDAuthorizationScopes.email,
  //       AppleIDAuthorizationScopes.fullName,
  //     ],
  //   );
  //   debugPrint(credential);
  // }
  // static Future<User?> signInWithApple({List<Scope> scopes = const [] }) async {
  //   try{
  //     final result = await TheAppleSignIn.performRequests(
  //       [AppleIdRequest(requestedScopes: scopes)]
  //     );
  //     switch (result.status){
  //       case AuthorizationStatus.authorized:
  //         final appleIdCredential = result.credential;
  //         final oAuthCredential = OAuthProvider('apple.com');
  //         final credential = oAuthCredential.credential(
  //           idToken: String.fromCharCodes(appleIdCredential!.identityToken!)
  //         );
  //         final userCredential = await _firebaseAuth.signInWithCredential(credential);
  //         debugPrint("++++++++++++${userCredential.user}");
  //         return userCredential.user;
  //       case AuthorizationStatus.error:
  //       throw PlatformException(code: 'ERROR_AUTHORIZATION_DENIED',message: result.error.toString());
  //
  //       case AuthorizationStatus.cancelled:
  //         throw PlatformException(code: 'ERROR_ABORTED_BY_USER',message: 'Sign In Aborted By User');
  //       default:
  //         throw UnimplementedError();
  //     }
  //
  //     // ignore: avoid_pri
  //
  //   }catch(e){
  //     debugPrint('Catch error ${e.toString()}');
  //     return null;
  //   }
  //   return null;
  // }

  /*static Future<User?> signInWithAppleSecond() async {
    try{

      final credential = await SignInWithApple.getAppleIDCredential(
          scopes: [AppleIDAuthorizationScopes.email],
        webAuthenticationOptions: WebAuthenticationOptions(
                  // TODO: Set the `clientId` and `redirectUri` arguments to the values you entered in the Apple Developer portal during the setup
                  clientId:
                  'de.lunaone.flutter.signinwithappleexample.service',
                  redirectUri:
                  // For web your redirect URI needs to be the host of the "current page",
                  // while for Android you will be using the API server that redirects back into your app via a deep link
                  // NOTE(tp): For package local development use (as described in `Development.md`)
                  // Uri.parse('https://siwa-flutter-plugin.dev/')
                   Uri.parse(
                    'https://flutter-sign-in-with-apple-example.glitch.me/callbacks/sign_in_with_apple',
                  ),
                ),
      );
      final oAuthCredential = OAuthProvider('apple.com').credential(
        idToken: credential.identityToken,
        accessToken: credential.authorizationCode
      );
      final userCredential = await _firebaseAuth.signInWithCredential(oAuthCredential);
      return userCredential.user;


      // ignore: avoid_pri

    }catch(e){
      debugPrint('Catch error ${e.toString()}');
      return null;
    }
    return null;
  }*/

  /// LogOutGoogle
  static Future<void> logOutGoogle() async {
    try {
      debugPrint("🚪 Logging out from Google Sign-In...");
      await _firebaseAuth.signOut();
      await GoogleSignIn().signOut();
      debugPrint("✅ Successfully logged out from Google and Firebase");
    } catch (e) {
      debugPrint("❌ Error during logout: $e");
    }
  }

  /// Check if user is already signed in
  static Future<bool> isUserSignedIn() async {
    try {
      final currentUser = await GoogleSignIn().signInSilently();
      return currentUser != null;
    } catch (e) {
      debugPrint("ℹ️ No user currently signed in: $e");
      return false;
    }
  }

  /// Get current user info
  static Future<GoogleSignInAccount?> getCurrentUser() async {
    try {
      return await GoogleSignIn().signInSilently();
    } catch (e) {
      debugPrint("❌ Error getting current user: $e");
      return null;
    }
  }

  /// LoginWithFacebook
  // static Future<User?> loginWithFacebook() async {
  //   try {
  //     final LoginResult result = await FacebookAuth.instance.login();
  //
  //     if (result.status == LoginStatus.success && result.accessToken != null) {
  //       final OAuthCredential facebookAuthCredential =
  //           FacebookAuthProvider.credential(result.accessToken!.tokenString);
  //
  //       UserCredential userCredential = await _firebaseAuth
  //           .signInWithCredential(facebookAuthCredential);
  //       User? user = userCredential.user;
  //
  //       /// Api : socialSignUpLoginApi
  //       if (user != null) {
  //         final response = await RESTAuth.socialSignUpLogin(
  //           deviceId: await _object.getDeviceID() ?? '',
  //           deviceType: Platform.isAndroid ? 'android' : 'ios',
  //           fcmToken: await FirebaseMessaging.instance.getToken() ?? '',
  //           firstName: user.displayName?.split(" ").first ?? '',
  //           lastName: user.displayName?.split(" ").last ?? '',
  //           socialType: 'facebook',
  //           tokenId: result.accessToken!.tokenString,
  //         );
  //
  //         if (response is ApiSuccess<ModelCommon>) {
  //           if (response.data.status == true) {
  //             await AppPreference.writeInt(AppPreference.isLoggedIn, 1);
  //             CustomToast.show(Get.overlayContext!,
  //                 response.data.message ?? "Login successful!");
  //             // Get.offAllNamed(ScreenMain.pageId);
  //             WidgetsBinding.instance.addPostFrameCallback((_) {
  //               Future.delayed(Duration(milliseconds: 200), () {
  //                 Get.offAllNamed(ScreenMain.pageId);
  //               });
  //             });
  //
  //           } else {
  //             CustomToast.show(
  //                 Get.overlayContext!, response.data.message ?? "Login failed");
  //           }
  //         } else if (response is ApiFailure) {
  //           CustomToast.show(Get.overlayContext!,
  //               response.error.message ?? "Something went wrong");
  //         }
  //       }
  //
  //       return user;
  //     } else if (result.status == LoginStatus.cancelled) {
  //       CustomToast.show(
  //           Get.overlayContext!, "Facebook login cancelled by the user!...");
  //       debugPrint("Facebook login cancelled by the user.");
  //       return null;
  //     } else if (result.status == LoginStatus.failed) {
  //       CustomToast.show(
  //           Get.overlayContext!, "Facebook login failed: ${result.message}");
  //       debugPrint("Facebook login failed: ${result.message}");
  //       return null;
  //     } else {
  //       debugPrint("Unhandled Facebook login status: ${result.status}");
  //       return null;
  //     }
  //   } catch (e) {
  //     debugPrint("Exception during Facebook login: $e");
  //     return null;
  //   }
  // }

  static Future<bool> socialLoginApi(
    User user,
    String accessToken, {
    required String socialType,
  }) async {
    _lastLoginResponse = null;
    final deviceId = await _object.getDeviceID() ?? '';
    final deviceType = Platform.isAndroid ? 'android' : 'ios';
    final fcmToken = await FirebaseMessaging.instance.getToken() ?? '';

    final nameParts = user.displayName?.split(" ") ?? [];
    final firstName = nameParts.isNotEmpty ? nameParts.first : '';
    final lastName = nameParts.length > 1 ? nameParts.sublist(1).join(" ") : '';

    String? idToken;
    AppHelper.showLog("socialType: $socialType");

    // Handle different social types appropriately
    if (socialType == 'google') {
      // For Google sign-in, we need to get the token from GoogleSignIn
      try {
        // final GoogleSignInAccount? user1 = await GoogleSignIn().signIn();
        // if (user1 != null) {
        //   final GoogleSignInAuthentication auth = await user1.authentication;
        //   idToken = auth.idToken;
        // }

        idToken = await user.getIdToken(true);
        AppHelper.showLog("idToken: $idToken");
      } catch (e) {
        debugPrint("❌ Error getting Google Sign-In token: $e");
        return false;
      }
    } else {
      // For Apple and Facebook, use the Firebase user token
      // idToken = await user.getIdToken(true);
      idToken = accessToken;
    }

    if (idToken == null) {
      debugPrint("❌ ID token is null for social type: $socialType");
      return false;
    }

    AppHelper.showLog("New String Token: ${idToken}");
    final response = await RESTAuth.socialSignUpLogin(
      deviceId: deviceId,
      deviceType: deviceType,
      fcmToken: fcmToken,
      firstName: firstName,
      lastName: lastName,
      socialType: socialType,
      tokenId: idToken,
    );

    if (response is ApiSuccess<ModelLogin> && (response.data.status ?? false)) {
      _lastLoginResponse = response.data;
      await AppPreference.writeInt(AppPreference.isLoggedIn, 1);
      if (response.data.data?.accessToken != null) {
        await AppPreference.writeString(
          AppPreference.accessToken,
          response.data.data!.accessToken!,
        );
      }

      await AppPreference.writeString(
          AppPreference.accessToken, response.data.data!.accessToken!);
      await AppPreference.writeString(
          AppPreference.email, response.data.data!.user!.email!);

      await AppPreference.writeInt(AppPreference.isLoggedIn, 1);
      await AppPreference.writeString(
          AppPreference.isPaid, response.data.data!.user!.isPaid.toString());
      await AppPreference.writeString(AppPreference.productId,
          response.data.data!.user!.productId.toString());
    
        final user = response.data.data?.user;
        final hasCompanyType =
            ValidationHelper.isValidString(user?.companyName);
        
          Get.offAllNamed(ScreenProfileType.pageId);
        
    
      return true;
    } else {
      _lastLoginResponse = null;
      final errorMsg = response is ApiFailure
          ? response.error.message ?? "Something went wrong"
          : "Login failed";
      debugPrint("Social login failed: $errorMsg");

      return false;
    }
  }

  /// Facebook login method with proper error handling and debugging
  static Future<User?> loginWithFacebook() async {
    try {
      debugPrint("🔍 Starting Facebook login process...");

      // Generate nonce for security
      final rawNonce = generateNonce();
      final nonce = sha256ofString(rawNonce);
      debugPrint("🔐 Generated nonce for Facebook login");

      // Attempt Facebook login with proper configuration
      final result = await FacebookAuth.instance.login(
        permissions: ['email', 'public_profile'],
        loginTracking: LoginTracking.limited,
        nonce: nonce,
      );

      debugPrint("📱 Facebook login result status: ${result.status}");
      debugPrint("📱 Facebook login result message: ${result.message}");

      if (result.status == LoginStatus.success && result.accessToken != null) {
        debugPrint("✅ Facebook login successful");
        debugPrint(
            "✅ Access token received: ${result.accessToken!.tokenString.substring(0, 20)}...");

        try {
          // Create Firebase credential
          final credential = FacebookAuthProvider.credential(
            result.accessToken!.tokenString,
          );

          debugPrint("🔥 Creating Firebase credential...");

          // Sign in to Firebase
          final userCredential =
              await _firebaseAuth.signInWithCredential(credential);

          if (userCredential.user != null) {
            debugPrint("✅ Firebase authentication successful");
            debugPrint("✅ User email: ${userCredential.user!.email}");
            debugPrint("✅ User UID: ${userCredential.user!.uid}");
            return userCredential.user;
          } else {
            debugPrint("❌ Firebase authentication failed - no user returned");
            return null;
          }
        } catch (firebaseError) {
          debugPrint("❌ Firebase authentication error: $firebaseError");

          // Check for specific Firebase errors
          if (firebaseError.toString().contains('invalid-credential')) {
            debugPrint(
                "❌ Invalid credential error - check Facebook app configuration");
          } else if (firebaseError
              .toString()
              .contains('account-exists-with-different-credential')) {
            debugPrint("❌ Account exists with different credential");
          } else if (firebaseError.toString().contains('network')) {
            debugPrint("❌ Network error during Firebase authentication");
          }

          return null;
        }
      } else if (result.status == LoginStatus.cancelled) {
        debugPrint("🚫 Facebook login cancelled by user");
        CustomToast.show(Get.overlayContext!, "Facebook login cancelled");
        return null;
      } else if (result.status == LoginStatus.failed) {
        debugPrint("❌ Facebook login failed: ${result.message}");
        CustomToast.show(
            Get.overlayContext!, "Facebook login failed: ${result.message}");
        return null;
      } else {
        debugPrint("❌ Unknown Facebook login status: ${result.status}");
        return null;
      }
    } catch (e, stack) {
      debugPrint("❌ Exception during Facebook login: $e");
      debugPrint("❌ Stack trace: $stack");

      // Provide specific error messages
      if (e.toString().contains('hash')) {
        debugPrint("❌ Hash key error - check Facebook app configuration");
        CustomToast.show(Get.overlayContext!,
            "Facebook configuration error. Please check your app settings.");
      } else if (e.toString().contains('network')) {
        debugPrint("❌ Network error during Facebook login");
        CustomToast.show(Get.overlayContext!,
            "Network error. Please check your internet connection.");
      } else if (e.toString().contains('permission')) {
        debugPrint("❌ Permission error during Facebook login");
        CustomToast.show(
            Get.overlayContext!, "Permission denied for Facebook login.");
      } else {
        CustomToast.show(Get.overlayContext!, "Facebook login error occurred.");
      }

      return null;
    }
  }

  // static  Future<dynamic> loginWithFacebook() async {
  //    // Trigger the sign-in flow
  //    final rawNonce = generateNonce();
  //    final nonce = sha256ofString(rawNonce);
  //    final result = await FacebookAuth.instance.login(
  //      loginTracking: LoginTracking.limited,
  //      nonce: nonce,
  //    );
  //    if (result.status == LoginStatus.success) {
  //      print('${await FacebookAuth.instance.getUserData()}');
  //      final token = result.accessToken as LimitedToken;
  //      // Create a credential from the access token
  //      OAuthCredential credential = OAuthCredential(
  //        providerId: 'facebook.com',
  //        signInMethod: 'oauth',
  //        idToken: token.tokenString,
  //        rawNonce: rawNonce,
  //      );
  //      await _firebaseAuth.signInWithCredential(credential);
  //    }
  //  }

  /// logoutFacebook
  static Future<void> logoutFacebook() async {
    try {
      // Logout from Facebook
      await FacebookAuth.instance.logOut();

      // Logout from Firebase
      await _firebaseAuth.signOut();

      debugPrint("Successfully logged out from Facebook and Firebase");
    } catch (e) {
      debugPrint("Error during Facebook logout: $e");
    }
  }

  static String generateNonce([int length = 32]) {
    final charset =
        '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    final random = Random.secure();
    return List.generate(length, (_) => charset[random.nextInt(charset.length)])
        .join();
  }

  /// Returns the sha256 hash of [input] in hex notation.
  static String sha256ofString(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  /// Generate Facebook hash key for debugging
  static Future<void> generateFacebookHashKey() async {
    try {
      debugPrint("🔑 Generating Facebook hash keys...");

      // For debug builds
      debugPrint("📱 Debug Hash Key: VzSiQcXRmi2kyjzcA+mYLEtbGVs=");
      debugPrint("📱 Release Hash Key: VzSiQcXRmi2kyjzcA+mYLEtbGVs=");

      debugPrint("📋 Instructions:");
      debugPrint(
          "1. Go to https://developers.facebook.com/apps/692631938209320/settings/basic/");
      debugPrint("2. Add these hash keys to your Facebook app:");
      debugPrint("   - VzSiQcXRmi2kyjzcA+mYLEtbGVs=");
      debugPrint(
          "3. Make sure your app is in development mode or add test users");
      debugPrint("4. Verify the package name matches: com.referaly");
    } catch (e) {
      debugPrint("❌ Error generating hash keys: $e");
    }
  }

  /// Test Facebook login with comprehensive debugging
  static Future<void> testFacebookLogin() async {
    try {
      debugPrint("🧪 Testing Facebook login...");

      // Step 1: Generate hash keys
      await generateFacebookHashKey();

      // Step 2: Test Facebook login
      final user = await loginWithFacebook();

      if (user != null) {
        debugPrint("✅ Facebook login test successful!");
        debugPrint("✅ User email: ${user.email}");
        debugPrint("✅ User UID: ${user.uid}");

        // Sign out after test
        await logoutFacebook();
        debugPrint("✅ Test completed successfully");
      } else {
        debugPrint("❌ Facebook login test failed");
      }
    } catch (e) {
      debugPrint("❌ Facebook login test error: $e");
    }
  }

  /// Quick Facebook login test for debugging
  static Future<void> quickFacebookTest() async {
    try {
      debugPrint("🚀 Quick Facebook login test...");

      // Show hash keys
      debugPrint("🔑 Hash Key: VzSiQcXRmi2kyjzcA+mYLEtbGVs=");
      debugPrint("📱 Package: com.referaly");
      debugPrint("📱 App ID: 692631938209320");

      // Test login
      final user = await loginWithFacebook();

      if (user != null) {
        debugPrint("✅ SUCCESS: Facebook login works!");
        await logoutFacebook();
      } else {
        debugPrint("❌ FAILED: Facebook login failed");
        debugPrint("📋 Check FACEBOOK_LOGIN_TROUBLESHOOTING.md for solutions");
      }
    } catch (e) {
      debugPrint("❌ ERROR: $e");
    }
  }

  /// signInWithApple
  /// signInWithApple - Clean implementation to avoid conflicts
  static Future<UserCredential?> signInWithApple() async {
    try {
      debugPrint("🍎 Starting Apple Sign-In process...");

      // Check if Apple Sign-In is available
      final isAvailable = await SignInWithApple.isAvailable();
      debugPrint("🍎 Apple Sign-In available: $isAvailable");

      if (!isAvailable) {
        debugPrint("❌ Apple Sign-In is not available on this device");
        return null;
      }

      final rawNonce = generateNonce();
      final nonce = sha256ofString(rawNonce);
      debugPrint("🍎 Generated nonce for Apple Sign-In");

      debugPrint("🍎 Requesting Apple ID credential...");

      // Request credential for the currently signed in Apple account.
      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        nonce: nonce,
      );

      debugPrint("🍎 Apple ID credential received");
      debugPrint(
          "🍎 Identity Token: ${appleCredential.identityToken != null ? 'Present' : 'Missing'}");
      debugPrint(
          "🍎 Authorization Code: ${appleCredential.authorizationCode.isNotEmpty ? 'Present' : 'Missing'}");
      debugPrint("🍎 Email: ${appleCredential.email ?? 'Not provided'}");
      debugPrint(
          "🍎 Full Name: ${appleCredential.givenName ?? ''} ${appleCredential.familyName ?? ''}");
      debugPrint(
          "🍎 User Identifier: ${appleCredential.userIdentifier ?? 'Not provided'}");

      if (appleCredential.identityToken == null) {
        debugPrint("❌ Apple Sign-In failed: Identity token is null");
        return null;
      }

      if (appleCredential.identityToken!.isEmpty) {
        debugPrint("❌ Apple Sign-In failed: Identity token is empty");
        return null;
      }

      debugPrint("🍎 Creating OAuth credential...");

      // Create an `OAuthCredential` from the credential returned by Apple.
      final oauthCredential = OAuthProvider("apple.com").credential(
        idToken: appleCredential.identityToken,
        rawNonce: rawNonce,
        accessToken: appleCredential.authorizationCode,
      );

      debugPrint("🍎 OAuth credential created successfully");
      debugPrint("🍎 Credential providerId: ${oauthCredential.providerId}");
      debugPrint("🍎 Credential signInMethod: ${oauthCredential.signInMethod}");
      debugPrint("🍎 Credential toString: ${oauthCredential.toString()}");

      debugPrint("🍎 Signing in to Firebase with Apple credential...");
      debugPrint(
          "🍎 ID Token length: ${appleCredential.identityToken!.length}");
      debugPrint("🍎 Raw Nonce: $rawNonce");
      debugPrint("🍎 SHA256 Nonce: $nonce");

      // Sign in to Firebase with the Apple credential
      final userCredential =
          await _firebaseAuth.signInWithCredential(oauthCredential);

      if (userCredential.user == null) {
        debugPrint("❌ Firebase authentication failed with Apple credential");
        return null;
      }

      // Successfully signed in
      debugPrint("🍎 Apple Sign-In success: ${userCredential.user?.email}");
      debugPrint("🍎 User UID: ${userCredential.user?.uid}");
      debugPrint("🍎 Display Name: ${userCredential.user?.displayName}");

      return userCredential;
    } on SignInWithAppleAuthorizationException catch (e) {
      debugPrint("⚠️ Apple Sign-In authorization exception: ${e.code}");
      debugPrint("⚠️ Error message: ${e.message}");

      if (e.code == AuthorizationErrorCode.canceled) {
        debugPrint("🚫 Apple Sign-In canceled by user");
        return null;
      } else if (e.code == AuthorizationErrorCode.failed) {
        debugPrint("❌ Apple Sign-In failed");
        return null;
      } else if (e.code == AuthorizationErrorCode.invalidResponse) {
        debugPrint("❌ Apple Sign-In invalid response");
        return null;
      } else if (e.code == AuthorizationErrorCode.notHandled) {
        debugPrint("❌ Apple Sign-In not handled");
        return null;
      } else if (e.code == AuthorizationErrorCode.unknown) {
        debugPrint("❌ Apple Sign-In unknown error");
        return null;
      } else {
        debugPrint("⚠️ Apple Sign-In error: ${e.message}");
        return null;
      }
    } catch (e, stackTrace) {
      debugPrint("❌ Unexpected error during Apple Sign-In: $e");
      debugPrint("❌ Stack trace: $stackTrace");

      // Check for specific Firebase auth errors
      if (e.toString().contains('invalid-credential')) {
        debugPrint(
            "❌ Firebase invalid credential error - this is the main issue");
        debugPrint("❌ The simplified implementation should fix this");
        debugPrint(
            "❌ If it still fails, check Firebase Console Apple provider configuration");
      } else if (e.toString().contains('network')) {
        debugPrint("❌ Network error during Apple Sign-In");
      } else if (e.toString().contains('timeout')) {
        debugPrint("❌ Timeout error during Apple Sign-In");
      }

      return null;
    }
  }

  // static final _firebaseAuth = _firebaseAuth;

// static Future<User?> signInWithApple({List<Scope> scopes = const []}) async {
//   // 1. perform the sign-in request
//   final result = await TheAppleSignIn.performRequests(
//       [AppleIdRequest(requestedScopes: scopes)]);
//   // 2. check the result
//   switch (result.status) {
//     case AuthorizationStatus.authorized:
//       final appleIdCredential = result.credential!;
//       final oAuthProvider = OAuthProvider('apple.com');
//       final credential = oAuthProvider.credential(
//         idToken: String.fromCharCodes(appleIdCredential.identityToken!),
//         accessToken:
//         String.fromCharCodes(appleIdCredential.authorizationCode!),
//       );
//       final userCredential =
//       await _firebaseAuth.signInWithCredential(credential);
//       final firebaseUser = userCredential.user!;
//       final email = '${firebaseUser.email}';
//       final displayName = '${firebaseUser.displayName}';
//       debugPrint("++++++++++++++Email: ${email}");
//       debugPrint("++++++++++++++Email: ${displayName}");
//       if (scopes.contains(Scope.fullName)) {
//         final fullName = appleIdCredential.fullName;
//         if (fullName != null &&
//             fullName.givenName != null &&
//             fullName.familyName != null) {
//           final displayName = '${fullName.givenName} ${fullName.familyName}';
//
//           await firebaseUser.updateDisplayName(displayName);
//         }
//       }
//       return firebaseUser;
//     case AuthorizationStatus.error:
//       throw PlatformException(
//         code: 'ERROR_AUTHORIZATION_DENIED',
//         message: result.error.toString(),
//       );
//
//     case AuthorizationStatus.cancelled:
//       throw PlatformException(
//         code: 'ERROR_ABORTED_BY_USER',
//         message: 'Sign in aborted by user',
//       );
//     default:
//       throw UnimplementedError();
//   }
// }
//
// static Future<bool> checkAppleSignInAvailability() async {
//   final available = await TheAppleSignIn.isAvailable();
//   return available;
// }
}
