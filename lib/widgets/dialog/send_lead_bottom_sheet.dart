import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:get/get.dart';
import 'package:referaly/apis/api_result.dart';
import 'package:referaly/apis/rest_auth.dart';
import 'package:referaly/controller/controller_main_professional.dart';
import 'package:referaly/helpers/agency_colleague_access_helper.dart';
import 'package:referaly/languages/languagekeys.dart';
import 'package:referaly/resources/app_assets.dart';
import 'package:referaly/resources/app_colors.dart';
import 'package:referaly/resources/app_preference.dart';
import 'package:referaly/resources/text_style.dart';
import 'package:referaly/utils/translations.dart';
import 'package:referaly/widgets/dialog/success_popup.dart';
import 'package:share_plus/share_plus.dart';

/// Unified bottom sheet to send a lead
/// - Tab 1 (default): Contact Form sharing (copy/share link)
/// - Tab 2: Manual Entry (inline quick form)
class SendLeadBottomSheet extends StatefulWidget {
  final String dealId;
  final String? companyName;
  final String? commissionValue;
  final String? formUrl; // may be empty if not provided by API

  const SendLeadBottomSheet({
    super.key,
    required this.dealId,
    this.companyName,
    this.commissionValue,
    this.formUrl,
  });

  @override
  State<SendLeadBottomSheet> createState() => _SendLeadBottomSheetState();
}

class _SendLeadBottomSheetState extends State<SendLeadBottomSheet> {
  bool showContactForm = false; // default tab

  // Manual entry controllers
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _firstName = TextEditingController();
  final TextEditingController _lastName = TextEditingController();
  final TextEditingController _phone = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _note = TextEditingController();
  bool consent = false;
  bool submitting = false;

  @override
  void dispose() {
    _firstName.dispose();
    _lastName.dispose();
    _phone.dispose();
    _email.dispose();
    _note.dispose();
    super.dispose();
  }

