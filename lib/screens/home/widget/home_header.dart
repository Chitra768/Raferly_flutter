// widgets/home_header.dart
import 'package:flutter/material.dart';
import 'package:referaly/resources/app_assets.dart';
import 'package:flutter_svg/flutter_svg.dart';
class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  Widget statCard(String label, String value, String icon, String icon1) {
    return Container(
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
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              SvgPicture.asset(icon, height: 24, width: 24),
            ],
          ),

        ],
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
          // Profile and menu
          const Row(
            children: [
              CircleAvatar(
                backgroundImage: AssetImage('assets/user.png'),
                // Use your asset
                radius: 26,
              ),
              SizedBox(width: 12),
              Expanded(
                child: Text.rich(
                  TextSpan(
                    text: 'Hello,\n',
                    children: [
                      TextSpan(
                        text: 'Arnaud Attencia !!',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
              Icon(Icons.menu, color: Colors.white),
            ],
          ),

          // Cards in 2x2 Grid inside header
          GridView.count(
            crossAxisCount: 2,
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 1.8, // try 0.7, 0.75, 0.8 depending on content height
            children: [
              statCard('Leads\nReceived', '80',AppAssets.imgHomeCrown,AppAssets.imgHomeCrown),
              statCard('Leads\nSent', '80',AppAssets.imgHomeLead,AppAssets.imgHomeCrown),
              statCard('Number of\nPartners', '80', AppAssets.imgHomeLead,AppAssets.imgHomeCrown),
              statCard('Commissions\nReceived', '80', AppAssets.imgHomeLead,AppAssets.imgHomeCrown),
            ],
          ),
        ],
      ),
    );
  }
}
