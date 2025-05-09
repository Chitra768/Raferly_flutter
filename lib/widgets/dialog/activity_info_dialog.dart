import 'package:flutter/material.dart';
import 'package:referaly/resources/app_assets.dart';
import 'package:referaly/resources/app_colors.dart';
import 'package:referaly/resources/text_style.dart';

/// Dialog showing activity tips with icons and descriptions
class ActivityInfoDialog extends StatelessWidget {
  const ActivityInfoDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final items = [
      {
        'icon': AppAssets.imgRefreal,
        'title': 'Add teammates',
        'description': 'Grant them access to your referrers and leads.',
      },
      {
        'icon': AppAssets.imgAddDoc,
        'title': 'Share documents',
        'description': 'Upload files for your referrers to view and share.',
      },
      {
        'icon': AppAssets.imgShare,
        'title': 'Invite referrers',
        'description': 'Share contracts and invite new referrers.',
      },
      {
        'icon': AppAssets.imgAddNotification,
        'title': 'Notify referrers',
        'description': 'Send updates directly to your referrers.',
      },
    ];

    return AlertDialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      contentPadding: const EdgeInsets.all(16),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(items.length * 2 - 1, (i) {
          if (i.isOdd) {
            // divider between items
            return Divider(color: Colors.grey[300], height: 1);
          }
          final index = i ~/ 2;
          final item = items[index];
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset(
                  item['icon'] as String,
                  width: 24,
                  height: 24,
                  color: AppColors.primary,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: '${item['title']}: ',
                          style: stylePoppins(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.black),
                        ),
                        TextSpan(
                          text: item['description'] as String,
                          style: stylePoppins(fontSize: 12, color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
