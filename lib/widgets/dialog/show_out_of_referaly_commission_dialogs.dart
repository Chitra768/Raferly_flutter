import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:referaly/controller/controller_main_professional.dart';
import 'package:referaly/languages/languagekeys.dart';
import 'package:referaly/models/model_company_detail.dart';
import 'package:referaly/resources/app_colors.dart';
import 'package:referaly/resources/text_style.dart';
import 'package:referaly/utils/translations.dart';
import 'package:referaly/widgets/custom_toast_msg.dart';
import 'package:referaly/widgets/primary_button.dart';
import 'package:referaly/widgets/secondary_button_outline.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class ShowOutOfReferalyCommissionDialogs extends StatelessWidget {
  final DealDetailData? data;
  ShowOutOfReferalyCommissionDialogs(this.data, {super.key});

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
    final users = data?.users;
    final logoUrl =
        users != null && users.isNotEmpty ? users[0].companyLogoUrl : null;

    return Dialog(
      backgroundColor: Colors.white, // White background
      insetPadding: const EdgeInsets.all(16),
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
                    ),
                    child: Image.network(
                      data?.companyLogoUrl ?? "",
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
                          data?.companyName ?? "-", // Hardcoded as per image
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600, // Adjusted font weight
                          ),
                        ),
                        Text(
                          data?.dealName ?? "-",
                          style: stylePoppins(
                              fontSize: 16.sp, // Adjusted font size
                              fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              // data?.commissionType != "no_commission"
              //     ?
              Align(
                alignment: Alignment.centerLeft,
                child: Text.rich(
                  TextSpan(
                    text:
                        '${tr(LanguageKeys.businessReferrerName)}  ', // Updated text
                    children: [
                      TextSpan(
                        text: data?.dealName,
                        style: stylePoppins(
                            color: AppColors.primary,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
              ),
              // : const SizedBox.shrink(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2),
                child: Column(
                  children: [
                    const SizedBox(height: 15),

                    /// Commission Fix
                    if (data?.commissionType == "fix_commission")
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text.rich(
                          TextSpan(
                            text: '${tr(LanguageKeys.fix_commission)} : ',
                            style: TextStyle(color: AppColors.grey700),
                            children: [
                              TextSpan(
                                text: '${data?.commissionValue} €',
                                style: TextStyle(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )

                    /// Commission Fix
                    else if (data?.commissionType == "percentage_commission")
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
                                    '${data?.commissionValue} %',
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

                      /// Commission in no commission
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text.rich(
                          TextSpan(
                            text:
                                '${tr(LanguageKeys.businessIntroduce)}', // Colon added here
                            style: stylePoppins(
                                color: AppColors.primary,
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                      ),

                    data?.commissionType != "no_commission"
                        ? const SizedBox(height: 35)
                        : const SizedBox.shrink(),
                    data?.commissionType != "no_commission"
                        ? Align(
                            alignment: Alignment.centerLeft,
                            child: InkWell(
                              onTap: () async {
                                final urlString = data
                                        ?.documentUrl ??
                                    '';
                                openPdfBottomSheet(context, urlString);
                              },
                              child: Obx(
                                () => Text(
                                  tr(LanguageKeys.clickHereToViewFull),
                                  style: TextStyle(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.w500,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ),
                            ),
                          )
                        : const SizedBox.shrink(),
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
                                        final datas = data;

                                        if (datas != null) {
                                          String? id = datas.id.toString();
                                          String? dealId = datas.id.toString();

                                          await controllerMainProfessional
                                              .acceptDeal(
                                            context,
                                            id: id,
                                            dealId: dealId,
                                            sendLeadOut:
                                                datas.sendLeadOut.toString(),
                                            createdBy:
                                                datas.createdBy.toString(),
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
