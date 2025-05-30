import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:referaly/get/screens.dart';
import 'package:referaly/languages/languagekeys.dart';
import 'package:referaly/resources/app_assets.dart';
import 'package:referaly/screens/auth/screen_profile_type.dart';
import 'package:referaly/screens/auth/screen_registration.dart';
import 'package:referaly/screens/home/screen_main.dart';
import 'package:referaly/social_logins/google_sign_in_service.dart';
import 'package:referaly/utils/translations.dart';
import 'package:referaly/widgets/primary_button.dart';

import '../../controller/controller_welcome.dart';
import '../../resources/app_colors.dart';
import '../../widgets/secondary_button_outline.dart';

class ScreenWelcome extends GetView<WelcomeController> {
  static String pageId = "/ScreenWelcome";

  final welcomeController = Get.put(WelcomeController());

  ScreenWelcome({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: AppColors.whiteColor,
        body: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              // Placeholder for the house image
              Image.asset(
                AppAssets.imgWelcomeHouse,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 20),

              // Welcome text
              Text(
                tr(LanguageKeys.Welcome),
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w600,
                  color: Colors.black, // Set the color to black
                ),
              ),

              const SizedBox(height: 20),
              PrimaryButton(
                  text: tr(LanguageKeys.createAccont),
                  onPressed: () {
                    Get.toNamed(ScreenRegistration.pageId);
                  }),
              const SizedBox(height: 25),
              SecondaryButton(
                text: 'login',
                onPressed: () {
                  Get.toNamed(ScreenLogin.pageId);
                },
              ),
              const SizedBox(height: 20),

              Row(
                children: [
                  Expanded(
                      child: Divider(
                          thickness: 1, color: Colors.grey.withOpacity(0.40))),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      tr(LanguageKeys.createAnAccount),
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: AppColors.blackColor,
                      ),
                    ),
                  ),
                  Expanded(
                      child: Divider(
                          thickness: 1, color: Colors.grey.withOpacity(0.40))),
                ],
              ),

              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () async {
                      final user = await GoogleSignInService.loginWithGoogle();

                      if (user != null) {
                        final tokenId = await FirebaseAuth.instance.currentUser
                            ?.getIdToken(true);

                        if (tokenId != null) {
                          final success =
                              await GoogleSignInService.socialLoginApi(
                                  user, tokenId,
                                  socialType: 'google');
                          if (success) {
                            // controller.isLoggingIn.value = false;
                            Get.offAllNamed(ScreenMain.pageId);
                          } else {
                            // controller.isLoggingIn.value = false;
                            // CustomToast.show(Get.overlayContext!,
                            //     "Google login failed");
                          }
                        } else {
                          // controller.isLoggingIn.value = false;
                          // CustomToast.show(Get.overlayContext!,
                          //     "Google token not found");
                        }
                      } else {
                        // controller.isLoggingIn.value = false;
                      }
                    },
                    child: _socialIcon(FontAwesomeIcons.google, 'Google'),
                  ),
                  const SizedBox(width: 20),
                  GestureDetector(
                      onTap: () async {
                        User? user =
                            await GoogleSignInService.loginWithFacebook();

                        if (user != null) {
                          final accessToken =
                              (await FacebookAuth.instance.accessToken)
                                  ?.tokenString;
                          print('FB ACCESS TOKEN $accessToken');
                          if (accessToken != null) {
                            final success =
                                await GoogleSignInService.socialLoginApi(
                                    user, accessToken,
                                    socialType: 'facebook');
                            if (success) {
                              // controller.isLoggingIn.value = false;
                              Get.offAllNamed(ScreenMain.pageId);
                            } else {
                              // controller.isLoggingIn.value = false;
                              // CustomToast.show(Get.overlayContext!,
                              //     "Facebook login failed");
                            }
                          } else {
                            // controller.isLoggingIn.value = false;
                            // CustomToast.show(Get.overlayContext!,
                            //     "Access token not found");
                          }
                        } else {
                          // controller.isLoggingIn.value = false;
                        }
                      },
                      child:
                          _socialIcon(FontAwesomeIcons.facebookF, 'Facebook')),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _socialIcon(IconData assetPath, String tooltip) {
    return Tooltip(
      message: tooltip,
      child: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          border: Border.all(
            color: AppColors.primary,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(40),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0), // Padding for SVG fitting
          child: Icon(
            assetPath,
            color: AppColors.primary,
            size: 32,
          ),
        ),
      ),
    );
  }
}
