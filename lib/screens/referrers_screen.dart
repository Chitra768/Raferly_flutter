import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:referaly/controller/referrers_controller.dart';
import 'package:referaly/languages/languagekeys.dart';
import 'package:referaly/resources/app_assets.dart';
import 'package:referaly/resources/app_colors.dart';
import 'package:referaly/resources/text_style.dart';
import 'package:referaly/utils/translations.dart';
import 'package:intl/intl.dart';

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
            ? TextField(
                controller: controller.searchController,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: tr(LanguageKeys.searchPlaceholder),
                  border: InputBorder.none,
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      controller.isSearching.value = false;
                      controller.searchController.clear();
                      controller.refreshList();
                    },
                  ),
                ),
                onChanged: controller.onSearchChanged,
              )
            : Text(
                tr(LanguageKeys.referrers),
                style: stylePoppins(
                    color: AppColors.blackColor, fontWeight: FontWeight.w600),
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
          return const Center(child: CircularProgressIndicator());
        }
        if (controller.error.isNotEmpty) {
          return Center(child: Text(controller.error.value));
        }
        if (controller.referrers.isEmpty) {
          return Center(child: Text(tr(LanguageKeys.noDataFound)));
        }
        return Column(
          children: [
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async => controller.refreshList(),
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: controller.referrers.length,
                  itemBuilder: (context, index) {
                    final ref = controller.referrers[index];
                    return Obx(() {
                      final isExpanded =
                          controller.expandedIndex.value == index;
                      return Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppColors.grey200),
                        ),
                        child: Column(
                          children: [
                            ListTile(
                              leading: CircleAvatar(
                                backgroundColor: Colors.red,
                                backgroundImage:
                                    ref.avatar != null && ref.avatar!.isNotEmpty
                                        ? NetworkImage(ref.avatar!)
                                        : null,
                              ),
                              title: Text(
                                "${ref.firstName ?? ''} ${ref.lastName ?? ''}",
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text(tr('test')),
                              trailing: IconButton(
                                icon: Icon(isExpanded
                                    ? Icons.expand_less
                                    : Icons.expand_more),
                                onPressed: () => controller.toggleExpand(index),
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
                                        ref.phoneNumber ?? "",
                                        isLink: true),
                                    const SizedBox(height: 8),
                                    _infoRow(tr(LanguageKeys.email), ref.email ?? "",
                                        isLink: true),
                                    const SizedBox(height: 8),
                                    _infoRow(tr(LanguageKeys.createdDate),
                                        _formatCreatedAt(ref.createdAt)),
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
