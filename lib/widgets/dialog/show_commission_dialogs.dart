import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:referaly/controller/controller_main_professional.dart';
import 'package:referaly/languages/languagekeys.dart';
import 'package:referaly/models/model_company_detail.dart';
import 'package:referaly/resources/app_assets.dart';
import 'package:referaly/resources/app_colors.dart';
import 'package:referaly/utils/translations.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

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
      enableDrag: false,
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
            double aVal = double.tryParse(a.commissionValue.toString()) ?? 0;
            double bVal = double.tryParse(b.commissionValue.toString()) ?? 0;
            return bVal.compareTo(aVal);
          });

          maxCommissionValue = percentageCases.first.commissionValue.toString();
          maxCommissionType = percentageCases.first.commissionType;
        } else if (fixedCases.isNotEmpty) {
          // If no percentage commissions, use the highest fixed commission
          fixedCases.sort((a, b) {
            double aVal = double.tryParse(a.commissionValue.toString()) ?? 0;
            double bVal = double.tryParse(b.commissionValue.toString()) ?? 0;
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
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      backgroundColor: Colors.transparent,
      child: Center(
        child: Container(
          constraints: BoxConstraints(
            maxWidth: 400,
            maxHeight: MediaQuery.of(context).size.height * 0.9,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Purple Header Section
              Container(
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                ),
                child: Column(
                  children: [
                    // Close button
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        GestureDetector(
                          onTap: () => Get.back(),
                          child: const Icon(
                            Icons.close,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                      ],
                    ),
                    // Handshake icon
                    SvgPicture.asset(AppAssets.imgHandshake, height: 30),
                    // Partnership Invitation text
                    Text(
                      tr(LanguageKeys.partnership),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5,
                      ),
                    ),
                    Text(
                      tr(LanguageKeys.invitation),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),

              // White Content Section
              Flexible(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Company Name and Tagline
                      Text(
                        data?.companyName ?? "",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF2D2D2D),
                          letterSpacing: 0.3,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        data?.dealName ??
                            "", // You can make this dynamic if needed
                        style: const TextStyle(
                          fontSize: 13,
                          color: Color(0xFF666666),
                          fontWeight: FontWeight.w400,
                          letterSpacing: 0.2,
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Commission Rate Section
                      Container(
                        alignment: Alignment.center,
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFAF5FF), // Light purple
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              tr(LanguageKeys.commissionRate),
                              style: const TextStyle(
                                fontSize: 12,
                                color: Color(0xFF666666),
                                fontWeight: FontWeight.w500,
                                letterSpacing: 0.2,
                              ),
                            ),
                            const SizedBox(height: 6),
                            data?.commissionType != "no_commission"
                                ? Text(
                                    '${data?.commissionValue ?? maxCommissionValue ?? ""} ${data?.commissionType == "percentage_commission" ? "%" : data?.commissionType == "fix_commission" ? "€" : ""}',
                                    style: const TextStyle(
                                      fontSize: 28,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.primary,
                                      letterSpacing: 0.5,
                                    ),
                                  )
                                : const SizedBox.shrink(),
                            const SizedBox(height: 6),
                            Text(
                              tr(LanguageKeys.withoutVATOfTheAmountInvoiced),
                              style: const TextStyle(
                                fontSize: 11,
                                color: Color(0xFF999999),
                                fontWeight: FontWeight.w400,
                                letterSpacing: 0.1,
                              ),
                            ),
                            Text(
                              tr(LanguageKeys.perSuccessfulReferral),
                              style: const TextStyle(
                                fontSize: 11,
                                color: Color(0xFF999999),
                                fontWeight: FontWeight.w400,
                                letterSpacing: 0.1,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Referral Agreement Section
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF9FAFB),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: const Color(0xFFE5E7EB),
                            width: 1,
                          ),
                        ),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                SvgPicture.asset(
                                  AppAssets.imgDocumentContract,
                                  width: 20,
                                  height: 20,
                                  color: AppColors.primary,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  tr(LanguageKeys.referralAgreement),
                                  style: const TextStyle(
                                    fontSize: 13,
                                    color: Color(0xFF2D2D2D),
                                    fontWeight: FontWeight.w500,
                                    letterSpacing: 0.2,
                                  ),
                                ),
                                const Spacer(),
                                GestureDetector(
                                  onTap: () async {
                                    final urlString = data?.documentUrl ?? '';
                                    if (urlString.isNotEmpty) {
                                      openPdfBottomSheet(context, urlString);
                                    }
                                  },
                                  child: Row(
                                    children: [
                                      Text(
                                        tr(LanguageKeys.view),
                                        style: const TextStyle(
                                          fontSize: 13,
                                          color: AppColors.primary,
                                          fontWeight: FontWeight.w500,
                                          letterSpacing: 0.2,
                                        ),
                                      ),
                                      const Icon(
                                        Icons.open_in_new,
                                        color: AppColors.primary,
                                        size: 16,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Terms and Conditions Checkbox
                      Obx(() => Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Checkbox(
                                value: controllerMainProfessional
                                    .isCheckedContract.value,
                                onChanged: (value) {
                                  controllerMainProfessional
                                      .isCheckedContract.value = value ?? false;
                                },
                                activeColor: AppColors.primary,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 12),
                                  child: Text(
                                    tr(LanguageKeys
                                        .iAcceptTheTermsAndConditionsOfTheReferralPartnershipAgreementAndUnderstandTheCommissionStructure),
                                    style: const TextStyle(
                                      fontSize: 11,
                                      color: Color(0xFF666666),
                                      fontWeight: FontWeight.w400,
                                      letterSpacing: 0.1,
                                      height: 1.3,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )),

                      const SizedBox(height: 20),

                      // Action Buttons
                      Obx(() => Column(
                            children: [
                              // Accept Partnership Button
                              SizedBox(
                                width: double.infinity,
                                height: 48,
                                child: ElevatedButton(
                                  onPressed: () async {
                                    if (controllerMainProfessional
                                        .isCheckedContract.value) {
                                      final dealData = data;
                                      if (dealData != null) {
                                        String? id = dealData.id.toString();
                                        String? dealId = dealData.id.toString();

                                        await controllerMainProfessional
                                            .acceptDeal(
                                          context,
                                          id: id,
                                          dealId: dealId,
                                          sendLeadOut:
                                              data?.sendLeadOut.toString(),
                                          createdBy: data?.createdBy.toString(),
                                        );
                                      }
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: controllerMainProfessional
                                            .isCheckedContract.value
                                        ? AppColors.primary
                                        : AppColors.primary.withOpacity(0.3),
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    elevation: 0,
                                  ),
                                  child: Text(
                                    tr(LanguageKeys.acceptPartnership),
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: 0.3,
                                    ),
                                  ),
                                ),
                              ),

                              const SizedBox(height: 12),

                              // Decline Button
                              SizedBox(
                                width: double.infinity,
                                height: 48,
                                child: ElevatedButton(
                                  onPressed: () => Get.back(),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFFF5F5F5),
                                    foregroundColor: const Color(0xFF666666),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    elevation: 0,
                                  ),
                                  child: Text(
                                    tr(LanguageKeys.decline),
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: 0.3,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
