import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:referaly/resources/app_colors.dart';
import 'package:referaly/resources/text_style.dart';

/// A dialog prompting users to upgrade to premium and highlighting benefits.
class PremiumUpgradeDialog extends StatelessWidget {
  final VoidCallback onSeeOffers;

  const PremiumUpgradeDialog({
    super.key,
    required this.onSeeOffers,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      titlePadding: const EdgeInsets.only(top: 15, right: 15),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          GestureDetector(
            onTap: () => Get.back(),
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.primary, width: 1),
              ),
              child: Icon(Icons.close, size: 24, color: AppColors.primary),
            ),
          ),
        ],
      ),
      content: SizedBox(
        width: double.maxFinite,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  'Upgrade to the Premium version to enjoy these benefits',
                  style: stylePoppins(fontSize: 20, fontWeight: FontWeight.w600),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 30),
              _buildBenefitItem('➕', 'Add a collaborator on the agency premium.'),
              const SizedBox(height: 10),
              _buildBenefitItem('🎯', 'Receive an unlimited number of potential clients.'),
              const SizedBox(height: 10),
              _buildBenefitItem('🤝', 'Create as many partner programs as you want.'),
              const SizedBox(height: 10),
              _buildBenefitItem('📁', 'Store all your documents without limits.'),
              const SizedBox(height: 10),
              _buildBenefitItem('📲', 'Send notifications to business introducers.'),
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  border: Border.all(color: AppColors.primary),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'By choosing the annual subscription 🎓, you benefit from a and also gain free access to online business networks 🌐, subject',
                  style: stylePoppins(fontSize: 16, color: AppColors.blackColor.withAlpha(150)),
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: Text(
                  'Upgrade to premium now to unlock these features 🔒',
                  style: stylePoppins(fontSize: 16, color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: 70,
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  onPressed: onSeeOffers,
                  child: Text(
                    'See Premium Offers',
                    style: stylePoppins(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBenefitItem(String icon, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(icon, style: stylePoppins(fontSize: 16)),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: stylePoppins(fontSize: 18, color: Colors.grey),
          ),
        ),
      ],
    );
  }
}
