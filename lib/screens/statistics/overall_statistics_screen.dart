import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:referaly/controller/overall_statistics_controller.dart';
import 'package:referaly/languages/languagekeys.dart';
import 'package:referaly/resources/app_colors.dart';
import 'package:referaly/resources/app_assets.dart';
import 'package:referaly/utils/translations.dart';
import 'package:referaly/models/model_overall_statistics.dart';
import 'package:referaly/widgets/network_circle_avatar.dart';

class OverallStatisticsScreen extends GetView<OverallStatisticsController> {
  static const String pageId = '/overallStatistics';

  const OverallStatisticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        centerTitle: true,
        title: Text(
          tr(LanguageKeys.referralStatistics),
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (controller.error.value.isNotEmpty) {
          return Center(
            child: Text(
              controller.error.value,
              style: const TextStyle(color: Colors.red),
            ),
          );
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 8),
              _FilterBar(),
              const SizedBox(height: 16),
              _TopThreePodium(),
              const SizedBox(height: 12),
              _NextRanks(),
              const SizedBox(height: 18),
              Text(
                tr(LanguageKeys.overallStatistics),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 12),
              GridView(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 1.6,
                ),
                children: [
                  _StatTile(
                    title: tr(LanguageKeys.leadsSent),
                    value: controller.leadsSent.value.toString(),
                    icon: AppAssets.imgProfileSend,
                    color: AppColors.primary,
                  ),
                  _StatTile(
                    title: tr(LanguageKeys.lostLeads),
                    value: controller.lostLeads.value.toString(),
                    icon: AppAssets.imgLostLead,
                    color: AppColors.redColor,
                  ),
                  _StatTile(
                    title: tr(LanguageKeys.successfulLeads),
                    value: controller.successfulLeads.value.toString(),
                    icon: AppAssets.imgSuccessfulLeads,
                    color: const Color(0xFF16A34A),
                  ),
                  _StatTile(
                    title: tr(LanguageKeys.pendingLeads),
                    value: controller.pendingLeads.value.toString(),
                    icon: AppAssets.image5,
                    color: const Color(0xFFEA580C),
                  ),
                  _StatTile(
                    title: tr(LanguageKeys.conversionRate),
                    value:
                        '${controller.conversionRate.value.toStringAsFixed(1)}%',
                    icon: AppAssets.imgConversionRate,
                    color: const Color(0xFF2563EB),
                  ),

                  _StatTile(
                    title: tr(LanguageKeys.avgPerReferrer),
                    value: controller.avgPerReferrer.value.toStringAsFixed(1),
                    icon: AppAssets.imgGroup,
                    color: const Color(0xFF8A2BE2),
                  ),
                  // _StatTile(
                  //   title: tr(LanguageKeys.receivedPerMonth),
                  //   value: controller.receivedPerMonth.value.toStringAsFixed(1),
                  //   icon: AppAssets.imgReceivedMonth,
                  //   color: const Color(0xFF8A2BE2),
                  // ),
                  _StatTile(
                    title: tr(LanguageKeys.annualReceived),
                    value: controller.annualReceived.value.toStringAsFixed(1),
                    icon: AppAssets.imgReceivedMonth,
                    color: const Color(0xFF8A2BE2),
                  ),
                  _StatTile(
                    title: tr(LanguageKeys.commisionPaid),
                    value: _formatCurrencyCompact(controller.commission.value),
                    icon: AppAssets.imgCommission,
                    color: const Color(0xFF16A34A),
                  ),
                  _StatTile(
                    title: tr(LanguageKeys.turnover),
                    value: _formatCurrencyCompact(controller.turnover.value),
                    icon: AppAssets.imgTurnover,
                    color: const Color(0xFF8A2BE2),
                  ),
                  // Full width summary tile
                  _StatTile(
                    title: tr(LanguageKeys.totalIncomeGenerated),
                    value: _formatCurrencyCompactWithComma(double.tryParse(
                            controller.totalIncomeGenerated.value) ??
                        0.0),
                    icon: AppAssets.imgIncome,
                    color: const Color(0xFF16A34A),
                  ),
                  // _TotalTile(
                  //   title: 'Total Income Generated',
                  //   value:
                  //       _formatCurrency(controller.totalIncomeGenerated.value),
                  // ),
                ],
              ),
            ],
          ),
        );
      }),
    );
  }

  static String _formatCurrencyCompact(double value) {
    if (value.abs() >= 1000) {
      final thousands = value / 1000.0;
      final str = thousands >= 100
          ? thousands.toStringAsFixed(0)
          : thousands.toStringAsFixed(1);
      return '€${str}k';
    }
    return _formatCurrency(value);
  }

  static String _formatCurrencyCompactWithComma(double value) {
    if (value.abs() >= 1000) {
      final thousands = value / 1000.0;
      final str = thousands >= 100
          ? thousands.toStringAsFixed(0)
          : thousands.toStringAsFixed(1);
      // Replace period with comma for European decimal format
      return '€${str.replaceAll('.', ',')}k';
    }
    return _formatCurrency(value);
  }

  static String _formatCurrency(double value) {
    if (value >= 1000) {
      // Show compact like 24.6k for cards, except the final total where we show exact
      // This method returns an exact formatted amount with currency symbol.
    }
    // For now, use a simple Euro format without localization.
    final intPart = value.truncate();
    final remainder = ((value - intPart) * 100).round();
    final withThousands = intPart.toString().replaceAllMapped(
          RegExp(r'\B(?=(\d{3})+(?!\d))'),
          (m) => ',',
        );
    final decimals = remainder.toString().padLeft(2, '0');
    return '€$withThousands.$decimals';
  }
}

