import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:referaly/controller/busniess_referrers_controller.dart';
import 'package:referaly/languages/languagekeys.dart';
import 'package:referaly/models/model_network_response.dart';
import 'package:referaly/resources/app_assets.dart';
import 'package:referaly/resources/app_colors.dart';
import 'package:referaly/resources/text_style.dart';
import 'package:referaly/utils/translations.dart';
import 'package:intl/intl.dart';
import 'package:referaly/widgets/logo_loader.dart';
import 'package:url_launcher/url_launcher.dart';

class BusinessReferrersListScreen extends StatelessWidget {
  static const pageId = '/business_referrers_list';
  BusinessReferrersListScreen({Key? key}) : super(key: key);
  final controller = Get.put(BusinessReferrersController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        title: Obx(() => controller.isSearching.value
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 200.w,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: AppColors.grey100.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TextField(
                      controller: controller.searchController,
                      autofocus: true,
                      decoration: InputDecoration(
                        hintText: tr(LanguageKeys.searchPlaceholder),
                        border: InputBorder.none,
                        // suffixIcon: IconButton(
                        //   icon: const Icon(Icons.close),
                        //   onPressed: () {
                        //     controller.isSearching.value = false;
                        //     controller.searchController.clear();
                        //     controller.refreshList();
                        //   },
                        // ),
                      ),
                      onChanged: controller.onSearchChanged,
                    ),
                  ),
                  IconButton(
                      onPressed: () {
                        controller.isSearching.value = false;
                        controller.clearSearch();
                        controller.refreshList();
                      },
                      icon: Icon(Icons.close, color: AppColors.grey600)),
                ],
              )
            : Text(
                tr(LanguageKeys.bussinessreferrence),
                style: stylePoppins(
                    color: AppColors.blackColor,
                    fontWeight: FontWeight.w500,
                    fontSize: 17.sp),
              )),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          Obx(() => controller.isSearching.value
              ? const SizedBox.shrink()
              : IconButton(
                  icon: Image.asset(
                    AppAssets.imgSearch,
                    color: AppColors.blackColor,
                    width: 24,
                    height: 24,
                  ),
                  onPressed: () {
                    controller.isSearching.value = true;
                  },
                )),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
              child: SizedBox(width: 24, height: 24, child: LogoLoader()));
        }
        if (controller.error.isNotEmpty) {
          return Center(child: Text(controller.error.value));
        }
        // Check appropriate list based on search state
        final currentList = controller.isSearching.value
            ? controller.arrSearchReferrers
            : controller.referrers;

        print("UI Debug - isSearching: ${controller.isSearching.value}");
        print("UI Debug - referrers length: ${controller.referrers.length}");
        print(
            "UI Debug - arrSearchReferrers length: ${controller.arrSearchReferrers.length}");
        print("UI Debug - currentList length: ${currentList.length}");

        if (currentList.isEmpty) {
          return Center(
              child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  controller.isSearching.value
                      ? Icons.search_off
                      : Icons.people_outline,
                  size: 64,
                  color: AppColors.grey500,
                ),
                const SizedBox(height: 16),
                Text(
                  controller.isSearching.value
                      ? tr(LanguageKeys.noSearchResults)
                      : tr(LanguageKeys.noCollaborators),
                  style: stylePoppins(
                      color: AppColors.blackColor, fontWeight: FontWeight.w500),
                  textAlign: TextAlign.center,
                ),
                if (controller.isSearching.value) ...[
                  const SizedBox(height: 8),
                  Text(
                    tr(LanguageKeys.tryDifferentKeywords),
                    style: stylePoppins(
                        color: AppColors.grey600, fontWeight: FontWeight.w400),
                    textAlign: TextAlign.center,
                  ),
                ],
              ],
            ),
          ));
        }
        return Column(
          children: [
            // Search results indicator
            if (controller.isSearching.value &&
                controller.arrSearchReferrers.isNotEmpty)
              Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                color: AppColors.grey100,
                child: Text(
                  '${controller.arrSearchReferrers.length} ${tr(LanguageKeys.resultsFound)}',
                  style: stylePoppins(
                    color: AppColors.grey600,
                    fontWeight: FontWeight.w500,
                    fontSize: 14.sp,
                  ),
                ),
              ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: controller.isSearching.value
                    ? controller.arrSearchReferrers.length
                    : controller.referrers.length,
                itemBuilder: (context, index) {
                  // Use appropriate list based on search state
                  final isSearching = controller.isSearching.value;
                  final ref = isSearching
                      ? controller.arrSearchReferrers[index]
                      : controller.referrers[index];

                  return Obx(() {
                    final isExpanded = controller.expandedIndex.value == index;

                    // BusinessReferrers structure
                    final coworkerRef = ref;
                    final fullName =
                        "${coworkerRef.firstName ?? ''} ${coworkerRef.lastName ?? ''}"
                            .trim();

                    return BusinessReferrerListItem(
                      name: fullName,
                      data1Referrer: coworkerRef,
                      isExpanded: isExpanded,
                      onHeaderTap: () {
                        controller.toggleExpand(index);
                      },
                    );
                  });
                },
              ),
            ),
          ],
        );
      }),
    );
  }
}

