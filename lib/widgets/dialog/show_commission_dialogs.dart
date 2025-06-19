import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:referaly/controller/controller_main_professional.dart';
import 'package:referaly/languages/languagekeys.dart';
import 'package:referaly/models/model_company_detail.dart';
import 'package:referaly/resources/app_assets.dart';
import 'package:referaly/resources/app_colors.dart';
import 'package:referaly/utils/translations.dart';
import 'package:referaly/widgets/custom_toast_msg.dart';
import 'package:referaly/widgets/primary_button.dart';
import 'package:referaly/widgets/secondary_button_outline.dart';
import 'package:url_launcher/url_launcher.dart';

class ShowCommissionDialogs extends StatelessWidget {
  final DealDetailData? data;
  ShowCommissionDialogs(this.data, {super.key});

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
      insetPadding: const EdgeInsets.all(16),
      backgroundColor: Colors.white, // White background
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
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
                        image: (data?.users?.isNotEmpty == true &&
                                data?.users?[0].companyLogoUrl != null &&
                                data!.users![0].companyLogoUrl!
                                    .startsWith('http'))
                            ? NetworkImage(data!.users![0].companyLogoUrl!)
                            : const AssetImage(AppAssets.imgPerson)
                                as ImageProvider,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      data?.dealName ?? "-",
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
                    // Align(
                    //   alignment: Alignment.centerLeft,
                    //   child: Text.rich(
                    //     TextSpan(
                    //       text: 'Business referrer name: ',
                    //       children: [
                    //         TextSpan(
                    //           text:
                    //               extractNameInBrackets(data?.dealName) ?? "-",
                    //           style: TextStyle(
                    //             color: AppColors.primary,
                    //             fontWeight: FontWeight.w500,
                    //           ),
                    //         ),
                    //       ],
                    //     ),
                    //   ),
                    // ),
                    // const SizedBox(height: 20),

                    /// Commission Fix
                    if (data?.commissionType == "fix_commission")
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text.rich(
                          TextSpan(
                            text: tr(LanguageKeys.commissionFix),
                            style: TextStyle(color: AppColors.grey700),
                            children: [
                              TextSpan(
                                text: '${data?.commissionValue ?? 0} €',
                                style: TextStyle(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w500,
                                ),
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
                            text: tr(LanguageKeys.commissionFix),
                            style: TextStyle(color: AppColors.grey700),
                            children: [
                              TextSpan(
                                text: '${data?.commissionValue ?? 0} %',
                                style: TextStyle(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w500,
                                ),
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
                          final urlString = data?.documentUrl ?? '';
                          if (urlString.isNotEmpty) {
                            final url = Uri.parse("https://docs.google.com/gview?embedded=true&url="+urlString);
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
                          tr(LanguageKeys.clickHereToViewFull),
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
                            Expanded(
                              child: Text(
                                tr(LanguageKeys.iHaveRead),
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
                                        final dealData =
                                            controllerMainProfessional
                                                .dealDetailData.value.data;
                                        if (dealData != null) {
                                          String? id = dealData.id.toString();
                                          String? dealId =
                                              dealData.id.toString();

                                          await controllerMainProfessional
                                              .acceptDeal(
                                            context,
                                            id: id,
                                            dealId: dealId,
                                            sendLeadOut:
                                                data?.sendLeadOut.toString(),
                                            createdBy:
                                                data?.createdBy.toString(),
                                          );
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
          )),
    );
  }
}