class _FilterBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final controller = Get.find<OverallStatisticsController>();

    return Obx(() {
      String getDisplayText() {
        final criteria = controller.selectedFilterCriteria.value;
        if (criteria.isEmpty) {
          return tr(LanguageKeys.filterByCriteria);
        }
        switch (criteria) {
          case 'leads_sent':
            return tr(LanguageKeys.perNumberOfLeadsSent);
          case 'conversion_rate':
            return tr(LanguageKeys.perConversionRate);
          case 'turnover':
            return tr(LanguageKeys.perTurnoverGenerated);
          default:
            return tr(LanguageKeys.filterByCriteria);
        }
      }

      final currentValue = controller.selectedFilterCriteria.value.isEmpty
          ? null
          : controller.selectedFilterCriteria.value;

      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: const Color(0xFFF2EFFF),
          borderRadius: BorderRadius.circular(14),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String?>(
            value: currentValue,
            isExpanded: true,
            icon:
                const Icon(Icons.filter_alt_rounded, color: Color(0xFF7A4DFF)),
            style: const TextStyle(
              color: Color(0xFF7A4DFF),
              fontWeight: FontWeight.w600,
            ),
            dropdownColor: Colors.white,
            hint: Center(
              child: Text(
                tr(LanguageKeys.filterByCriteria),
                style: const TextStyle(
                  color: Color(0xFF7A4DFF),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            items: [
              DropdownMenuItem<String?>(
                value: 'leads_sent',
                child: Text(
                  tr(LanguageKeys.perNumberOfLeadsSent),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              DropdownMenuItem<String?>(
                value: 'conversion_rate',
                child: Text(
                  tr(LanguageKeys.perConversionRate),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              DropdownMenuItem<String?>(
                value: 'turnover',
                child: Text(
                  tr(LanguageKeys.perTurnoverGenerated),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
            onChanged: (String? value) {
              controller.setFilterCriteria(value);
            },
            selectedItemBuilder: (BuildContext context) {
              return [
                Center(
                  child: Text(
                    getDisplayText(),
                    style: const TextStyle(
                      color: Color(0xFF7A4DFF),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Center(
                  child: Text(
                    getDisplayText(),
                    style: const TextStyle(
                      color: Color(0xFF7A4DFF),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Center(
                  child: Text(
                    getDisplayText(),
                    style: const TextStyle(
                      color: Color(0xFF7A4DFF),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ];
            },
          ),
        ),
      );
    });
  }
}

class _TopThreePodium extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final controller = Get.find<OverallStatisticsController>();
    return Obx(() {
      final items = [...controller.rankings];
      if (items.isEmpty) {
        return const SizedBox.shrink();
      }
      items.sort((a, b) => (a.rank!).compareTo(b.rank!));
      final first = items.isNotEmpty ? items[0] : null; // rank 1
      final second = items.length > 1 ? items[1] : null; // rank 2
      final third = items.length > 2 ? items[2] : null; // rank 3

      String formatName(item) {
        final fn = item.first_name ?? '';
        final ls = item.last_name_short ?? '';
        return (fn.isEmpty && ls.isEmpty)
            ? ''
            : '$fn ${ls.isEmpty ? '' : '$ls.'}'.trim();
      }

      // Helper function to get display value and label based on filter
      Map<String, String> getDisplayValue(ReferrerRanking item) {
        final filter = controller.selectedFilterCriteria.value;
        if (filter == 'leads_sent') {
          return {
            'value': '${item.lead_sent ?? 0}',
          };
        } else if (filter == 'conversion_rate') {
          return {
            'value': '${item.conversion_rate ?? 0}%',
            'label': '',
          };
        } else if (filter == 'turnover') {
          return {
            'value': OverallStatisticsScreen._formatCurrencyCompact(
                double.parse(item.turnover ?? '0')),
            'label': '',
          };
        } else {
          // Default: show leads
          return {
            'value': '${item.lead_sent ?? 0}',
          };
        }
      }

      return Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: second == null
                ? const SizedBox.shrink()
                : _PodiumTile(
                    avatarUrl: second.avatar ?? '',
                    rank: int.parse(second.rank ?? '2'),
                    name: formatName(second),
                    displayValue: getDisplayValue(second)['value'] ?? '0',
                    displayLabel: getDisplayValue(second)['label'] ?? 'leads',
                    height: 84,
                    barColor: const Color(0xFF757C8A),
                    ringColor: const Color(0xFF757C8A),
                    badgeColor: const Color(0xFF5B6170),
                    emblemstartColor: const Color(0xFFD1D5DB),
                    emblemendColor: const Color(0xFF6B7280),
                    emblemIcon: AppAssets.imgReward,
                  ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: first == null
                ? const SizedBox.shrink()
                : _PodiumTile(
                    avatarUrl: first.avatar ?? '',
                    rank: int.parse(first.rank ?? '1'),
                    name: formatName(first),
                    displayValue: getDisplayValue(first)['value'] ?? '0',
                    displayLabel: getDisplayValue(first)['label'] ?? 'leads',
                    height: 102,
                    isCenter: true,
                    barColor: const Color(0xFFEAB308),
                    ringColor: const Color(0xFFEAB308),
                    badgeColor: const Color(0xFFEAB308),
                    emblemstartColor: const Color(0xFFFDE047),
                    emblemendColor: const Color(0xFFEAB308),
                    emblemIcon: AppAssets.imgPurpleCrown,
                  ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: third == null
                ? const SizedBox.shrink()
                : _PodiumTile(
                    avatarUrl: third.avatar ?? '',
                    rank: int.parse(third.rank ?? '3'),
                    name: formatName(third),
                    displayValue: getDisplayValue(third)['value'] ?? '0',
                    displayLabel: getDisplayValue(third)['label'] ?? 'leads',
                    height: 72,
                    barColor: const Color(0xFFF26B2C),
                    ringColor: const Color(0xFFF26B2C),
                    badgeColor: const Color(0xFFEF6C3A),
                    emblemstartColor: const Color(0xFFFB923C),
                    emblemendColor: const Color(0xFFEA580C),
                    emblemIcon: AppAssets.imgReward1,
                  ),
          ),
        ],
      );
    });
  }
}

class _NextRanks extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final controller = Get.find<OverallStatisticsController>();
    return Obx(() {
      final items = [...controller.rankings]
        ..sort((a, b) => (a.rank!).compareTo(b.rank!));
      final below = items.where((e) => int.parse(e.rank ?? '0') >= 4).take(2).toList();

      String formatName(item) {
        final fn = item.first_name ?? '';
        final ls = item.last_name_short ?? '';
        return (fn.isEmpty && ls.isEmpty)
            ? ''
            : '$fn ${ls.isEmpty ? '' : '$ls.'}'.trim();
      }

      // Helper function to get display value and label based on filter
      Map<String, String> getDisplayValue(ReferrerRanking item) {
        final filter = controller.selectedFilterCriteria.value;
        if (filter == 'leads_sent') {
          return {
            'value': '${item.lead_sent ?? 0}',
          };
        } else if (filter == 'conversion_rate') {
          return {
            'value': '${item.conversion_rate ?? 0}%',
            'label': '',
          };
        } else if (filter == 'turnover') {
          return {
            'value': OverallStatisticsScreen._formatCurrencyCompact(
                double.parse(item.turnover ?? '0')),
            'label': '',
          };
        } else {
          // Default: show leads
          return {
            'value': '${item.lead_sent ?? 0}',
            'label': 'leads',
          };
        }
      }

      if (below.isEmpty) return const SizedBox.shrink();

      return Column(
        children: [
          _RankRow(
            avatarUrl: below[0].avatar ?? '',
            rank: int.parse(below[0].rank ?? '4'),
            name: formatName(below[0]),
            displayValue: getDisplayValue(below[0])['value'] ?? '0',
            displayLabel: getDisplayValue(below[0])['label'] ?? 'leads',
          ),
          if (below.length > 1) ...[
            const SizedBox(height: 10),
            _RankRow(
              avatarUrl: below[1].avatar ?? '',
              rank: int.parse(below[1].rank ?? '5'),
              name: formatName(below[1]),
              displayValue: getDisplayValue(below[1])['value'] ?? '0',
              displayLabel: getDisplayValue(below[1])['label'] ?? 'leads',
            ),
          ],
        ],
      );
    });
  }
}

class _PodiumTile extends StatelessWidget {
  final int rank;
  final String name;
  final String displayValue;
  final String displayLabel;
  final Color barColor;
  final double height;
  final bool isCenter;
  final Color ringColor;
  final Color badgeColor;
  final Color emblemstartColor;
  final Color emblemendColor;
  final String emblemIcon;
  final String avatarUrl;
  const _PodiumTile({
    required this.rank,
    required this.name,
    required this.displayValue,
    required this.displayLabel,
    required this.barColor,
    required this.height,
    this.isCenter = false,
    required this.ringColor,
    required this.badgeColor,
    required this.emblemstartColor,
    required this.emblemendColor,
    required this.emblemIcon,
    required this.avatarUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            // double-ring avatar with drop shadow
            Container(
              padding: EdgeInsets.all(isCenter ? 3 : 2.5),
              decoration: BoxDecoration(
                color: isCenter ? ringColor : Colors.transparent,
                shape: BoxShape.circle,
                boxShadow: const [
                  BoxShadow(
                      color: Color(0x22000000),
                      blurRadius: 8,
                      offset: Offset(0, 4)),
                ],
              ),
              child: Container(
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: isCenter ? Colors.transparent : Colors.transparent,
                  shape: BoxShape.circle,
                ),
                child: NetworkCircleAvatar(
                  imageUrl: avatarUrl,
                  radius: isCenter ? 26 : 26,
                ),
              ),
            ),
            // number badge bottom-right
            Positioned(
              right: 0,
              bottom: 0,
              child: Container(
                width: isCenter ? 26 : 24,
                height: isCenter ? 26 : 24,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  // subtle vertical gradient like the design
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      barColor.withOpacity(0.98),
                      barColor,
                    ],
                  ),
                  shape: BoxShape.circle,
                  boxShadow: const [
                    BoxShadow(
                        color: Color(0x33000000),
                        blurRadius: 4,
                        offset: Offset(0, 2)),
                  ],
                ),
                child: Text(
                  '$rank',
                  style: const TextStyle(
                      fontSize: 12,
                      color: Colors.white,
                      fontWeight: FontWeight.w600),
                ),
              ),
            ),
            // emblem removed from here; it will be aligned with the podium container below
          ],
        ),
        const SizedBox(height: 14),
        Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.topCenter,
          children: [
            Container(
              height: height,
              decoration: BoxDecoration(
                // subtle vertical gradient like the design
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    barColor.withOpacity(0.98),
                    barColor,
                  ],
                ),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(18),
                  topRight: Radius.circular(18),
                  bottomLeft: Radius.circular(1),
                  bottomRight: Radius.circular(1),
                ),
                boxShadow: const [
                  BoxShadow(
                      color: Color(0x26000000),
                      blurRadius: 10,
                      offset: Offset(0, 6)),
                ],
              ),
            ),
            Positioned(
              // overlap the top border like in the reference
              top: -12,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                      emblemstartColor,
                      emblemendColor,
                    ],
                  ),
                ),
                child: SvgPicture.asset(emblemIcon,
                    height: 22, width: 22, color: Colors.white),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          name,
          style:
              const TextStyle(fontWeight: FontWeight.w700, color: Colors.black),
        ),
        Text(
          '$displayValue $displayLabel',
          style: const TextStyle(fontSize: 12, color: Colors.black54),
        )
      ],
    );
  }
}

