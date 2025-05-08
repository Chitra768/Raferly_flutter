import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:referaly/resources/app_assets.dart';

class CustomAuthAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? logoAssetPath;
  final VoidCallback? onBackTap;
  final Color iconColor;
  final Color backgroundColor;
  final double iconSize;

  const CustomAuthAppBar({
    super.key,
    this.logoAssetPath,
    this.onBackTap,
    this.iconColor = Colors.black,
    this.backgroundColor = Colors.white,
    this.iconSize = 20,
  });

  @override
  Widget build(BuildContext context) {
    // Get the available width and height from MediaQuery
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double appBarHeight =
        screenHeight * 0.3; // Adjust this factor as needed for height

    return Container(
      color: backgroundColor,
      // padding: const EdgeInsets.symmetric(horizontal: 16),
      height: appBarHeight, // Use dynamic height based on the screen size
      width: screenWidth, // Use full width
      child: Stack(
        children: [
          // Image that takes full height and width
          Positioned.fill(
            child: Image.asset(
              logoAssetPath ?? AppAssets.imgHeaderBg,
              fit: BoxFit.cover, // Ensure the image fills the available space
            ),
          ),
          // Back button positioned over the image
          Positioned(
            top: 72, // Adjust this value as needed for positioning
            left: 16, // Adjust the left padding
            child: GestureDetector(
              onTap: onBackTap ?? () => Get.back(),
              child: Container(
                height: 44,
                width: 44,
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(Icons.arrow_back_ios_new,
                    size: iconSize, color: iconColor),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize =>
      const Size.fromHeight(200); // You can adjust this if needed
}
