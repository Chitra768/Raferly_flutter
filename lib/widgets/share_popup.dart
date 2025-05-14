import 'package:flutter/material.dart';
// TODO: Uncomment the next line and run `flutter pub add share_plus` in your project root.
// import 'package:share_plus/share_plus.dart';
import 'package:flutter/services.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:referaly/resources/app_colors.dart';
import 'package:referaly/resources/text_style.dart';

class SharePopup extends StatelessWidget {
  final String title;
  final String link;

  const SharePopup({Key? key, required this.title, required this.link})
      : super(key: key);

  void _share(BuildContext context, String platform) {
    // TODO: Uncomment the next line after adding share_plus to your pubspec.yaml
    // Share.share(link);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
          content: Text('Sharing is not enabled. Please install share_plus.')),
    );
  }

  void _copyLink(BuildContext context) {
    Clipboard.setData(ClipboardData(text: link));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Link copied to clipboard!')),
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
                    child: Text(title,
                        style: stylePoppins(
                            fontWeight: FontWeight.bold, fontSize: 18)),
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
                Text("Or Copy the Link Below",
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
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.link, color: Colors.purple, size: 90),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text("Share Direct",
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
                  icon: const Icon(Icons.chat,
                      color: Colors.green, size: 32), // WhatsApp placeholder
                  onPressed: () => _share(context, 'whatsapp'),
                ),
                IconButton(
                  icon: const Icon(Icons.email, color: Colors.blue, size: 32),
                  onPressed: () => _share(context, 'email'),
                ),
                IconButton(
                  icon: const Icon(Icons.business,
                      color: Colors.blueAccent,
                      size: 32), // LinkedIn placeholder
                  onPressed: () => _share(context, 'linkedin'),
                ),
                IconButton(
                  icon: const Icon(Icons.thumb_up,
                      color: Colors.blue, size: 32), // Facebook placeholder
                  onPressed: () => _share(context, 'facebook'),
                ),
                IconButton(
                  icon: const Icon(Icons.camera_alt,
                      color: Colors.purple, size: 32), // Instagram placeholder
                  onPressed: () => _share(context, 'instagram'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
