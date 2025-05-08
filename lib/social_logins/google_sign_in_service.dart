

import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
// import 'package:the_apple_sign_in/the_apple_sign_in.dart';

class GoogleSignInService{
  static Future<User?> loginWithGoogle() async {
    final googleAccount = await GoogleSignIn().signIn();
    debugPrint('Google sign  ${googleAccount?.email}');
    final googleAuth = await googleAccount?.authentication;
    debugPrint('Google sign in auth ${googleAuth?.accessToken}');

     final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken
    );

    UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);

    return userCredential.user;
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

  static Future<void> logOutGoogle() async {
    await FirebaseAuth.instance.signOut();
    await GoogleSignIn().signOut();
  }

  static  String generateNonce([int length = 32]) {
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