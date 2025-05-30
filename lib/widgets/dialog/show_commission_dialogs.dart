import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:referaly/controller/controller_main_professional.dart';
import 'package:referaly/resources/app_assets.dart';
import 'package:referaly/resources/app_colors.dart';
import 'package:referaly/widgets/custom_toast_msg.dart';
import 'package:referaly/widgets/primary_button.dart';
import 'package:referaly/widgets/secondary_button_outline.dart';
import 'package:url_launcher/url_launcher.dart';

class ShowCommissionDialogs extends StatelessWidget {
  ShowCommissionDialogs({super.key});

  final controllerMainProfessional = Get.find<ControllerMainProfessional>();

  String? extractNameInBrackets(String? text) {
    if (text == null) return null;
    final regex = RegExp(r'\((.*?)\)');
    final match = regex.firstMatch(text);
    return match?.group(1);
  }

  @override
  Widget build(BuildContext context) {
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
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.circular(8), // set to 0 for sharp square
                      image: DecorationImage(
                        image: controllerMainProfessional.dealDetailData.value
                                        .data!.users![0].companyLogoUrl !=
                                    null &&
                                controllerMainProfessional.dealDetailData.value
                                    .data!.users![0].companyLogoUrl!
                                    .startsWith('http')
                            ? NetworkImage(controllerMainProfessional
                                .dealDetailData
                                .value
                                .data!
                                .users![0]
                                .companyLogoUrl!)
                            : const AssetImage(AppAssets.imgPerson)
                                as ImageProvider,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      controllerMainProfessional
                              .dealDetailData.value.data?.dealName ??
                          "-",
                      style: const TextStyle(
                          fontSize: 14, fontWeight: FontWeight.w600),
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
                          text: 'Business referrer name: ',
                          children: [
                            TextSpan(
                              text: extractNameInBrackets(
                                      controllerMainProfessional.dealDetailData
                                          .value.data?.dealName) ??
                                  "-",
                              style: TextStyle(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    /// Commission Fix
                    if (controllerMainProfessional
                            .dealDetailData.value.data?.commissionType ==
                        "fix_commission")
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text.rich(
                          TextSpan(
                            text: 'Commission fixe: ',
                            style: TextStyle(color: AppColors.grey700),
                            children: [
                              TextSpan(
                                //text: '50 €',
                                text:
                                    '${controllerMainProfessional.dealDetailData.value.data?.commissionValue} €',
                                style: TextStyle(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                        ),
                      )
                    else
                      /// Commission in percentage
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text.rich(
                          TextSpan(
                            text: 'Commission : ',
                            style: TextStyle(color: AppColors.grey700),
                            children: [
                              TextSpan(
                                //text: '50 €',
                                text:
                                    '${controllerMainProfessional.dealDetailData.value.data?.commissionValue} %',
                                style: TextStyle(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                        ),
                      ),

                    const SizedBox(height: 35),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: InkWell(
                        onTap: () async {
                          final urlString = controllerMainProfessional
                                  .dealDetailData.value.data?.documentUrl ??
                              '';
                          if (urlString.isNotEmpty) {
                            final url = Uri.parse(urlString);
                            if (await canLaunchUrl(url)) {
                              await launchUrl(url,
                                  mode: LaunchMode.externalApplication);
                            } else {
                              Get.snackbar('Error', 'Could not open the URL');
                            }
                          } else {
                            Get.snackbar('Info', 'Document URL not available');
                          }
                        },
                        child: Text(
                          'Click here to view the full contract',
                          style: TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w500,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ),
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
                            ),
                            const Expanded(
                              child: Text(
                                "I have read and accept the terms and conditions of the contract",
                                style: TextStyle(
                                    fontSize: 12, fontWeight: FontWeight.w500),
                              ),
                            ),
                          ],
                        )),
                    const SizedBox(height: 20),
                    Obx(() => Row(
                          children: [
                            Expanded(
                              child: SecondaryButton(
                                text: 'Cancel',
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
                                text: 'Accept',
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
