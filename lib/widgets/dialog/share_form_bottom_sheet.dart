import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:referaly/resources/app_assets.dart';
import 'package:referaly/resources/app_colors.dart';
import 'package:referaly/widgets/qr_code_popup.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:referaly/languages/languagekeys.dart';
import 'package:referaly/utils/translations.dart';

class ShareFormBottomSheet extends StatefulWidget {
  final String formUrl;
  final VoidCallback? onPreviewForm;

  const ShareFormBottomSheet({
    super.key,
    required this.formUrl,
    this.onPreviewForm,
  });

  @override
  State<ShareFormBottomSheet> createState() => _ShareFormBottomSheetState();
}

class _ShareFormBottomSheetState extends State<ShareFormBottomSheet> {
  bool isLinkSelected = true;
  final TextEditingController _linkController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _linkController.text = widget.formUrl;
  }

  @override
  void dispose() {
    _linkController.dispose();
    super.dispose();
  }

  void _copyLink() {
    Clipboard.setData(ClipboardData(text: widget.formUrl));
    Get.snackbar(
      tr(LanguageKeys.success),
      tr(LanguageKeys.linkCopied),
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
  }

  void _shareOnFacebook() {
    final url =
        'https://www.facebook.com/sharer/sharer.php?u=${Uri.encodeComponent(widget.formUrl)}';
    _launchUrl(url);
  }

  void _shareOnTwitter() {
    final url =
        'https://twitter.com/intent/tweet?url=${Uri.encodeComponent(widget.formUrl)}';
    _launchUrl(url);
  }

  void _shareOnWhatsApp() {
    final url = 'https://wa.me/?text=${Uri.encodeComponent(widget.formUrl)}';
    _launchUrl(url);
  }

  void _shareOnLinkedIn() {
    final url =
        'https://www.linkedin.com/sharing/share-offsite/?url=${Uri.encodeComponent(widget.formUrl)}';
    _launchUrl(url);
  }

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  void _showFormPreview() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          insetPadding: const EdgeInsets.all(16),
          backgroundColor: Colors.transparent,
          child: Container(
            width: MediaQuery.of(context).size.width * 0.9,
            height: MediaQuery.of(context).size.height * 0.8,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                // Header with purple background
                Container(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                  decoration: const BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              tr(LanguageKeys.shareReferenceForm),
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              tr(LanguageKeys.allowExternalForm),
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.white70,
                              ),
                            ),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.close,
                            color: Colors.white,
                            size: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Form Preview Content
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        // Form Preview Header
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: AppColors.primary.withOpacity(0.1),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.visibility_outlined,
                                color: AppColors.primary,
                                size: 16,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              tr(LanguageKeys.formPreview),
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 12),

                        // Form Preview Container
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade50,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.grey.shade200),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              // Business Referral Form Title
                              Text(
                                tr(LanguageKeys.businessReferralForm),
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.primary,
                                ),
                              ),

                              const SizedBox(height: 12),

                              // Company and Commission Info
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    '${tr(LanguageKeys.company)}: TechCorp Solutions',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey.shade700,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '${tr(LanguageKeys.commission)}: \$500',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green,
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 16),

                              // Your Information Section
                              _buildFormSection(
                                title: tr(LanguageKeys.yourInformation),
                                fields: [
                                  _buildFormField(
                                      tr(LanguageKeys.enterNameAndLastnameStar),
                                      isRequired: true),
                                  _buildFormField(tr(LanguageKeys.enterEmails),
                                      isRequired: true),
                                  _buildFormField(tr(LanguageKeys.enterPhone)),
                                  _buildFormField(tr(LanguageKeys.enterJobs)),
                                  _buildFormField(tr(LanguageKeys.enterCities)),
                                ],
                              ),

                              const SizedBox(height: 16),

                              // Lead Information Section
                              _buildFormSection(
                                title: tr(LanguageKeys.leadInformation),
                                fields: [
                                  _buildFormField(
                                      tr(LanguageKeys.enterNameAndLastname)),
                                  _buildFormField(tr(LanguageKeys.enterPhone)),
                                  _buildFormField(tr(LanguageKeys.enterEmails)),
                                  _buildFormField(
                                      tr(LanguageKeys.enterDescription),
                                      isTextArea: true),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Done Button
                Container(
                  padding: const EdgeInsets.all(16),
                  child: SizedBox(
                    width: double.infinity,
                    height: 44,
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        tr(LanguageKeys.done),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildFormSection(
      {required String title, required List<Widget> fields}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 10),
        ...fields,
      ],
    );
  }

  Widget _buildFormField(String label,
      {bool isRequired = false, bool isTextArea = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w500,
            color: Colors.grey.shade700,
          ),
        ),
        const SizedBox(height: 4),
        Container(
          alignment: Alignment.center,
          height: isTextArea ? 60 : 32,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: isTextArea
              ? TextField(
                  maxLines: 3,
                  textAlign: TextAlign.start,
                  textAlignVertical: TextAlignVertical.top,
                  style: const TextStyle(fontSize: 12),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
                    hintText: '${label.toLowerCase().replaceAll('*', '')}...',
                    hintStyle:
                        TextStyle(color: Colors.grey.shade400, fontSize: 12),
                  ),
                )
              : TextField(
                  textAlign: TextAlign.start,
                  textAlignVertical: TextAlignVertical.center,
                  style: const TextStyle(fontSize: 12),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.fromLTRB(8, 0, 0, 15),
                    hintText: '${label.toLowerCase().replaceAll('*', '')}...',
                    hintStyle:
                        TextStyle(color: Colors.grey.shade400, fontSize: 12),
                  ),
                ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      tr(LanguageKeys.shareReferenceForm),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(13),
                    ),
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      iconSize: 14,
                      icon: const Icon(Icons.close, color: Colors.black),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                ],
              ),
            ),

            // Content
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  // Information Section
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: SvgPicture.asset(AppAssets.imgInfoActivity),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                tr(LanguageKeys.shareExternalForm),
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primary,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                tr(LanguageKeys.shareExternalFormDescription),
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: AppColors.primary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Form Preview Section
                  GestureDetector(
                    onTap: _showFormPreview,
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withOpacity(0.1),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.visibility_outlined,
                              color: AppColors.primary,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  tr(LanguageKeys.formPreview),
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  tr(LanguageKeys.formPreviewDescription),
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.grey.shade400,
                            size: 16,
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Sharing Method Selection
                  Row(
                    children: [
                      SvgPicture.asset(AppAssets.imgRevert,
                          width: 20, height: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          tr(LanguageKeys.chooseSharingMethod),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // Method Selection Buttons
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () => setState(() => isLinkSelected = true),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 12, horizontal: 16),
                            decoration: BoxDecoration(
                              color: isLinkSelected
                                  ? AppColors.primary
                                  : Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SvgPicture.asset(AppAssets.imgLink,
                                    width: 20,
                                    height: 20,
                                    color: isLinkSelected
                                        ? Colors.white
                                        : Colors.grey.shade600),
                                const SizedBox(width: 8),
                                Text(
                                  tr(LanguageKeys.link),
                                  style: TextStyle(
                                    color: isLinkSelected
                                        ? Colors.white
                                        : Colors.grey.shade600,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            setState(() => isLinkSelected = false);
                            Get.to(() => QRCodePopup(
                                  title: tr(LanguageKeys.shareReferenceForm),
                                  link: widget.formUrl,
                                ));
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 12, horizontal: 16),
                            decoration: BoxDecoration(
                              color: !isLinkSelected
                                  ? AppColors.primary
                                  : Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.qr_code,
                                  color: !isLinkSelected
                                      ? Colors.white
                                      : Colors.grey.shade600,
                                  size: 18,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  tr(LanguageKeys.qrCode),
                                  style: TextStyle(
                                    color: !isLinkSelected
                                        ? Colors.white
                                        : Colors.grey.shade600,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.whiteColor,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: Column(
                      children: [
                        // Link Sharing Section
                        // Share Link Icon and Title
                        Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: AppColors.primary.withOpacity(0.1),
                                  shape: BoxShape.circle,
                                ),
                                child: SvgPicture.asset(AppAssets.imgLink,
                                    width: 20,
                                    height: 20,
                                    color: AppColors.primary),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                tr(LanguageKeys.shareLinks),
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                tr(LanguageKeys.copyLinkOrShareDirectly),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 20),

                        // Link Input Field
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 8),
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade100,
                                  borderRadius: BorderRadius.circular(8),
                                  border:
                                      Border.all(color: Colors.grey.shade300),
                                ),
                                child: TextField(
                                  controller: _linkController,
                                  readOnly: true,
                                  style: const TextStyle(fontSize: 14),
                                  decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    isDense: true,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            GestureDetector(
                              onTap: _copyLink,
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: AppColors.primary,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: SvgPicture.asset(AppAssets.imgCopy,
                                    width: 16, height: 16),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 20),

                        // Social Media Sharing
                        Align(
                          alignment: Alignment.center,
                          child: Text(
                            tr(LanguageKeys.shareOnSocialNetworks),
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                            ),
                          ),
                        ),

                        const SizedBox(height: 12),

                        // Social Media Buttons
                        Align(
                          alignment: Alignment.center,
                          child: Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            alignment: WrapAlignment.center,
                            children: [
                              _buildSocialButton(
                                icon: AppAssets.imgFacebook,
                                color: const Color(0xFF1877F2),
                                onTap: _shareOnFacebook,
                                iconColor: Colors.white,
                              ),
                              _buildSocialButton(
                                icon: AppAssets.imgEmail,
                                color: const Color(0xFF1DA1F2),
                                onTap: _shareOnTwitter,
                                iconColor: Colors.white,
                              ),
                              _buildSocialButton(
                                icon: AppAssets.imgWhatsapp,
                                color: const Color(0xFF25D366),
                                onTap: _shareOnWhatsApp,
                                iconColor: Colors.white,
                              ),
                              _buildSocialButton(
                                icon: AppAssets.imgLinkedin,
                                color: const Color(0xFF0077B5),
                                onTap: _shareOnLinkedIn,
                                iconColor: Colors.white,
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 20),
                      ],
                    ),
                  ),

                  // Bottom padding
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSocialButton({
    required String icon,
    required Color color,
    required Color iconColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 50,
        height: 50,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Image.asset(
          icon,
          width: 14,
          height: 14,
        ),
      ),
    );
  }
}
