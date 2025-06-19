import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:referaly/languages/languagekeys.dart';
import 'package:referaly/resources/app_assets.dart';
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
        title: Text(
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
                onPressed: () async {
                  // Request contact permission
                  final status = await Permission.contacts.request();
                  if (status.isGranted) {
                    // Show loading dialog first
                    Get.dialog(
                      const Center(
                        child: CircularProgressIndicator(),
                      ),
                      barrierDismissible: false,
                    );

                    try {
                      // Get all contacts but show loading progress
                      final contacts = await FlutterContacts.getContacts(
                        withProperties: true,
                      );

                      // Close loading dialog
                      Get.back();

                      if (contacts.isNotEmpty) {
                        // Show contact picker dialog
                        final selectedContact = await showDialog<Contact>(
                          context: context,
                          builder: (context) {
                            final TextEditingController searchController =
                                TextEditingController();
                            final RxList<Contact> filteredContacts =
                                contacts.obs;
                            final RxBool isLoading = false.obs;

                            return AlertDialog(
                              backgroundColor: Colors.white,
                              insetPadding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 20),
                              title: Text(tr(LanguageKeys.selectContact),
                                  style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500)),
                              content: SizedBox(
                                width: double.maxFinite,
                                height:
                                    MediaQuery.of(context).size.height * 0.6,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    TextField(
                                      controller: searchController,
                                      autofocus: true,
                                      decoration: InputDecoration(
                                        hintText:
                                            tr(LanguageKeys.searchPlaceholder),
                                        filled: true,
                                        fillColor: Colors.grey[100],
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          borderSide: BorderSide.none,
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          borderSide: BorderSide.none,
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          borderSide: BorderSide.none,
                                        ),
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                                horizontal: 16, vertical: 14),
                                        suffixIcon: IconButton(
                                          icon: const Icon(Icons.close),
                                          onPressed: () {
                                            searchController.clear();
                                            filteredContacts.value = contacts;
                                          },
                                        ),
                                      ),
                                      onChanged: (value) {
                                        if (value.isEmpty) {
                                          filteredContacts.value = contacts;
                                        } else {
                                          // Debounce search to improve performance
                                          Future.delayed(
                                              const Duration(milliseconds: 300),
                                              () {
                                            if (searchController.text ==
                                                value) {
                                              filteredContacts.value = contacts
                                                  .where((contact) =>
                                                      contact.displayName
                                                          ?.toLowerCase()
                                                          .contains(value
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
                                      child: Obx(() => filteredContacts
                                                  .isEmpty &&
                                              searchController.text.isNotEmpty
                                          ? const Center(
                                              child: Text('No contacts found'),
                                            )
                                          : ListView.builder(
                                              shrinkWrap: true,
                                              itemCount:
                                                  filteredContacts.length,
                                              itemBuilder: (context, index) {
                                                final contact =
                                                    filteredContacts[index];
                                                return ListTile(
                                                  title: Text(
                                                      contact.displayName ??
                                                          ''),
                                                  subtitle: contact.phones
                                                              ?.isNotEmpty ==
                                                          true
                                                      ? Text(contact.phones!
                                                              .first.number ??
                                                          '')
                                                      : null,
                                                  onTap: () => Navigator.pop(
                                                      context, contact),
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
                                  ? selectedContact.phones.first.number ?? ''
                                  : '';
                          controller.emailController.text =
                              selectedContact.emails?.isNotEmpty == true
                                  ? selectedContact.emails.first.address ?? ''
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
                icon: Icon(
                  Icons.person,
                  color: AppColors.primary,
                  size: 24,
                ),
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
              Obx(
                () => controller.type.value == "edit"
                    ? TextFormField(
                        controller: TextEditingController(
                            text: controller.dealName.value),
                        style: stylePoppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: AppColors.fontBlack,
                        ),
                        decoration: _inputDecoration("").copyWith(
                          fillColor: Colors.grey,
                        ),
                        enabled: false,
                      )
                    : DropdownButtonFormField(
                        value: controller.selectedDealId.value?.isEmpty == true
                            ? null
                            : controller.selectedDealId.value,
                        hint: Text(tr(LanguageKeys.chooseOneoption)),
                        isExpanded: true,
                        items: controller.acceptList
                            .map((e) => DropdownMenuItem(
                                  value: e.id.toString(),
                                  child: ConstrainedBox(
                                    constraints: BoxConstraints(
                                      maxWidth:
                                          MediaQuery.of(context).size.width -
                                              80,
                                    ),
                                    child: Text(
                                      e.dealName ?? '',
                                      style: stylePoppins(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500),
                                      overflow: TextOverflow.ellipsis,
                                      softWrap: true,
                                    ),
                                  ),
                                ))
                            .toList(),
                        onChanged: (value) {
                          controller.selectedDealId.value = value.toString();
                        },
                        icon: const Icon(Icons.keyboard_arrow_down,
                            color: Colors.black),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.grey[100],
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 14),
                        ),
                      ),
              ),
              const SizedBox(height: 16),
              // First Name & Last Name (disabled)
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
                          style: stylePoppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: AppColors.fontBlack,
                          ),
                          decoration:
                              _inputDecoration(tr(LanguageKeys.firstName))
                                  .copyWith(
                            fillColor: controller.type.value == "edit"
                                ? Colors.grey
                                : Colors.grey[100],
                          ),
                          enabled:
                              controller.type.value == "edit" ? false : true,
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
                          style: stylePoppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: AppColors.fontBlack,
                          ),
                          decoration:
                              _inputDecoration(tr(LanguageKeys.lastName))
                                  .copyWith(
                            fillColor: controller.type.value == "edit"
                                ? Colors.grey
                                : Colors.grey[100],
                          ),
                          enabled:
                              controller.type.value == "edit" ? false : true,
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
                decoration: _inputDecoration(tr(LanguageKeys.enterNum)),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 16),
              // Email (disabled)
              _buildLabel(tr(LanguageKeys.email), isRequired: false),
              const SizedBox(height: 8),
              TextFormField(
                controller: controller.emailController,
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
                      controller.updateLead();
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
