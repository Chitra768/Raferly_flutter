import 'package:flutter/material.dart';

import '../resources/app_colors.dart';

class CustomToast {
  static void show(BuildContext context, String message,
      {Duration duration = const Duration(seconds: 2)}) {
    // This can be called during route transitions (e.g. cancelled social login),
    // where an Overlay might not be available. Never crash the app for a toast.
    try {
      FocusScope.of(context).unfocus();
    } catch (_) {}

    final overlay = Overlay.maybeOf(context);
    if (overlay == null) {
      final messenger = ScaffoldMessenger.maybeOf(context);
      if (messenger != null) {
        messenger.hideCurrentSnackBar();
        messenger.showSnackBar(
          SnackBar(
            content: Text(message),
            duration: duration,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
      return;
    }
    final overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        left: 20.0,
        right: 20.0,
        bottom: 20.0,
        child: Material(
          color: AppColors.transparent,
          child: AnimatedOpacity(
            opacity: 1.0,
            duration: const Duration(milliseconds: 350),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                color: AppColors.whiteColor,
                borderRadius: BorderRadius.circular(12.0),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.blackColor.withOpacity(0.2),
                    offset: const Offset(0, 4),
                    blurRadius: 8,
                  ),
                ],
              ),
              child: Text(
                message,
                style: TextStyle(
                  color: AppColors.blackColor,
                  fontSize: 15.0,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ),
    );

    // Insert the overlay entry
    overlay.insert(overlayEntry);

    // Fade out the toast after the given duration
    Future.delayed(duration, () {
      overlayEntry.remove();
    });
  }
}
