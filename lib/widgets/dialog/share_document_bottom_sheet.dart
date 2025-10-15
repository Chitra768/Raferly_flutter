import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:referaly/resources/app_assets.dart';
import 'package:referaly/resources/app_colors.dart';
import 'package:referaly/resources/text_style.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:referaly/languages/languagekeys.dart';
import 'package:referaly/utils/translations.dart';

class ShareDocumentBottomSheet extends StatefulWidget {
  final String documentName;
  final String documentUrl;

  const ShareDocumentBottomSheet({
    super.key,
    required this.documentName,
    required this.documentUrl,
  });

  @override
  State<ShareDocumentBottomSheet> createState() =>
      _ShareDocumentBottomSheetState();
}

class _ShareDocumentBottomSheetState extends State<ShareDocumentBottomSheet> {
  final TextEditingController _linkController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _linkController.text = widget.documentUrl;
  }

  @override
  void dispose() {
    _linkController.dispose();
    super.dispose();
  }

  void _copyLink() {
    Clipboard.setData(ClipboardData(text: widget.documentUrl));
    Get.snackbar(
      tr(LanguageKeys.success),
      tr(LanguageKeys.linkCopied),
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
  }

  void _shareOnLinkedIn() {
    final url =
        'https://www.linkedin.com/sharing/share-offsite/?url=${Uri.encodeComponent(widget.documentUrl)}';
    _launchUrl(url);
  }

  void _shareOnTwitter() {
    final url =
        'https://twitter.com/intent/tweet?url=${Uri.encodeComponent(widget.documentUrl)}';
    _launchUrl(url);
  }

  void _shareOnWhatsApp() {
    final url =
        'https://wa.me/?text=${Uri.encodeComponent(widget.documentUrl)}';
    _launchUrl(url);
  }

  void _shareOnEmail() {
    final url =
        'mailto:?subject=${Uri.encodeComponent(widget.documentName)}&body=${Uri.encodeComponent(widget.documentUrl)}';
    _launchUrl(url);
  }

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Purple Header Section
          Container(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
            decoration: const BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Column(
              children: [
                // Close Button
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: const Icon(
                          Icons.close,
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
                    ),
                  ],
                ),
                // Share Icon
                Container(
                  width: 40,
                  height: 40,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Icon(
                    Icons.share,
                    color: AppColors.whiteColor,
                    size: 20,
                  ),
                ),
                const SizedBox(height: 16),
                // Title
                Text(
                  tr(LanguageKeys.shareProfessionalDocuments),
                  textAlign: TextAlign.center,
                  style: stylePoppins(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                // Subtitle
                Text(
                  tr(LanguageKeys.amplifyRecommendationNetwork),
                  textAlign: TextAlign.center,
                  style: stylePoppins(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: Colors.white.withOpacity(0.9),
                  ),
                ),
              ],
            ),
          ),

          // White Content Area
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Improve Quality Section
                  _buildImproveQualitySection(),
                  const SizedBox(height: 24),

                  // Quick Share Options Section
                  _buildQuickShareOptionsSection(),
                  const SizedBox(height: 24),

                  // Why Share Documents Section
                  _buildWhyShareSection(),
                  const SizedBox(height: 24),

                  // Impact Statistics Section
                  _buildImpactStatisticsSection(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImproveQualitySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          tr(LanguageKeys.improveRecommendationQuality),
          textAlign: TextAlign.center,
          style: stylePoppins(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          tr(LanguageKeys.shareProfessionalDocumentsDescription),
          textAlign: TextAlign.center,
          style: stylePoppins(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: Colors.grey.shade700,
          ),
        ),
      ],
    );
  }

  Widget _buildQuickShareOptionsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            SvgPicture.asset(AppAssets.imgRevert, width: 20, height: 20),
            const SizedBox(width: 8),
            Text(
              tr(LanguageKeys.quickShareOptions),
              style: stylePoppins(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.whiteColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // Share Link Section
              Row(
                children: [
                  Text(tr(LanguageKeys.shareLink),
                      style: stylePoppins(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.black)),
                  const Spacer(),
                  SvgPicture.asset(AppAssets.imgLink,
                      width: 15, height: 15, color: AppColors.primary),
                ],
              ),
              const SizedBox(height: 8),

              // Link Input Field
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey.shade300),
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
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: SvgPicture.asset(AppAssets.imgCopy,
                          width: 18, height: 18),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // Security Message
              Row(
                children: [
                  Icon(
                    Icons.security,
                    color: Colors.grey.shade600,
                    size: 16,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    tr(LanguageKeys.secureLinkExpires30Days),
                    style: stylePoppins(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        // Social Media Buttons
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildSocialButton(
              icon: AppAssets.imgLinkedinBox,
              label: 'LinkedIn',
              color: const Color(0xFF0077B5),
              onTap: _shareOnLinkedIn,
            ),
            _buildSocialButton(
              icon: AppAssets.imgTwitterBox,
              label: 'Twitter',
              color: const Color(0xFF1DA1F2),
              onTap: _shareOnTwitter,
            ),
            _buildSocialButton(
              icon: AppAssets.imgWhatsappBox,
              label: 'WhatsApp',
              color: const Color(0xFF25D366),
              onTap: _shareOnWhatsApp,
            ),
            _buildSocialButton(
              icon: AppAssets.imgMessageBox,
              label: 'Email',
              color: Colors.grey.shade300,
              onTap: _shareOnEmail,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSocialButton({
    required String icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(icon, width: 80, height: 80),
        ],
      ),
    );
  }

  Widget _buildWhyShareSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(
              Icons.lightbulb,
              color: AppColors.primary,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              tr(LanguageKeys.whyShareDocuments),
              style: stylePoppins(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        _buildBenefitItem(
          tr(LanguageKeys.betterQualityRecommendations),
          tr(LanguageKeys.informedClientsMakeBetterChoices),
        ),
        const SizedBox(height: 12),
        _buildBenefitItem(
          tr(LanguageKeys.buildTrustCredibility),
          tr(LanguageKeys.transparencyIncreasesConversion),
        ),
        const SizedBox(height: 12),
        _buildBenefitItem(
          tr(LanguageKeys.expandYourNetwork),
          tr(LanguageKeys.easySharingDevelopsInfluence),
        ),
      ],
    );
  }

  Widget _buildBenefitItem(String title, String subtitle) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            color: Colors.green.withOpacity(0.3),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.check,
            color: Colors.green,
            size: 14,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: stylePoppins(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: stylePoppins(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildImpactStatisticsSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            tr(LanguageKeys.impactStatistics),
            textAlign: TextAlign.center,
            style: stylePoppins(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: _buildStatisticItem(
                    '3.2x', tr(LanguageKeys.higherConversionRate)),
              ),
              Expanded(
                child: _buildStatisticItem(
                    '89%', tr(LanguageKeys.customerSatisfaction)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatisticItem(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: stylePoppins(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          textAlign: TextAlign.center,
          style: stylePoppins(
            fontSize: 12,
            fontWeight: FontWeight.w400,
            color: Colors.black,
          ),
        ),
      ],
    );
  }
}
