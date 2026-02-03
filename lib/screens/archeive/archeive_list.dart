import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:referaly/languages/languagekeys.dart';
import 'package:referaly/models/model_archive_list_receive.dart';
import 'package:referaly/resources/app_assets.dart';
import 'package:referaly/resources/app_colors.dart';
import 'package:referaly/resources/text_style.dart';
import 'package:referaly/screens/statistics/overall_statistics_screen.dart';
import 'package:referaly/utils/translations.dart';
import 'package:referaly/widgets/logo_loader.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:convert';

import '../../controller/controller_archeivvelist.dart';
import '../../widgets/custom_app_bar.dart';

class ArchiveList extends GetView<ArcheiveListController> {
  const ArchiveList({super.key});
  static String pageId = '/screenArcheiev';

  String _formatCreatedAt(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return '';
    try {
      final date = DateTime.parse(dateStr);
      return DateFormat('dd/MM/yyyy').format(date);
    } catch (e) {
      return dateStr;
    }
  }

  Future<void> _addToContacts(ArcheiveData? leadData) async {
    try {
      // Request both READ and WRITE contacts permissions
      final status = await FlutterContacts.requestPermission();
      if (status) {
        // Create new contact

        final fullName =
            '${leadData?.firstName ?? ''} ${leadData?.lastName ?? ''}';
        final parts = fullName.split(' ');
        final firstName = parts.isNotEmpty ? parts.first : '';
        final lastName = parts.length > 1 ? parts.sublist(1).join(' ') : '';

        final contact = Contact()
          ..name = Name(
              first:
                  '${firstName + ' ' + lastName} (${leadData?.user?.firstName ?? ''} ${leadData?.user?.lastName ?? ''})',
              last: '')
          ..phones = [Phone(leadData?.phoneNumber ?? '')]
          ..emails = [Email(leadData?.email ?? '')];
        await contact.insert();

        // Show success message
        Get.snackbar(
          tr(LanguageKeys.success),
          tr(LanguageKeys.contactAddedSuccessfully),
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: AppColors.primary,
          colorText: Colors.white,
        );
      } else {
        // Show error message if permission denied
        Get.snackbar(
          'Error',
          'Permission to access contacts was denied. Please enable it in settings.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
          mainButton: TextButton(
            onPressed: () async {
              await Permission.contacts.request();
            },
            child: const Text(
              'Grant Permission',
              style: TextStyle(color: Colors.white),
            ),
          ),
        );
      }
    } catch (e) {
      // Show error message if something goes wrong
      Get.snackbar(
        'Error',
        'Failed to add contact: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  String _extractLostReason(String? lostReasonStr) {
    if (lostReasonStr == null || lostReasonStr.isEmpty) return '';
    try {
      final List<dynamic> reasons = (lostReasonStr.startsWith('['))
          ? List<dynamic>.from(jsonDecode(lostReasonStr))
          : [];
      if (reasons.isNotEmpty && reasons[0]['reason'] != null) {
        return reasons[0]['reason'];
      }
      return '';
    } catch (e) {
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: CommonAppBar(
        title: tr(LanguageKeys.archive),
        actions: [
          PopupMenuButton<bool>(
            icon: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SvgPicture.asset(
                controller.isAssending.value
                    ? AppAssets.imgSortAes
                    : AppAssets.imgSortDes,
                colorFilter:
                    const ColorFilter.mode(AppColors.primary, BlendMode.srcIn),
                height: 32,
              ),
            ),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            color: AppColors.whiteColor,
            offset: const Offset(0, 40),
            itemBuilder: (context) => [
              PopupMenuItem<bool>(
                value: false,
                child: Text(
                  tr(LanguageKeys.newest),
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: !controller.isAssending.value
                        ? AppColors.primary
                        : AppColors.fontBlack,
                  ),
                ),
              ),
              PopupMenuItem<bool>(
                value: true,
                child: Text(
                  tr(LanguageKeys.oldest),
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: controller.isAssending.value
                        ? AppColors.primary
                        : AppColors.fontBlack,
                  ),
                ),
              ),
            ],
            onSelected: (value) {
              controller.isAssending.value = value;
              controller.getArchiveList(order: value ? "desc" : "asc");
            },
          ),
        ],
      ),
      body: Obx(
        () {
          if (controller.isLoading.value) {
            return const Center(
                child: SizedBox(width: 24, height: 24, child: LogoLoader()));
          }

          final filteredLeads = controller.filteredArchiveLeads;
          final isSearching = controller.searchQuery.value.trim().isNotEmpty;
          final hasArchivedLeads =
              controller.archiveList.value?.data?.isNotEmpty ?? false;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                _buildStatisticsSection(),
                const SizedBox(height: 16),
                _buildFilterButtons(),
                const SizedBox(height: 24),
                _buildSearchBar(),
                const SizedBox(height: 16),
                if (!hasArchivedLeads)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 48.0),
                    child: Text(
                      tr(controller.type.value == 'receive'
                          ? LanguageKeys.noArchiveReceive
                          : LanguageKeys.noArchiveSent),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: AppColors.blackColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w600),
                    ),
                  )
                else if (filteredLeads.isEmpty && isSearching)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 48.0),
                    child: Text(
                      tr(LanguageKeys.noDataFound),
                      style: stylePoppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.fontBlack),
                    ),
                  )
                else
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: filteredLeads.length,
                    itemBuilder: (context, index) {
                      final item = filteredLeads[index];
                      final isLost = item.isLost == '1';
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: _buildLeadCard(item, isLost),
                      );
                    },
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatisticsSection() {
    // Get statistics from API response
    final statistics = controller.archivedLeadStatistics.value?.data;
    final totalCommissionAmount = statistics?.totalCommissionAmount ?? 0.0;
    final totalArchivedLeads = statistics?.totalLeads ?? 0.0;
    final succeededLeads = statistics?.completedLeads ?? 0.0;

    return Container(
      padding: const EdgeInsets.all(8),
      child: Column(
        children: [
          // Three statistics cards
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  icon: Icons.people_sharp,
                  iconColor: const Color(0xFF805AD5), // Purple color
                  value: "${totalArchivedLeads.toStringAsFixed(0)}",
                  label: tr(LanguageKeys.totalArchivedLeads),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildStatCard(
                  icon: Icons.euro,
                  iconColor: const Color(0xFF48BB78), // Green color
                  value: '€ ${totalCommissionAmount.toStringAsFixed(0)}',
                  label: tr(LanguageKeys.commissionsPaid),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildStatCard(
                  icon: Icons.check,
                  iconColor: const Color(0xFF48BB78), // Green color
                  value: "${succeededLeads.toStringAsFixed(0)}",
                  label: tr(LanguageKeys.succeededLeads),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // See all statistics button

          if (controller.type.value == 'receive')
            GestureDetector(
              onTap: () {
                Get.toNamed(
                  OverallStatisticsScreen.pageId,
                );
              },
              child: Container(
                width: double.infinity,
                height: 48,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      AppAssets.imgActivityStatics,
                      colorFilter:
                          const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                      height: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      tr(LanguageKeys.seeAllStatistics),
                      style: stylePoppins(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildFilterButtons() {
    return Row(
      children: [
        Expanded(
          child: Obx(() => GestureDetector(
                onTap: () {
                  controller.setFilterType('won');
                },
                child: Container(
                  height: 48,
                  margin: const EdgeInsets.only(left: 18),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: controller.selectedFilterType.value == 'won'
                          ? Colors.green
                          : Colors.green.withOpacity(0.5),
                      width: 1.5,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.check,
                        color: controller.selectedFilterType.value == 'won'
                            ? Colors.green
                            : Colors.green.withOpacity(0.7),
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        tr(LanguageKeys.succeeded),
                        style: stylePoppins(
                          color: controller.selectedFilterType.value == 'won'
                              ? Colors.green
                              : Colors.green.withOpacity(0.7),
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              )),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Obx(() => GestureDetector(
                onTap: () {
                  controller.setFilterType('lost');
                },
                child: Container(
                  height: 48,
                  margin: const EdgeInsets.only(right: 18),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: controller.selectedFilterType.value == 'lost'
                          ? Colors.red
                          : Colors.red.withOpacity(0.5),
                      width: 1.5,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.close,
                        color: controller.selectedFilterType.value == 'lost'
                            ? Colors.red
                            : Colors.red.withOpacity(0.7),
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        tr(LanguageKeys.lost),
                        style: stylePoppins(
                          color: controller.selectedFilterType.value == 'lost'
                              ? Colors.red
                              : Colors.red.withOpacity(0.7),
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              )),
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: TextField(
        onChanged: controller.updateSearchQuery,
        textInputAction: TextInputAction.search,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(vertical: 12),
          prefixIcon: const Icon(Icons.search, color: Color(0xFF94A3B8)),
          border: InputBorder.none,
          hintText: tr(LanguageKeys.searchPlaceholderLeads),
          hintStyle: stylePoppins(
            color: const Color(0xFF94A3B8),
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required Color iconColor,
    required String value,
    required String label,
  }) {
    return Container(
      height: 180, // Further increased height to prevent overflow
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Icon container
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: iconColor,
              size: 24,
            ),
          ),
          const SizedBox(height: 8), // Fixed spacing
          // Value
          Text(
            value,
            textAlign: TextAlign.center,
            style: stylePoppins(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF2D3748),
            ),
          ),
          const SizedBox(height: 4),
          // Label
          Text(
            label,
            maxLines: 2,
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            style: stylePoppins(
              fontSize: 10.sp,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF718096),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFinancialButtons(ArcheiveData item) {
    // Calculate financial values for this specific lead
    // final commission =
    //     double.tryParse(item.deal?.commissionValue ?? '0') ?? 0.0;
    // final turnover =
    //     commission > 0 ? commission / 0.3 : 0.0; // Assuming 30% commission rate
    // final netIncome = turnover - commission;

    return Row(
      children: [
        if (item.turnover != null) ...[
          Expanded(
            child: _buildFinancialButton(
              icon: Icons.trending_up,
              iconColor: const Color(0xFF48BB78), // Purple color
              value: '€${item.turnover ?? '0'}',
              label: tr(LanguageKeys.turnover),
              onTap: () => _showFinancialDetails(tr(LanguageKeys.turnover),
                  double.tryParse(item.turnover ?? '0') ?? 0.0),
            ),
          ),
        ],
        if (item.turnover != null) ...[
          const SizedBox(width: 8),
        ],
        if (item.commissionAmount != null) ...[
          Expanded(
            child: _buildFinancialButton(
              icon: Icons.euro,
              iconColor: const Color(0xFF48BB78), // Green color
              value: '€${item.commissionAmount ?? '0'}',
              label: tr(LanguageKeys.commission),
              onTap: () => _showFinancialDetails(tr(LanguageKeys.commission),
                  double.tryParse(item.commissionAmount ?? '0') ?? 0.0),
            ),
          ),
        ],
        if (item.commissionAmount != null) ...[
          const SizedBox(width: 8),
        ],
        if (item.netIncome != null) ...[
          Expanded(
            child: _buildFinancialButton(
              icon: Icons.account_balance_wallet,
              iconColor: const Color(0xFF48BB78), // Blue color
              value:
                  '€${double.tryParse(item.netIncome ?? '0')?.toStringAsFixed(0) ?? '0'}',
              label: tr(LanguageKeys.netIncome),
              onTap: () => _showFinancialDetails(tr(LanguageKeys.netIncome),
                  double.tryParse(item.netIncome ?? '0') ?? 0.0),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildFinancialButton({
    required IconData icon,
    required Color iconColor,
    required String value,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 40,
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: label == tr(LanguageKeys.turnover) ||
                  label == tr(LanguageKeys.commission)
              ? Colors.green.withOpacity(0.05)
              : Colors.green.withOpacity(0.2),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Value
            Text(
              value,
              textAlign: TextAlign.center,
              style: stylePoppins(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: iconColor,
              ),
            ),
            const SizedBox(height: 2),
            // Label
            Text(
              label,
              maxLines: 1,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              style: stylePoppins(
                fontSize: 8.sp,
                fontWeight: FontWeight.w500,
                color: iconColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLeadCard(ArcheiveData item, bool isLost) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with name and referrer
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile image or default icon
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.grey[200],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: item?.companyLogoUrl?.isNotEmpty ?? false
                      ? Image.network(
                          item?.companyLogoUrl ?? '',
                          width: 40,
                          height: 40,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Image.asset(
                              AppAssets.imgDefaultPerson,
                              width: 40,
                              height: 40,
                              fit: BoxFit.cover,
                            );
                          },
                        )
                      : Image.asset(
                          AppAssets.imgDefaultPerson,
                          width: 40,
                          height: 40,
                          fit: BoxFit.cover,
                        ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Text(
                          "${item?.firstName ?? ''} ${item?.lastName ?? ''}",
                          style: stylePoppins(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        const Spacer(),
                        // Status indicator
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: isLost
                                    ? Colors.red.withOpacity(0.1)
                                    : Colors.green.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    isLost ? Icons.close : Icons.check,
                                    color: isLost ? Colors.red : Colors.green,
                                    size: 16,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    isLost
                                        ? tr(LanguageKeys.lost)
                                        : tr(LanguageKeys.succeeded),
                                    style: stylePoppins(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: isLost ? Colors.red : Colors.green,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${tr(LanguageKeys.referredBy)}: ${item?.user?.firstName ?? ''} ${item?.user?.lastName ?? ''}',
                      style: stylePoppins(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Text(
                          _formatCreatedAt(item?.createdAt ?? ''),
                          style: stylePoppins(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey[500],
                          ),
                        ),
                        const Spacer(),
                      ],
                    ),
                    // Lost reason section (only for lost leads)
                    if (isLost) ...[
                      const SizedBox(height: 16),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.red.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                          border:
                              Border.all(color: Colors.red.withOpacity(0.3)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              tr(LanguageKeys.reasonOfTheLoss),
                              style: stylePoppins(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Colors.red,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              _extractLostReason(item?.lostReason),
                              style: stylePoppins(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: Colors.red[700],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],

                    // Financial buttons (only for non-lost leads)
                    if (!isLost) ...[
                      const SizedBox(height: 16),
                      _buildFinancialButtons(item),
                    ],

                    const SizedBox(height: 16),

                    // Action buttons
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: isLost ? 50 : 40,
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: TextButton.icon(
                              onPressed: () {
                                _showLeadDescription(item);
                              },
                              icon: const Icon(
                                Icons.visibility,
                                color: Colors.white,
                                size: 14,
                              ),
                              label: Text(
                                tr(LanguageKeys.seeDescription),
                                textAlign: TextAlign.start,
                                maxLines: isLost ? 2 : 1,
                                overflow: TextOverflow.ellipsis,
                                style: stylePoppins(
                                  color: Colors.white,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ),
                        if (isLost && controller.type.value == "receive") ...[
                          const SizedBox(width: 8),
                          Expanded(
                            child: Container(
                              height: 50,
                              decoration: BoxDecoration(
                                color: AppColors.primary,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: TextButton.icon(
                                onPressed: () {
                                  controller.recoverArchiveLead(
                                      leadId: item?.id ?? '');
                                },
                                icon: const Icon(
                                  Icons.refresh,
                                  color: Colors.white,
                                  size: 14,
                                ),
                                label: Text(
                                  tr(LanguageKeys.retrieve),
                                  textAlign: TextAlign.center,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: stylePoppins(
                                    color: Colors.white,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ],
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

  void _showLeadDescription(dynamic item) {
    showModalBottomSheet(
      backgroundColor: Colors.white,
      context: Get.context!,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Top bar with title and close button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const SizedBox(width: 40), // For alignment
                      Text(
                        tr(LanguageKeys.description),
                        style: stylePoppins(
                          fontSize: 24,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.grey),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Action buttons
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            _addToContacts(item);
                          },
                          child: Container(
                            height: 48,
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.person_add,
                                  color: Colors.white,
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  tr(LanguageKeys.addContact),
                                  textAlign: TextAlign.center,
                                  maxLines: 2,
                                  style: stylePoppins(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            final contactInfo = '''
${item?.firstName?.trim() ?? ''} ${item?.lastName?.trim() ?? ''}
${item?.phoneNumber?.trim() ?? ''}
${item?.email?.trim() ?? ''}

''';
                            Share.share(contactInfo);
                          },
                          child: Container(
                            height: 48,
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.share,
                                  color: Colors.white,
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  tr(LanguageKeys.share),
                                  textAlign: TextAlign.center,
                                  maxLines: 2,
                                  style: stylePoppins(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  // Card with details
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 8,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        _infoTile(
                          Icons.person,
                          tr(LanguageKeys.name),
                          "${item?.firstName ?? ''} ${item?.lastName ?? ''}",
                        ),
                        const Divider(),
                        _infoTile(
                          Icons.business,
                          tr(LanguageKeys.nameOfTheBusinessReferrer),
                          "${item?.user?.firstName ?? ''} ${item?.user?.lastName ?? ''}",
                        ),
                        const Divider(),
                        _infoTile(
                          Icons.phone,
                          tr(LanguageKeys.phoneNumber),
                          item?.phoneNumber ?? '',
                        ),
                        const Divider(),
                        _infoTile(
                          Icons.email,
                          tr(LanguageKeys.email),
                          item?.email ?? '',
                        ),
                        const Divider(),
                        _infoTile(
                          Icons.description,
                          tr(LanguageKeys.description),
                          item?.description ?? '',
                        ),
                        const Divider(),
                        _infoTile(
                          Icons.calendar_month,
                          tr(LanguageKeys.dateArchive),
                          DateFormat('dd/MM/yyyy').format(
                            DateTime.parse(item?.createdAt ?? ''),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

// Helper widget for info row
  Widget _infoTile(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: AppColors.primary),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label,
                  style: stylePoppins(color: Colors.grey, fontSize: 13)),
              const SizedBox(height: 2),
              if (label == tr(LanguageKeys.phoneNumber) &&
                  value.isNotEmpty &&
                  value != "null")
                GestureDetector(
                  onTap: () async {
                    final Uri phoneLaunchUri = Uri(
                      scheme: 'tel',
                      path: value,
                    );
                    if (await canLaunchUrl(phoneLaunchUri)) {
                      await launchUrl(phoneLaunchUri);
                    }
                  },
                  child: Text(
                    value,
                    style: stylePoppins(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                      color: AppColors.primary,
                    ).copyWith(
                      decoration: TextDecoration.underline,
                    ),
                  ),
                )
              else if (label == tr(LanguageKeys.email) &&
                  value.isNotEmpty &&
                  value != "null")
                GestureDetector(
                  onTap: () async {
                    final Uri emailLaunchUri = Uri(
                      scheme: 'mailto',
                      path: value,
                    );
                    if (await canLaunchUrl(emailLaunchUri)) {
                      await launchUrl(emailLaunchUri);
                    }
                  },
                  child: Text(
                    value != "null" ? value : tr(LanguageKeys.nullDataText),
                    style: stylePoppins(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                      color: AppColors.primary,
                    ).copyWith(
                      decoration: TextDecoration.underline,
                    ),
                  ),
                )
              else
                Text(
                  value != "null" ? value : tr(LanguageKeys.nullDataText),
                  style: stylePoppins(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Color _financialAccentColor(String type) {
    final normalized = type.toLowerCase();
    if (normalized.contains('turnover')) {
      return const Color(0xFF2F855A);
    } else if (normalized.contains('commission')) {
      return const Color(0xFFDD6B20);
    }
    return const Color(0xFF7F3DFF);
  }

  Color _financialSurfaceColor(Color accent) {
    return Color.alphaBlend(accent.withOpacity(0.08), Colors.white);
  }

  void _showFinancialDetails(String type, double amount) {
    final accentColor = _financialAccentColor(type);
    final currencyFormatter =
        NumberFormat.currency(symbol: '€', decimalDigits: 2, locale: 'en');
    final formattedAmount = currencyFormatter.format(amount);

    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: Get.context!,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
          ),
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 16,
            bottom: MediaQuery.of(context).viewInsets.bottom + 24,
          ),
          child: SafeArea(
            top: false,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Stack(
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        type,
                        style: stylePoppins(
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    Positioned(
                      right: -12,
                      top: -12,
                      child: IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(
                          Icons.close,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Container(
                  width: double.infinity,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.15),
                        blurRadius: 18,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        formattedAmount,
                        style: stylePoppins(
                          fontSize: 36,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        type == tr(LanguageKeys.turnover)
                            ? tr(LanguageKeys.totalTurnover)
                            : type == tr(LanguageKeys.commission)
                                ? tr(LanguageKeys.totalCommission)
                                : tr(LanguageKeys.totalNetIncome),
                        style: stylePoppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  type == tr(LanguageKeys.turnover)
                      ? tr(LanguageKeys.thisShowsSpecificLeadTurnover)
                      : type == tr(LanguageKeys.commission)
                          ? tr(LanguageKeys.thisShowsSpecificLeadCommission)
                          : tr(LanguageKeys.thisShowsSpecificLeadNetIncome),
                  textAlign: TextAlign.center,
                  style: stylePoppins(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
