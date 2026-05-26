import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:referaly/languages/languagekeys.dart';
import 'package:referaly/resources/app_assets.dart';
import 'package:referaly/resources/app_colors.dart';
import 'package:referaly/resources/text_style.dart';
import 'package:referaly/utils/translations.dart';
import 'package:referaly/widgets/qr_code_popup.dart';
import 'package:referaly/widgets/contact_selection_screen.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class SharePopup extends StatelessWidget {
  final String title;
  final String link;
  /// When set, shows “Par email” row; closes this dialog then runs (navigate to add-by-email flow, etc.).
  final VoidCallback? onInviteByEmail;

  const SharePopup({
    Key? key,
    required this.title,
    required this.link,
    this.onInviteByEmail,
  }) : super(key: key);

  void _share(BuildContext context, String platform, String link) async {
    final encodedLink = Uri.encodeComponent(link);
    String? url;

    switch (platform) {
      case 'whatsapp':
        url = 'whatsapp://send?text=$encodedLink';
        break;

      case 'message':
        url = 'sms:?body=$encodedLink';
        break;

      case 'email':
        url = 'mailto:?subject=Check this out&body=$encodedLink';
        break;

      case 'facebook':
        url = 'https://www.facebook.com/sharer/sharer.php?u=$encodedLink';
        break;

      case 'linkedin':
        url =
            'https://www.linkedin.com/sharing/share-offsite/?url=$encodedLink';
        break;

      case 'instagram':
        // Instagram does not support direct link sharing via URL scheme,
        // you can instead fallback to a general share sheet:
        Share.share(link);
        return;

      default:
        Share.share(link);
        return;
    }

    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    } else {
      // fallback: open general share sheet
      Share.share(link);
    }
  }

  void _copyLink(BuildContext context) {
    Clipboard.setData(ClipboardData(text: link));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(tr(LanguageKeys.linkCopiedToClipboard)),
      ),
    );
  }

  void _selectMultipleContacts(BuildContext context) {
    Navigator.of(context).pop(); // Close the share popup first
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ContactSelectionScreen(
          link: link,
          defaultMessage: tr(LanguageKeys.defaultReferralInviteMessage),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(16),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white,
        ),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.9,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Purple Header Section
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: Column(
                  children: [
                    // Close button
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        GestureDetector(
                          onTap: () => Navigator.of(context).pop(),
                          child: const Icon(
                            Icons.close,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // Icons row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: SvgPicture.asset(
                            AppAssets.imgAppLgo,
                            width: 10,
                            height: 10,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Icon(
                          Icons.swap_horiz,
                          color: Colors.white,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Icon(
                            Icons.person_add_alt_1,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    // Title
                    Text(
                      tr(LanguageKeys.inviteBusinessReferrer),
                      textAlign: TextAlign.center,
                      style: stylePoppins(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Subtitle
                    Text(
                      tr(LanguageKeys.inviteBusinessReferrerDescription),
                      textAlign: TextAlign.center,
                      style: stylePoppins(
                        fontWeight: FontWeight.normal,
                        fontSize: 12,
                        color: const Color.fromARGB(255, 220, 194, 194).withOpacity(0.9),
                      ),
                    ),
                  ],
                ),
              ),
              // White Content Section - Scrollable
              Flexible(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        // Invite Multiple Contacts Section
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: AppColors.primaryLightPink,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  // Icon with three people
                                  Container(
                                    width: 36,
                                    height: 36,
                                    padding: const EdgeInsets.all(8),
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: AppColors.primary,
                                    ),
                                    child: SvgPicture.asset(
                                      AppAssets.imgGroup,
                                      width: 10,
                                      height: 10,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        // Title
                                        Text(
                                          tr(LanguageKeys
                                              .inviteMultipleContacts),
                                          textAlign: TextAlign.center,
                                          style: stylePoppins(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                            color: Colors.black,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        // Description
                                        Text(
                                          tr(LanguageKeys
                                              .saveTimeInviteEveryone),
                                          textAlign: TextAlign.start,
                                          style: stylePoppins(
                                            fontWeight: FontWeight.normal,
                                            fontSize: 10,
                                            color: Colors.grey.shade600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 20),
                              // Select Contacts Button
                              GestureDetector(
                                onTap: () {
                                  _selectMultipleContacts(context);
                                },
                                child: Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 10),
                                  decoration: BoxDecoration(
                                    color: AppColors.primary,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SvgPicture.asset(
                                        AppAssets.imgSaveActivity,
                                        width: 15,
                                        height: 15,
                                        color: Colors.white,
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        tr(LanguageKeys.selectContactsToInvite),
                                        style: stylePoppins(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 14,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        // Separator
                        Row(
                          children: [
                            Expanded(
                              child: Divider(
                                color: Colors.grey.shade300,
                                thickness: 1,
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12),
                              child: Text(
                                tr(LanguageKeys.orShareIndividually),
                                style: stylePoppins(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Divider(
                                color: Colors.grey.shade300,
                                thickness: 1,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        // QR Code Option
                        GestureDetector(
                          onTap: () {
                            // Close current popup and show QR code popup
                            Navigator.of(context).pop();
                            showDialog(
                              context: context,
                              builder: (context) => QRCodePopup(
                                title: title,
                                link: link,
                              ),
                            );
                          },
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.grey.shade200),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: AppColors.primary.withOpacity(0.1),
                                  ),
                                  child: const Icon(
                                    Icons.qr_code,
                                    color: AppColors.primary,
                                    size: 20,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        tr(LanguageKeys.qrCode),
                                        style: stylePoppins(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 16,
                                          color: Colors.black,
                                        ),
                                      ),
                                      Text(
                                        tr(LanguageKeys.letThemScanToJoin),
                                        style: stylePoppins(
                                          fontWeight: FontWeight.normal,
                                          fontSize: 12,
                                          color: Colors.grey.shade600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Icon(
                                  Icons.chevron_right,
                                  color: Colors.grey.shade400,
                                  size: 20,
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        // Share Link Option
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.grey.shade200),
                          ),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Container(
                                    width: 40,
                                    height: 40,
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: AppColors.primary.withOpacity(0.1),
                                      shape: BoxShape.circle,
                                    ),
                                    child: SvgPicture.asset(
                                      AppAssets.imgLink,
                                      width: 10,
                                      height: 10,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          tr(LanguageKeys.shareLink),
                                          style: stylePoppins(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 16,
                                            color: Colors.black,
                                          ),
                                        ),
                                        Text(
                                          tr(LanguageKeys.copyOrShareDirectly),
                                          style: stylePoppins(
                                            fontWeight: FontWeight.normal,
                                            fontSize: 12,
                                            color: Colors.grey.shade600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              // Link with copy button
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 8),
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade50,
                                  borderRadius: BorderRadius.circular(8),
                                  border:
                                      Border.all(color: Colors.grey.shade200),
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        link.length > 30
                                            ? '${link.substring(0, 30)}...'
                                            : link,
                                        style: stylePoppins(
                                          fontWeight: FontWeight.normal,
                                          fontSize: 12,
                                          color: Colors.grey.shade700,
                                        ),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () => _copyLink(context),
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 12, vertical: 6),
                                        decoration: BoxDecoration(
                                          color: AppColors.primary,
                                          borderRadius:
                                              BorderRadius.circular(6),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            const Icon(
                                              Icons.copy,
                                              color: Colors.white,
                                              size: 14,
                                            ),
                                            const SizedBox(width: 4),
                                            Text(
                                              tr(LanguageKeys.copy),
                                              style: stylePoppins(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 12,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 16),
                              // Social Media Share Buttons
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  _buildSocialButton(
                                    AppAssets.imgFacebook,
                                    'Facebook',
                                    () => _share(context, 'facebook', link),
                                    null,
                                  ),
                                  _buildSocialButton(
                                    AppAssets.imgLinkedin,
                                    'LinkedIn',
                                    () => _share(context, 'linkedin', link),
                                    null,
                                  ),
                                  _buildSocialButton(
                                    AppAssets.imgWhatsapp,
                                    'WhatsApp',
                                    () => _share(context, 'whatsapp', link),
                                    null,
                                  ),
                                  _buildSocialButton(
                                    AppAssets.imgMessage,
                                    'Twitter',
                                    () => _share(context, 'twitter', link),
                                    AppColors.whiteColor,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        if (onInviteByEmail != null) ...[
                          const SizedBox(height: 12),
                          _buildEmailInviteTile(context),
                        ],
                        const SizedBox(height: 16),
                        // Informational Note
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade50,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.grey.shade200),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 20,
                                height: 20,
                                decoration: BoxDecoration(
                                  color: AppColors.whiteColor,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Image.asset(
                                  AppAssets.imgInfo,
                                  width: 10,
                                  height: 10,
                                  color: AppColors.primary,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  tr(LanguageKeys.bySharingYourReferral),
                                  style: stylePoppins(
                                    fontWeight: FontWeight.normal,
                                    fontSize: 11,
                                    color: Colors.grey.shade700,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static const Color _emailTileSlateTitle = Color(0xFF1E293B);
  static const Color _emailTileSlateMuted = Color(0xFF64748B);
  static const Color _emailTileIconBg = Color(0xFFF5F3FF);

  Widget _buildEmailInviteTile(BuildContext context) {
    const chevronGrey = Color(0xFFCBD5E1);
    const borderColor = Color(0xFFE2E8F0);
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: () {
          final cb = onInviteByEmail;
          if (cb == null) return;
          Navigator.of(context).pop();
          cb();
        },
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: borderColor, width: 1),
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: const BoxDecoration(
                  color: _emailTileIconBg,
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.mail_rounded, color: AppColors.primary, size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      tr(LanguageKeys.inviteByEmailTitle),
                      style: stylePoppins(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        color: _emailTileSlateTitle,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      tr(LanguageKeys.inviteByEmailSubtitle),
                      style: stylePoppins(
                        fontWeight: FontWeight.w400,
                        fontSize: 12,
                        color: _emailTileSlateMuted,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: chevronGrey, size: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSocialButton(
      String iconPath, String platform, VoidCallback onTap, Color? color) {
    Color buttonColor;
    switch (platform) {
      case 'Facebook':
        buttonColor = const Color(0xFF1877F2);
        break;
      case 'LinkedIn':
        buttonColor = const Color(0xFF0077B5);
        break;
      case 'WhatsApp':
        buttonColor = const Color(0xFF25D366);
        break;
      case 'Twitter':
        buttonColor = const Color(0xFF1DA1F2);
        break;
      default:
        buttonColor = Colors.grey;
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: buttonColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Image.asset(
            iconPath,
            width: 20,
            height: 20,
            color: color,
          ),
        ),
      ),
    );
  }
}
