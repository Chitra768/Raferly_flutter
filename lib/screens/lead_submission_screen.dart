import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:referaly/languages/languagekeys.dart';
import 'package:referaly/resources/app_colors.dart';
import 'package:referaly/resources/text_style.dart';
import 'package:referaly/utils/translations.dart';
import '../controller/add_lead_controller.dart';

class LeadSubmissionScreen extends GetView<AddLeadController> {
  static String pageId = "/lead_submission";

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
        title:  Text(
          tr(LanguageKeys.leadSubmissionForm),
          style: TextStyle(
              fontSize: 18, fontWeight: FontWeight.w600, color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Form(
          key: controller.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Import from contacts button
              OutlinedButton.icon(
                onPressed: () {
                  // TODO: Implement import from contacts
                },
                icon: Icon(Icons.person, color: AppColors.primary),
                label: Text(tr(LanguageKeys.importFromContact),
                    style: TextStyle(color: AppColors.primary)),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: AppColors.primary),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                  textStyle:
                      TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
              ),
              const SizedBox(height: 24),
              // Feedback types dropdown
              Text(tr(LanguageKeys.selectDeal),
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
              const SizedBox(height: 8),

              // Deal dropdown (disabled)
              Obx(() => DropdownButtonFormField<String>(
                    value: controller.selectedDealId.value,
                    hint:  Text(tr(LanguageKeys.outOfReferalyDealName)),
                    items: controller.dealList
                        .map((deal) => DropdownMenuItem(
                              value: deal.id.toString(),
                              child: Text(deal.dealName ?? ''),
                            ))
                        .toList(),
                    style: stylePoppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: AppColors.fontBlack,
                    ),
                    onChanged: null, // disables the dropdown
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none),
                    ),
                  )),
              const SizedBox(height: 16),
              // First Name & Last Name (disabled)
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildLabel(tr(LanguageKeys.firstName), isRequired: true),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: controller.firstNameController,
                          style: stylePoppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: AppColors.fontBlack,
                          ),
                          decoration: _inputDecoration(tr(LanguageKeys.firstName)).copyWith(
                            fillColor: Colors.grey,
                          ),
                          enabled: false,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildLabel(tr(LanguageKeys.lastName), isRequired: true),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: controller.lastNameController,
                          style: stylePoppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: AppColors.fontBlack,
                          ),
                          decoration: _inputDecoration(tr(LanguageKeys.lastName)).copyWith(
                            fillColor: Colors.grey,
                          ),
                          enabled: false,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Phone Number (enabled)
              _buildLabel(tr(LanguageKeys.phoneNumber)),
              const SizedBox(height: 8),
              TextFormField(
                controller: controller.phoneController,
                decoration: _inputDecoration(tr(LanguageKeys.companyPhoneNumber)),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 16),
              // Email (disabled)
              _buildLabel(tr(LanguageKeys.email), isRequired: true),
              const SizedBox(height: 8),
              TextFormField(
                controller: controller.emailController,
                decoration: _inputDecoration(tr(LanguageKeys.enterEmail)).copyWith(
                  fillColor: Colors.grey[300],
                ),
                enabled: false,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),
              // Note
               Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(tr(LanguageKeys.description),
                      style: TextStyle(fontWeight: FontWeight.w500)),
                ],
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: controller.noteController,
                maxLines: 3,
                maxLength: 500,
                decoration: _inputDecoration(tr(LanguageKeys.detailAboutLead)),
              ),
              // Consent checkbox
              Obx(() {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Checkbox(
                      value: controller.isConsentChecked.value,
                      onChanged: (val) {
                        controller.isConsentChecked.value = val ?? false;
                      },
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          controller.isConsentChecked.value =
                              !controller.isConsentChecked.value;
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(top: 12.0),
                          child: Text(
                            tr(LanguageKeys.agreeLeadTxt),
                            style: stylePoppins(
                              fontSize: 10,
                              fontWeight: FontWeight.w400,
                              color: AppColors.fontBlack,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              }),
              const SizedBox(height: 16),
              // Submit button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () {
                    if (!controller.isConsentChecked.value) {
                      Get.snackbar('Consent Required',
                          'You must certify consent before submitting.',
                          backgroundColor: Colors.red[100]);
                      return;
                    }
                    if (controller.formKey.currentState!.validate()) {
                      controller. updateLead();
                      Get.back();
                    }
                  },
                  child: Text(tr(LanguageKeys.updateLead),
                      style: TextStyle(fontSize: 18, color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String label, {bool isRequired = false}) {
    return Row(
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
        if (isRequired) ...[
          const SizedBox(width: 4),
          const Text('*', style: TextStyle(color: Colors.red)),
        ],
      ],
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      filled: true,
      fillColor: Colors.grey[100],
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      hintText: hint,
    );
  }
}
