import 'dart:io';

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
import 'package:referaly/widgets/logo_loader.dart';
import 'package:image_picker/image_picker.dart';

import '../../resources/app_preference.dart';
import '../../widgets/dialog/premium_upgrade_dialog.dart';
import '../dashboard/membership_screen.dart';

class BusinessReferrerContractScreen extends StatefulWidget {
  static String pageId = "/businessReferrerContract";

  const BusinessReferrerContractScreen({super.key});

  @override
  State<BusinessReferrerContractScreen> createState() =>
      _BusinessReferrerContractScreenState();
}

class _BusinessReferrerContractScreenState
    extends State<BusinessReferrerContractScreen> {
  late BusinessReferrerContractController controller =
      Get.put(BusinessReferrerContractController());
  final List<String> commissionOptions = [
    tr(LanguageKeys.no_commission),
    tr(LanguageKeys.fix_commission),
    tr(LanguageKeys.percentage_commission)
  ];

  // Add persistent controllers for different commission controller.cases
  List<TextEditingController> leadTypeControllers = [];
  List<TextEditingController> commissionValueControllers = [];

  @override
  void initState() {
    super.initState();
    // Initialize controllers for the first case
    _initializeControllers();
  }

  void _initializeControllers() {
    // Clear existing controllers
    for (var controller in leadTypeControllers) {
      controller.dispose();
    }
    for (var controller in commissionValueControllers) {
      controller.dispose();
    }

    leadTypeControllers.clear();
    commissionValueControllers.clear();

    // Create controllers for each case
    for (int i = 0; i < controller.cases.length; i++) {
      final leadController =
          TextEditingController(text: controller.cases[i]["lead_type"]);
      final commissionController =
          TextEditingController(text: controller.cases[i]["commission_value"]);

      // Add listeners to keep controller.cases data in sync
      leadController.addListener(() {
        if (i < controller.cases.length) {
          controller.cases[i]["lead_type"] = leadController.text;
        }
      });

      commissionController.addListener(() {
        if (i < controller.cases.length) {
          controller.cases[i]["commission_value"] = commissionController.text;
        }
      });

      leadTypeControllers.add(leadController);
      commissionValueControllers.add(commissionController);
    }
  }

  @override
  void dispose() {
    // Dispose controllers
    for (var controller in leadTypeControllers) {
      controller.dispose();
    }
    for (var controller in commissionValueControllers) {
      controller.dispose();
    }
    super.dispose();
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
        actions: [
          IconButton(
            onPressed: () async {
              // TODO: Implement share functionality
              // Add your delete logic here
              if (controller.dealId.value.isNotEmpty) {
                await controller.deleteContract(controller.dealId.value);
              }
            },
            icon: const Icon(Icons.delete),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildProgramTypeDropdown(),
                if (controller.selectedProgramType ==
                    tr(LanguageKeys.writeACustomName)) ...[
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: controller.dealNameController,
                    readOnly:
                        controller.isEditMode.value == true ? true : false,
                    decoration: InputDecoration(
                      hintText: tr(LanguageKeys.enterDealName),
                      hintStyle: stylePoppins(color: Colors.grey, fontSize: 14),
                      filled: true,
                      fillColor: Colors.grey[200],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 10),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
                // buildDealNameField(),
                // const SizedBox(height: 20),
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
                Obx(() => controller.isUniqueCommission.value == false
                    ? buildAddNewButton()
                    : const SizedBox.shrink()),
                const SizedBox(height: 16),
                buildSubmitButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildProgramTypeDropdown() {
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
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(8),
          ),
          child: DropdownButtonFormField<String>(
            isExpanded: true,
            value: controller.selectedProgramType !=
                    tr(LanguageKeys.selectAnOption)
                ? controller.selectedProgramType
                : null,
            icon: const Icon(Icons.keyboard_arrow_down),
            decoration: const InputDecoration(
              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              border: InputBorder.none,
            ),
            dropdownColor: Colors.white,
            style: stylePoppins(fontSize: 14, color: Colors.grey[600]),
            hint: Text(tr(LanguageKeys.selectAnOption),
                style: stylePoppins(fontSize: 14, color: Colors.grey[600])),
            onChanged: controller.isEditMode.value == true
                ? null
                : (value) {
                    if (value != null) {
                      setState(() {
                        controller.selectedProgramType = value;
                        if (value != tr(LanguageKeys.writeACustomName)) {
                          controller.customProgramNameController.clear();
                        }
                        // Optionally update the deal name field automatically
                        if (value == tr(LanguageKeys.businessReferralProgram) ||
                            value == tr(LanguageKeys.ambassadorProgram)) {
                          controller.dealNameController.text = value;
                        } else {
                          controller.dealNameController.clear();
                        }
                      });
                    }
                  },
            items: [
              DropdownMenuItem<String>(
                value: tr(LanguageKeys.businessReferralProgram),
                child: Text(tr(LanguageKeys.businessReferralProgram)),
              ),
              DropdownMenuItem<String>(
                value: tr(LanguageKeys.ambassadorProgram),
                child: Text(tr(LanguageKeys.ambassadorProgram)),
              ),
              DropdownMenuItem<String>(
                value: tr(LanguageKeys.writeACustomName),
                child: Text(tr(LanguageKeys.writeACustomName)),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  // Widget buildDealNameField() {
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       Text(
  //         tr(LanguageKeys.nameOfDeal),
  //         style: stylePoppins(
  //           fontSize: 16,
  //           fontWeight: FontWeight.w500,
  //         ),
  //       ),
  //       const SizedBox(height: 8),
  //       TextFormField(
  //         controller: controller.dealNameController,
  //         decoration: InputDecoration(
  //           hintText: tr(LanguageKeys.enterDealName),
  //           hintStyle: stylePoppins(color: Colors.grey, fontSize: 14),
  //           filled: true,
  //           fillColor: Colors.grey[200],
  //           border: OutlineInputBorder(
  //             borderRadius: BorderRadius.circular(8),
  //             borderSide: BorderSide.none,
  //           ),
  //           contentPadding:
  //               const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
  //         ),
  //       ),
  //     ],
  //   );
  // }

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
            maxLines: 2,
            textAlign: TextAlign.center,
            softWrap: false,
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
          const Icon(Icons.info_outline, size: 18, color: AppColors.primary),
          const SizedBox(width: 8),
          Expanded(
            child: Obx(
              () => Text(
                controller.isUniqueCommission.value
                    ? tr(LanguageKeys.itWillSpecified)
                    : tr(LanguageKeys.ifYouAreOffer),
                style: stylePoppins(
                  fontSize: 12,
                  color: AppColors.primary,
                ),
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
                    if (value == tr(LanguageKeys.no_commission)) {
                      controller.commissionValueController.text = '';
                    }
                    controller.update();
                  }
                },
                items: [
                  DropdownMenuItem<String>(
                    value: tr(LanguageKeys.no_commission),
                    child: Text(tr(LanguageKeys.no_commission)),
                  ),
                  DropdownMenuItem<String>(
                    value: tr(LanguageKeys.fix_commission),
                    child: Text(tr(LanguageKeys.fix_commission)),
                  ),
                  DropdownMenuItem<String>(
                    value: tr(LanguageKeys.percentage_commission),
                    child: Text(tr(LanguageKeys.percentage_commission)),
                  ),
                ],
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
                        hintText: tr(LanguageKeys.enterCommission),
                        suffixIcon: controller.selectedCommissionOption.value ==
                                tr(LanguageKeys.fix_commission)
                            ? const Padding(
                                padding: EdgeInsets.all(12.0),
                                child:
                                    Text('€', style: TextStyle(fontSize: 18)),
                              )
                            : const Padding(
                                padding: EdgeInsets.all(12.0),
                                child:
                                    Text('%', style: TextStyle(fontSize: 18)),
                              ),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ],
                );
              }
              return const SizedBox.shrink();
            }),
          ],
        );
      } else {
        // NEW UI for Different Commissions
        return StatefulBuilder(
            builder: (context, setState) => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ...List.generate(controller.cases.length, (index) {
                      return Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF8F8F8),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Stack(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(tr(LanguageKeys.leadType),
                                    style: stylePoppins(
                                        fontWeight: FontWeight.w500)),
                                const SizedBox(height: 8),
                                TextField(
                                  controller: leadTypeControllers[index],
                                  style: stylePoppins(fontSize: 14),
                                  decoration: InputDecoration(
                                    hintText: tr(LanguageKeys.enterLeadType),
                                    filled: true,
                                    fillColor: Colors.white,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide.none,
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 12),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  tr(LanguageKeys.commissionShared),
                                  style: stylePoppins(
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: DropdownButtonFormField<String>(
                                    value: controller.cases[index]
                                                ["commission_type"] !=
                                            tr(LanguageKeys.chooseOneoption)
                                        ? controller.cases[index]
                                            ["commission_type"]
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
                                        setState(() {
                                          AppHelper.showLog(
                                              "DropdownValue: ${value}");
                                          controller.cases[index]
                                              ["commission_type"] = value;
                                          if (value ==
                                              tr(LanguageKeys.no_commission)) {
                                            controller.cases[index]
                                                ["commission_value"] = '';
                                          }
                                        });
                                      }
                                    },
                                    items: [
                                      DropdownMenuItem<String>(
                                        value: "no_commission",
                                        child: Text(
                                            tr(LanguageKeys.no_commission)),
                                      ),
                                      DropdownMenuItem<String>(
                                        value: "fix_commission",
                                        child: Text(
                                            tr(LanguageKeys.fix_commission)),
                                      ),
                                      DropdownMenuItem<String>(
                                        value: "percentage_commission",
                                        child: Text(tr(LanguageKeys
                                            .percentage_commission)),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 10),
                                if (controller.cases[index]
                                            ["commission_type"] ==
                                        "fix_commission" ||
                                    controller.cases[index]
                                            ["commission_type"] ==
                                        "percentage_commission")
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(height: 16),
                                      Text(
                                        tr(LanguageKeys.commisionValue),
                                        style: stylePoppins(
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      TextFormField(
                                        controller:
                                            commissionValueControllers[index],
                                        decoration: InputDecoration(
                                          filled: true,
                                          fillColor: Colors.white,
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            borderSide: BorderSide.none,
                                          ),
                                          hintText:
                                              tr(LanguageKeys.enterCommission),
                                          suffixIcon: controller.cases[index]
                                                      ["commission_type"] ==
                                                  "fix_commission"
                                              ? const Padding(
                                                  padding: EdgeInsets.all(12.0),
                                                  child: Text('€',
                                                      style: TextStyle(
                                                          fontSize: 18)),
                                                )
                                              : const Padding(
                                                  padding: EdgeInsets.all(12.0),
                                                  child: Text('%',
                                                      style: TextStyle(
                                                          fontSize: 18)),
                                                ),
                                        ),
                                        keyboardType: TextInputType.number,
                                      ),
                                    ],
                                  ),
                              ],
                            ),
                            if (controller.cases.length > 1)
                              Positioned(
                                top: 0,
                                right: 0,
                                child: GestureDetector(
                                  onTap: () => removeCase(index),
                                  child: Image.asset(
                                    AppAssets.imgDeleteicon,
                                    color: const Color(0xFF8E2DE2),
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
                          side: const BorderSide(color: Color(0xFF8E2DE2)),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                        ),
                        child: Text(
                          tr(LanguageKeys.addCase),
                          style: stylePoppins(
                            color: const Color(0xFF8E2DE2),
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ],
                ));
      }
    });
  }

  Widget buildContractSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Obx(
              () => Text(
                tr(LanguageKeys.contract),
                style: stylePoppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
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
              if (isUploadFile == true) {
                return;
              }
              final url = controller
                      .mainController.dashboard.value?.data?.documentUrl ??
                  '';
              AppHelper.showLog("url: $url");
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
                  child: const Icon(
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
            onTap: () async {
              try {
                final ImagePicker picker = ImagePicker();
                final XFile? file = await picker.pickMedia();

                if (file != null) {
                  if (file.path.toLowerCase().endsWith('.pdf')) {
                    controller.contractFile = File(file.path);
                    AppHelper.showLog("file: ${controller.contractFile}");
                    // final result = await OpenFilex.open(file.path);
                    // if (result.type == ResultType.done) {
                    //   controller.contractFile = File(file.path);
                    //   AppHelper.showLog("file: ${controller.contractFile}");
                    // } else {
                    //   Get.snackbar(
                    //     'Error',
                    //     'Failed to open PDF file',
                    //     snackPosition: SnackPosition.BOTTOM,
                    //     backgroundColor: Colors.red,
                    //     colorText: Colors.white,
                    //   );
                    // }
                  } else {
                    Get.snackbar(
                      'Error',
                      'Please select a PDF file',
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: Colors.red,
                      colorText: Colors.white,
                    );
                  }
                }
              } catch (e) {
                Get.snackbar(
                  'Error',
                  'Failed to select file',
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: Colors.red,
                  colorText: Colors.white,
                );
              }
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
        PopupMenuButton(
          offset: const Offset(0, 40),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          color: Colors.white,
          position: PopupMenuPosition.under,
          constraints: BoxConstraints(
            minWidth: MediaQuery.of(context).size.width - 32,
            maxWidth: MediaQuery.of(context).size.width - 32,
          ),
          itemBuilder: (context) => [
            PopupMenuItem(
              enabled: false,
              child: Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                alignment: Alignment.centerLeft,
                child: Obx(
                  () => Text(
                    tr(LanguageKeys.theTrackingStep),
                    style: stylePoppins(
                      fontSize: 12,
                      color: Colors.grey[700],
                    ),
                  ),
                ),
              ),
            ),
          ],
          child: const Icon(
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
            if (controller.selectedCommissionOption.value !=
                    tr(LanguageKeys.no_commission) &&
                controller.selectedCommissionOption.value !=
                    tr(LanguageKeys.chooseOneoption))
              Container(
                margin: const EdgeInsets.only(bottom: 8, top: 10),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                alignment: Alignment.centerLeft,
                child: Text(
                  tr(LanguageKeys.commisionPaid),
                  style:
                      stylePoppins(fontSize: 16, fontWeight: FontWeight.w500),
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
            SizedBox(
              width: 32,
              child: GestureDetector(
                onTap: onTap,
                child: Padding(
                  padding: const EdgeInsets.all(2),
                  child: Image.asset(
                    AppAssets.imgDeleteicon,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ),
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
            const Icon(
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
        if (AppPreference.readString(AppPreference.isPaid) == "0") {
          Get.dialog(PremiumUpgradeDialog(
            onSeeOffers: () {
              Get.back();
              Get.toNamed(MembershipScreen.pageId)?.then((value) {
                controller.mainController.getProfile();
              });
            },
          ));
        } else {
          AppHelper.showLog('controller.cases: ${controller.cases.toString()}');
          controller.submitDeal(controller.cases);
        }
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
                ? SizedBox(
                    width: 24,
                    height: 24,
                    child: LogoLoader(color: AppColors.whiteColor),
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

  void addCase() {
    setState(() {
      final newIndex = controller.cases.length;
      controller.cases.add({
        "id": "0",
        "deal_id":
            controller.dealId.value.isNotEmpty ? controller.dealId.value : "0",
        "name": "",
        "created_at": "",
        "updated_at": "",
        "lead_type": "",
        "commission_type": tr(LanguageKeys.chooseOneoption),
        "commission_value": "0"
      });

      // Add controllers for the new case with listeners
      final leadController = TextEditingController();
      final commissionController = TextEditingController();

      // Add listeners to keep controller.cases data in sync
      leadController.addListener(() {
        if (newIndex < controller.cases.length) {
          controller.cases[newIndex]["lead_type"] = leadController.text;
        }
      });

      commissionController.addListener(() {
        if (newIndex < controller.cases.length) {
          controller.cases[newIndex]["commission_value"] =
              commissionController.text;
        }
      });

      leadTypeControllers.add(leadController);
      commissionValueControllers.add(commissionController);
    });
  }

  void removeCase(int index) {
    setState(() {
      // Dispose controllers before removing
      if (index < leadTypeControllers.length) {
        leadTypeControllers[index].dispose();
        leadTypeControllers.removeAt(index);
      }
      if (index < commissionValueControllers.length) {
        commissionValueControllers[index].dispose();
        commissionValueControllers.removeAt(index);
      }
      controller.cases.removeAt(index);
    });
  }
}
