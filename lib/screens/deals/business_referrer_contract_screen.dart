import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:referaly/controller/business_referrer_contract_controller.dart'
    show BusinessReferrerContractController;
import 'package:referaly/languages/languagekeys.dart';
import 'package:referaly/resources/app_assets.dart';
import 'package:referaly/resources/app_colors.dart';
import 'package:referaly/resources/app_helper.dart';
import 'package:referaly/resources/text_style.dart';
import 'package:referaly/utils/translations.dart';
import 'package:referaly/widgets/dialog/send_contact_dialog.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';

class BusinessReferrerContractScreen extends StatefulWidget {
  static String pageId = "/businessReferrerContract";

  const BusinessReferrerContractScreen({super.key});

  @override
  State<BusinessReferrerContractScreen> createState() =>
      _BusinessReferrerContractScreenState();
}

class _BusinessReferrerContractScreenState
    extends State<BusinessReferrerContractScreen> {
  late BusinessReferrerContractController controller;
  final List<String> commissionOptions = [
    tr(LanguageKeys.no_commission),
    tr(LanguageKeys.fix_commission),
    tr(LanguageKeys.percentage_commission)
  ];
  List<Map<String, dynamic>> cases = [
    {"leadType": TextEditingController(), "commissionShared": null}
  ];

  @override
  void initState() {
    super.initState();
    controller = Get.put(BusinessReferrerContractController());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        title: Text(
          controller.dealId.value.isNotEmpty
              ? tr(LanguageKeys.editDeal)
              : tr(LanguageKeys.new_deal),
          style: stylePoppins(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildDealNameField(),
                const SizedBox(height: 20),
                buildSegmentControl(),
                const SizedBox(height: 8),
                buildCommissionInfo(),
                const SizedBox(height: 20),
                buildCommissionSharedDropdown(),
                const SizedBox(height: 20),
                buildContractSection(),
                const SizedBox(height: 20),
                buildTrackNameSection(),
                const SizedBox(height: 20),
                buildStageItems(),
                const SizedBox(height: 20),
                buildAddNewButton(),
                const SizedBox(height: 16),
                buildSubmitButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildDealNameField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          tr(LanguageKeys.nameOfDeal),
          style: stylePoppins(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller.dealNameController,
          decoration: InputDecoration(
            hintText: tr(LanguageKeys.enterDealName),
            hintStyle: stylePoppins(color: Colors.grey, fontSize: 14),
            filled: true,
            fillColor: Colors.grey[200],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          ),
        ),
      ],
    );
  }

  Widget buildSegmentControl() {
    return Obx(() => Container(
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              segmentItem(
                  title: tr(LanguageKeys.uniqueCommision),
                  isSelected: controller.isUniqueCommission.value),
              segmentItem(
                  title: tr(LanguageKeys.differentCommision),
                  isSelected: !controller.isUniqueCommission.value,
                  isFirst: false),
            ],
          ),
        ));
  }

  Expanded segmentItem(
      {required String title, required bool isSelected, bool isFirst = true}) {
    return Expanded(
      child: GestureDetector(
        onTap: () => controller.toggleCommissionType(isFirst),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 15),
          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary : AppColors.transparent,
            borderRadius: BorderRadius.circular(15),
          ),
          alignment: Alignment.center,
          child: Text(
            title,
            style: stylePoppins(
              fontSize: 13,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              color: isSelected ? Colors.white : Colors.grey,
            ),
          ),
        ),
      ),
    );
  }

  Widget buildCommissionInfo() {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline, size: 18, color: AppColors.primary),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              tr(LanguageKeys.itWillSpecified),
              style: stylePoppins(
                fontSize: 12,
                color: AppColors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildCommissionSharedDropdown() {
    return Obx(() {
      if (controller.isUniqueCommission.value) {
        // OLD UI for Unique Commission
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              tr(LanguageKeys.commissionShared),
              style: stylePoppins(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: DropdownButtonFormField<String>(
                value: controller.selectedCommissionOption.value !=
                        tr(LanguageKeys.chooseOneoption)
                    ? controller.selectedCommissionOption.value
                    : null,
                icon: const Icon(Icons.keyboard_arrow_down),
                decoration: const InputDecoration(
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  border: InputBorder.none,
                ),
                dropdownColor: Colors.white,
                hint: Text(tr(LanguageKeys.chooseOneoption),
                    style: stylePoppins(fontSize: 11)),
                style: stylePoppins(fontSize: 14, color: Colors.grey[600]),
                onChanged: (value) {
                  if (value != null) {
                    controller.setCommissionOption(value);
                    controller.update();
                  }
                },
                items: commissionOptions
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 10),
            Obx(() {
              if (controller.selectedCommissionOption.value ==
                      tr(LanguageKeys.fix_commission) ||
                  controller.selectedCommissionOption.value ==
                      tr(LanguageKeys.percentage_commission)) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),
                    Text(
                      tr(LanguageKeys.commisionValue),
                      style: stylePoppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: controller.commissionValueController,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.grey[100],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        hintText: 'Enter Commission Value',
                        suffixIcon: controller.selectedCommissionOption.value ==
                                tr(LanguageKeys.fix_commission)
                            ? Padding(
                                padding: const EdgeInsets.all(12.0),
                                child:
                                    Text('€', style: TextStyle(fontSize: 18)),
                              )
                            : Padding(
                                padding: const EdgeInsets.all(12.0),
                                child:
                                    Text('%', style: TextStyle(fontSize: 18)),
                              ),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ],
                );
              }
              return SizedBox.shrink();
            }),
          ],
        );
      } else {
        // NEW UI for Different Commissions
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ...List.generate(cases.length, (index) {
              return Container(
                margin: EdgeInsets.only(bottom: 16),
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Color(0xFFF8F8F8),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Stack(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(tr(LanguageKeys.leadType),
                            style: stylePoppins(fontWeight: FontWeight.w500)),
                        SizedBox(height: 8),
                        TextField(
                          controller: cases[index]["leadType"],
                          style: stylePoppins(fontSize: 14),
                          decoration: InputDecoration(
                            hintText: tr(LanguageKeys.enterLeadType),
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 16, vertical: 12),
                          ),
                        ),
                        SizedBox(height: 16),
                        const SizedBox(height: 8),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: DropdownButtonFormField<String>(
                            value: controller.selectedCommissionOption.value !=
                                    tr(LanguageKeys.chooseOneoption)
                                ? controller.selectedCommissionOption.value
                                : null,
                            icon: const Icon(Icons.keyboard_arrow_down),
                            decoration: const InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                              border: InputBorder.none,
                            ),
                            dropdownColor: Colors.white,
                            hint: Text(tr(LanguageKeys.chooseOneoption),
                                style: stylePoppins(fontSize: 11)),
                            style: stylePoppins(
                                fontSize: 14, color: Colors.grey[600]),
                            onChanged: (value) {
                              if (value != null) {
                                controller.setCommissionOption(value);
                                controller.update();
                              }
                            },
                            items: commissionOptions
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Obx(() {
                          if (controller.selectedCommissionOption.value ==
                                  tr(LanguageKeys.fix_commission) ||
                              controller.selectedCommissionOption.value ==
                                  tr(LanguageKeys.percentage_commission)) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 16),
                                Text(
                                  tr(LanguageKeys.commisionValue),
                                  style: stylePoppins(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500),
                                ),
                                const SizedBox(height: 8),
                                TextFormField(
                                  controller:
                                      controller.commissionValueController,
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Colors.grey[100],
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide.none,
                                    ),
                                    hintText: 'Enter Commission Value',
                                    hintStyle: stylePoppins(fontSize: 14),
                                    suffixIcon: controller
                                                .selectedCommissionOption
                                                .value ==
                                            tr(LanguageKeys.fix_commission)
                                        ? Padding(
                                            padding: const EdgeInsets.all(11.0),
                                            child: Text('€',
                                                style: TextStyle(fontSize: 16)),
                                          )
                                        : Padding(
                                            padding: const EdgeInsets.all(11.0),
                                            child: Text('%',
                                                style: TextStyle(fontSize: 16)),
                                          ),
                                  ),
                                  keyboardType: TextInputType.number,
                                ),
                              ],
                            );
                          }
                          return SizedBox.shrink();
                        }),
                      ],
                    ),
                    if (cases.length > 1)
                      Positioned(
                        top: 0,
                        right: 0,
                        child: GestureDetector(
                          onTap: () => removeCase(index),
                          child: Image.asset(
                            AppAssets.imgDeleteicon,
                            color: Color(0xFF8E2DE2),
                          ),
                        ),
                      ),
                  ],
                ),
              );
            }),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: addCase,
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: Color(0xFF8E2DE2)),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                child: Text(
                  tr(LanguageKeys.addCase),
                  style: stylePoppins(
                    color: Color(0xFF8E2DE2),
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
        );
      }
    });
  }

  Widget buildContractSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              "Contract",
              style: stylePoppins(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(width: 5),
            Text(
              "*",
              style: stylePoppins(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.red,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Obx(() => Column(
              children: [
                buildContractOption(
                  title: tr(LanguageKeys.generateContract),
                  isSelected: controller.isGenerateContract.value,
                  onTap: () => controller.toggleContractGeneration(true),
                ),
                const SizedBox(height: 8),
                buildContractOption(
                  title: tr(LanguageKeys.uploadYourOwn),
                  isSelected: !controller.isGenerateContract.value,
                  onTap: () => controller.toggleContractGeneration(false),
                  isUploadFile: true,
                ),
              ],
            )),
      ],
    );
  }

  Widget buildContractOption({
    required String title,
    required bool isSelected,
    required VoidCallback onTap,
    bool isUploadFile = false,
  }) {
    return Row(
      children: [
        GestureDetector(
          onTap: onTap,
          child: Radio(
            value: true,
            groupValue: isSelected,
            onChanged: (_) => onTap(),
            activeColor: AppColors.primary,
          ),
        ),
        if (!isUploadFile)
          Expanded(
            child: Text(
              title,
              style: stylePoppins(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        if (!isUploadFile)
          GestureDetector(
            onTap: () async {
              final url =
                  'https://refearly-back.developmentlabs.co/sample-document/Different-Commissions-Sample-es.pdf';
              controller.downloadAndOpenPdf(url);
            },
            child: Row(
              children: [
                Text(
                  tr(LanguageKeys.clickHere),
                  style: stylePoppins(
                    fontSize: 14,
                    color: AppColors.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(width: 4),
                Transform.rotate(
                  angle: -(3.14 / 4),
                  child: Icon(
                    Icons.arrow_forward,
                    size: 16,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ),
        if (isUploadFile)
          GestureDetector(
            onTap: () {
              final url =
                  'https://refearly-back.developmentlabs.co/sample-document/Different-Commissions-Sample-es.pdf';
              controller.downloadAndOpenPdf(url);
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(Icons.upload_file, size: 20),
                  const SizedBox(width: 5),
                  Text(
                    tr(LanguageKeys.uploadYourOwn),
                    style: stylePoppins(fontSize: 12),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  Widget buildTrackNameSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          tr(LanguageKeys.trackName),
          style: stylePoppins(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        GestureDetector(
          onTap: () {},
          child: Icon(
            Icons.info_outline,
            color: AppColors.primary,
          ),
        ),
      ],
    );
  }

  Widget buildStageItems() {
    return Obx(() => Column(
          children: [
            ListView.separated(
              physics: const NeverScrollableScrollPhysics(),
              itemCount: controller.dynamicFields.length,
              shrinkWrap: true,
              separatorBuilder: (context, index) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                return buildStageItem(
                  controller: controller.dynamicFields[index],
                  hintText: tr(LanguageKeys.enterTrackName),
                  showDelete: index != 0,
                  onTap: () => controller.removeDynamicField(index),
                );
              },
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 8, top: 10),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              alignment: Alignment.centerLeft,
              child: Text(
                "Commission Paid",
                style: stylePoppins(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ));
  }

  Widget buildStageItem({
    required TextEditingController controller,
    required String hintText,
    required bool showDelete,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: TextFormField(
              controller: controller,
              decoration: InputDecoration(
                isDense: true,
                contentPadding: EdgeInsets.zero,
                hintText: hintText,
                hintStyle: stylePoppins(color: Colors.grey, fontSize: 14),
                border: InputBorder.none,
              ),
            ),
          ),
          if (showDelete)
            GestureDetector(
              onTap: onTap,
              child: Padding(
                padding: const EdgeInsets.all(2),
                child: Image.asset(
                  AppAssets.imgDeleteicon,
                  color: AppColors.primary,
                ),
              ),
            )
        ],
      ),
    );
  }

  Widget buildAddNewButton() {
    return GestureDetector(
      onTap: () {
        controller.addDynamicField();
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.primary),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.add,
              color: AppColors.primary,
            ),
            const SizedBox(width: 8),
            Text(
              tr(LanguageKeys.addnew),
              style: stylePoppins(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: AppColors.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildSubmitButton() {
    return GestureDetector(
      onTap: () {
        controller.submitDeal();
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Obx(
            () => controller.isLoading.value
                ? const CircularProgressIndicator(
                    color: Colors.white,
                  )
                : Text(
                    controller.dealId.value.isNotEmpty
                        ? tr(LanguageKeys.updateDeal)
                        : tr(LanguageKeys.submitDeal),
                    style: stylePoppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
          ),
        ),
      ),
    );
  }

  Widget _buildInviteOption({
    required String iconPath,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 120,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4)
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(iconPath, width: 48, height: 48),
            const SizedBox(height: 8),
            Text(
              label,
              style: stylePoppins(fontSize: 12),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  void addCase() {
    setState(() {
      cases
          .add({"leadType": TextEditingController(), "commissionShared": null});
    });
  }

  void removeCase(int index) {
    setState(() {
      cases.removeAt(index);
    });
  }
}