class _RankRow extends StatelessWidget {
  final int rank;
  final String name;
  final String displayValue;
  final String displayLabel;
  final String avatarUrl;
  const _RankRow(
      {required this.rank,
      required this.name,
      required this.displayValue,
      required this.displayLabel,
      required this.avatarUrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFFFFFF), Color(0xFFF3E8FF)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        border: Border.all(color: const Color(0xFF8A2BE2).withOpacity(0.1)),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Container(
            width: 26,
            alignment: Alignment.center,
            child: Text(
              '$rank',
              style: const TextStyle(
                  color: Colors.black38, fontWeight: FontWeight.w700),
            ),
          ),
          const SizedBox(width: 10),
          NetworkCircleAvatar(
            imageUrl: avatarUrl,
            radius: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(fontWeight: FontWeight.w700)),
                const SizedBox(height: 2),
                Text('$displayValue $displayLabel',
                    style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600)),
              ],
            ),
          ),
          const Icon(Icons.star, color: AppColors.primary),
        ],
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  final String title;
  final String value;
  final String icon;
  final Color color;

  const _StatTile({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primary.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                width: 34,
                height: 34,
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child:
                    SvgPicture.asset(icon, height: 18, width: 18, color: color),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      value,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _TotalTile extends StatelessWidget {
  final String title;
  final String value;

  const _TotalTile({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(top: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F8FA),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.black54,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 24,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}
