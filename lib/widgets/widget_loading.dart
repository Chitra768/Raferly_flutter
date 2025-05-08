import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../resources/app_colors.dart';

class WidgetLoading extends StatelessWidget {
  final double? size;
  final Color? color;
  const WidgetLoading({
    super.key,
    this.size,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: LoadingAnimationWidget.staggeredDotsWave(
        size: size ?? 40,
        color: color ?? AppColors.primary,
      ),
    );
  }
}
