// widgets/section_tiles.dart
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../resources/app_assets.dart';

class SectionTiles extends StatelessWidget {
  const SectionTiles({super.key});

  Widget tile(String title, String? icon) {
    return Expanded(
      child: Container(
        height: 100,
        margin: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          color: const Color(0xFF8E2DE2),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white),
            ),
            SvgPicture.asset(icon!, height: 20, width: 20),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        tile("Pour mon activité", AppAssets.imgHomeCrown),
        tile("Je suis apporteur d'affaires",AppAssets.imgHomeCrown),
      ],
    );
  }
}
