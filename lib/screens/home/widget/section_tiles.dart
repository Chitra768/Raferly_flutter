// widgets/section_tiles.dart
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../resources/app_assets.dart';

class SectionTiles extends StatelessWidget {
  const SectionTiles({super.key});

  Widget tile(String title, String? icon1, String? icon) {
    return Expanded(
      child: Container(
        // height: 179,
        margin: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          color: const Color(0xFF8E2DE2),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      title,
                      textAlign: TextAlign.start,
                      style: const TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  SvgPicture.asset(icon!, height: 20, width: 20),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  child: Text(
                    "1",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 28,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                SvgPicture.asset(icon1!, height: 78, width: 92),
              ],
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        tile("Pour\nmon\nactivité", AppAssets.imgHomeVector,
            AppAssets.imgHomeCrown),
        tile("Je suis apporteur d'affaires", AppAssets.imgHomeVector2, ""),
      ],
    );
  }
}
