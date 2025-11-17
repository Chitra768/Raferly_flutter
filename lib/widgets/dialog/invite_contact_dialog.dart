import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:referaly/languages/languagekeys.dart';
import 'package:referaly/resources/app_assets.dart';
import 'package:referaly/resources/app_colors.dart' show AppColors;
import 'package:referaly/resources/text_style.dart';
import 'package:referaly/utils/translations.dart';
import 'package:referaly/controller/controller_main_professional.dart';
import 'package:referaly/widgets/dialog/professional_account_activation_dialog.dart';

/// A dialog presenting two invite options.
class InviteContactDialog extends StatelessWidget {
  final VoidCallback onOutOfReferaly;
  final VoidCallback onDealList;
  final VoidCallback onCreateDeal;

  const InviteContactDialog({
    super.key,
    required this.onOutOfReferaly,
    required this.onDealList,
    required this.onCreateDeal,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 20),
      backgroundColor: Colors.transparent,
      elevation: 0,
      contentPadding: EdgeInsets.zero,
      content: Container(
        width: Get.width * .85,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.25),
              blurRadius: 24,
              offset: const Offset(0, 12),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header
            Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
                color: AppColors.primary,
              ),
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
              child: Stack(
                children: [
                  // Centered content
                  Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Send icon
                        Container(
                          width: 64,
                          height: 64,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Center(
                            child: SvgPicture.asset(
                              AppAssets.imgSendActivity,
                              width: 32,
                              height: 32,
                              fit: BoxFit.contain,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        // Title
                        Text(
                          tr(LanguageKeys.sendReferral),
                          style: stylePoppins(
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        // Subtitle
                      ],
                    ),
                  ),
                  // Close button in top-right
                  Positioned(
                    right: 0,
                    top: 0,
                    child: GestureDetector(
                      onTap: () => Get.back(),
                      child: Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Icon(
                          Icons.close,
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Options
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
              child: Column(
                children: [
                  _InviteCard(
                    imagePath: AppAssets.imgPeople15x,
                    title: tr(LanguageKeys.referalyProfessional),
                    subtitle: tr(
                        LanguageKeys.sendToAVerifiedProfessionalOnOurPlatform),
                    statusColor: const Color(0xFF22C55E),
                    onTap: () {
                      Get.back();
                      onDealList();
                    },
                  ),
                  const SizedBox(height: 12),
                  _InviteCard(
                    imagePath: AppAssets.imgEmail,
                    title: tr(LanguageKeys.externalContact),
                    subtitle:
                        tr(LanguageKeys.shareViaEmailOrMessagingPlatforms),
                    statusColor: const Color(0xFF3B82F6),
                    onTap: () {
                      Get.back();
                      onOutOfReferaly();
                    },
                  ),
                ],
              ),
            ),

            // Get Started Button
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      _handleGetStartedTap();
                    },
                    borderRadius: BorderRadius.circular(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // const Icon(
                        //   Icons.rocket_launch,
                        //   color: Colors.white,
                        //   size: 20,
                        // ),
                        // const SizedBox(width: 8),
                        Flexible(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              tr(LanguageKeys.getstarted),
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: stylePoppins(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleGetStartedTap() {
    // Get the main controller to check account type
    final controller = Get.find<ControllerMainProfessional>();
    final companyType =
        controller.profile.value?.data?.companyType?.toLowerCase();

    if (companyType == 'individual') {
      // Show professional account activation dialog for individual accounts
      Get.dialog(
        ProfessionalAccountActivationDialog(
          onActivate: () {
            // Navigate to professional account activation/upgrade
            // This could be a subscription screen or profile type change
            Get.toNamed('/membership');
          },
          onContinue: () {
            // Continue with the original action
            Get.back();
            onCreateDeal();
          },
        ),
      );
    } else {
      // For professional accounts, proceed normally
      Get.back();
      onCreateDeal();
    }
  }
}

class _InviteCard extends StatelessWidget {
  final String imagePath;
  final String title;
  final String subtitle;
  final Color statusColor;
  final VoidCallback onTap;

  const _InviteCard({
    required this.imagePath,
    required this.title,
    required this.subtitle,
    required this.statusColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.08),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Image.asset(
                  imagePath,
                  width: 24,
                  height: 24,
                  fit: BoxFit.contain,
                  color: AppColors.primary,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          style: stylePoppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: AppColors.blackColor,
                          ),
                        ),
                      ),
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: statusColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: stylePoppins(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: AppColors.blackColor.withOpacity(0.6),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
