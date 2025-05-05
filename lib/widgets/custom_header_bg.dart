import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomBGHeader extends StatelessWidget {
  final String imagePath;
  final double imageHeight;
  final Color backgroundColor;
  final Color borderColor;
  final Color iconColor;
  final double topPadding;
  final double leftPadding;
  final IconData icon;
  final double iconSize;

  const CustomBGHeader({
    Key? key,
    required this.imagePath,
    this.imageHeight = 220,
    this.backgroundColor = Colors.white,
    this.borderColor = Colors.white,
    this.iconColor = Colors.black,
    this.topPadding = 70,
    this.leftPadding = 16,
    this.icon = Icons.arrow_back_ios_new,
    this.iconSize = 20,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          width: double.infinity,
          height: imageHeight,
          child: Image.asset(
            imagePath,
            fit: BoxFit.cover,
          ),
        ),
        Positioned(
          top: topPadding,
          left: leftPadding,
          child: Container(
            height: 45,
            width: 45,
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: borderColor,
                width: 2,
              ),
            ),
            child: IconButton(
              icon: Icon(
                icon,
                color: iconColor,
                size: iconSize,
              ),
              onPressed: () => Get.back(),
            ),
          ),
        ),
      ],
    );
  }
}
