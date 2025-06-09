import 'package:flutter/material.dart';
// TODO: Uncomment the next line and run `flutter pub add share_plus` in your project root.
// import 'package:share_plus/share_plus.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:referaly/languages/languagekeys.dart';
import 'package:referaly/resources/app_assets.dart';
import 'package:referaly/resources/app_colors.dart';
import 'package:referaly/resources/text_style.dart';
import 'package:referaly/utils/translations.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class SharePopup extends StatelessWidget {
  final String title;
  final String link;

  const SharePopup({Key? key, required this.title, required this.link})
      : super(key: key);

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

    if (url != null && await canLaunchUrl(Uri.parse(url))) {
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

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      insetPadding: const EdgeInsets.all(10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                Expanded(
                  child: Center(
                    child: Text(
                      tr(LanguageKeys.share),
                      textAlign: TextAlign.center,
                      style: stylePoppins(
                        fontWeight: FontWeight.w500,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            QrImageView(
              data: link,
              version: QrVersions.auto,
              size: 170.0,
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: Divider(thickness: 1, endIndent: 10),
                ),
                Text(tr(LanguageKeys.copyLinkBelow),
                    style: stylePoppins(
                        fontWeight: FontWeight.w500,
                        fontSize: 13,
                        color: AppColors.greyFontColor)),
                Expanded(
                  child: Divider(thickness: 1, indent: 10),
                ),
              ],
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: () => _copyLink(context),
              child: Container(
                height: 250,
                width: 250,
                padding: const EdgeInsets.all(26),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.primary),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      AppAssets.imgLink,
                      width: 90,
                      color: AppColors.primary,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(tr(LanguageKeys.shareDirect),
                style: stylePoppins(
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                    color: AppColors.bgDark)),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Replace these with your own SVGs or images for each platform
                IconButton(
                  icon: Image.asset(AppAssets.imgWhatsapp,
                      width: 32), // WhatsApp placeholder
                  // WhatsApp placeholder
                  onPressed: () => _share(context, 'whatsapp', link),
                ),
                IconButton(
                  icon: Image.asset(AppAssets.imgMessage, width: 32),
                  onPressed: () => _share(context, 'message', link),
                ),
                IconButton(
                  icon: Image.asset(AppAssets.imgLinkedin,
                      width: 32), // LinkedIn placeholder
                  onPressed: () => _share(context, 'linkedin', link),
                ),
                IconButton(
                  icon: Image.asset(AppAssets.imgFacebook,
                      width: 32), // Facebook placeholder
                  onPressed: () => _share(context, 'facebook', link),
                ),
                IconButton(
                  icon: Image.asset(AppAssets.imgEmail, width: 35),
                  onPressed: () => _share(context, 'email', link),
                ),

                IconButton(
                  icon: Image.asset(AppAssets.imgInstagram,
                      width: 32), // Instagram placeholder
                  onPressed: () => _share(context, 'instagram', link),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
