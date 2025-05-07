import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:referaly/resources/app_assets.dart';
import 'package:referaly/resources/text_style.dart';

/// A dialog presenting two invite options.
class InviteContactDialog extends StatelessWidget {
  final VoidCallback onAlreadyInvited;
  final VoidCallback onNotInvited;

  const InviteContactDialog({
    super.key,
    required this.onAlreadyInvited,
    required this.onNotInvited,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 20),
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          GestureDetector(
            onTap: () => Get.back(),
            child: const Icon(Icons.close),
          ),
          const SizedBox(height: 5),
          Text(
            "The professional I want to send a contact to",
            style: stylePoppins(fontSize: 16, fontWeight: FontWeight.w900),
          )
        ],
      ),
      content: SizedBox(
        width: double.maxFinite,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _InviteOption(
              iconPath: AppAssets.imgReferalyIconForModal,
              label: 'Has not invited me on Referaly',
              onTap: () {
                Get.back();
                onNotInvited();
              },
            ),
            const SizedBox(
              width: 10,
            ),
            _InviteOption(
              iconPath: AppAssets.imgReferalyInviteIcon,
              label: 'Has already invited me on Referaly',
              onTap: () {
                Get.back();
                onAlreadyInvited();
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _InviteOption extends StatelessWidget {
  final String iconPath;
  final String label;
  final VoidCallback onTap;

  const _InviteOption({
    required this.iconPath,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: Get.width * .36,
        height: 140,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 2,
                spreadRadius: 1,
                offset: const Offset(1, 4))
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Spacer(),
            Image.asset(iconPath, width: 48, height: 48),
            const SizedBox(height: 12),
            Text(
              label,
              style: stylePoppins(fontSize: 12, fontWeight: FontWeight.w700),
              textAlign: TextAlign.center,
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
