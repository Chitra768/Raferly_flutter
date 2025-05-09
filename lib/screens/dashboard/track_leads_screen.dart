import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:referaly/controller/track_lead.dart';
import 'package:referaly/resources/app_assets.dart';
import 'package:referaly/screens/archeive/archeive_list.dart';
import 'package:referaly/widgets/dialog/add_lead_dialog.dart' show AddLeadDialog;

import '../../resources/app_colors.dart';
import '../../resources/text_style.dart';

class TrackLeadsScreen extends StatefulWidget {
  static String pageId = "/trackLeads";
  final TrackLeadsController controller;

  const TrackLeadsScreen({super.key, required this.controller});

  @override
  State<TrackLeadsScreen> createState() => _TrackLeadsScreenState();
}

class _TrackLeadsScreenState extends State<TrackLeadsScreen> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _buildHeader(),
        _buildToggleButtons(),
        _buildActionButtons(),
        Expanded(
          child:
              Obx(() => widget.controller.isLeadsReceived.value ? _buildLeadsList() : _buildSentLeadsList()),
        ),
      ],
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 30, 20, 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Track your leads",
            style: stylePoppins(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: Colors.black,
            ),
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
                  onTap: () => widget.controller.toggleLeadType(true),
                  child: Container(
                    margin: const EdgeInsets.all(5),
                    height: 46,
                    decoration: BoxDecoration(
                      color: widget.controller.isLeadsReceived.value ? AppColors.primary : Colors.transparent,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Lead Received",
                          style: stylePoppins(
                            color: widget.controller.isLeadsReceived.value ? Colors.white : Colors.black87,
                            fontWeight:
                                widget.controller.isLeadsReceived.value ? FontWeight.w500 : FontWeight.w400,
                          ),
                        ),
                        const SizedBox(width: 15),
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
                  onTap: () => widget.controller.toggleLeadType(false),
                  child: Container(
                    height: 46,
                    decoration: BoxDecoration(
                      color:
                          !widget.controller.isLeadsReceived.value ? AppColors.primary : Colors.transparent,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Center(
                      child: Text(
                        "Leads sent",
                        style: stylePoppins(
                          color: !widget.controller.isLeadsReceived.value ? Colors.white : Colors.black87,
                          fontWeight:
                              !widget.controller.isLeadsReceived.value ? FontWeight.w500 : FontWeight.w400,
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
    return Obx(
      () {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: widget.controller.isLeadsReceived.value
              ? Row(
                  children: [
                    Expanded(
                      child: _buildActionButton(
                        title: "Add a lead",
                        icon: Image.asset(
                          AppAssets.imgAddLead,
                          height: 50,
                          width: 50,
                          alignment: Alignment.centerRight,
                        ),
                        onTap: () {
                          Get.dialog(AddLeadDialog());
                        },
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(child: archiveBtn()),
                  ],
                )
              : Align(
                  alignment: Alignment.centerLeft,
                  child: SizedBox(
                    width: (Get.width / 2) - 16,
                    child: archiveBtn(),
                  ),
                ),
        );
      },
    );
  }

  Widget archiveBtn() {
    return _buildActionButton(
      title: "Archive",
      icon: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: SvgPicture.asset(
          AppAssets.imgArchive,
          color: AppColors.primary,
          height: 30,
        ),
      ),
      onTap: () => Get.toNamed((ArchiveList.pageId)),
    );
  }

  Widget _buildActionButton({
    required String title,
    required Widget icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.primary, width: 1.5),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            icon,
            Text(
              title,
              style: stylePoppins(
                fontSize: 16,
                fontWeight: FontWeight.w600,
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
              onTap: () {},
              index: index,
              name: "Kavan Solanki",
              subTitle: "Darshan Patel",
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
    bool isExpanded = false;
    final data = Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(10),
      ),
      child: StatefulBuilder(builder: (context, sts) {
        return Column(
          children: [
            InkWell(
              onTap: () {
                sts(() {});
                isExpanded = !isExpanded;
                onTap();
              },
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
                              fontSize: 18,
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
                            padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 10),
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
                            padding: EdgeInsets.symmetric(horizontal: 2, vertical: 10),
                            child: Icon(
                              Icons.keyboard_arrow_down,
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
        );
      }),
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
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
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
