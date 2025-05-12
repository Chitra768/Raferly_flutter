import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';
import 'package:referaly/widgets/primary_button.dart';
import '../../controller/controller_forgot.dart';
import '../../controller/controller_verification.dart';
import '../../resources/app_assets.dart';
import '../../resources/app_colors.dart';
import '../../widgets/custom_auth_app_bar.dart';

class ScreenVerification extends GetView<VerificationController> {
  static const String pageId = "/ScreenVerification";

  final VerificationController controllerr = Get.put(VerificationController());
  ScreenVerification({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: const CustomAuthAppBar(),
        backgroundColor: AppColors.whiteColor,
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
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
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                          fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 30),

                    /// P-inPut Field
                    Center(
                      child: Pinput(
                        length: 4,
                        controller: controller.pinputController,
                        keyboardType: TextInputType.number, // Only numbers
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        defaultPinTheme: PinTheme(
                          width: 70,
                          height: 68,
                          textStyle: TextStyle(
                            fontSize: 20, // Smaller font size
                            color: AppColors.blackColor, // Black text color
                            fontWeight: FontWeight.w500,
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
                            fontSize: 20,
                            color: AppColors.blackColor,
                            fontWeight: FontWeight.w600,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppColors.primary),
                          ),
                        ),
                        separatorBuilder: (index) => const SizedBox(width: 12),
                        onCompleted: (pin) {
                          print("Completed: $pin");
                        },
                      ),
                    ),

                    const SizedBox(height: 20),

                    /// Resend Code
                    Obx(
                      () => Center(
                        child: TextButton(
                          onPressed: controller.resendTimerSeconds.value == 0
                              ? controller.resendCode
                              : null,
                          child: Text.rich(
                            TextSpan(
                              children: [
                                if (controller.resendTimerSeconds.value ==
                                    0) ...[
                                  TextSpan(
                                    text: "I didn't receive a code ",
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: AppColors.blackColor,
                                    ),
                                  ),
                                  TextSpan(
                                    text: "Resend",
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: AppColors
                                          .blackColor, // dark color for Resend
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ] else ...[
                                  TextSpan(
                                    text:
                                        "Send code again 00:${controller.resendTimerSeconds.value.toString().padLeft(2, '0')}",
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),
                    Obx(() => PrimaryButton(
                          text: controllerr.isVerifying.value
                              ? "Verifying..."
                              : "Verify",
                          onPressed: controllerr.isVerifying.value
                              ? null
                              : () => controllerr.verifyOtpApi(),
                        )),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