class BusinessReferrerListItem extends StatelessWidget {
  final String name;
  final BusinessReferrers? data1Referrer;
  final bool isExpanded;
  final VoidCallback? onHeaderTap;

  const BusinessReferrerListItem({
    super.key,
    required this.name,
    this.data1Referrer,
    this.isExpanded = false,
    this.onHeaderTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onHeaderTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: AppColors.whiteColor,
          borderRadius: BorderRadius.circular(16),
          border:
              Border.all(color: AppColors.primary.withOpacity(0.2), width: 1),
        ),
        child: Stack(
          children: [
            data(context),
          ],
        ),
      ),
    );
  }

  Widget data(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header section
          GestureDetector(
            onTap: onHeaderTap,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  // Avatar with letter
                  Container(
                    width: 45,
                    height: 45,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey[200]!),
                      color: Colors.white,
                    ),
                    child: data1Referrer?.avatarUrl != null
                        ? Image.network(
                            data1Referrer?.avatarUrl ?? "",
                            fit: BoxFit.cover,
                          )
                        : Container(
                            width: 45,
                            height: 45,
                            decoration: BoxDecoration(
                              color: Colors.grey[400],
                              shape: BoxShape.circle,
                            ),
                            child: Image.asset(AppAssets.imgDefaultPerson),
                          ),
                  ),
                  const SizedBox(width: 16),
                  // Name and leads count
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          style: stylePoppins(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            Container(
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(
                                color: AppColors.primary,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              "${data1Referrer?.leadCount ?? "0"} leads envoyés",
                              style: stylePoppins(
                                fontSize: 11.sp,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // Expand/collapse arrow
                  Icon(
                    isExpanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: AppColors.grey600,
                    size: 32,
                  ),
                ],
              ),
            ),
          ),

          // Expanded content
          if (isExpanded) ...[
            // Source section
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFF5F3FF),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        width: 25,
                        height: 25,
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: const Icon(
                          Icons.link,
                          color: Colors.white,
                          size: 15,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Source du contact",
                            style: stylePoppins(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          tr(LanguageKeys.viaReferaly),
                          style: stylePoppins(
                            fontSize: 8.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Ce contact a été ajouté via la plateforme Referaly et bénéficie de toutes les fonctionnalités de suivi automatisé.",
                    style: stylePoppins(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w400,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Contact details
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  _buildDetailRow(
                    icon: AppAssets.imgPhoneActivity,
                    iconColor: AppColors.primary,
                    label: tr(LanguageKeys.phoneNumberNetwork),
                    value: data1Referrer?.phoneNumber ??
                        tr(LanguageKeys.notAvialble),
                  ),
                  const SizedBox(height: 20),
                  _buildDetailRow(
                    icon: AppAssets.imgEmailactivity,
                    iconColor: AppColors.primary,
                    label: tr(LanguageKeys.email),
                    value: data1Referrer?.email ?? tr(LanguageKeys.notAvialble),
                  ),
                  const SizedBox(height: 20),
                  _buildDetailRow(
                    icon: AppAssets.imgPersonactivity,
                    iconColor: AppColors.primary,
                    label: tr(LanguageKeys.companyType),
                    value: data1Referrer?.companyName ??
                        tr(LanguageKeys.notAvialble),
                  ),
                  const SizedBox(height: 20),
                  _buildDetailRow(
                    icon: AppAssets.imgJobActivity,
                    iconColor: AppColors.primary,
                    label: tr(LanguageKeys.job),
                    value: data1Referrer?.job ?? tr(LanguageKeys.notAvialble),
                  ),
                  const SizedBox(height: 20),
                  _buildDetailRow(
                    icon: AppAssets.imgBusniesActivity,
                    iconColor: AppColors.primary,
                    label: tr(LanguageKeys.contract),
                    value: data1Referrer?.lastAcceptedDealName ??
                        tr(LanguageKeys.notAvialble),
                  ),
                  const SizedBox(height: 20),
                  _buildDetailRow(
                    icon: AppAssets.imgCalanderActivity,
                    iconColor: AppColors.primary,
                    label: tr(LanguageKeys.acceptedDate),
                    value: _formatCreatedAt(data1Referrer?.createdAt),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Action buttons
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        _showSaveContactDialog(context);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColors.primary),
                          borderRadius: BorderRadius.circular(12),
                          color: AppColors.primary.withOpacity(0.1),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset(AppAssets.imgSaveActivity,
                                height: 15, color: AppColors.primary),
                            const SizedBox(width: 8),
                            Text(
                              "Sauvegarder",
                              style: stylePoppins(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w600,
                                color: AppColors.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.bar_chart,
                            color: Colors.grey,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            "Statistiques",
                            style: stylePoppins(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),
          ],
        ],
      ),
    );
  }

  Widget _buildDetailRow({
    required String icon,
    required Color iconColor,
    required String label,
    required String value,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 32,
          height: 32,
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: iconColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: SvgPicture.asset(
            icon,
            color: iconColor,
            width: 4,
            height: 4,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: stylePoppins(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: stylePoppins(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _formatCreatedAt(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return '';
    try {
      final date = DateTime.parse(dateStr);
      return DateFormat('dd/MM/yyyy').format(date);
    } catch (e) {
      return dateStr;
    }
  }

  void _showSaveContactDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 20),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header with close button
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.close,
                          color: Colors.black,
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Profile Picture Section
              Center(
                child: Stack(
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.grey[200]!, width: 2),
                      ),
                      child: data1Referrer?.avatarUrl != null
                          ? ClipOval(
                              child: Image.network(
                                data1Referrer!.avatarUrl!,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    decoration: BoxDecoration(
                                      color: Colors.grey[400],
                                      shape: BoxShape.circle,
                                    ),
                                    child:
                                        Image.asset(AppAssets.imgDefaultPerson),
                                  );
                                },
                              ),
                            )
                          : Container(
                              decoration: BoxDecoration(
                                color: Colors.grey[400],
                                shape: BoxShape.circle,
                              ),
                              child: Image.asset(AppAssets.imgDefaultPerson),
                            ),
                    ),
                    // Online indicator
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          color: Colors.green,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Name
              Text(
                name,
                style: stylePoppins(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 24),

              // Contact Information Fields
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  children: [
                    // Phone Field
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey[200]!),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 30,
                            height: 30,
                            decoration: BoxDecoration(
                              color: AppColors.primary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              Icons.phone,
                              color: AppColors.primary,
                              size: 15,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  tr(LanguageKeys.phoneNumber),
                                  style: stylePoppins(
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.grey[600],
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  data1Referrer?.phoneNumber ??
                                      tr(LanguageKeys.notAvialble),
                                  style: stylePoppins(
                                    fontSize: 13.sp,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          GestureDetector(
                            onTap: () async {
                              final Uri phoneUri = Uri(
                                  scheme: 'tel',
                                  path: data1Referrer?.phoneNumber);
                              if (await canLaunchUrl(phoneUri)) {
                                await launchUrl(phoneUri);
                              }
                            },
                            child: Container(
                              width: 30,
                              height: 30,
                              decoration: BoxDecoration(
                                color: AppColors.primary,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(
                                Icons.phone,
                                color: Colors.white,
                                size: 15,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Email Field
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey[200]!),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 30,
                            height: 30,
                            decoration: BoxDecoration(
                              color: AppColors.primary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              Icons.email,
                              color: AppColors.primary,
                              size: 15,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  tr(LanguageKeys.email),
                                  style: stylePoppins(
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.grey[600],
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  data1Referrer?.email ??
                                      tr(LanguageKeys.notAvialble),
                                  style: stylePoppins(
                                    fontSize: 13.sp,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          GestureDetector(
                            onTap: () async {
                              final Uri emailUri = Uri(
                                  scheme: 'mailto', path: data1Referrer?.email);
                              if (await canLaunchUrl(emailUri)) {
                                await launchUrl(emailUri);
                              }
                            },
                            child: Container(
                              width: 30,
                              height: 30,
                              decoration: BoxDecoration(
                                color: AppColors.primary,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(
                                Icons.email,
                                color: Colors.white,
                                size: 15,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Add Contact Button
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                child: Center(
                  child: GestureDetector(
                    onTap: () {
                      // TODO: Implement add contact functionality
                      Navigator.of(context).pop();
                      // Show success message
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            "Contact ajouté avec succès",
                            style: stylePoppins(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                          ),
                          backgroundColor: AppColors.primary,
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 12),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.person_add_alt_1,
                            color: Colors.white,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            "Ajouter le contact",
                            style: stylePoppins(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
