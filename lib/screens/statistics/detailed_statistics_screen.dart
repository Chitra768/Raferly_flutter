import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:referaly/controller/detailed_statistics_controller.dart';
import 'package:referaly/languages/languagekeys.dart';
import 'package:referaly/resources/app_colors.dart';
import 'package:referaly/utils/translations.dart';
import 'package:referaly/utils/currency_formatter.dart';
import 'package:referaly/widgets/logo_loader.dart';
import 'package:referaly/widgets/network_circle_avatar.dart';

class DetailedStatisticsScreen extends GetView<DetailedStatisticsController> {
  static const String pageId = '/detailedStatistics';

  const DetailedStatisticsScreen({super.key});

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
          tr(LanguageKeys.detailedStatistics),
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
      ),
      body: Obx(() => controller.isLoading.value
          ? const Center(
              child: SizedBox(width: 24, height: 24, child: LogoLoader()))
          : SafeArea(
              child: SingleChildScrollView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildProfileCard(),
                    const SizedBox(height: 14),
                    Text(
                      tr(LanguageKeys.rankings),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 14),
                    Obx(() => _buildRankCard(
                          title: tr(LanguageKeys.leadsRanking),
                          subtitle: tr(LanguageKeys.basedOnNumberOfLeadsSent),
                          rank: '#${controller.leadsRanking.value}',
                          total:
                              '/ ${controller.leadsRankingTotal.value} ${tr(LanguageKeys.referrersStatistics)}',
                          gradient: const LinearGradient(
                            colors: [Color(0xFFF5EAFE), Color(0xFFEFE7FF)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        )),
                    const SizedBox(height: 12),
                    Obx(() => _buildRankCard(
                          title: tr(LanguageKeys.conversionRanking),
                          subtitle: tr(LanguageKeys.basedOnConversionRate),
                          rank: '#${controller.conversionRanking.value}',
                          total:
                              '/ ${controller.conversionRankingTotal.value} ${tr(LanguageKeys.referrersStatistics)}',
                          gradient: const LinearGradient(
                            colors: [Color(0xFFEFFCF3), Color(0xFFE7F8EE)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          rankColor: const Color(0xFF16A34A),
                        )),
                    const SizedBox(height: 14),
                    Text(
                      tr(LanguageKeys.leadStatistics),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 14),
                    Obx(() => GridView(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 12,
                            crossAxisSpacing: 12,
                            childAspectRatio: 1.7,
                          ),
                          children: [
                            _buildStatBox(
                              value: controller.leadsSent.value.toString(),
                              label: tr(LanguageKeys.leadsSent),
                              valueColor: const Color(0xFF2563EB),
                              background: const Color(0xFFEFF3FF),
                            ),
                            _buildStatBox(
                              value: controller.lostLeads.value.toString(),
                              label: tr(LanguageKeys.lostLeads),
                              valueColor: const Color(0xFFEF4444),
                              background: const Color(0xFFFFEEEE),
                            ),
                            _buildStatBox(
                              value:
                                  controller.successfulLeads.value.toString(),
                              label: tr(LanguageKeys.successfulLeads),
                              valueColor: const Color(0xFF16A34A),
                              background: const Color(0xFFEFFCF3),
                            ),
                            _buildStatBox(
                              value: controller.pendingLeads.value.toString(),
                              label: tr(LanguageKeys.pendingLeads),
                              valueColor: const Color(0xFFF59E0B),
                              background: const Color(0xFFFFF8E1),
                            ),
                          ],
                        )),
                    const SizedBox(height: 14),
                    Text(
                      tr(LanguageKeys.performance),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 14),
                    Obx(() => _buildConversionCard(
                          rate: double.tryParse(
                                  controller.conversionRate.value) ??
                              0.0,
                          note: controller.conversionNote.value,
                        )),
                    const SizedBox(height: 8),
                    Obx(() => _buildMonthlyCard(
                        rate: double.tryParse(
                                controller.monthlyConversionRate.value) ??
                            0.0)),
                    const SizedBox(height: 24),
                    // Financial Data section
                    Text(
                      tr(LanguageKeys.financialData),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 14),
                    Obx(() => Column(
                          children: [
                            _buildFinancialCard(
                              title: tr(LanguageKeys.totalCommissionPaid),
                              value: CurrencyFormatter.formatCurrency(
                                  double.tryParse(controller
                                          .totalCommissionAmount.value) ??
                                      0.0,
                                  locale: 'EUR'),
                              background: const Color(0xFFF2E8FF),
                              titleColor: const Color(0xFF7C3AED),
                              valueColor: const Color(0xFF7C3AED),
                            ),
                            const SizedBox(height: 12),
                            _buildFinancialCard(
                              title: tr(LanguageKeys.turnoverGenerated),
                              value: CurrencyFormatter.formatCurrency(
                                  double.tryParse(
                                          controller.turnoverGenerated.value) ??
                                      0.0,
                                  locale: 'EUR'),
                              background: const Color(0xFFEFFCF3),
                              titleColor: const Color(0xFF16A34A),
                              valueColor: const Color(0xFF16A34A),
                            ),
                            const SizedBox(height: 12),
                            _buildFinancialCard(
                              title: tr(LanguageKeys.profitGenerated),
                              value: CurrencyFormatter.formatCurrency(
                                  double.tryParse(
                                          controller.profitGenerated.value) ??
                                      0.0,
                                  locale: 'EUR'),
                              background: const Color(0xFFEFF5FF),
                              titleColor: const Color(0xFF2563EB),
                              valueColor: const Color(0xFF2563EB),
                            ),
                          ],
                        )),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            )),
    );
  }

  Widget _buildProfileCard() {
    return Obx(() => Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.grey200),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 12,
                offset: const Offset(0, 6),
              )
            ],
          ),
          child: Row(
            children: [
              NetworkCircleAvatar(
                imageUrl: controller.userAvatar.value,
                radius: 24,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      controller.userName.value,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      controller.userRole.value,
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.grey600,
                      ),
                    ),
                  ],
                ),
              ),
              if (controller.userBadge.value.isNotEmpty)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5EAFE),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    controller.userBadge.value,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
            ],
          ),
        ));
  }

  Widget _buildRankCard({
    required String title,
    required String subtitle,
    required String rank,
    required String total,
    required Gradient gradient,
    Color rankColor = AppColors.primary,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: rankColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: AppColors.grey600,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                rank,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: rankColor,
                ),
              ),
              Text(
                total,
                style: TextStyle(
                  fontSize: 10,
                  color: AppColors.grey600,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildStatBox({
    required String value,
    required String label,
    required Color valueColor,
    required Color background,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w600,
              color: valueColor,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 13.sp,
              color: AppColors.grey700,
              fontWeight: FontWeight.w400,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildConversionCard({required double rate, required String note}) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.textFieldColor.withOpacity(0.2),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.textFieldColor.withOpacity(0.5)),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  tr(LanguageKeys.conversionRate),
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textTitle,
                  ),
                ),
              ),
              Text(
                '${rate.toStringAsFixed(1)}%',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF16A34A),
                ),
              ),
            ],
          ),
          Text(
            note,
            style: TextStyle(
              color: AppColors.grey600,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMonthlyCard({required double rate}) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.textFieldColor.withOpacity(0.2),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.textFieldColor.withOpacity(0.5)),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  tr(LanguageKeys.monthlyConversionRate),
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textTitle,
                  ),
                ),
              ),
              Text(
                rate == 0 || rate == 0.0 ? 'N/A' : '${rate.toInt()}',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF16A34A),
                ),
              ),
            ],
          ),
          Text(
            tr(LanguageKeys.leadsPerMonth),
            style: TextStyle(
              color: AppColors.grey600,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFinancialCard({
    required String title,
    required String value,
    required Color background,
    required Color titleColor,
    required Color valueColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: titleColor,
              ),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: valueColor,
            ),
          )
        ],
      ),
    );
  }
}
