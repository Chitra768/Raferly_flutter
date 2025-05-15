import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:referaly/controller/referrers_controller.dart';

class ReferrersScreen extends StatelessWidget {
  const ReferrersScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ReferrersController>();

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        title: Text("Referrers",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh, color: Colors.black),
            onPressed: controller.refreshList,
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: controller.searchController,
              decoration: InputDecoration(
                hintText: "Search referrers...",
                prefixIcon: Icon(Icons.search),
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                filled: true,
                fillColor: Colors.grey[100],
                suffixIcon:
                    Obx(() => controller.searchController.text.isNotEmpty
                        ? IconButton(
                            icon: Icon(Icons.clear),
                            onPressed: () {
                              controller.refreshList();
                            },
                          )
                        : SizedBox()),
              ),
              onChanged: controller.onSearchChanged,
            ),
          ),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return Center(child: CircularProgressIndicator());
              }
              if (controller.error.isNotEmpty) {
                return Center(child: Text(controller.error.value));
              }
              if (controller.referrers.isEmpty) {
                return Center(child: Text("No referrers found"));
              }
              return RefreshIndicator(
                onRefresh: () async => controller.refreshList(),
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: controller.referrers.length,
                  itemBuilder: (context, index) {
                    final ref = controller.referrers[index];
                    final isExpanded = controller.expandedIndex.value == index;
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
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text("Test"),
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
                                  Divider(),
                                  _infoRow(
                                      "Phone Number", ref.phoneNumber ?? ""),
                                  _infoRow("Email", ref.email ?? "",
                                      isLink: true),
                                  _infoRow("Created Date", ref.createdAt ?? ""),
                                ],
                              ),
                            ),
                        ],
                      ),
                    );
                  },
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _infoRow(String label, String value, {bool isLink = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        children: [
          Expanded(child: Text(label, style: TextStyle(color: Colors.grey))),
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
