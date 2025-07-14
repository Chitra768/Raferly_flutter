import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:referaly/controller/controller_main_professional.dart';
import 'package:referaly/languages/languagekeys.dart';
import 'package:referaly/models/model_company_detail.dart';
import 'package:referaly/resources/app_assets.dart';
import 'package:referaly/resources/app_colors.dart';
import 'package:referaly/resources/text_style.dart';
import 'package:referaly/utils/translations.dart';
import 'package:referaly/widgets/custom_toast_msg.dart';
import 'package:referaly/widgets/primary_button.dart';
import 'package:referaly/widgets/secondary_button_outline.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
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

  void openPdfBottomSheet(BuildContext context, String pdfUrl) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: [
              // Header
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                  color: Colors.white,
                  boxShadow: [BoxShadow(blurRadius: 4, color: Colors.black12)],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    )
                  ],
                ),
              ),
              // PDF Viewer
              const Divider(height: 1),
              Expanded(
                child: SfPdfViewer.network(pdfUrl),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    String? maxCommissionValue;
    String? maxCommissionType;

    if (data?.dealCommissionType == 2 && (data?.dealCases?.length ?? 0) > 1) {
      final eligibleCases = data!.dealCases!
          .where((e) =>
              e.commissionType == "percentage_commission" ||
              e.commissionType == "fix_commission")
          .toList();

      if (eligibleCases.isNotEmpty) {
        // Separate percentage and fixed commissions
        final percentageCases = eligibleCases
            .where((e) => e.commissionType == "percentage_commission")
            .toList();
        final fixedCases = eligibleCases
            .where((e) => e.commissionType == "fix_commission")
            .toList();

        // If we have percentage commissions, prioritize them
        if (percentageCases.isNotEmpty) {
          // Sort percentage cases by value (highest first)
          percentageCases.sort((a, b) {
            double aVal =
                double.tryParse(a.commissionValue.toString() ?? '0') ?? 0;
            double bVal =
                double.tryParse(b.commissionValue.toString() ?? '0') ?? 0;
            return bVal.compareTo(aVal);
          });

          maxCommissionValue = percentageCases.first.commissionValue.toString();
          maxCommissionType = percentageCases.first.commissionType;
        } else if (fixedCases.isNotEmpty) {
          // If no percentage commissions, use the highest fixed commission
          fixedCases.sort((a, b) {
            double aVal =
                double.tryParse(a.commissionValue.toString() ?? '0') ?? 0;
            double bVal =
                double.tryParse(b.commissionValue.toString() ?? '0') ?? 0;
            return bVal.compareTo(aVal);
          });

          maxCommissionValue = fixedCases.first.commissionValue.toString();
          maxCommissionType = fixedCases.first.commissionType;
        }

        print("maxCommissionValue: $maxCommissionValue");
        print("maxCommissionType: $maxCommissionType");
      }
    }

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
                    ),
                    child: Image.network(
                      controllerMainProfessional
                              .dealDetailData.value.data?.companyLogoUrl ??
                          "",
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start, // Align text to the start
                      children: [
                        Text(
                          controllerMainProfessional
                                  .dealDetailData.value.data?.companyName ??
                              "-", // Hardcoded as per image
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600, // Adjusted font weight
                          ),
                        ),
                        // Text(
                        //   controllerMainProfessional
                        //       .dealDetailData.value.data?.dealName ??
                        //       "-",
                        //   style: stylePoppins(
                        //       fontSize: 16.sp, // Adjusted font size
                        //       fontWeight: FontWeight.w600),
                        // ),
                      ],
                    ),
                  ),
                ],
              ),
              data?.commissionType != "no_commission" &&
                      data?.commissionType != "null"
                  ? const SizedBox(height: 15)
                  : const SizedBox.shrink(),
              // if (data?.commissionType != "no_commission" &&
              //     data?.commissionType != "null" &&
              //     data?.commissionType != null)
              //   Align(
              //     alignment: Alignment.centerLeft,
              //     child: Text.rich(
              //       TextSpan(
              //         text:
              //             '${tr(LanguageKeys.businessReferrerName)}  ', // Updated text
              //         children: [
              //           TextSpan(
              //             text: "",
              //             style: stylePoppins(
              //                 color: AppColors.primary,
              //                 fontSize: 16.sp,
              //                 fontWeight: FontWeight.w500),
              //           ),
              //         ],
              //       ),
              //     ),
              //   ),
              // const SizedBox.shrink(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 0),
                child: Column(
                  children: [
                    const SizedBox(height: 15),

                    if (data?.dealCommissionType == 2 &&
                        (data?.dealCases?.isNotEmpty == true &&
                            data?.dealCases?.first.commissionType !=
                                "no_commission"))
                      // 🌟 Show max commission when deal type = 2 and multiple cases
                      if (maxCommissionValue != null &&
                          maxCommissionType != null)
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text.rich(
                            TextSpan(
                              text: '${tr(LanguageKeys.upTo)} : ',
                              style: TextStyle(color: AppColors.grey700),
                              children: [
                                TextSpan(
                                  text:
                                      '$maxCommissionValue ${maxCommissionType == "fix_commission" ? "€" : "%"}',
                                  style: const TextStyle(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                    data?.dealCommissionType == 2 &&
                            (data?.dealCases?.isNotEmpty == true &&
                                data?.dealCases?.first.commissionType !=
                                    "no_commission" &&
                                (data?.dealCases?.length ?? 0) >= 1)
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const SizedBox(height: 5),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text.rich(
                                  TextSpan(
                                    text: tr(LanguageKeys.theDetailsOfTheDeal),
                                    style: stylePoppins(
                                        color: AppColors.grey700,
                                        fontWeight: FontWeight.w400),
                                  ),
                                ),
                              ),
                            ],
                          )
                        : const SizedBox.shrink(),

                    /// Commission Fix
                    if (data?.commissionType == "fix_commission" &&
                        data?.dealCommissionType == 1)
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text.rich(
                          TextSpan(
                            text: '${tr(LanguageKeys.fix_commission)} : ',
                            style: TextStyle(color: AppColors.grey700),
                            children: [
                              TextSpan(
                                text:
                                    '${controllerMainProfessional.dealDetailData.value.data?.commissionValue} €',
                                style: const TextStyle(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )

                    /// Commission Fix
                    else if (data?.commissionType == "percentage_commission" &&
                        data?.dealCommissionType == 1)
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text.rich(
                          TextSpan(
                            text:
                                '${tr(LanguageKeys.percentage_commission)} : ',
                            style: TextStyle(color: AppColors.grey700),
                            children: [
                              TextSpan(
                                text:
                                    '${controllerMainProfessional.dealDetailData.value.data?.commissionValue} %',
                                style: const TextStyle(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    else if ((data?.commissionType == "no_commission" &&
                            data?.dealCommissionType == 1) ||
                        (data?.dealCases?.first.commissionType ==
                                "no_commission" &&
                            data?.dealCommissionType == 2))

                      /// Commission in no commission
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            tr(LanguageKeys.forYou),
                            style: stylePoppins(
                                color: AppColors.blackColor,
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w500),
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text.rich(
                              TextSpan(
                                text: tr(LanguageKeys.byRecommendingThis),
                                style: stylePoppins(
                                    color: AppColors.primary,
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                          ),
                        ],
                      )
                    else
                      const SizedBox.shrink(),
                    // data?.commissionType != "no_commission" &&
                    data?.dealCommissionType == 1 ||
                            data?.dealCommissionType == 2
                        ? const SizedBox(height: 35)
                        : const SizedBox.shrink(),
                    // data?.commissionType != "no_commission" &&
                    data?.dealCommissionType == 1 ||
                            data?.dealCommissionType == 2
                        ? Align(
                            alignment: Alignment.centerLeft,
                            child: InkWell(
                              onTap: () async {
                                final urlString = data?.documentUrl ?? '';
                                openPdfBottomSheet(context, urlString);
                              },
                              child: Text(
                                tr(LanguageKeys.clickHereToViewFull),
                                style: const TextStyle(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w500,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                          )
                        : const SizedBox.shrink(),
                    // data?.commissionType != "no_commission" &&
                    data?.dealCommissionType == 1 ||
                            data?.dealCommissionType == 2
                        ? const SizedBox(height: 12)
                        : const SizedBox.shrink(),
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
                                style: const TextStyle(
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
