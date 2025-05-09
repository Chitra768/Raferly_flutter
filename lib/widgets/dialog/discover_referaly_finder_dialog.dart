import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:referaly/resources/app_assets.dart';
import 'package:referaly/resources/app_colors.dart';
import 'package:referaly/resources/text_style.dart';

/// Dialog presenting the Discover Referaly Finder introduction
class DiscoverReferalyFinderDialog extends StatelessWidget {
  final VoidCallback? onLetsGo;

  const DiscoverReferalyFinderDialog({
    super.key,
    this.onLetsGo,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 20),
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      titlePadding: EdgeInsets.zero,
      title: Padding(
        padding: const EdgeInsets.only(top: 15, right: 15),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.only(top: 15),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SvgPicture.asset(AppAssets.imgAppLgo, width: 30, height: 30),
                    const SizedBox(width: 8),
                    Text(
                      'REFERALY',
                      style: stylePoppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                      ).copyWith(height: 0.5, letterSpacing: 3),
                    ),
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: GestureDetector(
                onTap: () => Get.back(),
                child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                        shape: BoxShape.circle, border: Border.all(color: AppColors.primary, width: 1)),
                    child: Icon(Icons.close, size: 24, color: AppColors.primary)),
              ),
            ),
          ],
        ),
      ),
      contentPadding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
      content: SizedBox(
        width: Get.width,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              Center(
                child: Text(
                  '✨ Discover Referaly Finder! ✨',
                  style: stylePoppins(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 8),
              Center(
                child: Text(
                  'Quickly find qualified professionals to whom you can refer your contacts — with an optional commission!',
                  style: stylePoppins(
                    fontSize: 14,
                    color: AppColors.grey600,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 16),
              // Reusable bullet items
              _DialogBulletItem(
                icon: Icon(Icons.search, size: 20, color: AppColors.grey600),
                title: 'Why use Referaly Finder?',
              ),
              const SizedBox(height: 15),
              _DialogBulletItem(
                icon: Image.asset(AppAssets.imgAddLead, height: 25, width: 25),
                title: 'Extensive professional network:',
                description: 'Easily connect with trustworthy, qualified partners from our selection.👥',
                spacing: 3,
              ),
              const SizedBox(height: 12),
              _DialogBulletItem(
                icon: Image.asset(AppAssets.imgAddLead, height: 25, width: 25),
                title: 'Transparency and flexibility:',
                description: "Want a commission? We negotiate it for you, only if you're interested!💰",
              ),
              const SizedBox(height: 12),
              _DialogBulletItem(
                icon: Image.asset(AppAssets.imgAddLead, height: 25, width: 25),
                title: 'People-first connections:',
                description:
                    'Engage directly with professionals to verify their reliability and grow your network.🤝',
              ),
              const SizedBox(height: 12),
              _DialogBulletItem(
                icon: Image.asset(AppAssets.imgAddLead, height: 25, width: 25),
                title: '100% free service:',
                description: 'No fees — our priority is making connections easy and beneficial!💰',
              ),
              const SizedBox(height: 12),
              _DialogBulletItem(
                icon: Icon(Icons.public, size: 20, color: AppColors.buttonBlue),
                title: 'You gain visibility, they gain contacts — a true win-win collaboration!',
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: onLetsGo ?? () => Get.back(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.whiteColor,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: Text(
                    "Let's go !",
                    style: stylePoppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.whiteColor,
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
}

// Add reusable bullet widget
class _DialogBulletItem extends StatelessWidget {
  final Widget icon;
  final String title;
  final String? description;
  final double spacing;

  const _DialogBulletItem({
    super.key,
    required this.icon,
    required this.title,
    this.description,
    this.spacing = 8,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        icon,
        SizedBox(width: spacing),
        Expanded(
          child: description == null
              ? Text(
                  title,
                  style: stylePoppins(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: stylePoppins(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description!,
                      style: stylePoppins(
                        fontSize: 15,
                        color: AppColors.grey600,
                      ),
                    ),
                  ],
                ),
        ),
      ],
    );
  }
}
