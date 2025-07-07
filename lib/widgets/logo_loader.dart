import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:math' as math;

import 'package:referaly/resources/app_assets.dart';
import 'package:referaly/resources/app_colors.dart';

class LogoLoader extends StatefulWidget {
  final double size;
   final Color color;

   const LogoLoader({super.key, this.size = 20, this.color = AppColors.primary});

  @override
  State<LogoLoader> createState() => _LogoLoaderState();
}

class _LogoLoaderState extends State<LogoLoader>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(); // Continuous loop
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RotationTransition(
      turns: _controller,
      child: SvgPicture.asset(
        AppAssets.imgAppLgo,
        width: widget.size,
        height: widget.size,
        fit: BoxFit.cover,
        color: widget.color,
      ),
    );
  }
}
