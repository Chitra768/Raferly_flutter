import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:referaly/controller/my_activity_controller.dart';
import 'package:referaly/resources/app_assets.dart';
import 'package:referaly/resources/app_colors.dart';
import 'package:referaly/resources/text_style.dart';

class MyActivityScreen extends StatefulWidget {
  static String pageId = "/myActivity";

  const MyActivityScreen({super.key});

  @override
  State<MyActivityScreen> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyActivityScreen> {
  late MyActivityController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.put(MyActivityController());
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
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        title: Text(
          "For my activity",
          style: stylePoppins(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),
            buildSegmentControl(),
            const SizedBox(height: 20),
            Expanded(
              child: Obx(() {
                return controller.isMyContractsSelected.value
                    ? buildDealsListView()
                    : SingleChildScrollView(
                        child: Column(
                          children: [
                            buildPurpleCard(),
                            const SizedBox(height: 20),
                            buildActionButtonsRow(),
                            const SizedBox(height: 30),
                            buildBusinessReferrersSection(),
                            buildVersionInfo(),
                          ],
                        ),
                      );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildSegmentControl() {
    return Obx(
      () {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => controller.toggleTabSelection(true),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                    margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                    decoration: BoxDecoration(
                      color:
                          controller.isMyContractsSelected.value ? AppColors.primary : AppColors.transparent,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      'My Contracts',
                      style: stylePoppins(
                        fontSize: 16,
                        fontWeight:
                            controller.isMyContractsSelected.value ? FontWeight.w600 : FontWeight.w500,
                        color: controller.isMyContractsSelected.value ? Colors.white : Colors.grey,
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () => controller.toggleTabSelection(false),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                    margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                    decoration: BoxDecoration(
                      color:
                          !controller.isMyContractsSelected.value ? AppColors.primary : AppColors.transparent,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      'My Network',
                      style: stylePoppins(
                        fontSize: 16,
                        fontWeight:
                            !controller.isMyContractsSelected.value ? FontWeight.w600 : FontWeight.w500,
                        color: controller.isMyContractsSelected.value ? Colors.grey : Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // Deals List View (My Contracts tab)
  Widget buildDealsListView() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: 3,
      itemBuilder: (context, index) {
        String referrer = "";
        switch (index) {
          case 0:
            referrer = "(Darshan Patel)";
            break;
          case 1:
            referrer = "(Hetal-- Patel&-+_)";
            break;
          case 2:
            referrer = "(Test Test)";
            break;
        }
        return buildDealCard(
          title: "Test",
          referrer: referrer,
        );
      },
    );
  }

  Widget buildDealCard({required String title, required String referrer}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black.withAlpha(20), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        children: [
          buildDealHeader(title: title, referrer: referrer),
          const Divider(height: 1),
          buildMoreInfo(),
          buildDealActionButtons(),
        ],
      ),
    );
  }

  Widget buildDealHeader({required String title, required String referrer}) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.circular(6),
            ),
            child: const Center(
              child: Icon(
                Icons.person,
                color: Colors.white,
                size: 30,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: stylePoppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  "Business referral - $referrer",
                  style: stylePoppins(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: [
              GestureDetector(
                onTap: () {},
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.asset(
                    AppAssets.imgAddDoc,
                    color: AppColors.primary,
                    scale: 3,
                  ),
                ),
              ),
              GestureDetector(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 2),
                  child: Icon(Icons.more_vert, color: Colors.grey[700]),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildMoreInfo() {
    return InkWell(
      onTap: () {},
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "More information",
              style: stylePoppins(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            Icon(Icons.add, color: Colors.grey[700]),
          ],
        ),
      ),
    );
  }

  Widget buildDealActionButtons() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.primary,
                side: BorderSide(color: AppColors.primary),
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                "Edit Deal",
                style: stylePoppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                "Share Deal",
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
    );
  }

  // Network tab content
  Widget buildPurpleCard() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.symmetric(vertical: 15),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Image.asset(AppAssets.imgReferrelsPeople, height: 60),
          const SizedBox(height: 5),
          Text(
            'Referreals',
            style: stylePoppins(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            "5",
            style: stylePoppins(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildActionButtonsRow() {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10), border: Border.all(color: AppColors.grey200, width: 2)),
      padding: const EdgeInsets.fromLTRB(10, 5, 10, 20),
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: SizedBox(
        width: Get.width - 52,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            GestureDetector(
                onTap: () {},
                child: Padding(
                  padding: const EdgeInsets.all(2),
                  child: Icon(
                    Icons.info,
                    color: AppColors.primary,
                  ),
                )),
            Row(
              children: [
                singlePrItem(
                  image: AppAssets.imgRefreal,
                  isBlue: true,
                  onTap: () {},
                  scale: 1.4,
                  request: 1,
                ),
                singlePrItem(
                  image: AppAssets.imgAddDoc,
                  isBlue: false,
                  onTap: () {},
                  scale: 2.5,
                ),
                singlePrItem(
                  image: AppAssets.imgShare,
                  isBlue: false,
                  onTap: () {},
                  scale: 3,
                ),
                singlePrItem(
                  image: AppAssets.imgAddNotification,
                  isBlue: false,
                  onTap: () {},
                  scale: 1.5,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget singlePrItem(
      {required String image,
      required VoidCallback onTap,
      int request = 0,
      required bool isBlue,
      required double scale}) {
    final width = ((Get.width - 62) / 4);
    const double imageContaierHeight = 60;
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: width,
        height: 70,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
              left: 10,
              top: 10,
              child: Container(
                width: width - 10,
                height: imageContaierHeight,
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: AppColors.grey200),
                child: Image.asset(image, scale: scale, color: AppColors.primary),
              ),
            ),
            Positioned(
              left: 0,
              top: 0,
              child: Image.asset(isBlue ? AppAssets.imgpointBlue : AppAssets.imgPoint, height: 25),
            ),
            if (request != 0)
              Positioned(
                right: 15,
                bottom: 5,
                child: Container(
                  decoration: BoxDecoration(shape: BoxShape.circle, color: AppColors.pdfBg),
                  padding: const EdgeInsets.all(6),
                  child: Text(
                    request.toString(),
                    style: stylePoppins(
                      fontSize: 12,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              )
          ],
        ),
      ),
    );
  }

  Widget buildBusinessReferrersSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Business Referrers",
            style: stylePoppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 6,
            separatorBuilder: (context, index) => const SizedBox(height: 16),
            itemBuilder: (context, index) {
              return ReferrerListItem(
                name: "Darshan Patel",
                showPrimium: index > 1,
              );
            },
          )
        ],
      ),
    );
  }

  Widget buildVersionInfo() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Text(
        "With the free version, you can add a maximum of 5 business referrers.",
        style: stylePoppins(
          fontSize: 18,
          fontWeight: FontWeight.w900,
          color: Colors.grey[800],
        ),
        textAlign: TextAlign.left,
      ),
    );
  }
}

class ReferrerListItem extends StatefulWidget {
  final String name;
  final bool showPrimium;
  const ReferrerListItem({
    super.key,
    required this.name,
    this.showPrimium = false,
  });

  @override
  State<ReferrerListItem> createState() => _ReferrerListItemState();
}

class _ReferrerListItemState extends State<ReferrerListItem> {
  bool expanded = false;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        data(),
        if (widget.showPrimium)
          Positioned.fill(
              child: ClipRect(
                  child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: const SizedBox(),
          )))
      ],
    );
  }

  Widget data() {
    return GestureDetector(
      onTap: () {
        if (!widget.showPrimium) {
          setState(() {
            expanded = !expanded;
          });
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: const BoxDecoration(
                    color: Colors.blue,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.person,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    widget.name,
                    style: stylePoppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Icon(expanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down),
              ],
            ),
            if (expanded) ...[
              const SizedBox(height: 12),
              const Divider(),
              const SizedBox(height: 12),
              // Additional expanded content would go here
              Text(
                "Referrer details",
                style: stylePoppins(
                  fontSize: 14,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
