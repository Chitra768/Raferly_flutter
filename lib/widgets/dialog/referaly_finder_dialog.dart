import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:referaly/languages/languagekeys.dart';
import 'package:referaly/resources/app_colors.dart';
import 'package:referaly/resources/text_style.dart';
import 'package:referaly/utils/translations.dart';
import 'package:referaly/widgets/dialog/discover_referaly_finder_dialog.dart';

/// Dialog to find a professional for a lead
class ReferalyFinderDialog extends StatefulWidget {
  final VoidCallback? onImportContacts;
  final VoidCallback? onSubmit;

  const ReferalyFinderDialog({
    super.key,
    this.onImportContacts,
    this.onSubmit,
  });

  @override
  _ReferalyFinderDialogState createState() => _ReferalyFinderDialogState();
}

class _ReferalyFinderDialogState extends State<ReferalyFinderDialog> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController typeController = TextEditingController();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController moreInfoController = TextEditingController();
  String? selectedCommission = "";
  final List<String> commissionOptions = [
    tr(LanguageKeys.no_commission),
    tr(LanguageKeys.fix_commission),
    tr(LanguageKeys.percentage_commission)
  ];
  bool consentGiven = false;

  @override
  void dispose() {
    typeController.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    cityController.dispose();
    descriptionController.dispose();
    moreInfoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      titlePadding: EdgeInsets.zero,
      title: Padding(
        padding: const EdgeInsets.only(top: 15, right: 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            GestureDetector(
              onTap: () => Get.back(),
              child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.primary, width: 1)),
                  child: Icon(Icons.close, size: 24, color: AppColors.primary)),
            ),
          ],
        ),
      ),
      content: SizedBox(
        width: double.maxFinite,
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    tr(LanguageKeys.referalyFinder),
                    style: stylePoppins(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        tr(LanguageKeys.weFind),
                        style: stylePoppins(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Get.dialog(const DiscoverReferalyFinderDialog());
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(left: 4),
                        child: Icon(Icons.info_outline,
                            color: AppColors.primary, size: 18),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: tr(LanguageKeys.typeOfProfessional),
                        style: stylePoppins(
                            fontSize: 14, fontWeight: FontWeight.w500),
                      ),
                      TextSpan(
                        text: '*',
                        style: stylePoppins(
                                fontSize: 14, fontWeight: FontWeight.w500)
                            .copyWith(color: AppColors.redColor),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: typeController,
                  decoration: InputDecoration(
                    hintText: tr(LanguageKeys.typeOfProfessionalPlaceholder),
                    filled: true,
                    hintStyle:
                        stylePoppins(fontSize: 13, fontWeight: FontWeight.w400),
                    fillColor: Colors.grey[100],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 14),
                  ),
                  validator: (val) => val == null || val.trim().isEmpty
                      ? tr(LanguageKeys.typeOfProfessionalError)
                      : null,
                ),
                const SizedBox(height: 20),
                Center(
                  child: Text(
                    tr(LanguageKeys.leadInfo),
                    style:
                        stylePoppins(fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                ),
                const SizedBox(height: 12),
                GestureDetector(
                  onTap: widget.onImportContacts,
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 16),
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.primary),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.import_contacts, color: AppColors.primary),
                        const SizedBox(width: 8),
                        Text(
                          tr(LanguageKeys.importFromContact),
                          style: stylePoppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text.rich(
                            TextSpan(children: [
                              TextSpan(
                                  text: tr(LanguageKeys.firstName),
                                  style: stylePoppins(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500)),
                              TextSpan(
                                  text: '*',
                                  style: stylePoppins(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500)
                                      .copyWith(color: AppColors.redColor)),
                            ]),
                          ),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: firstNameController,
                            decoration: InputDecoration(
                              hintText: tr(LanguageKeys.firstName),
                              filled: true,
                              fillColor: Colors.grey[100],
                              hintStyle: stylePoppins(
                                  fontSize: 13, fontWeight: FontWeight.w400),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide.none,
                              ),
                              errorStyle: stylePoppins(fontSize: 10),
                              errorMaxLines: 2,
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 14),
                            ),
                            validator: (val) =>
                                val == null || val.trim().isEmpty
                                    ? tr(LanguageKeys.firastNameError)
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
                          Text.rich(
                            TextSpan(children: [
                              TextSpan(
                                  text: tr(LanguageKeys.lastName),
                                  style: stylePoppins(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500)),
                              TextSpan(
                                  text: '*',
                                  style: stylePoppins(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500)
                                      .copyWith(color: AppColors.redColor)),
                            ]),
                          ),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: lastNameController,
                            decoration: InputDecoration(
                              hintText: tr(LanguageKeys.lastName),
                              filled: true,
                              fillColor: Colors.grey[100],
                              hintStyle: stylePoppins(
                                  fontSize: 13, fontWeight: FontWeight.w400),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide.none,
                              ),
                              errorStyle: stylePoppins(fontSize: 10),
                              errorMaxLines: 2,
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 18, vertical: 14),
                            ),
                            validator: (val) =>
                                val == null || val.trim().isEmpty
                                    ? tr(LanguageKeys.lastNameError)
                                    : null,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text.rich(
                  TextSpan(children: [
                    TextSpan(
                        text: tr(LanguageKeys.phoneNumber),
                        style: stylePoppins(
                            fontSize: 14, fontWeight: FontWeight.w500)),
                    TextSpan(
                        text: '*',
                        style: stylePoppins(
                                fontSize: 14, fontWeight: FontWeight.w500)
                            .copyWith(color: AppColors.redColor)),
                  ]),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: phoneController,
                  decoration: InputDecoration(
                    hintText: tr(LanguageKeys.enterNum),
                    filled: true,
                    fillColor: Colors.grey[100],
                    hintStyle:
                        stylePoppins(fontSize: 13, fontWeight: FontWeight.w400),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 14),
                  ),
                  validator: (val) => val == null || val.trim().isEmpty
                      ? tr(LanguageKeys.phoneNumError)
                      : null,
                ),
                const SizedBox(height: 16),
                Text.rich(
                  TextSpan(children: [
                    TextSpan(
                        text: tr(LanguageKeys.email),
                        style: stylePoppins(
                            fontSize: 14, fontWeight: FontWeight.w500)),
                    TextSpan(
                        text: '*',
                        style: stylePoppins(
                                fontSize: 14, fontWeight: FontWeight.w500)
                            .copyWith(color: AppColors.redColor)),
                  ]),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: emailController,
                  decoration: InputDecoration(
                    hintText: tr(LanguageKeys.enterEmail),
                    filled: true,
                    fillColor: Colors.grey[100],
                    hintStyle:
                        stylePoppins(fontSize: 13, fontWeight: FontWeight.w400),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 14),
                  ),
                  validator: (val) => val == null || val.trim().isEmpty
                      ? tr(LanguageKeys.emptyEmail)
                      : null,
                ),
                const SizedBox(height: 16),
                Text.rich(
                  TextSpan(children: [
                    TextSpan(
                        text: tr(LanguageKeys.city),
                        style: stylePoppins(
                            fontSize: 14, fontWeight: FontWeight.w500)),
                    TextSpan(
                        text: '*',
                        style: stylePoppins(
                                fontSize: 14, fontWeight: FontWeight.w500)
                            .copyWith(color: AppColors.redColor)),
                  ]),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: cityController,
                  decoration: InputDecoration(
                    hintText: tr(LanguageKeys.enterCity),
                    filled: true,
                    fillColor: Colors.grey[100],
                    hintStyle:
                        stylePoppins(fontSize: 13, fontWeight: FontWeight.w400),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 14),
                  ),
                  validator: (val) => val == null || val.trim().isEmpty
                      ? tr(LanguageKeys.cityError)
                      : null,
                ),
                const SizedBox(height: 16),
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: tr(LanguageKeys.description),
                        style: stylePoppins(
                            fontSize: 14, fontWeight: FontWeight.w500),
                      ),
                      TextSpan(
                        text: '*',
                        style: stylePoppins(
                                fontSize: 14, fontWeight: FontWeight.w500)
                            .copyWith(color: AppColors.redColor),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: descriptionController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    hintText: tr(LanguageKeys.detailAboutLead),
                    filled: true,
                    fillColor: Colors.grey[100],
                    hintStyle:
                        stylePoppins(fontSize: 13, fontWeight: FontWeight.w400),
                    errorStyle:
                        stylePoppins(fontSize: 12, color: AppColors.redColor),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 14),
                  ),
                  validator: (val) => val == null || val.trim().isEmpty
                      ? tr(LanguageKeys.enterDescriptionErr)
                      : null,
                ),
                const SizedBox(height: 16),
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: 'Commission ',
                        style: stylePoppins(
                            fontSize: 14, fontWeight: FontWeight.w500),
                      ),
                      TextSpan(
                        text: '*',
                        style: stylePoppins(
                                fontSize: 14, fontWeight: FontWeight.w500)
                            .copyWith(color: AppColors.redColor),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  value: selectedCommission,
                  hint: Text(tr(LanguageKeys.chooseOneoption)),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey[100],
                    hintStyle:
                        stylePoppins(fontSize: 13, fontWeight: FontWeight.w400),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 14),
                  ),
                  validator: (val) => val == null || val.isEmpty
                      ? tr(LanguageKeys.pleaseSelectCommType)
                      : null,
                  items: commissionOptions.map((option) {
                    return DropdownMenuItem<String>(
                      value: option,
                      child: Text(option),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedCommission = value;
                    });
                  },
                ),
                const SizedBox(height: 16),
                Text(tr(LanguageKeys.moreInfo),
                    style: stylePoppins(
                        fontSize: 14, fontWeight: FontWeight.w500)),
                const SizedBox(height: 8),
                TextFormField(
                  controller: moreInfoController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    hintText: tr(LanguageKeys.enterMoreInfo),
                    filled: true,
                    fillColor: Colors.grey[100],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 14),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  tr(LanguageKeys.finderFooterText),
                  style: stylePoppins(fontSize: 12, color: AppColors.grey600),
                ),
                const SizedBox(height: 12),
                FormField<bool>(
                  initialValue: consentGiven,
                  validator: (value) =>
                      value == true ? null : 'Consent required',
                  builder: (state) => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Checkbox(
                            visualDensity: const VisualDensity(
                                horizontal: -4, vertical: -4),
                            value: state.value,
                            onChanged: (value) => state.didChange(value),
                            activeColor: AppColors.primary,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              tr(LanguageKeys.agreeLeadTxt),
                              style: stylePoppins(
                                  fontSize: 11, fontWeight: FontWeight.w400),
                            ),
                          ),
                        ],
                      ),
                      if (state.hasError)
                        Padding(
                          padding: const EdgeInsets.only(left: 16),
                          child: Text(state.errorText!,
                              style: const TextStyle(
                                  color: Colors.red, fontSize: 12)),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                GestureDetector(
                  onTap: () {
                    if (_formKey.currentState!.validate()) {
                      widget.onSubmit?.call();
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
                      child: Text(
                        tr(LanguageKeys.submitALead),
                        style: stylePoppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
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
}
