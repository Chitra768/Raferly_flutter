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

import '../apis/api_result.dart';
import '../apis/rest_auth.dart';
import '../models/model_common.dart';
import '../resources/app_preference.dart';

// import 'package:the_apple_sign_in/the_apple_sign_in.dart';

class GoogleSignInService {
  static final RESTAuth _object = RESTAuth();

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
          await FirebaseAuth.instance.signInWithCredential(credential);

      return userCredential.user;
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
  //         final userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
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
      final userCredential = await FirebaseAuth.instance.signInWithCredential(oAuthCredential);
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
    await FirebaseAuth.instance.signOut();
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
  //       UserCredential userCredential = await FirebaseAuth.instance
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
  static Future<bool> socialLoginApi(User user, String accessToken) async {
    final response = await RESTAuth.socialSignUpLogin(
      deviceId: await _object.getDeviceID() ?? '',
      deviceType: Platform.isAndroid ? 'android' : 'ios',
      fcmToken: await FirebaseMessaging.instance.getToken() ?? '',
      firstName: user.displayName?.split(" ").first ?? '',
      lastName: user.displayName?.split(" ").last ?? '',
      socialType: 'facebook',
      tokenId: accessToken,
    );

    if (response is ApiSuccess<ModelCommon> && response.data.status == true) {
      await AppPreference.writeInt(AppPreference.isLoggedIn, 1);
      CustomToast.show(
          Get.overlayContext!, response.data.message ?? "Login successful!");
      return true;
    } else {
      CustomToast.show(
          Get.overlayContext!,
          (response is ApiFailure)
              ? response.error.message ?? "Something went wrong"
              : "Login failed");
      return false;
    }
  }

  static Future<User?> loginWithFacebook() async {
    try {
      final LoginResult result = await FacebookAuth.instance.login();

      switch (result.status) {
        case LoginStatus.success:
          if (result.accessToken != null) {
            final OAuthCredential credential = FacebookAuthProvider.credential(
                result.accessToken!.tokenString);

            UserCredential userCredential =
                await FirebaseAuth.instance.signInWithCredential(credential);

            return userCredential.user;
          } else {
            CustomToast.show(Get.overlayContext!, "Access token missing.");
            debugPrint("Facebook login succeeded but access token is null.");
            return null;
          }

        case LoginStatus.cancelled:
          CustomToast.show(
              Get.overlayContext!, "Facebook login cancelled by the user.");
          debugPrint("Facebook login cancelled by the user.");
          return null;

        case LoginStatus.failed:
          CustomToast.show(
              Get.overlayContext!, "Facebook login failed: ${result.message}");
          debugPrint("Facebook login failed: ${result.message}");
          return null;

        case LoginStatus.operationInProgress:
          CustomToast.show(
              Get.overlayContext!, "Facebook login is already in progress.");
          debugPrint("Facebook login is already in progress.");
          return null;
      }
    } catch (e, stack) {
      CustomToast.show(Get.overlayContext!, "Facebook login error occurred.");
      debugPrint("Exception during Facebook login: $e\n$stack");
      return null;
    }
  }

  /// logoutFacebook
  static Future<void> logoutFacebook() async {
    try {
      // Logout from Facebook
      await FacebookAuth.instance.logOut();

      // Logout from Firebase
      await FirebaseAuth.instance.signOut();

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

  // static  Future<UserCredential> signInWithApple() async {
  //   // To prevent replay attacks with the credential returned from Apple, we
  //   // include a nonce in the credential request. When signing in with
  //   // Firebase, the nonce in the id token returned by Apple, is expected to
  //   // match the sha256 hash of `rawNonce`.
  //   final rawNonce = generateNonce();
  //   final nonce = sha256ofString(rawNonce);
  //
  //   // Request credential for the currently signed in Apple account.
  //   final appleCredential = await SignInWithApple.getAppleIDCredential(
  //     scopes: [
  //       AppleIDAuthorizationScopes.email,
  //       AppleIDAuthorizationScopes.fullName,
  //     ],
  //     nonce: nonce,
  //   );
  //
  //   // Create an `OAuthCredential` from the credential returned by Apple.
  //   final oauthCredential = OAuthProvider("apple.com").credential(
  //     idToken: appleCredential.identityToken,
  //     rawNonce: rawNonce,
  //   );
  //
  //   // Sign in the user with Firebase. If the nonce we generated earlier does
  //   // not match the nonce in `appleCredential.identityToken`, sign in will fail.
  //   return await FirebaseAuth.instance.signInWithCredential(oauthCredential);
  // }

  static final _firebaseAuth = FirebaseAuth.instance;

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
