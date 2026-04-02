import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:referaly/controller/referral_tracking_controller.dart';
import 'package:referaly/languages/languagekeys.dart';
import 'package:referaly/models/model_parent_referral_statistics.dart';
import 'package:referaly/resources/app_colors.dart';
import 'package:referaly/resources/text_style.dart';
import 'package:referaly/utils/currency_formatter.dart';
import 'package:referaly/utils/translations.dart';
import 'package:referaly/widgets/logo_loader.dart';
import 'package:referaly/widgets/network_circle_avatar.dart';

class ReferralTrackingScreen extends GetView<ReferralTrackingController> {
  static String pageId = "/referralTracking";

  const ReferralTrackingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(ReferralTrackingController());

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        title: Text(
          tr(LanguageKeys.referralTracking),
          style: stylePoppins(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        centerTitle: false,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: SizedBox(width: 24, height: 24, child: LogoLoader()));
        }

        if (controller.error.value.isNotEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                controller.error.value,
                textAlign: TextAlign.center,
                style: stylePoppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF6B7280),
                ),
              ),
            ),
          );
        }

        final stats = controller.stats.value;
        if (stats == null) {
          return const SizedBox.shrink();
        }

        return RefreshIndicator(
          onRefresh: controller.fetchStatistics,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildStatsCards(stats),
                const SizedBox(height: 24),
                _buildLeadsBreakdown(stats),
                const SizedBox(height: 24),
                _buildCommissionsSection(stats),
                const SizedBox(height: 24),
                _buildReferrersList(stats.business_referrers ?? []),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildStatsCards(ParentReferralStatisticsData stats) {
    return Column(
      children: [
        _buildStatCard(
          label: tr(LanguageKeys.referrersAdded),
          value: (stats.referrer_added ?? 0).toString(),
          icon: Icons.people_outline,
          iconColor: AppColors.primary,
        ),
        const SizedBox(height: 12),
        _buildStatCard(
          label: tr(LanguageKeys.totalLeads),
          value: (stats.total_leads ?? 0).toString(),
          icon: Icons.trending_up,
          iconColor: AppColors.primary,
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required String label,
    required String value,
    required IconData icon,
    required Color iconColor,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB), width: 1),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label.toUpperCase(),
                style: stylePoppins(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF6B7280),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: stylePoppins(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF1F2937),
                ),
              ),
            ],
          ),
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: iconColor, size: 22),
          ),
        ],
      ),
    );
  }

  Widget _buildLeadsBreakdown(ParentReferralStatisticsData stats) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          tr(LanguageKeys.leadsBreakdown),
          style: stylePoppins(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF1F2937),
          ),
        ),
        const SizedBox(height: 12),
        _buildLeadRow(
          label: tr(LanguageKeys.wonLeads),
          count: stats.won_leads ?? 0,
          percentage: stats.won_leads_percentage ?? 0,
          color: const Color(0xFF22C55E),
          icon: Icons.check_circle,
        ),
        const SizedBox(height: 10),
        _buildLeadRow(
          label: tr(LanguageKeys.lostLeads),
          count: stats.lost_leads ?? 0,
          percentage: stats.lost_leads_percentage ?? 0,
          color: const Color(0xFFEF4444),
          icon: Icons.close,
        ),
        const SizedBox(height: 10),
        _buildLeadRow(
          label: tr(LanguageKeys.pendingLeads),
          count: stats.pending_leads ?? 0,
          percentage: stats.pending_leads_percentage ?? 0,
          color: const Color(0xFFF97316),
          icon: Icons.circle,
          iconSize: 12,
        ),
      ],
    );
  }

  Widget _buildLeadRow({
    required String label,
    required int count,
    required double percentage,
    required Color color,
    required IconData icon,
    double iconSize = 18,
  }) {
    final percentageText = percentage.toStringAsFixed(1);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFE5E7EB), width: 1),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label.toUpperCase(),
                  style: stylePoppins(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: color,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  "$count",
                  style: stylePoppins(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF1F2937),
                  ),
                ),
                Text(
                  "$percentageText% ${tr(LanguageKeys.ofTotal)}",
                  style: stylePoppins(
                    fontSize: 11,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF9CA3AF),
                  ),
                ),
              ],
            ),
          ),
          Icon(icon, color: color, size: iconSize),
        ],
      ),
    );
  }

  Widget _buildCommissionsSection(ParentReferralStatisticsData stats) {
    final totalCommission = stats.total_commission_amount ?? 0;
    final commissionRate = stats.commission_rate ?? 0;
    final parentCommission = stats.parent_commission_amount ?? 0;
    final rateProgress = (commissionRate / 100).clamp(0.0, 1.0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          tr(LanguageKeys.commissions),
          style: stylePoppins(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF1F2937),
          ),
        ),
        const SizedBox(height: 12),

        // Total Commission Generated card
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF7C3AED), Color(0xFF9333EA)],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    tr(LanguageKeys.totalCommissionGenerated).toUpperCase(),
                    style: stylePoppins(
                      fontSize: 9,
                      fontWeight: FontWeight.w600,
                      color: Colors.white.withOpacity(0.8),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    CurrencyFormatter.formatCurrency(totalCommission, locale: 'EUR'),
                    style: stylePoppins(
                      fontSize: 26,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.euro,
                  color: Colors.white,
                  size: 22,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 14),

        // Commission Rate
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              tr(LanguageKeys.commissionRate),
              style: stylePoppins(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF374151),
              ),
            ),
            Text(
              "${commissionRate.toStringAsFixed(0)}%",
              style: stylePoppins(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: rateProgress,
            minHeight: 6,
            backgroundColor: const Color(0xFFE5E7EB),
            valueColor:
                const AlwaysStoppedAnimation<Color>(AppColors.primary),
          ),
        ),

        const SizedBox(height: 14),

        // Your Total Commission card
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.primary, width: 1.5),
          ),
          child: Column(
            children: [
              Text(
                tr(LanguageKeys.yourTotalCommission).toUpperCase(),
                style: stylePoppins(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                CurrencyFormatter.formatCurrency(parentCommission, locale: 'EUR'),
                style: stylePoppins(
                  fontSize: 26,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF1F2937),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                "${commissionRate.toStringAsFixed(0)}% of ${CurrencyFormatter.formatCurrency(totalCommission, locale: 'EUR')}",
                style: stylePoppins(
                  fontSize: 11,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xFF9CA3AF),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildReferrersList(List<ParentBusinessReferrer> referrers) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          tr(LanguageKeys.businessReferrersAdded),
          style: stylePoppins(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF1F2937),
          ),
        ),
        const SizedBox(height: 12),
        if (referrers.isEmpty)
          Text(
            tr(LanguageKeys.noDataFound),
            style: stylePoppins(
              fontSize: 13,
              fontWeight: FontWeight.w400,
              color: const Color(0xFF9CA3AF),
            ),
          )
        else
          ...referrers.map(
            (r) => _buildReferrerRow(
              name: r.full_name ?? '',
              leadsCount: r.leads_sent ?? 0,
              avatarUrl: r.avatar_url ?? '',
            ),
          ),
      ],
    );
  }

  Widget _buildReferrerRow({
    required String name,
    required int leadsCount,
    required String avatarUrl,
  }) {
    final initial = name.isNotEmpty ? name[0].toUpperCase() : "?";
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        leading: avatarUrl.isNotEmpty
            ? NetworkCircleAvatar(imageUrl: avatarUrl, radius: 20)
            : CircleAvatar(
                radius: 20,
                backgroundColor: const Color(0xFFE5E7EB),
                child: Text(
                  initial,
                  style: stylePoppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF374151),
                  ),
                ),
              ),
        title: Text(
          name,
          style: stylePoppins(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF1F2937),
          ),
        ),
        subtitle: Text(
          "$leadsCount ${tr(LanguageKeys.xLeads)}",
          style: stylePoppins(
            fontSize: 12,
            fontWeight: FontWeight.w400,
            color: const Color(0xFF9CA3AF),
          ),
        ),
      ),
    );
  }
}
