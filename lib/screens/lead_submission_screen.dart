import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:referaly/languages/languagekeys.dart';
import 'package:referaly/resources/app_colors.dart';
import 'package:referaly/resources/text_style.dart';
import 'package:referaly/utils/translations.dart';
import 'package:referaly/widgets/logo_loader.dart';
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
        title: Text(
          tr(LanguageKeys.leadSubmissionForm),
          style: const TextStyle(
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
              Obx(
                () => controller.type.value == "edit"
                    ? const SizedBox()
                    : OutlinedButton.icon(
                        onPressed: () async {
                          // Request contact permission
                          final status =
                              await FlutterContacts.requestPermission();
                          if (status) {
                            // Show loading dialog first
                            Get.dialog(
                              const Center(
                                child: LogoLoader(),
                              ),
                              barrierDismissible: false,
                            );

                            try {
                              // Close loading dialog
                              Get.back();

                              if (controller.contacts.isNotEmpty) {
                                // Show contact picker dialog
                                final selectedContact =
                                    await showDialog<Contact>(
                                  context: context,
                                  builder: (context) {
                                    final TextEditingController
                                        searchController =
                                        TextEditingController();
                                    controller.filteredContacts.value =
                                        controller.contacts;

                                    return AlertDialog(
                                      backgroundColor: Colors.white,
                                      insetPadding: const EdgeInsets.symmetric(
                                          horizontal: 20, vertical: 20),
                                      title: Text(
                                          tr(LanguageKeys.selectContact),
                                          style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500)),
                                      content: SizedBox(
                                        width: double.maxFinite,
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.6,
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            TextField(
                                              controller: searchController,
                                              autofocus: true,
                                              decoration: InputDecoration(
                                                hintText: tr(LanguageKeys
                                                    .searchPlaceholder),
                                                filled: true,
                                                fillColor: Colors.grey[100],
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                  borderSide: BorderSide.none,
                                                ),
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                  borderSide: BorderSide.none,
                                                ),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                  borderSide: BorderSide.none,
                                                ),
                                                contentPadding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 16,
                                                        vertical: 14),
                                                suffixIcon: IconButton(
                                                  icon: const Icon(Icons.close),
                                                  onPressed: () {
                                                    searchController.clear();
                                                    controller.filteredContacts
                                                            .value =
                                                        controller.contacts;
                                                  },
                                                ),
                                              ),
                                              onChanged: (value) {
                                                if (value.isEmpty) {
                                                  controller.filteredContacts
                                                          .value =
                                                      controller.contacts;
                                                } else {
                                                  // Debounce search to improve performance
                                                  Future.delayed(
                                                      const Duration(
                                                          milliseconds: 300),
                                                      () {
                                                    if (searchController.text ==
                                                        value) {
                                                      controller
                                                              .filteredContacts
                                                              .value =
                                                          controller.contacts
                                                              .where((contact) =>
                                                                  contact
                                                                      .displayName
                                                                      ?.toLowerCase()
                                                                      .contains(
                                                                          value
                                                                              .toLowerCase()) ??
                                                                  false)
                                                              .toList();
                                                    }
                                                  });
                                                }
                                              },
                                            ),
                                            const SizedBox(height: 16),
                                            Expanded(
                                              child: Obx(() => controller
                                                          .filteredContacts
                                                          .isEmpty &&
                                                      searchController
                                                          .text.isNotEmpty
                                                  ? const Center(
                                                      child: Text(
                                                          'No contacts found'),
                                                    )
                                                  : ListView.builder(
                                                      shrinkWrap: true,
                                                      itemCount: controller
                                                          .filteredContacts
                                                          .length,
                                                      itemBuilder:
                                                          (context, index) {
                                                        final contact = controller
                                                                .filteredContacts[
                                                            index];
                                                        return ListTile(
                                                          title: Text(contact
                                                                  .displayName ??
                                                              ''),
                                                          subtitle: contact
                                                                      .phones
                                                                      ?.isNotEmpty ==
                                                                  true
                                                              ? Text(contact
                                                                      .phones!
                                                                      .first
                                                                      .number ??
                                                                  '')
                                                              : null,
                                                          onTap: () =>
                                                              Navigator.pop(
                                                                  context,
                                                                  contact),
                                                        );
                                                      },
                                                    )),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                );

                                if (selectedContact != null) {
                                  // Split the display name into first and last name
                                  final nameParts =
                                      selectedContact.displayName?.split(' ') ??
                                          [];
                                  final firstName = nameParts.isNotEmpty
                                      ? nameParts.first
                                      : '';
                                  final lastName = nameParts.length > 1
                                      ? nameParts.sublist(1).join(' ')
                                      : '';

                                  // Update the text controllers
                                  controller.firstNameController.text =
                                      firstName;
                                  controller.lastNameController.text = lastName;
                                  controller.phoneController.text =
                                      selectedContact.phones?.isNotEmpty == true
                                          ? selectedContact
                                                  .phones.first.number ??
                                              ''
                                          : '';
                                  controller.emailController.text =
                                      selectedContact.emails?.isNotEmpty == true
                                          ? selectedContact
                                                  .emails.first.address ??
                                              ''
                                          : '';
                                }
                              } else {
                                Get.snackbar(
                                  tr(LanguageKeys.error),
                                  'No contacts found',
                                  snackPosition: SnackPosition.BOTTOM,
                                );
                              }
                            } catch (e) {
                              // Close loading dialog
                              Get.back();
                              Get.snackbar(
                                tr(LanguageKeys.error),
                                'Error loading contacts: $e',
                                snackPosition: SnackPosition.BOTTOM,
                              );
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
                        icon: const Icon(
                          Icons.person,
                          color: AppColors.primary,
                          size: 24,
                        ),
                        label: Text(tr(LanguageKeys.importFromContact),
                            style: const TextStyle(color: AppColors.primary)),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: AppColors.primary),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          padding: const EdgeInsets.symmetric(
                              vertical: 16, horizontal: 24),
                          textStyle: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w500),
                        ),
                      ),
              ),
              controller.type.value == "edit"
                  ? const SizedBox()
                  : const SizedBox(height: 24),

              Column(
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
                    validator: controller.validateFirstName,
                    decoration:
                        _inputDecoration(tr(LanguageKeys.firstName)).copyWith(
                      fillColor: controller.type.value == "edit"
                          ? Colors.grey
                          : Colors.grey[100],
                    ),
                    enabled: controller.type.value == "edit" ? false : true,
                  ),
                ],
              ),
              const SizedBox(width: 12),
              Column(
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
                    validator: controller.validateLastName,
                    decoration:
                        _inputDecoration(tr(LanguageKeys.lastName)).copyWith(
                      fillColor: controller.type.value == "edit"
                          ? Colors.grey
                          : Colors.grey[100],
                    ),
                    enabled: controller.type.value == "edit" ? false : true,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Phone Number (enabled)
              _buildLabel(tr(LanguageKeys.phoneNumber), isRequired: true),
              const SizedBox(height: 8),
              TextFormField(
                controller: controller.phoneController,
                validator: controller.validatePhone,
                decoration: _inputDecoration(tr(LanguageKeys.enterNum)),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 16),
              // Email (disabled)
              _buildLabel(tr(LanguageKeys.email), isRequired: false),
              const SizedBox(height: 8),
              TextFormField(
                controller: controller.emailController,
                validator: controller.validateEmail,
                decoration: _inputDecoration(tr(LanguageKeys.enterEmail)),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),
              // Note
              // Note
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Obx(
                    () => Text('Description ${controller.noteLength}/500',
                        style: const TextStyle(fontWeight: FontWeight.w500)),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: controller.noteController,
                maxLines: 3,
                maxLength: 500,
                validator: (v) => v == null || v.isEmpty
                    ? tr(LanguageKeys.pleaseEnterDescription)
                    : null,
                buildCounter: (context,
                        {required currentLength,
                        required isFocused,
                        maxLength}) =>
                    null,
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
                height: 55.h,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () {
                    if (controller.formKey.currentState!.validate()) {
                      if (!controller.isConsentChecked.value) {
                        Get.snackbar('Consent Required',
                            'You must certify consent before submitting.',
                            backgroundColor: Colors.red[100]);
                        return;
                      }
                      if (controller.type.value == "edit") {
                        controller.updateLead();
                      } else {
                        controller.selectedFeedbackType.value = "";
                        controller.createLead();
                      }
                    }
                  },
                  child: Obx(
                    () => controller.isLoading.value
                        ? Center(
                            child: LogoLoader(color: AppColors.whiteColor),
                          )
                        : Text(
                            controller.type.value == "edit"
                                ? tr(LanguageKeys.updateLead)
                                : tr(LanguageKeys.invitedSubmitLead),
                            style: const TextStyle(
                                fontSize: 18, color: Colors.white)),
                  ),
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
