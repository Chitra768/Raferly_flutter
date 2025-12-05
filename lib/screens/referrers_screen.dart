import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:referaly/controller/referrers_controller.dart';
import 'package:referaly/languages/languagekeys.dart';
import 'package:referaly/resources/app_assets.dart';
import 'package:referaly/resources/app_colors.dart';
import 'package:referaly/resources/text_style.dart';
import 'package:referaly/utils/translations.dart';
import 'package:intl/intl.dart';
import 'package:referaly/widgets/logo_loader.dart';
import 'package:referaly/models/model_collaboratorList.dart';

import '../models/model_referral_list.dart';

class ReferrersScreen extends StatelessWidget {
  static const pageId = '/referrers';
  ReferrersScreen({Key? key}) : super(key: key);
  final controller = Get.put(ReferrersController());

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
                tr(LanguageKeys.inviteCollab),
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
            child: Text(tr(LanguageKeys.noCollaborators),
                style: stylePoppins(
                    color: AppColors.blackColor, fontWeight: FontWeight.w500)),
          ));
        }
        return Column(
          children: [
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

                    // Handle different data structures
                    String? avatar;
                    String? fullName;
                    String? phoneNumber;
                    String? email;
                    String? createdAt;
                    String? userId;

                    if (isSearching) {
                      // BusinessReferralLeadData structure
                      final searchRef = ref as ReferrelData;
                      avatar = searchRef.companyLogoUrl;
                      fullName =
                          "${searchRef.firstName ?? ''} ${searchRef.lastName ?? ''}"
                              .trim();
                      phoneNumber = searchRef.phoneNumber;
                      email = searchRef.email;
                      createdAt = searchRef.createdAt;
                      userId = searchRef.id?.toString();
                    } else {
                      // CoworkerlistData structure
                      final coworkerRef = ref as CoworkerlistData;
                      avatar = coworkerRef.user?.companyLogoUrl;
                      fullName = coworkerRef.user?.fullName;
                      phoneNumber = coworkerRef.user?.phoneNumber;
                      email = coworkerRef.user?.email;
                      createdAt = coworkerRef.createdAt;
                      userId = coworkerRef.id?.toString();
                    }

                    return Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: const Color(0xfff9fafb),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.grey200),
                      ),
                      child: Column(
                        children: [
                          ListTile(
                            contentPadding: const EdgeInsets.all(8),
                            leading: Container(
                              height: 50.w,
                              width: 50.w,
                              decoration: BoxDecoration(
                                color: AppColors.whiteColor,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.network(
                                  avatar ?? '',
                                  height: 50.w,
                                  width: 50.w,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            title: Text(
                              fullName ?? '',
                              style:
                                  const TextStyle(fontWeight: FontWeight.w500),
                            ),
                            trailing: SizedBox(
                              width: 70,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  // Show add icon when searching, delete icon when not searching
                                  GestureDetector(
                                    child: Icon(
                                      isSearching
                                          ? Icons.person_add_rounded
                                          : Icons.delete,
                                      color: isSearching
                                          ? AppColors.primary
                                          : AppColors.primary,
                                      size: 24,
                                    ),
                                    onTap: () {
                                      if (isSearching) {
                                        controller.addCoworker(
                                            userID: userId ?? '');
                                      } else {
                                        controller.deleteCoworker(
                                            userID: userId ?? '');
                                      }
                                    },
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      controller.toggleExpand(index);
                                    },
                                    child: Icon(isExpanded
                                        ? Icons.expand_less
                                        : Icons.expand_more),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          if (isExpanded)
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16.0, vertical: 8),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Divider(
                                    color: AppColors.grey200,
                                  ),
                                  _infoRow(tr(LanguageKeys.phoneNumber),
                                      phoneNumber ?? "",
                                      isLink: true),
                                  const SizedBox(height: 8),
                                  _infoRow(tr(LanguageKeys.email), email ?? "",
                                      isLink: true),
                                  const SizedBox(height: 8),
                                  _infoRow(tr(LanguageKeys.createdDate),
                                      _formatCreatedAt(createdAt)),
                                ],
                              ),
                            ),
                        ],
                      ),
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

  Widget _infoRow(String label, String value, {bool isLink = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        children: [
          Expanded(
              child: Text(
            label,
            style: stylePoppins(
              color: AppColors.grey600,
              fontWeight: FontWeight.w500,
            ),
          )),
          Expanded(
            child: Text(
              value,
              style: stylePoppins(
                color: isLink ? AppColors.primary : AppColors.blackColor,
                fontWeight: isLink ? FontWeight.w500 : FontWeight.normal,
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  String _formatCreatedAt(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return '';
    try {
      final date = DateTime.parse(dateStr);
      return DateFormat('MMM d | hh:mm a').format(date);
    } catch (e) {
      return dateStr;
    }
  }
}
