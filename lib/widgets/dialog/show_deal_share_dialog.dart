import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:referaly/controller/controller_main_professional.dart';
import 'package:referaly/languages/languagekeys.dart';
import 'package:referaly/resources/app_assets.dart';
import 'package:referaly/resources/app_colors.dart';
import 'package:referaly/utils/translations.dart';
import 'package:referaly/widgets/custom_toast_msg.dart';
import 'package:referaly/widgets/primary_button.dart';
import 'package:referaly/widgets/secondary_button_outline.dart';
import 'package:url_launcher/url_launcher.dart';

class ShowDealShareDialog extends StatelessWidget {
  ShowDealShareDialog({super.key});

  final controllerMainProfessional = Get.find<ControllerMainProfessional>();

  String? extractNameInBrackets(String? text) {
    if (text == null) return null;
    final regex = RegExp(r'\((.*?)\)');
    final match = regex.firstMatch(text);
    return match?.group(1);
  }

  @override
  Widget build(BuildContext context) {
    final users = controllerMainProfessional.dealDetailData.value.data?.users;
    final logoUrl =
        users != null && users.isNotEmpty ? users[0].companyLogoUrl : null;

    return Dialog(
      backgroundColor: Colors.white, // White background
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Obx(() {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Align(
                alignment: Alignment.topRight,
                child: GestureDetector(
                  onTap: () => Get.back(),
                  child: const Icon(Icons.close),
                ),
              ),
              const SizedBox(height: 8),
              Row(
                crossAxisAlignment: CrossAxisAlignment
                    .center, // Align items vertically in the center
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.circular(8), // set to 0 for sharp square
                      image: DecorationImage(
                        image: (logoUrl != null && logoUrl.startsWith('http'))
                            ? NetworkImage(logoUrl)
                            : const AssetImage(AppAssets.imgPerson)
                                as ImageProvider,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start, // Align text to the start
                      children: [
                        // Text(
                        //   "test", // Hardcoded as per image
                        //   style: TextStyle(
                        //       fontSize: 14,
                        //       fontWeight:
                        //           FontWeight.w400, // Adjusted font weight
                        //       color: AppColors.grey700 // Adjusted color
                        //       ),
                        // ),
                        Text(
                          controllerMainProfessional
                                  .dealDetailData.value.data?.dealName ??
                              "-",
                          style: const TextStyle(
                              fontSize: 16, // Adjusted font size
                              fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  children: [
                    const SizedBox(height: 15),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text.rich(
                        TextSpan(
                          text:
                              '${tr(LanguageKeys.nameOfTheBusinessReferrer)} : ',
                          children: [
                            TextSpan(
                              text: extractNameInBrackets(
                                      controllerMainProfessional.dealDetailData
                                          .value.data?.dealName) ??
                                  "-",
                              style: TextStyle(
                                  color: AppColors
                                      .primary, // Changed to black as per image
                                  fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 25),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        tr(LanguageKeys
                            .businessIntroducerDoesNotRequestCommission),
                        style: TextStyle(
                            color:
                                AppColors.primary, // Primary color as per image
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                    // Removed the "Click here to view the full contract" section
                    // const SizedBox(height: 35),
                    // Align(
                    //   alignment: Alignment.centerLeft,
                    //   child: InkWell(
                    //     onTap: () async {
                    //       final urlString = controllerMainProfessional
                    //           .dealDetailData.value.data?.documentUrl ??
                    //           '';
                    //       if (urlString.isNotEmpty) {
                    //         final url = Uri.parse(urlString);
                    //         if (await canLaunchUrl(url)) {
                    //           await launchUrl(url,
                    //               mode: LaunchMode.externalApplication);
                    //         } else {
                    //           Get.snackbar('Error', 'Could not open the URL');
                    //         }
                    //       } else {
                    //         Get.snackbar('Info', 'Document URL not available');
                    //       }
                    //     },
                    //     child: Text(
                    //       'Click here to view the full contract',
                    //       style: TextStyle(
                    //         color: AppColors.primary,
                    //         fontWeight: FontWeight.w500,
                    //         decoration: TextDecoration.underline,
                    //       ),
                    //     ),
                    //   ),
                    // ),
                    const SizedBox(height: 12),
                    Obx(() => Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Checkbox(
                              value: controllerMainProfessional
                                  .isCheckedContract.value,
                              onChanged: (value) {
                                controllerMainProfessional
                                    .isCheckedContract.value = value ?? false;
                              },
                              activeColor: AppColors.primary,
                              side: BorderSide(
                                  color: AppColors.grey700,
                                  width: 1.5), // Changed checkbox border color
                            ),
                            Expanded(
                              child: Text(
                                tr(LanguageKeys.acceptTermsAndConditions),
                                style: const TextStyle(
                                    fontSize: 12, fontWeight: FontWeight.w500),
                              ),
                            ),
                          ],
                        )),
                    const SizedBox(height: 20),
// Action Buttons
                    Obx(() => Row(
                          children: [
                            Expanded(
                              child: SecondaryButton(
                                text: tr(LanguageKeys.cancel),
                                onPressed: () => Get.back(),
                                backgroundColor: Colors.transparent,
                                borderColor: AppColors.blackColor,
                                textColor: AppColors.blackColor,
                                fontWeight: FontWeight.w500,
                                borderRadius: 10,
                              ),
                            ),
                            SizedBox(
                                width: MediaQuery.of(context).size.width * 0.2),
                            Expanded(
                              child: PrimaryButton(
                                text: tr(LanguageKeys.accept),
                                onPressed: controllerMainProfessional
                                        .isCheckedContract.value
                                    ? () async {
                                        final data = controllerMainProfessional
                                            .dealDetailData.value.data;

                                        if (data != null) {
                                          String? id = data.id.toString();
                                          String? dealId = data.id.toString();
                                          String? sendLeadOut = "0";

                                          await controllerMainProfessional
                                              .acceptDeal(
                                            context,
                                            id: id,
                                            dealId: dealId,
                                            sendLeadOut: sendLeadOut,
                                          );

                                          Get.back();
                                        } else {
                                          CustomToast.show(
                                              context, 'Invalid deal data');
                                        }
                                      }
                                    : null,
                                backgroundColor: AppColors.primary,
                                textColor: AppColors.whiteColor,
                                fontWeight: FontWeight.w500,
                                borderRadius: 10,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                elevation: 2,
                              ),
                            ),
                          ],
                        )),
                  ],
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}
