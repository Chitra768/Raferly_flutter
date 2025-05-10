import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:referaly/controller/membership_controller.dart';
import 'package:referaly/resources/app_assets.dart';
import 'package:referaly/resources/app_colors.dart';
import 'package:referaly/resources/text_style.dart';

class MembershipScreen extends StatefulWidget {
  static String pageId = "/membership";
  const MembershipScreen({super.key});

  @override
  State<MembershipScreen> createState() => _MembershipScreenState();
}

class _MembershipScreenState extends State<MembershipScreen> {
  MembershipController controller = Get.put(MembershipController());
  @override
  void initState() {
    super.initState();
    controller = Get.put(MembershipController());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'Subscription',
          style: stylePoppins(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Divider(),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeaderSection(),
                    const SizedBox(height: 24),
                    _buildPlanToggleSection(),
                    const SizedBox(height: 32),
                    _buildInfoCards(),
                    // Plans
                    Obx(() => Column(
                          children: [
                            _buildPlanCard(
                              title: 'Independent',
                              price: controller.isYearly.value ? '40,050.00' : '3,500.00',
                              isPrimary: controller.isIndependent.value,
                              onTap: () => controller.togglePlanType(true),
                              features: '1 unique access',
                            ),
                            const SizedBox(height: 16),
                            _buildPlanCard(
                              title: 'Agency Premium',
                              price: controller.isYearly.value ? '71,600.00' : '6,000.00',
                              isPrimary: !controller.isIndependent.value,
                              onTap: () => controller.togglePlanType(false),
                              features:
                                  'Up to 10 team accesses to Collaborate as Team ( Administrator account and collaborator account )',
                            ),
                          ],
                        )),
                    const SizedBox(height: 24),
                    _buildSubscriptionButton(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Obx _buildInfoCards() {
    return Obx(() {
      return controller.isYearly.value
          ? Column(
              children: [
                _buildInfoCard(
                  btnTitle: 'See how NFC Card Works',
                  content: 'An exclusive NFC card to share your info and instantly add business referrers.',
                  title: 'Referaly Connected Card',
                  icon: AppAssets.imgCc,
                  ontap: () {},
                ),
                const SizedBox(height: 20),
                _buildInfoCard(
                  btnTitle: 'See how NFC Card Works',
                  content: 'Enjoy unlimited, personalized coaching with a networking expert.',
                  title: 'Unlimited Expert Coaching',
                  icon: AppAssets.imgGroup,
                  ontap: () {},
                ),
                const SizedBox(height: 20),
              ],
            )
          : const SizedBox();
    });
  }

  Widget _buildHeaderSection() {
    return Column(
      children: [
        Center(
          child: Text(
            'Get Premium',
            style: stylePoppins(fontSize: 24, fontWeight: FontWeight.w800),
          ),
        ),
        const SizedBox(height: 8),
        Center(
          child: Text(
            'Choose the best plan for you',
            style: stylePoppins(fontSize: 16, color: Colors.black.withAlpha(200)),
          ),
        ),
      ],
    );
  }

  Widget _buildPlanToggleSection() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(30),
      ),
      child: Obx(() => Row(
            children: [
              _buildToggleButton(
                label: 'Yearly',
                offer: '-20%',
                isSelected: controller.isYearly.value,
                onTap: () => controller.togglePlan(true),
              ),
              _buildToggleButton(
                label: 'Monthly',
                isSelected: !controller.isYearly.value,
                onTap: () => controller.togglePlan(false),
              ),
            ],
          )),
    );
  }

  Widget _buildToggleButton({
    required String label,
    String offer = '',
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(30),
          ),
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: stylePoppins(
                  fontSize: 16,
                  color: isSelected ? Colors.white : Colors.black,
                  fontWeight: FontWeight.w500,
                ),
              ),
              if (offer.isNotEmpty)
                Container(
                  margin: const EdgeInsets.only(left: 10),
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                      color: const Color(0xFF22C55E), borderRadius: BorderRadiusDirectional.circular(50)),
                  alignment: Alignment.center,
                  child: Text(
                    offer,
                    style: stylePoppins(fontSize: 12, color: Colors.white),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPlanCard(
      {required String title,
      required String price,
      required String features,
      required bool isPrimary,
      required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: Get.width,
        decoration: BoxDecoration(
          color: isPrimary ? AppColors.primary : Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: !isPrimary
              ? Border.all(
                  color: Colors.grey[300]!,
                  width: 1,
                )
              : null,
          boxShadow: !isPrimary
              ? [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: stylePoppins(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: isPrimary ? Colors.white : Colors.black,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '₹$price',
                  style: stylePoppins(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: isPrimary ? Colors.white : Colors.black,
                  ),
                ),
                Text(
                  controller.isYearly.value ? ' /year' : ' /month',
                  style: stylePoppins(
                    fontSize: 16,
                    color: isPrimary ? Colors.white70 : Colors.grey[600],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SvgPicture.asset(
                  AppAssets.imgCheckGreen,
                  height: 24,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    features,
                    style: stylePoppins(
                      fontSize: 14,
                      color: isPrimary ? Colors.white : Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubscriptionButton() {
    return InkWell(
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
    );
  }

  Widget _buildInfoCard({
    required String icon,
    required String title,
    required String content,
    required String btnTitle,
    required VoidCallback ontap,
  }) {
    return Container(
      width: Get.width,
      decoration: BoxDecoration(
        color: const Color(0x1A9437DA).withAlpha(10),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey[300]!),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      child: Column(
        children: [
          Row(
            children: [
              SvgPicture.asset(icon, height: 22, color: AppColors.primary),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: stylePoppins(fontSize: 18, fontWeight: FontWeight.w600),
                ),
              ),
              Image.asset(AppAssets.imgGift, height: 28),
              const SizedBox(width: 8),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            content,
            style: stylePoppins(fontSize: 16, color: Colors.black.withAlpha(200)),
          ),
          const SizedBox(height: 20),
          GestureDetector(
            onTap: ontap,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(AppAssets.imgPlay, height: 16, color: Colors.white),
                  const SizedBox(width: 10),
                  Text(
                    btnTitle,
                    style: stylePoppins(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.white),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}