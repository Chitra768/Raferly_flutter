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
import 'package:referaly/widgets/custom_toast_msg.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import '../apis/api_result.dart';
import '../apis/rest_auth.dart';
import '../models/model_common.dart';
import '../resources/app_preference.dart';

// import 'package:the_apple_sign_in/the_apple_sign_in.dart';

class GoogleSignInService {
  static final RESTAuth _object = RESTAuth();

  static final _firebaseAuth = FirebaseAuth.instance;

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

  /// LoginWithGoogle
  static Future<User?> loginWithGoogle() async {
    try {
      final GoogleSignInAccount? googleAccount = await GoogleSignIn().signIn();

      if (googleAccount == null) {
        CustomToast.show(
            Get.overlayContext!, "Google login cancelled by the user.");
        return null;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleAccount.authentication;

      if (googleAuth.accessToken == null || googleAuth.idToken == null) {
        debugPrint("Google authentication failed: Missing tokens.");
        return null;
      }

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential =
          await _firebaseAuth.signInWithCredential(credential);

      return userCredential.user; // Returning the Firebase User object directly
    } catch (e) {
      debugPrint("Exception during Google login: $e");
      CustomToast.show(Get.overlayContext!, "Google login error occurred.");
      return null;
    }
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
    await _firebaseAuth.signOut();
    await GoogleSignIn().signOut();
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
    final deviceId = await _object.getDeviceID() ?? '';
    final deviceType = Platform.isAndroid ? 'android' : 'ios';
    final fcmToken = await FirebaseMessaging.instance.getToken() ?? '';

    final nameParts = user.displayName?.split(" ") ?? [];
    final firstName = nameParts.isNotEmpty ? nameParts.first : '';
    final lastName = nameParts.length > 1 ? nameParts.sublist(1).join(" ") : '';

    final response = await RESTAuth.socialSignUpLogin(
      deviceId: deviceId,
      deviceType: deviceType,
      fcmToken: fcmToken,
      firstName: firstName,
      lastName: lastName,
      socialType: socialType,
      tokenId: accessToken,
    );

    if (response is ApiSuccess<ModelCommon> && response.data.status == true) {
      await AppPreference.writeInt(AppPreference.isLoggedIn, 1);
      CustomToast.show(
        Get.overlayContext!,
        response.data.message ?? "Login successful!",
      );
      return true;
    } else {
      final errorMsg = response is ApiFailure
          ? response.error.message ?? "Something went wrong"
          : "Login failed";
      CustomToast.show(Get.overlayContext!, errorMsg);
      return false;
    }
  }

  /// Facebook login method with nonce and sha256 integration
  static Future<User?> loginWithFacebook() async {
    try {
      if (Platform.isIOS) {
        // iOS: Use nonce and manual credential
        final rawNonce = generateNonce();
        final nonce = sha256ofString(rawNonce);

        final result = await FacebookAuth.instance.login(
          loginTracking: LoginTracking.limited,
          nonce: nonce,
        );

        if (result.status == LoginStatus.success &&
            result.accessToken != null) {
          final token = result.accessToken!;
          final OAuthCredential credential = OAuthCredential(
            providerId: 'facebook.com',
            signInMethod: 'oauth',
            idToken: token.tokenString,
            rawNonce: rawNonce,
          );

          final userCredential =
              await _firebaseAuth.signInWithCredential(credential);
          return userCredential.user;
        }
      } else {
        // Android: Use simple credential
        final result = await FacebookAuth.instance.login();

        if (result.status == LoginStatus.success &&
            result.accessToken != null) {
          final credential = FacebookAuthProvider.credential(
            result.accessToken!.tokenString,
          );

          final userCredential =
              await _firebaseAuth.signInWithCredential(credential);
          return userCredential.user;
        }
      }

      // Fallback for cancelled or failed login
      debugPrint("Facebook login failed or cancelled.");
      return null;
    } catch (e, stack) {
      debugPrint("Exception during Facebook login: $e\n$stack");
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

  /// signInWithApple
  static Future<UserCredential?> signInWithApple() async {
    try {
      final rawNonce = generateNonce();
      final nonce = sha256ofString(rawNonce);

      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        nonce: nonce,
      );

      final oauthCredential = OAuthProvider("apple.com").credential(
        idToken: appleCredential.identityToken,
        rawNonce: rawNonce,
        accessToken: appleCredential.authorizationCode,
      );

      return await _firebaseAuth.signInWithCredential(oauthCredential);
    } on SignInWithAppleAuthorizationException catch (e) {
      if (e.code == AuthorizationErrorCode.canceled) {
        debugPrint(" ⚠️ Apple sign-in canceled by user.");
        return null;
      } else {
        debugPrint(" ⚠️ Apple sign-in error: ${e.message}");
        rethrow;
      }
    } catch (e) {
      debugPrint("⚠️ Unexpected error during Apple sign-in: $e");
      rethrow;
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
