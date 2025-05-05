import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';
import 'package:referaly/widgets/primary_button.dart';
import '../../controller/controller_verification.dart';
import '../../resources/app_assets.dart';
import '../../resources/app_colors.dart';
import '../../widgets/custom_header_bg.dart';

class ScreenVerification extends GetView<VerificationController> {
  static const String pageId = "/ScreenVerification";
  const ScreenVerification({super.key});

  @override
  Widget build(BuildContext context) {
    final VerificationController verificationController =
        Get.put(VerificationController());

    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const CustomBGHeader(
            imagePath: AppAssets.imgHeaderBg,
          ),

          ///  Enter Code
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                const Text(
                  'Enter Code',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Enter the verification code we just sent on your email address.',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                const SizedBox(height: 30),
                Center(
                  child: Pinput(
                    length: 4,
                    controller: controller.pinputController,
                    defaultPinTheme: PinTheme(
                      width: 70,
                      height: 68,
                      textStyle: TextStyle(
                        fontSize: 34,
                        color: AppColors.primary,
                        fontWeight: FontWeight.w700,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFD9D9D9)),
                      ),
                    ),
                    focusedPinTheme: PinTheme(
                      width: 70,
                      height: 68,
                      textStyle: TextStyle(
                        fontSize: 34,
                        color: AppColors.primary,
                        fontWeight: FontWeight.w700,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.primary),
                      ),
                    ),
                    onCompleted: (pin) {
                      print("Completed: $pin");
                    },
                  ),
                ),
                const SizedBox(height: 20),
                Obx(
                  () => Center(
                    child: TextButton(
                      onPressed:
                          verificationController.resendTimerSeconds.value == 0
                              ? verificationController.resendCode
                              : null,
                      child: Text(
                        verificationController.resendTimerSeconds.value == 0
                            ? 'Send code again'
                            : 'Send code again 00:${verificationController.resendTimerSeconds.value.toString().padLeft(2, '0')}',
                        style: TextStyle(
                            fontSize: 16,
                            color: verificationController
                                        .resendTimerSeconds.value ==
                                    0
                                ? AppColors.blackColor
                                : AppColors.blackColor),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                PrimaryButton(text: "Verify", onPressed: () {}),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
