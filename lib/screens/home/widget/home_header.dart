// widgets/home_header.dart
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:referaly/resources/app_assets.dart';
import 'package:referaly/screens/archeive/archeive_list.dart' show ArchiveList;
import 'package:referaly/screens/dashboard/home_without_primum.dart';
import 'package:referaly/screens/dashboard/my_activity_screen.dart';
import 'package:referaly/screens/dashboard/track_leads_screen.dart';

import '../../../resources/app_colors.dart';

class HomeHeader extends StatelessWidget {
  final GlobalKey<ScaffoldState> drawerKey;
  const HomeHeader({super.key, required this.drawerKey});

  Widget statCard(String label, String value, String icon, String icon1) {
    return GestureDetector(
      onTap: () {
        if (label.contains('Leads')) {
          Get.toNamed(TrackLeadsScreen.pageId);
        } else if (label.contains('Partners')) {
          Get.toNamed(MyActivityScreen.pageId);
        } else if (label.contains('Commissions')) {
          Get.toNamed(ArchiveList.pageId);
        }
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    label,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                SvgPicture.asset(icon1, height: 20, width: 20),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text(
                    value,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 22,
                      color: AppColors.primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                SvgPicture.asset(icon, height: 36, width: 36),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 60, 16, 24),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF8E2DE2), Color(0xFF4A00E0)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(32)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CmnAppBar(scaffoldKey: drawerKey),
          GridView.count(
            crossAxisCount: 2,
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 1.6, // try 0.7, 0.75, 0.8 depending on content height
            children: [
              statCard('Leads\nReceived', '80', AppAssets.imgHomeLead, AppAssets.imgHomeCrown),
              statCard('Leads\nSent', '80', AppAssets.imgHomeSent, ""),
              statCard('Number of\nPartners', '80', AppAssets.imgHomePartner, AppAssets.imgHomeCrown),
              statCard('Commissions\nReceived', '80', AppAssets.imgHomeReceived, ""),
            ],
          ),
        ],
      ),
    );
  }
}
