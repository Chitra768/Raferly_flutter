import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:referaly/controllers/membership_controller.dart';
import 'package:referaly/resources/app_assets.dart';
import 'package:referaly/resources/app_colors.dart';
import 'package:referaly/resources/text_style.dart';

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
          'Subscription',
          style: stylePoppins(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  'Get Premium',
                  style: stylePoppins(fontSize: 24, fontWeight: FontWeight.w700),
                ),
              ),
              const SizedBox(height: 8),
              Center(
                child: Text(
                  'Choose the best plan for you',
                  style: stylePoppins(fontSize: 16, color: Colors.grey[600]),
                ),
              ),
              const SizedBox(height: 24),
              // Plan toggle
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Obx(() => Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () => controller.togglePlan(true),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              decoration: BoxDecoration(
                                color: controller.isYearly.value ? AppColors.primary : Colors.transparent,
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: Center(
                                child: Text(
                                  'Yearly',
                                  style: stylePoppins(
                                    fontSize: 16,
                                    color: controller.isYearly.value ? Colors.white : Colors.black,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () => controller.togglePlan(false),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              decoration: BoxDecoration(
                                color: !controller.isYearly.value ? AppColors.primary : Colors.transparent,
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: Center(
                                child: Text(
                                  'Monthly',
                                  style: stylePoppins(
                                    fontSize: 16,
                                    color: !controller.isYearly.value ? Colors.white : Colors.black,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    )),
              ),
              const SizedBox(height: 32),
              // Referaly Connected Card
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    SvgPicture.asset(AppAssets.imgCc, height: 32, color: AppColors.primary),
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
                    SvgPicture.asset(AppAssets.imgPrimum, height: 28),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              // How does it work button
              InkWell(
                onTap: () {},
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'See how NFC Card Works',
                        style: stylePoppins(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white),
                      ),
                      const SizedBox(width: 8),
                      SvgPicture.asset(AppAssets.imgPlay, height: 16, color: Colors.white),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              // Unlimited Expert Coaching
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    SvgPicture.asset(AppAssets.imgGroup, height: 32, color: AppColors.primary),
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
                    SvgPicture.asset(AppAssets.imgPrimum, height: 28),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              // How does it work button
              InkWell(
                onTap: () {},
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'See how NFC Card Works',
                        style: stylePoppins(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white),
                      ),
                      const SizedBox(width: 8),
                      SvgPicture.asset(AppAssets.imgPlay, height: 16, color: Colors.white),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              // Independent Plan
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
                          style: stylePoppins(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          controller.isYearly.value ? '₹40,500.00 /year' : '₹3,500.00 /month',
                          style: stylePoppins(fontSize: 24, fontWeight: FontWeight.w700, color: Colors.white),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '( VAT Included )',
                          style: stylePoppins(fontSize: 12, color: Colors.white70),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            SvgPicture.asset(AppAssets.imgCheckGreen, height: 18),
                            const SizedBox(width: 8),
                            Text(
                              '1 unique access',
                              style: stylePoppins(fontSize: 14, color: Colors.white),
                            ),
                          ],
                        ),
                      ],
                    )),
              ),
              const SizedBox(height: 16),
              // Agency Premium Plan
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
                          'Agency Premium',
                          style: stylePoppins(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          controller.isYearly.value ? '₹71,600.00 /year' : '₹6,000.00 /month',
                          style: stylePoppins(fontSize: 24, fontWeight: FontWeight.w700, color: Colors.white),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '( VAT Included )',
                          style: stylePoppins(fontSize: 12, color: Colors.white70),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            SvgPicture.asset(AppAssets.imgCheckGreen, height: 18),
                            const SizedBox(width: 8),
                            Text(
                              'Up to 5 team members to Collaborate as referrers and get their own referral network',
                              style: stylePoppins(fontSize: 14, color: Colors.white),
                              maxLines: 2,
                            ),
                          ],
                        ),
                      ],
                    )),
              ),
              const SizedBox(height: 24),
              // Buy Subscription Button
              InkWell(
                onTap: () {},
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(AppAssets.imgPrimum, height: 24, color: Colors.white),
                        const SizedBox(width: 8),
                        Text(
                          'Buy Subscription',
                          style: stylePoppins(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white),
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
}
