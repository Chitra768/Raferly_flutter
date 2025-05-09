import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:referaly/resources/app_assets.dart';
import 'package:referaly/resources/app_colors.dart';
import 'package:referaly/resources/text_style.dart';
import 'package:referaly/screens/dashboard/membership_screen.dart';
import 'package:referaly/screens/deals/invited_deals_screen.dart' show InvitedDealsScreen;
import 'package:referaly/screens/deals/out_of_referaly_dialog.dart'
    show OutOfReferalyDialog, OutOfReferalyScreen;
import 'package:referaly/widgets/dialog/invite_contact_dialog.dart' show InviteContactDialog;
import 'package:referaly/widgets/dialog/premium_upgrade_dialog.dart';

/// Dialog to send a contact to a professional who does not have Referaly
class SendContactDialog extends StatelessWidget {
  final VoidCallback? onCreateReferral;

  const SendContactDialog({
    super.key,
    this.onCreateReferral,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 20),
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      titlePadding: EdgeInsets.zero,
      title: Padding(
        padding: const EdgeInsets.only(top: 8, right: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            GestureDetector(
              onTap: () => Get.back(),
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Icon(Icons.close, size: 24),
              ),
            ),
          ],
        ),
      ),
      content: SizedBox(
        width: double.maxFinite,
        child: GestureDetector(
          onTap: () {
            Get.back();
            Get.dialog(InviteContactDialog(
              onAlreadyInvited: () {
                Get.toNamed(InvitedDealsScreen.pageId);
              },
              onNotInvited: () {
                Get.toNamed(OutOfReferalyScreen.pageId);
              },
            ));
          },
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: Get.width * .65,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 10,
                        spreadRadius: 1,
                        offset: const Offset(1, 5))
                  ],
                ),
                padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.telegram,
                      size: 60,
                      color: AppColors.primary,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Send a contact',
                      style: stylePoppins(fontSize: 20, fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'to a professional who does not have Referaly',
                      style: stylePoppins(fontSize: 16, color: Colors.grey[600]),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              GestureDetector(
                onTap: () {
                  Get.back();
                  Get.dialog(PremiumUpgradeDialog(
                    onSeeOffers: () {
                      Get.back();
                      Get.toNamed(MembershipScreen.pageId);
                    },
                  ));
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Create a business \n referral program ',
                        style: stylePoppins(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white),
                      ),
                      const SizedBox(width: 10),
                      Image.asset(AppAssets.imgPoint, width: 24, height: 24)
                    ],
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
