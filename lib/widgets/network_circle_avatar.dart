import 'package:flutter/material.dart';
import 'package:referaly/resources/app_assets.dart';
import 'package:referaly/resources/app_colors.dart';

/// A circle avatar that loads an image from [imageUrl].
/// Shows [placeholder] or default person icon on load error (e.g. 404).
class NetworkCircleAvatar extends StatelessWidget {
  const NetworkCircleAvatar({
    super.key,
    required this.imageUrl,
    this.radius = 24,
    this.placeholderAsset,
  });

  final String imageUrl;
  final double radius;
  final String? placeholderAsset;

  @override
  Widget build(BuildContext context) {
    final size = radius * 2;
    final placeholder = placeholderAsset ?? AppAssets.imgDefaultPerson;
    if (imageUrl.isEmpty) {
      return CircleAvatar(
        radius: radius,
        backgroundImage: const AssetImage(AppAssets.imgDefaultPerson),
      );
    }
    return ClipOval(
      child: SizedBox(
        width: size,
        height: size,
        child: Image.network(
          imageUrl,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => Image.asset(
            placeholder,
            fit: BoxFit.cover,
            width: size,
            height: size,
          ),
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return Container(
              width: size,
              height: size,
              color: AppColors.grey100,
              child: const Center(
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
