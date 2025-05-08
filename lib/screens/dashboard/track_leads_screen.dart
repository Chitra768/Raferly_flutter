import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:referaly/controller/track_lead.dart';
import 'package:referaly/popups/add_lead_dialog.dart' show AddLeadDialog;
import 'package:referaly/resources/app_assets.dart';
import 'package:referaly/screens/archeive/archeive_list.dart';
import 'package:referaly/widgets/custom_bottom_bar.dart';

import '../../resources/app_colors.dart';
import '../../resources/text_style.dart';

class TrackLeadsScreen extends StatefulWidget {
  static String pageId = "/trackLeads";

  const TrackLeadsScreen({super.key});

  @override
  State<TrackLeadsScreen> createState() => _TrackLeadsScreenState();
}

class _TrackLeadsScreenState extends State<TrackLeadsScreen> {
  late TrackLeadsController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.isRegistered<TrackLeadsController>()
        ? Get.find<TrackLeadsController>()
        : Get.put(TrackLeadsController());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _buildHeader(),
            _buildToggleButtons(),
            _buildActionButtons(),
            Expanded(
              child: Obx(() => controller.isLeadsReceived.value
                  ? _buildLeadsList()
                  : _buildSentLeadsList()),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const CustomBottomSheet(),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 30, 20, 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Track your leads",
            style: stylePoppins(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          GestureDetector(
            onTap: () {
              Get.back();
            },
            child: Icon(Icons.arrow_back_ios, color: AppColors.primary),
          ),
        ],
      ),
    );
  }

  Widget _buildToggleButtons() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Obx(() => Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => controller.toggleLeadType(true),
                  child: Container(
                    margin: const EdgeInsets.all(5),
                    height: 46,
                    decoration: BoxDecoration(
                      color: controller.isLeadsReceived.value
                          ? AppColors.primary
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Lead Received",
                          style: stylePoppins(
                            color: controller.isLeadsReceived.value
                                ? Colors.white
                                : Colors.black87,
                            fontWeight: controller.isLeadsReceived.value
                                ? FontWeight.w500
                                : FontWeight.w400,
                          ),
                        ),
                        const SizedBox(width: 5),
                        Container(
                          padding: const EdgeInsets.all(2),
                          decoration: const BoxDecoration(
                            color: Colors.amber,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.star,
                            color: Colors.white,
                            size: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () => controller.toggleLeadType(false),
                  child: Container(
                    height: 46,
                    decoration: BoxDecoration(
                      color: !controller.isLeadsReceived.value
                          ? AppColors.primary
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text(
                        "Leads sent",
                        style: stylePoppins(
                          color: !controller.isLeadsReceived.value
                              ? Colors.white
                              : Colors.black87,
                          fontWeight: !controller.isLeadsReceived.value
                              ? FontWeight.w500
                              : FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          )),
    );
  }

  Widget _buildActionButtons() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Expanded(
            child: _buildActionButton(
              title: "Add a lead",
              icon: AppAssets.imgAddLead,
              onTap: () {
                Get.dialog(AddLeadDialog());
              },
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: _buildActionButton(
              title: "Archive",
              icon: FontAwesomeIcons.archive,
              onTap: () {
                Get.toNamed(ArchiveList.pageId);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required String title,
    required dynamic icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.primary, width: 1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            icon is String
                ? Image.asset(
                    icon,
                    height: 50,
                    width: 50,
                  )
                : FaIcon(
                    icon,
                    size: 35,
                    color: AppColors.primary,
                  ),
            const SizedBox(width: 5),
            Text(
              title,
              style: stylePoppins(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLeadsList() {
    return ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: 15,
        itemBuilder: (context, index) {
          return _buildLeadItem(
              index: index,
              name: "Kavan Solanki",
              subTitle: "Darshan Patel",
              onTap: () => controller.toggleExpanded(index),
              isPrimum: index > 1);
        });
  }

  Widget _buildLeadItem({
    required int index,
    required String name,
    required bool isPrimum,
    String? subTitle,
    required VoidCallback onTap,
  }) {
    final data = Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          InkWell(
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                children: [
                  Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          style: stylePoppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        if (subTitle != null)
                          Text(
                            subTitle,
                            style: stylePoppins(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: () {},
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 3, vertical: 10),
                          child: Icon(
                            Icons.info_outline,
                            color: AppColors.primary,
                            size: 25,
                          ),
                        ),
                      ),
                      const SizedBox(width: 5),
                      GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: onTap,
                        child: const Padding(
                          padding:
                              EdgeInsets.symmetric(horizontal: 2, vertical: 10),
                          child: Icon(
                            Icons.keyboard_arrow_up,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
    if (isPrimum) {
      return Stack(
        children: [
          data,
          Positioned.fill(
              child: ClipRect(
                  child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: const SizedBox(),
          )))
        ],
      );
    } else {
      return data;
    }
  }

  Widget _buildExpandedContent(int index) {
    return Container(
      padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Divider(),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Phone",
                      style: stylePoppins(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                    Text(
                      "+1 234 567 8901",
                      style: stylePoppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Email",
                      style: stylePoppins(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                    Text(
                      "kavans@example.com",
                      style: stylePoppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Text(
            "Description",
            style: stylePoppins(
              fontSize: 12,
              color: Colors.grey,
            ),
          ),
          Text(
            "Looking for plumbing services at home, need urgent fix for water leakage in bathroom.",
            style: stylePoppins(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Created: 12 May 2023",
                style: stylePoppins(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
              Row(
                children: [
                  OutlinedButton.icon(
                    onPressed: () {},
                    icon: Icon(Icons.edit, size: 16, color: AppColors.primary),
                    label: Text(
                      "Edit",
                      style: stylePoppins(
                        fontSize: 12,
                        color: AppColors.primary,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      side: BorderSide(color: AppColors.primary),
                    ),
                  ),
                  const SizedBox(width: 10),
                  OutlinedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.delete_outline,
                        size: 16, color: Colors.red),
                    label: Text(
                      "Delete",
                      style: stylePoppins(
                        fontSize: 12,
                        color: Colors.red,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      side: const BorderSide(color: Colors.red),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSentLeadsList() {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      children: [
        _buildSentLeadItem(
          name: "GreenTech Services",
          type: "Plumbing",
          date: "10 May 2023",
          status: "Pending",
          statusColor: Colors.amber,
        ),
        _buildSentLeadItem(
          name: "Home Solutions Inc",
          type: "Electrical",
          date: "05 May 2023",
          status: "Approved",
          statusColor: Colors.green,
        ),
        _buildSentLeadItem(
          name: "Quick Repair Pro",
          type: "Carpentry",
          date: "25 Apr 2023",
          status: "Rejected",
          statusColor: Colors.red,
        ),
      ],
    );
  }

  Widget _buildSentLeadItem({
    required String name,
    required String type,
    required String date,
    required String status,
    required Color statusColor,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: stylePoppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        type,
                        style: stylePoppins(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    status,
                    style: stylePoppins(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: statusColor,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.only(left: 62),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    date,
                    style: stylePoppins(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                  Row(
                    children: [
                      Container(
                        height: 26,
                        width: 26,
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.info_outline,
                          color: Colors.white,
                          size: 16,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Container(
                        height: 26,
                        width: 26,
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.call,
                          color: Colors.white,
                          size: 16,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
