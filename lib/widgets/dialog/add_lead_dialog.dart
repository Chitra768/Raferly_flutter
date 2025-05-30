import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';
import 'package:referaly/languages/languagekeys.dart';
import 'package:referaly/resources/app_colors.dart';
import 'package:referaly/resources/app_helper.dart';
import 'package:referaly/utils/translations.dart';
import 'package:permission_handler/permission_handler.dart';

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
                    GestureDetector(
                      onTap: () => Get.back(),
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Icon(
                          Icons.close,
                          size: 24,
                          color: AppColors.whiteColor,
                        ),
                      ),
                    ),
                    Spacer(),
                    Text(
                      tr(LanguageKeys.addLead),
                      style: const TextStyle(
                          fontSize: 22, fontWeight: FontWeight.w600),
                    ),
                    Spacer(),
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
                      onPressed: () async {
                        // Request contact permission
                        final status = await Permission.contacts.request();
                        if (status.isGranted) {
                          // Get contacts
                          final contacts = await FlutterContacts.getContacts(
                              withProperties: true);

                          if (contacts.isNotEmpty) {
                            // Show contact picker dialog
                            final selectedContact = await showDialog<Contact>(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: Text(tr(LanguageKeys.selectContact)),
                                content: SizedBox(
                                  width: double.maxFinite,
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: contacts.length,
                                    itemBuilder: (context, index) {
                                      final contact = contacts.elementAt(index);
                                      return ListTile(
                                        title: Text(contact.displayName ?? ''),
                                        onTap: () =>
                                            Navigator.pop(context, contact),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            );

                            if (selectedContact != null) {
                              // Split the display name into first and last name
                              final nameParts =
                                  selectedContact.displayName?.split(' ') ?? [];
                              final firstName =
                                  nameParts.isNotEmpty ? nameParts.first : '';
                              final lastName = nameParts.length > 1
                                  ? nameParts.sublist(1).join(' ')
                                  : '';

                              // Update the text controllers
                              controller.firstNameController.text = firstName;
                              controller.lastNameController.text = lastName;
                              controller.phoneController.text =
                                  selectedContact.phones?.isNotEmpty == true
                                      ? selectedContact.phones.first.number ??
                                          ''
                                      : '';
                              controller.emailController.text =
                                  selectedContact.emails?.isNotEmpty == true
                                      ? selectedContact.emails.first.address ??
                                          ''
                                      : '';
                            }
                          }
                        } else {
                          // Show permission denied message
                          Get.snackbar(
                            tr(LanguageKeys.error),
                            tr(LanguageKeys.contactPermissionDenied),
                            snackPosition: SnackPosition.BOTTOM,
                          );
                        }
                      },
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
                      style: const TextStyle(
                          fontSize: 14, fontWeight: FontWeight.w500)),
                ),
                const SizedBox(height: 8),
                Obx(() => DropdownButtonFormField<String>(
                      value: controller.selectedFeedbackType.value,
                      hint: Text(tr(LanguageKeys.chooseOneoption)),
                      isExpanded: true,
                      items: controller.feedbackTypes
                          .map((type) => DropdownMenuItem(
                              value: type,
                              child: ConstrainedBox(
                                constraints: BoxConstraints(
                                  maxWidth:
                                      MediaQuery.of(context).size.width - 100,
                                ),
                                child: Text(
                                  type,
                                  overflow: TextOverflow.ellipsis,
                                  softWrap: true,
                                ),
                              )))
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
                          controller.feedbackTypes[1]
                      ? Column(
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(tr(LanguageKeys.selectDeal),
                                  style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500)),
                            ),
                            Obx(() => DropdownButtonFormField<String>(
                                  value: controller.selectedBusinessDeal.value,
                                  hint: Text(tr(LanguageKeys.chooseOneoption)),
                                  isExpanded: true,
                                  items: controller.businessReferralDealList
                                      .map((type) => DropdownMenuItem(
                                          value: type.id.toString(),
                                          child: ConstrainedBox(
                                            constraints: BoxConstraints(
                                              maxWidth: MediaQuery.of(context)
                                                      .size
                                                      .width -
                                                  100,
                                            ),
                                            child: Text(
                                              type.dealName ?? '',
                                              overflow: TextOverflow.ellipsis,
                                              softWrap: true,
                                            ),
                                          )))
                                      .toList(),
                                  onChanged: (val) {
                                    controller.selectedBusinessDeal.value = val;
                                    controller.selectedDealId.value = val;
                                    AppHelper.showLog(
                                        "val ID: ${controller.selectedDealId.value}");
                                    AppHelper.showLog(
                                        "selectedBusinessDeal ID: ${controller.selectedBusinessDeal.value}");
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
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(tr(LanguageKeys.selectReferrer),
                                  style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500)),
                            ),
                            Obx(() => DropdownButtonFormField<String>(
                                  value:
                                      controller.selectedBusinessReferrer.value,
                                  hint: Text(tr(LanguageKeys.chooseOneoption)),
                                  isExpanded: true,
                                  items: controller.businessReferralLeadList
                                      .map((type) => DropdownMenuItem(
                                          value: type.id.toString(),
                                          child: ConstrainedBox(
                                            constraints: BoxConstraints(
                                              maxWidth: MediaQuery.of(context)
                                                      .size
                                                      .width -
                                                  100,
                                            ),
                                            child: Text(
                                              '${type.firstName} ${type.lastName}',
                                              overflow: TextOverflow.ellipsis,
                                              softWrap: true,
                                            ),
                                          )))
                                      .toList()
                                      .toSet()
                                      .toList(),
                                  onChanged: (val) {
                                    if (val != null) {
                                      final selectedReferrer = controller
                                          .businessReferralLeadList
                                          .firstWhere((referrer) =>
                                              referrer.id.toString() == val);
                                      controller
                                          .selectedBusinessReferrer.value = val;
                                      controller.selectedBusinessReferrerId
                                          .value = val;
                                      controller.selectedDealId.value =
                                          selectedReferrer.dealId.toString();

                                      AppHelper.showLog(
                                          "selectedBusinessReferrer ID: ${controller.selectedBusinessReferrer.value}");
                                      AppHelper.showLog(
                                          "selectedDealId: ${controller.selectedDealId.value}");
                                    }
                                  },
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Colors.grey[100],
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: BorderSide.none),
                                  ),
                                  validator: (val) => val == null
                                      ? 'Please select a business referrer'
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
                            decoration:
                                _inputDecoration(tr(LanguageKeys.firstName)),
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
                            decoration:
                                _inputDecoration(tr(LanguageKeys.lastName)),
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
                  decoration: _inputDecoration(tr(LanguageKeys.enterNum)),
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Obx(
                      () => Text('Note (${controller.noteLength}/500)',
                          style: TextStyle(fontWeight: FontWeight.w500)),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: controller.noteController,
                  maxLines: 3,
                  maxLength: 500,
                  buildCounter: (context,
                          {required currentLength,
                          required isFocused,
                          maxLength}) =>
                      null,
                  decoration:
                      _inputDecoration(tr(LanguageKeys.detailAboutLead)),
                ),
                const SizedBox(height: 24),
                // Submit button
                SizedBox(
                  width: 200,
                  child: ElevatedButton(
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
                        // Get.back();
                      }
                    },
                    child: Obx(
                      () => controller.isLoading.value
                          ? const CircularProgressIndicator(color: Colors.white)
                          : Text(tr(LanguageKeys.submitALead),
                              style: const TextStyle(
                                  fontSize: 18, color: Colors.white)),
                    ),
                  ),
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
