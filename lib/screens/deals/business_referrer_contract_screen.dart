import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:referaly/controllers/business_referrer_contract_controller.dart';
import 'package:referaly/resources/app_assets.dart';
import 'package:referaly/resources/app_colors.dart';
import 'package:referaly/resources/text_style.dart';
import 'package:referaly/widgets/dialog/send_contact_dialog.dart';

class BusinessReferrerContractScreen extends StatefulWidget {
  static String pageId = "/businessReferrerContract";

  const BusinessReferrerContractScreen({super.key});

  @override
  State<BusinessReferrerContractScreen> createState() => _BusinessReferrerContractScreenState();
}

class _BusinessReferrerContractScreenState extends State<BusinessReferrerContractScreen> {
  late BusinessReferrerContractController controller;

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
          "Business Referrer contract",
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
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
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
          "Name of the Deal",
          style: stylePoppins(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller.dealNameController,
          decoration: InputDecoration(
            hintText: "Enter Deal Name",
            hintStyle: stylePoppins(color: Colors.grey),
            filled: true,
            fillColor: Colors.grey[200],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
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
              segmentItem(title: 'Unique Commission', isSelected: controller.isUniqueCommission.value),
              segmentItem(
                  title: 'Different commissions',
                  isSelected: !controller.isUniqueCommission.value,
                  isFirst: false),
            ],
          ),
        ));
  }

  Expanded segmentItem({required String title, required bool isSelected, bool isFirst = true}) {
    return Expanded(
      child: GestureDetector(
        onTap: () => controller.toggleCommissionType(isFirst),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
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
              "If you offer only one type of commission or none at all",
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Commission Shared",
          style: stylePoppins(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Obx(() => DropdownButtonFormField<String>(
                value: controller.selectedCommissionOption.value,
                icon: const Icon(Icons.keyboard_arrow_down),
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  border: InputBorder.none,
                ),
                style: stylePoppins(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
                onChanged: (value) {
                  if (value != null) {
                    controller.setCommissionOption(value);
                  }
                },
                items: <String>['Choose One option', '10%', '20%', '30%', '40%', '50%']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              )),
        ),
      ],
    );
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
                  title: "Generate the contract automatically",
                  isSelected: controller.isGenerateContract.value,
                  onTap: () => controller.toggleContractGeneration(true),
                ),
                const SizedBox(height: 8),
                buildContractOption(
                  title: "Upload your own contract",
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
          Row(
            children: [
              Text(
                "Click here",
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
        if (isUploadFile)
          Container(
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
                  "Upload your own contract",
                  style: stylePoppins(fontSize: 12),
                ),
              ],
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
          "Track Name",
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
    return Column(
      children: [
        buildStageItem(
          title: "Contact called",
        ),
        buildStageItem(
          title: "Contract signed",
          onTap: controller.toggleContractSigned,
          showCheckbox: true,
        ),
        buildStageItem(
          title: "Service delivered",
          onTap: controller.toggleServiceDelivered,
          showCheckbox: true,
        ),
        buildStageItem(
          title: "Payment received",
          onTap: controller.togglePaymentReceived,
          showCheckbox: true,
        ),
        buildStageItem(
          title: "Commission Paid",
          isGrey: true,
        ),
      ],
    );
  }

  Widget buildStageItem({
    required String title,
    VoidCallback? onTap,
    bool showCheckbox = false,
    bool isGrey = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: isGrey ? Colors.grey[200] : Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: stylePoppins(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: isGrey ? Colors.grey[600] : Colors.black,
            ),
          ),
          if (showCheckbox)
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
        // Add new functionality
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
              "Add New",
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
      // onTap: controller.submitDeal,
      onTap: () {
        Get.dialog(SendContactDialog(
          onCreateReferral: () {},
        ));
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(
            "Submit Deal",
            style: stylePoppins(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.white,
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
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4)],
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
}
