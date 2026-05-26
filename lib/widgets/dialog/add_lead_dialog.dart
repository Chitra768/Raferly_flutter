import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:referaly/controller/controller_main_professional.dart';
import 'package:referaly/helpers/agency_colleague_access_helper.dart';
import 'package:referaly/languages/languagekeys.dart';
import 'package:referaly/resources/app_colors.dart';
import 'package:referaly/resources/app_helper.dart';
import 'package:referaly/resources/text_style.dart';
import 'package:referaly/utils/translations.dart';
import 'package:referaly/widgets/logo_loader.dart';

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
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(
                          Icons.close,
                          size: 24,
                          color: AppColors.whiteColor,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        tr(LanguageKeys.addLead),
                        textAlign: TextAlign.center,
                        style: stylePoppins(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        controller.firstNameController.clear();
                        controller.lastNameController.clear();
                        controller.phoneController.clear();
                        controller.emailController.clear();
                controller. noteController.clear();
                controller. selectedFeedbackType.value = null;
               controller.  selectedBusinessReferrer.value = null;
               controller.  selectedBusinessDeal.value = null;
               controller.  selectedDealId.value = null;
               controller.  selectedBusinessReferrerId.value = null;
                controller. selectedCreatedBy.value = null;
                Get.back();
                      },
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
                       final status = await FlutterContacts.requestPermission();
                        if (status) {
                          // Show loading dialog first
                          Get.dialog(
                            const Center(
                              child: LogoLoader(),
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
                                                      horizontal: 16,
                                                      vertical: 14),
                                              suffixIcon: IconButton(
                                                icon: const Icon(Icons.close),
                                                onPressed: () {
                                                  searchController.clear();
                                                  filteredContacts.value =
                                                      contacts;
                                                },
                                              ),
                                            ),
                                            onChanged: (value) {
                                              if (value.isEmpty) {
                                                filteredContacts.value =
                                                    contacts;
                                              } else {
                                                // Debounce search to improve performance
                                                Future.delayed(
                                                    const Duration(
                                                        milliseconds: 300), () {
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
                                                    searchController
                                                        .text.isNotEmpty
                                                ? const Center(
                                                    child: Text(
                                                        'No contacts found'),
                                                  )
                                                : ListView.builder(
                                                    shrinkWrap: true,
                                                    itemCount:
                                                        filteredContacts.length,
                                                    itemBuilder:
                                                        (context, index) {
                                                      final contact =
                                                          filteredContacts[
                                                              index];
                                                      return ListTile(
                                                        title: Text(contact
                                                                .displayName ??
                                                            ''),
                                                        subtitle: contact.phones
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
                      icon: Icon(Icons.person, color: AppColors.primary),
                      label: Text(tr(LanguageKeys.importFromContact),
                          style: TextStyle(
                              color: AppColors.primary,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500)),
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
                        controller.selectedFeedbackType.value = val ?? '';
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
                                        "selectedDealId ID: ${controller.selectedDealId.value}");
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
                                      controller.selectedBusinessDealId.value =
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
                            validator: (v) => v == null || v.isEmpty
                                ? tr(LanguageKeys.pleaseEnterFirstName)
                                : null,
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
                  validator: (v) {
                    final phone = controller.phoneController.text.trim();
                    final email = controller.emailController.text.trim();
                    if (phone.isEmpty && email.isEmpty) {
                      return tr(LanguageKeys.pleaseEnterPhoneNumber);
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                // Email
                _buildLabel(tr(LanguageKeys.email), isRequired: true),
                const SizedBox(height: 8),
                TextFormField(
                  controller: controller.emailController,
                  decoration: _inputDecoration(tr(LanguageKeys.enterEmail)),
                  validator: (v) {
                    final phone = controller.phoneController.text.trim();
                    final email = controller.emailController.text.trim();
                    if (phone.isEmpty && email.isEmpty) {
                      return tr(LanguageKeys.pleaseEnterEmail);
                    }
                    // If email is not empty, check for valid email format
                    if (email.isNotEmpty && (v == null || v.isEmpty)) {
                      return tr(LanguageKeys.pleaseEnterEmail);
                    }
                    return null;
                  },
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 16),
                // Note
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Obx(
                      () => Text('Note (${controller.noteLength}/500)',
                          style: const TextStyle(fontWeight: FontWeight.w500)),
                    ),
                    const SizedBox(width: 4),
                    const Text('*', style: TextStyle(color: Colors.red)),
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
                  validator: (v) => v == null || v.isEmpty
                      ? tr(LanguageKeys.pleaseEnterDescription)
                      : null,
                ),
                const SizedBox(height: 24),
                // Submit button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      padding: const EdgeInsets.symmetric(
                          vertical: 16, horizontal: 32),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: () {
                      final profile = Get.find<ControllerMainProfessional>()
                          .profile
                          .value
                          ?.data;
                      if (!AgencyColleagueAccessHelper.guardEdit(
                          profile, AgencyPermission.leadsSent)) {
                        return;
                      }
                      if (controller.formKey.currentState!.validate()) {
                        // Handle submit
                        controller.createLead();
                        // Get.back();
                      }
                    },
                    child: Obx(
                      () => controller.isLoading.value
                          ? SizedBox(
                              width: 24,
                              height: 24,
                              child: LogoLoader(color: AppColors.whiteColor),
                            )
                          : FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                tr(LanguageKeys.submitLead),
                                style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white),
                              ),
                            ),
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
