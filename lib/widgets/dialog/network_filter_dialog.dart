import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:referaly/languages/languagekeys.dart';
import 'package:referaly/resources/app_colors.dart';
import 'package:referaly/resources/text_style.dart';
import 'package:referaly/utils/translations.dart';

import '../../resources/app_assets.dart';

/// Shared "single filter" dialog used by both:
/// - My Network tab (`MyActivityController`)
/// - Business Referrers list (`BusinessReferrersController`)
///
/// API filter values:
/// active, pending, a_z, z_a, most_leads_sent, conversion_rate, turn_over_generated
Future<void> openNetworkFilterDialog(
  BuildContext context, {
  required int activeCount,
  required int pendingCount,
  required String currentFilterBy,
  required Future<void> Function(String filterBy) onSelect,
  required Future<void> Function() onClear,
}) {
  return showDialog<void>(
    context: context,
    barrierDismissible: true,
    builder: (ctx) => NetworkFilterDialog(
      activeCount: activeCount,
      pendingCount: pendingCount,
      currentFilterBy: currentFilterBy,
      onSelect: onSelect,
      onClear: onClear,
    ),
  );
}

class NetworkFilterDialog extends StatelessWidget {
  const NetworkFilterDialog({
    super.key,
    required this.activeCount,
    required this.pendingCount,
    required this.currentFilterBy,
    required this.onSelect,
    required this.onClear,
  });

  final int activeCount;
  final int pendingCount;
  final String currentFilterBy;
  final Future<void> Function(String filterBy) onSelect;
  final Future<void> Function() onClear;

  @override
  Widget build(BuildContext context) {
    final current = currentFilterBy.trim();

    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.sizeOf(context).width * 0.9,
          maxHeight: MediaQuery.sizeOf(context).height * 0.55,
        ),
        child: Material(
          color: Colors.white,
          elevation: 10,
          shadowColor: Colors.black.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          clipBehavior: Clip.antiAlias,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 21),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  border: Border(
                    bottom: BorderSide(color: Color(0xFFE5E7EB), width: 1),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        tr(LanguageKeys.myNetworkFilterOptionsTitle),
                        style: stylePoppins(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF111827),
                        ),
                      ),
                    ),
                    Material(
                      color: Colors.transparent,
                      shape: const CircleBorder(),
                      child: InkWell(
                        customBorder: const CircleBorder(),
                        onTap: () => Navigator.of(context).pop(),
                        child: const SizedBox(
                          width: 32,
                          height: 32,
                          child: Center(
                            child: Icon(Icons.close, size: 18, color: Color(0xFF6B7280)),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(15, 20, 12, 36),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Status section (gap 16)
                      Column(
                        children: [
                          _statusRow(
                            dotColor: const Color(0xFF22C55E),
                            label: tr(LanguageKeys.myNetworkFilterActive),
                            count: activeCount,
                            selected: current == 'active',
                            onTap: () async {
                              Navigator.of(context).pop();
                              unawaited(onSelect('active'));
                            },
                          ),
                          const SizedBox(height: 8),
                          _statusRow(
                            dotColor: const Color(0xFFFACC15),
                            label: tr(LanguageKeys.myNetworkFilterPending),
                            count: pendingCount,
                            selected: current == 'pending',
                            onTap: () async {
                              Navigator.of(context).pop();
                              unawaited(onSelect('pending'));
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),

                      // Sort / ranking section (gap 20)
                      Column(
                        children: [
                          _iconRow(
                            icon: AppAssets.imgSortAes,
                            iconColor: const Color(0xFF2563EB),
                            label: tr(LanguageKeys.myNetworkFilterAZ),
                            selected: current == 'a_z',
                            onTap: () async {
                              Navigator.of(context).pop();
                              unawaited(onSelect('a_z'));
                            },
                          ),
                          const SizedBox(height: 8),
                          _iconRow(
                            icon: AppAssets.imgSortDes,
                            iconColor: const Color(0xFF2563EB),
                            label: tr(LanguageKeys.myNetworkFilterZA),
                            selected: current == 'z_a',
                            onTap: () async {
                              Navigator.of(context).pop();
                              unawaited(onSelect('z_a'));
                            },
                          ),
                          const SizedBox(height: 8),
                          _iconRow(
                            icon: AppAssets.imgSendActivity,
                            iconColor: const Color(0xFF9333EA),
                            label: tr(LanguageKeys.myNetworkFilterMostLeadsSent),
                            selected: current == 'most_leads_sent',
                            onTap: () async {
                              Navigator.of(context).pop();
                              unawaited(onSelect('most_leads_sent'));
                            },
                          ),
                          const SizedBox(height: 8),
                          _iconRow(
                            icon: AppAssets.imgActivityStatics,
                            iconColor: const Color(0xFF16A34A),
                            label: tr(LanguageKeys.myNetworkFilterConversionRate),
                            selected: current == 'conversion_rate',
                            onTap: () async {
                              Navigator.of(context).pop();
                              unawaited(onSelect('conversion_rate'));
                            },
                          ),
                          const SizedBox(height: 8),
                          _iconRow(
                            icon: AppAssets.imgEuro,
                            iconColor: const Color(0xFFF97316),
                            label: tr(LanguageKeys.myNetworkFilterTurnoverGenerated),
                            selected: current == 'turn_over_generated',
                            onTap: () async {
                              Navigator.of(context).pop();
                              unawaited(onSelect('turn_over_generated'));
                            },
                          ),
                        ],
                      ),

                      // Not in Figma, but keeps existing functionality.
                      const SizedBox(height: 20),
                      Align(
                        alignment: Alignment.center,
                        child: TextButton(
                          onPressed: () async {
                            Navigator.of(context).pop();
                            unawaited(onClear());
                          },
                          child: Text(
                            tr(LanguageKeys.myNetworkClearFilters),
                            style: stylePoppins(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _statusRow({
    required Color dotColor,
    required String label,
    required int count,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return Material(
      color: selected ? AppColors.primary.withOpacity(0.2) : Colors.transparent,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 8,
          ),
          height: 40,
          child: Row(
            children: [
              Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(color: dotColor, shape: BoxShape.circle),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  label,
                  style: stylePoppins(
                    fontSize: 16.sp,
                    fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
                    color: const Color(0xFF111827),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFF3F4F6),
                  borderRadius: BorderRadius.circular(9999),
                ),
                child: Text(
                  '$count',
                  style: stylePoppins(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF6B7280),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _iconRow({
    required String icon,
    Color? iconColor,
    required String label,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return Material(
      color: selected ? AppColors.primary.withOpacity(0.2) : Colors.transparent,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          height: 40,
          child: Row(
            children: [
              SizedBox(
                width: 24,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: SvgPicture.asset(icon,
                      width: 18,
                      height: 18,
                      colorFilter: iconColor != null ? ColorFilter.mode(iconColor, BlendMode.srcIn) : null),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  label,
                  style: stylePoppins(
                    fontSize: 16.sp,
                    fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
                    color: const Color(0xFF111827),
                  ),
                ),
              ),
              // if (selected) const Icon(Icons.check, size: 18, color: AppColors.primary),
            ],
          ),
        ),
      ),
    );
  }
}
