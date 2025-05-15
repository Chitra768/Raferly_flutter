import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:referaly/controller/referrers_controller.dart';
import 'package:referaly/resources/app_assets.dart';
import 'package:referaly/resources/app_colors.dart';
import 'package:referaly/resources/text_style.dart';

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
                  hintText: "Search referrers...",
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
                "Referrers",
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
          return const Center(child: Text("No Deals"));
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
                              subtitle: const Text("Test"),
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
                                    const Divider(),
                                    _infoRow(
                                        "Phone Number", ref.phoneNumber ?? ""),
                                    _infoRow("Email", ref.email ?? "",
                                        isLink: true),
                                    _infoRow(
                                        "Created Date", ref.createdAt ?? ""),
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
              child: Text(label, style: const TextStyle(color: Colors.grey))),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                color: isLink ? Colors.purple : Colors.black,
                fontWeight: isLink ? FontWeight.w500 : FontWeight.normal,
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}
