import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:referaly/controllers/membership_controller.dart';
import 'package:referaly/resources/app_colors.dart';
import 'package:referaly/resources/text_style.dart';

import '../../widgets/common_widgets.dart';

class MembershipScreen extends GetView<MembershipController> {
  static String pageId = "/membership";

  const MembershipScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Ensure controller is initialized
    Get.put(MembershipController());

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'Membership',
          style: stylePoppins(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                'Get Premium',
                style: stylePoppins(fontSize: 20, fontWeight: FontWeight.w700),
              ),
            ),
            const SizedBox(height: 4),
            Center(
              child: Text(
                'Choose the best plan for you',
                style: stylePoppins(fontSize: 14, color: Colors.grey[600]),
              ),
            ),
            const SizedBox(height: 16),
            // Plan toggle
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Obx(() => CustomSegmentControl(
                    isFirstSelected: controller.isYearly.value,
                    firstLabel: 'Yearly',
                    secondLabel: 'Monthly',
                    onSelectionChanged: (first) => controller.togglePlan(first),
                    fontSize: 16,
                  )),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  // Card 1
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 5,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(16),
                    margin: const EdgeInsets.only(bottom: 16),
                    child: Row(
                      children: [
                        Icon(Icons.credit_card, size: 32, color: AppColors.primary),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Referaly Connected Card',
                                style: stylePoppins(fontSize: 16, fontWeight: FontWeight.w600),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'An exclusive NFC card to share your info and instantly add business referrers.',
                                style: stylePoppins(fontSize: 14, color: Colors.grey[600]),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Icon(Icons.card_giftcard, size: 28, color: Colors.orange),
                      ],
                    ),
                  ),
                  // Button How does it work
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: Text(
                        'How does it work?',
                        style: stylePoppins(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Card 2
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 5,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(16),
                    margin: const EdgeInsets.only(bottom: 16),
                    child: Row(
                      children: [
                        Icon(Icons.group, size: 32, color: AppColors.primary),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Unlimited Expert Coaching',
                                style: stylePoppins(fontSize: 16, fontWeight: FontWeight.w600),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Enjoy unlimited, personalized coaching with a networking expert.',
                                style: stylePoppins(fontSize: 14, color: Colors.grey[600]),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Icon(Icons.card_giftcard, size: 28, color: Colors.orange),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: Text(
                        'How does it work?',
                        style: stylePoppins(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Pricing Card
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Obx(() => Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Independent',
                              style: stylePoppins(
                                  fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              controller.isYearly.value ? '₹40,500.00 / Yearly' : '₹3,500.00 / Monthly',
                              style: stylePoppins(
                                  fontSize: 20, fontWeight: FontWeight.w700, color: Colors.white),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '( VAT Included )',
                              style: stylePoppins(fontSize: 12, color: Colors.white70),
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                const Icon(Icons.check_circle, color: Colors.greenAccent, size: 18),
                                const SizedBox(width: 6),
                                Text(
                                  controller.isYearly.value ? '1 unique access' : 'Unlimited access',
                                  style: stylePoppins(fontSize: 14, color: Colors.white),
                                ),
                              ],
                            ),
                          ],
                        )),
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