  Future<void> _submitManual() async {
    final profile =
        Get.find<ControllerMainProfessional>().profile.value?.data;
    if (!AgencyColleagueAccessHelper.guardEdit(
        profile, AgencyPermission.leadsSent)) {
      return;
    }
    if (!(_formKey.currentState?.validate() ?? false)) return;
    if (!consent) {
      Get.snackbar(
        tr(LanguageKeys.error),
        tr(LanguageKeys.pleaseAcceptTerms),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }
  final currentLanguage = AppPreference.getLanguage();
    setState(() => submitting = true);
    try {
      final result = await RESTAuth.createLead(
        _firstName.text.trim(),
        _lastName.text.trim(),
        _phone.text.trim(),
        _email.text.trim(),
        _note.text.trim(),
        tr(LanguageKeys.mySelf),
        widget.dealId,
        '', // business_deal_id (optional)
        '', // business_referrer_id (optional)
        '', 
        currentLanguage,
        // created_by (optional)
      );

      if (result is ApiSuccess) {
        if (Get.isBottomSheetOpen ?? false) {
          Get.back();
        } else if (Navigator.of(context).canPop()) {
          Navigator.of(context).pop();
        }
        Get.dialog(
          SuccessPopup(
            message: tr(LanguageKeys.leadAddedSuccessfully),
          ),
          barrierDismissible: false,
        );
      } else if (result is ApiFailure) {
        Get.snackbar(
          tr(LanguageKeys.error),
          result.error.message ?? tr(LanguageKeys.somethingWentWrong),
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        tr(LanguageKeys.error),
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      if (mounted) setState(() => submitting = false);
    }
  }

  void _copyLink() {
    final url = (widget.formUrl ?? '').trim();
    if (url.isEmpty) return;
    Clipboard.setData(ClipboardData(text: url));
    Get.snackbar(
      tr(LanguageKeys.success),
      tr(LanguageKeys.linkCopied),
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
  }

  Future<void> _importFromContacts() async {
    try {
      final status = await FlutterContacts.requestPermission();
      if (!status) {
        Get.snackbar(
          tr(LanguageKeys.error),
          tr(LanguageKeys.contactPermissionDenied),
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }

      final contacts = await FlutterContacts.getContacts(
        withProperties: true,
        withPhoto: false,
      );

      if (contacts.isEmpty) {
        Get.snackbar(
          tr(LanguageKeys.error),
          'No contacts found',
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }

      final selected = await showDialog<Contact>(
        context: context,
        builder: (context) {
          final TextEditingController searchController =
              TextEditingController();
          List<Contact> filtered = List.of(contacts);
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              backgroundColor: Colors.white,
              insetPadding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              title: Text(
                tr(LanguageKeys.selectContact),
                style:
                    const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              ),
              content: SizedBox(
                width: double.maxFinite,
                height: MediaQuery.of(context).size.height * 0.6,
                child: Column(
                  children: [
                    TextField(
                      controller: searchController,
                      decoration: InputDecoration(
                        hintText: tr(LanguageKeys.searchPlaceholder),
                        filled: true,
                        fillColor: Colors.grey[100],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 14),
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () {
                            searchController.clear();
                            setState(() => filtered = List.of(contacts));
                          },
                        ),
                      ),
                      onChanged: (value) {
                        final v = value.trim().toLowerCase();
                        setState(() {
                          filtered = v.isEmpty
                              ? List.of(contacts)
                              : contacts
                                  .where((c) =>
                                      c.displayName.toLowerCase().contains(v))
                                  .toList();
                        });
                      },
                    ),
                    const SizedBox(height: 12),
                    Expanded(
                      child:
                          filtered.isEmpty && searchController.text.isNotEmpty
                              ? const Center(child: Text('No contacts found'))
                              : ListView.builder(
                                  itemCount: filtered.length,
                                  itemBuilder: (context, index) {
                                    final c = filtered[index];
                                    return ListTile(
                                      title: Text(c.displayName),
                                      subtitle: (c.phones.isNotEmpty)
                                          ? Text(c.phones.first.number)
                                          : null,
                                      onTap: () => Navigator.pop(context, c),
                                    );
                                  },
                                ),
                    ),
                  ],
                ),
              ),
            );
          });
        },
      );

      if (selected != null) {
        final nameParts = selected.displayName.split(' ');
        final firstName = nameParts.isNotEmpty ? nameParts.first : '';
        final lastName =
            nameParts.length > 1 ? nameParts.sublist(1).join(' ') : '';
        _firstName.text = firstName;
        _lastName.text = lastName;
        _phone.text =
            (selected.phones.isNotEmpty) ? selected.phones.first.number : '';
        _email.text =
            (selected.emails.isNotEmpty) ? selected.emails.first.address : '';
      }
    } catch (e) {
      Get.snackbar(
        tr(LanguageKeys.error),
        'Error loading contacts: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    return Container(
      height: media.size.height * 0.9,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 8, 8),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      tr(LanguageKeys.LeadsTitle),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  )
                ],
              ),
            ),

            // Segmented control
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.all(4),
                child: Row(
                  children: [
                    _segmented(
                      label: tr(LanguageKeys.addLeadManually1),
                      selected: !showContactForm,
                      onTap: () => setState(() => showContactForm = false),
                      icon: AppAssets.imgEditIcon,
                    ),
                    _segmented(
                      label: tr(LanguageKeys.contactForm),
                      selected: showContactForm,
                      onTap: () => setState(() => showContactForm = true),
                      icon: AppAssets.imgLink,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 12),

            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: showContactForm
                    ? _buildContactFormShare(context)
                    : _buildManualEntry(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _segmented({
    required String label,
    required bool selected,
    required VoidCallback onTap,
    required String icon,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 40,
          decoration: BoxDecoration(
            color: selected ? AppColors.whiteColor : AppColors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                icon,
                height: 16,
                color: selected ? AppColors.primary : Colors.black,
              ),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  label,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: selected ? AppColors.primary : Colors.black,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContactFormShare(BuildContext context) {
    final url = (widget.formUrl ?? '').trim();
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16 + 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Top share icon
          Center(
            child: Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.12),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Image.asset(
                  AppAssets.imgShare,
                  width: 22,
                  height: 22,
                  color: AppColors.primary,
                ),
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Title
          Text(
            tr(LanguageKeys.shareFormTitle),
            textAlign: TextAlign.center,
            style: stylePoppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF111827),
            ),
          ),

          const SizedBox(height: 8),

          // Subtitle
          Text(
            tr(LanguageKeys.shareFormDescription),
            textAlign: TextAlign.center,
            style: stylePoppins(
              fontSize: 13,
              color: const Color(0xFF6B7280),
              fontWeight: FontWeight.w400,
            ),
          ),

          const SizedBox(height: 20),

          // Benefits card
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.06),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  tr(LanguageKeys.benefitsOfTheShareableForm),
                  style: stylePoppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 12),
                _benefitRow(tr(LanguageKeys.automaticInformationCollection)),
                const SizedBox(height: 10),
                _benefitRow(tr(LanguageKeys.realTimeSubmissionTracking)),
                const SizedBox(height: 10),
                _benefitRow(
                    tr(LanguageKeys.automaticAttributionToYourReferral)),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Personalized link label
          Text(
            tr(LanguageKeys.yourPersonalizedLink),
            style: stylePoppins(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF374151),
            ),
          ),

          const SizedBox(height: 8),

          // Link field + copy button
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 48,
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFE5E7EB)),
                  ),
                  child: Text(
                    url.isEmpty ? tr(LanguageKeys.notAvialble) : url,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: stylePoppins(
                        fontSize: 14, color: const Color(0xFF111827)),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              GestureDetector(
                onTap: url.isEmpty ? null : _copyLink,
                child: Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: SvgPicture.asset(
                      AppAssets.imgCopy,
                      width: 18,
                      height: 18,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Share button
          SizedBox(
            height: 52,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              onPressed: url.isEmpty
                  ? null
                  : () {
                      Share.share(url);
                    },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    AppAssets.imgShareIcon,
                    width: 18,
                    height: 18,
                    color: Colors.white,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    tr(LanguageKeys.shareForm),
                    style: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _benefitRow(String text) {
    return Row(
      children: [
        Container(
          width: 22,
          height: 22,
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.12),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.check,
            size: 14,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: stylePoppins(
              fontSize: 13,
              color: AppColors.primary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildManualEntry(BuildContext context) {
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(16, 8, 16, 16 + 24 + keyboardHeight),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: _importFromContacts,
              behavior: HitTestBehavior.opaque,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            tr(LanguageKeys.importFromContact),
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primary,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            tr(LanguageKeys.quickFillForm),
                            style: const TextStyle(
                                fontSize: 12, color: AppColors.primary),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.perm_contact_calendar,
                          color: AppColors.primary, size: 18),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            _fieldLabel(tr(LanguageKeys.firstName), required: true),
            const SizedBox(height: 6),
            _textField(_firstName, tr(LanguageKeys.firstName), required: true),
            const SizedBox(width: 12),
            _fieldLabel(tr(LanguageKeys.lastName), required: true),
            const SizedBox(height: 6),
            _textField(_lastName, tr(LanguageKeys.lastName), required: true),
            const SizedBox(height: 12),
            _fieldLabel(tr(LanguageKeys.phoneNumber), required: true),
            const SizedBox(height: 6),
            _textField(_phone, tr(LanguageKeys.enterNum),
                keyboard: TextInputType.phone, required: true),
            const SizedBox(height: 12),
            _fieldLabel(tr(LanguageKeys.email), required: true),
            const SizedBox(height: 6),
            _textField(_email, tr(LanguageKeys.enterEmail),
                keyboard: TextInputType.emailAddress),
            const SizedBox(height: 12),
            _fieldLabel(tr(LanguageKeys.description), required: true),
            const SizedBox(height: 6),
            _textField(_note, tr(LanguageKeys.detailAboutLead), maxLines: 3),
            const SizedBox(height: 8),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Checkbox(
                  value: consent,
                  onChanged: (v) => setState(() => consent = v ?? false),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 12.0),
                    child: Text(
                      tr(LanguageKeys.agreeLeadTxt),
                      style: stylePoppins(fontSize: 10),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                // Expanded(
                //   child: OutlinedButton(
                //     onPressed: () => Navigator.pop(context),
                //     style: OutlinedButton.styleFrom(
                //       side:
                //           const BorderSide(color: Color(0xFFE5E7EB), width: 1),
                //       backgroundColor: const Color(0xFFF3F4F6),
                //       shape: RoundedRectangleBorder(
                //           borderRadius: BorderRadius.circular(12)),
                //       padding: const EdgeInsets.symmetric(vertical: 12),
                //     ),
                //     child: Text(
                //       tr(LanguageKeys.cancel),
                //       style: stylePoppins(
                //           fontSize: 14,
                //           fontWeight: FontWeight.w500,
                //           color: const Color(0xFF374151)),
                //     ),
                //   ),
                // ),
                // const SizedBox(width: 12),
                Expanded(
                  child: SizedBox(
                    height: 48,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: submitting ? null : _submitManual,
                      child: submitting
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                  color: Colors.white, strokeWidth: 2),
                            )
                          : Text(
                              tr(LanguageKeys.invitedSubmitLead),
                              style: const TextStyle(color: Colors.white),
                            ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _textField(TextEditingController c, String hint,
      {bool required = false, int maxLines = 1, TextInputType? keyboard}) {
    return TextFormField(
      controller: c,
      maxLines: maxLines,
      keyboardType: keyboard,
      validator: required
          ? (v) =>
              (v == null || v.trim().isEmpty) ? '${hint} is required' : null
          : null,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: Colors.grey[100],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
    );
  }

  Widget _fieldLabel(String text, {bool required = false}) {
    return Row(
      children: [
        Text(text, style: stylePoppins(fontWeight: FontWeight.w500)),
        if (required) ...[
          const SizedBox(width: 4),
          const Text('*', style: TextStyle(color: Colors.red)),
        ],
      ],
    );
  }
}
