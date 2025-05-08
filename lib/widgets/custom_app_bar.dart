// App Bar
// widgets/common_app_bar.dart

import 'package:flutter/material.dart';
import 'package:referaly/resources/app_colors.dart';

class CommonAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showBack;
  final List<Widget>? actions;

  const CommonAppBar({
    super.key,
    required this.title,
    this.showBack = true,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      foregroundColor: AppColors.whiteColor,
       surfaceTintColor: AppColors.whiteColor,
      leading: showBack ? const BackButton() : null,
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      centerTitle: true,
      actions: actions,
      backgroundColor: Colors.white,
      elevation: 1,
      iconTheme: const IconThemeData(color: Colors.black),
      titleTextStyle: const TextStyle(color: Colors.black, fontSize: 18),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
