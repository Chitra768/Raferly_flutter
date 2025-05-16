import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:referaly/languages/languagekeys.dart';
import 'package:referaly/resources/app_colors.dart';
import 'package:referaly/resources/app_helper.dart';
import 'package:referaly/utils/translations.dart';

import '../../controller/add_lead_controller.dart';

class AddLeadDialog extends StatelessWidget {
  AddLeadDialog({super.key});

  final AddLeadController controller = Get.put(AddLeadController());
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      insetPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: SingleChildScrollView(
          child: Form(
            key: controller.formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Title and close button
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Opacity(
                      opacity: 0,
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Icon(Icons.close, size: 24),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        tr(LanguageKeys.addLead),
                        style: const TextStyle(
                            fontSize: 22, fontWeight: FontWeight.w600),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Get.back(),
                      child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Icon(Icons.close, size: 24),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Import from contacts
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    OutlinedButton.icon(
                      onPressed: () {},
                      icon: Icon(Icons.person, color: AppColors.primary),
                      label: Text(tr(LanguageKeys.importFromContact),
                          style: TextStyle(color: AppColors.primary)),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: AppColors.primary),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Feedback types dropdown
                 Align(
                  alignment: Alignment.centerLeft,
                  child: Text(tr(LanguageKeys.assignLeadType),
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                ),
                const SizedBox(height: 8),
                Obx(() => DropdownButtonFormField<String>(
                      value: controller.selectedFeedbackType.value,
                      hint: Text(tr(LanguageKeys.chooseOneoption)),
                      items: controller.feedbackTypes
                          .map((type) =>
                              DropdownMenuItem(value: type, child: Text(type)))
                          .toList(),
                      onChanged: (val) {
                        controller.selectedFeedbackType.value = val;
                        AppHelper.showLog("val: $val");
                        if (val == tr(LanguageKeys.businessReferrer)) {
                          controller.businessDealList();
                        }
                      },
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.grey[100],
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none),
                      ),
                      validator: (val) =>
                          val == null ? 'Please select a feedback type' : null,
                    )),
                const SizedBox(height: 16),

                Obx(
                  () => controller.selectedFeedbackType.value ==
                          tr(LanguageKeys.businessReferrer)
                      ? Column(
                          children: [
                            Obx(() => DropdownButtonFormField<String>(
                                  value:
                                      controller.selectedBusinessReferrer.value,
                                  hint: Text(tr(LanguageKeys.chooseOneoption)),
                                  items: controller.businessReferralLeadList
                                      .map((type) => DropdownMenuItem(
                                          value: type.id.toString(),
                                          child: Text(
                                              '${type.firstName} ${type.lastName}')))
                                      .toList(),
                                  onChanged: (val) {
                                    controller.selectedBusinessReferrer.value =
                                        val;
                                    controller
                                        .selectedBusinessReferrerId.value = val;
                                  },
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Colors.grey[100],
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: BorderSide.none),
                                  ),
                                )),
                            const SizedBox(height: 16),
                            Obx(() => DropdownButtonFormField<String>(
                                  value: controller.selectedBusinessDeal.value,
                                  hint: Text(tr(LanguageKeys.chooseOneoption)),
                                  items: controller.businessReferralDealList
                                      .map((type) => DropdownMenuItem(
                                          value: type.id.toString(),
                                          child: Text(type.dealName ?? '')))
                                      .toList(),
                                  onChanged: (val) {
                                    controller.selectedBusinessDeal.value = val;
                                    controller.selectedDealId.value = val;
                                    AppHelper.showLog(
                                        "val ID: ${controller.selectedDealId.value}");
                                  },
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Colors.grey[100],
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: BorderSide.none),
                                  ),
                                  validator: (val) => val == null
                                      ? 'Please select a business deal'
                                      : null,
                                )),
                            const SizedBox(height: 16),
                          ],
                        )
                      : const SizedBox(),
                ),

                // First Name & Last Name
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildLabel(tr(LanguageKeys.firstName),
                              isRequired: true),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: controller.firstNameController,
                            decoration: _inputDecoration(tr(LanguageKeys.firstName)),
                            validator: (v) =>
                                v == null || v.isEmpty ? 'Required' : null,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildLabel(tr(LanguageKeys.lastName),
                              isRequired: true),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: controller.lastNameController,
                            decoration: _inputDecoration(tr(LanguageKeys.lastName)),
                            validator: (v) =>
                                v == null || v.isEmpty ? 'Required' : null,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Phone Number
                _buildLabel(tr(LanguageKeys.phoneNumber)),
                const SizedBox(height: 8),
                TextFormField(
                  controller: controller.phoneController,
                  decoration: _inputDecoration(tr(LanguageKeys.enterCompanyNumber)),
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 16),
                // Email
                _buildLabel(tr(LanguageKeys.email), isRequired: true),
                const SizedBox(height: 8),
                TextFormField(
                  controller: controller.emailController,
                  decoration: _inputDecoration(tr(LanguageKeys.enterEmail)),
                  validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 16),
                // Note
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Note (0/500)',
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
                const SizedBox(height: 24),
                // Submit button
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(
                        vertical: 16, horizontal: 32),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () {
                    if (controller.formKey.currentState!.validate()) {
                      // Handle submit
                      controller.createLead();
                      Get.back();
                    }
                  },
                  child: Text(tr(LanguageKeys.submitALead),
                      style: TextStyle(fontSize: 18, color: Colors.white)),
                ),
              ],
            ),
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
