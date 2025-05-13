import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:referaly/controller/track_lead.dart';
import 'package:referaly/models/model_send_lead.dart';
import 'package:referaly/resources/app_assets.dart';
import 'package:referaly/screens/archeive/archeive_list.dart';
import 'package:referaly/screens/lead_submission_screen.dart';
import 'package:referaly/widgets/dialog/add_lead_dialog.dart'
    show AddLeadDialog;

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
  Set<int> expandedIndices = {};

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _buildHeader(),
        _buildToggleButtons(),
        _buildActionButtons(),
        Expanded(
          child: Obx(() => widget.controller.isLeadsReceived.value
              ? _buildLeadsList()
              : _buildSentLeadsList()),
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
                      color: widget.controller.isLeadsReceived.value
                          ? AppColors.primary
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Lead Received",
                          style: stylePoppins(
                            color: widget.controller.isLeadsReceived.value
                                ? Colors.white
                                : Colors.black87,
                            fontWeight: widget.controller.isLeadsReceived.value
                                ? FontWeight.w500
                                : FontWeight.w400,
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
                      color: !widget.controller.isLeadsReceived.value
                          ? AppColors.primary
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Center(
                      child: Text(
                        "Leads sent",
                        style: stylePoppins(
                          color: !widget.controller.isLeadsReceived.value
                              ? Colors.white
                              : Colors.black87,
                          fontWeight: !widget.controller.isLeadsReceived.value
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
        itemCount: widget.controller.receivedLead.value?.data?.length ?? 0,
        itemBuilder: (context, index) {
          return _buildLeadItem(
              onTap: () {},
              index: index,
              name: widget
                      .controller.receivedLead.value?.data?[index].firstName ??
                  '',
              subTitle:
                  widget.controller.receivedLead.value?.data?[index].email ??
                      '',
              isPrimum: index > 1);
        });
  }

  Widget infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "$label: ",
            style: stylePoppins(
              color: Colors.grey,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            value,
            style: stylePoppins(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "$label: ",
            style: stylePoppins(
              color: Colors.grey,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: stylePoppins(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLeadItem({
    required int index,
    required String name,
    required bool isPrimum,
    String? subTitle,
    required VoidCallback onTap,
  }) {
    final isExpanded = expandedIndices.contains(index);

    Widget leadContent = Column(
      children: [
        Padding(
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
              GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: !isPrimum
                    ? () {
                        // Your delete logic here
                      }
                    : null, // Disabled for premium
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 3, vertical: 10),
                  child: Image.asset(
                    widget.controller.receivedLead.value?.data?[index]
                                .leadAssignType ==
                            "3"
                        ? AppAssets.imgDeleteicon
                        : AppAssets.imgInfo,
                    height: 20,
                    color: AppColors.primary
                        .withOpacity(isPrimum ? 0.5 : 1.0), // faded for premium
                  ),
                ),
              ),
              const SizedBox(width: 5),
              GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: !isPrimum
                    ? () {
                        setState(() {
                          if (isExpanded) {
                            expandedIndices.remove(index);
                          } else {
                            expandedIndices.add(index);
                          }
                        });
                      }
                    : null, // Disabled for premium
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 2, vertical: 10),
                  child: Icon(
                    Icons.keyboard_arrow_down,
                    color: isPrimum
                        ? Colors.black26
                        : Colors.black, // faded for premium
                  ),
                ),
              ),
            ],
          ),
        ),
        if (!isPrimum && isExpanded)
          Obx(() => widget.controller.receivedLead.value?.data?[index]
                      .leadAssignType ==
                  "3"
              ? Column(
                  children: [
                    Divider(
                      color: Colors.grey[200],
                      thickness: 1,
                    ),
                    infoRow(
                        "Phone Number",
                        widget.controller.receivedLead.value?.data?[index]
                                .phoneNumber ??
                            ''),
                    infoRow(
                        "Email",
                        widget.controller.receivedLead.value?.data?[index]
                                .email ??
                            ''),
                    infoRow(
                        "Created Date",
                        widget.controller.receivedLead.value?.data?[index]
                                .createdAt ??
                            ''),
                  ],
                )
              : Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      buildTimeline(currentStep: 2),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                showModalBottomSheet(
                                  backgroundColor: Colors.white,
                                  context: context,
                                  isScrollControlled: true,
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(30)),
                                  ),
                                  builder: (context) {
                                    return SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.4,
                                      width: Get.width,
                                      child: Padding(
                                        padding: EdgeInsets.all(24.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Stack(
                                              alignment: Alignment.center,
                                              children: [
                                                Center(
                                                  child: Text(
                                                    "Description",
                                                    style: stylePoppins(
                                                        fontSize: 24,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
                                                Positioned(
                                                  right: 0,
                                                  child: GestureDetector(
                                                    onTap: () =>
                                                        Navigator.of(context)
                                                            .pop(),
                                                    child: Icon(
                                                      Icons.close,
                                                      color: Colors.grey,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            _infoRow(
                                                "Phone Number",
                                                widget
                                                        .controller
                                                        .receivedLead
                                                        .value
                                                        ?.data?[index]
                                                        .phoneNumber ??
                                                    ''),
                                            _infoRow("Email",
                                                "${widget.controller.receivedLead.value?.data?[index].email ?? ''} ${widget.controller.receivedLead.value?.data?[index].lastName ?? ''}"),
                                            _infoRow("Full Name",
                                                "${widget.controller.receivedLead.value?.data?[index].firstName ?? ''} ${widget.controller.receivedLead.value?.data?[index].lastName ?? ''}"),
                                            _infoRow(
                                                "Description",
                                                widget
                                                        .controller
                                                        .receivedLead
                                                        .value
                                                        ?.data?[index]
                                                        .description ??
                                                    ''),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 10),
                                decoration: BoxDecoration(
                                  color: Colors.grey[100],
                                  borderRadius: BorderRadius.circular(5),
                                  border: Border.all(color: Colors.purple),
                                ),
                                child: Center(
                                  child: Text(
                                    "See description",
                                    style: stylePoppins(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.purple,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                // Your lost lead logic here
                                Get.toNamed(
                                  LeadSubmissionScreen.pageId,
                                  arguments: {
                                    'lead_assign_type': widget
                                        .controller
                                        .receivedLead
                                        .value
                                        ?.data?[index]
                                        .leadAssignType,
                                    'first': widget.controller.receivedLead
                                            .value?.data?[index].firstName ??
                                        '',
                                    'last': widget.controller.receivedLead.value
                                            ?.data?[index].lastName ??
                                        '',
                                    'email': widget.controller.receivedLead
                                            .value?.data?[index].email ??
                                        '',
                                    'phone': widget.controller.receivedLead
                                            .value?.data?[index].phoneNumber ??
                                        '',
                                  },
                                );
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 10),
                                decoration: BoxDecoration(
                                  color: Colors.grey[100],
                                  borderRadius: BorderRadius.circular(5),
                                  border: Border.all(color: Colors.purple),
                                ),
                                child: Center(
                                  child: Text(
                                    "Lost lead",
                                    style: stylePoppins(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.red,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                )),
      ],
    );

    Widget data = Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(10),
      ),
      child: leadContent,
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
              ),
            ),
          ),
        ],
      );
    } else {
      return data;
    }
  }

  Widget _buildSentLeadsList() {
    return Obx(
      () {
        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          itemCount: widget.controller.sendLead.value?.data?.length ?? 0,
          itemBuilder: (context, index) {
            return LeadStepperCard(
              name: widget.controller.sendLead.value?.data?[index].firstName ??
                  '',
              subtitle:
                  widget.controller.sendLead.value?.data?[index].companyName ??
                      '',
              currentStep: 0,
              steps: [
                "Contact called",
                "Contract signed",
                "Service delivered",
                "Payment received",
              ],
              data: widget.controller.sendLead.value?.data?[index],
            );
          },
        );
      },
    );
  }

  Widget buildTimeline({required int currentStep}) {
    final steps = [
      "Contact called",
      "Contract signed",
      "Service delivered",
      "Payment received",
    ];

    return Column(
      children: List.generate(steps.length, (index) {
        final isActive = index == currentStep;
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                // Dot
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: isActive ? Colors.grey : Colors.grey,
                    shape: BoxShape.circle,
                  ),
                ),
                // Line (except for last step)
                if (index != steps.length - 1)
                  Container(
                    width: 2,
                    height: 42,
                    color: Colors.grey,
                  ),
              ],
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  steps[index],
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: isActive ? Colors.black : Colors.black,
                  ),
                ),
                if (isActive)
                  Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: AppColors.whiteColor,
                        borderRadius: BorderRadius.circular(3),
                        border: Border.all(color: Colors.black),
                      ),
                      child: Text(
                        "Next",
                        style: stylePoppins(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ],
        );
      }),
    );
  }
}

class LeadStepperCard extends StatelessWidget {
  final String name;
  final String subtitle;
  final int currentStep; // 0-based index of the active step
  final List<String> steps;
  final VoidCallback? onSeeDescription;
  final Data? data;
  const LeadStepperCard({
    super.key,
    required this.name,
    required this.subtitle,
    required this.currentStep,
    required this.steps,
    this.onSeeDescription,
    this.data,
  });
  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "$label: ",
            style: stylePoppins(
              color: Colors.grey,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: stylePoppins(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildTimeline({required int currentStep}) {
    final steps = [
      "Contact called",
      "Contract signed",
      "Service delivered",
      "Payment received",
    ];

    return Column(
      children: List.generate(steps.length, (index) {
        final isActive = index == currentStep;
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                SizedBox(
                  height: 5,
                ),
                // Dot
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: isActive ? Colors.grey : Colors.grey,
                    shape: BoxShape.circle,
                  ),
                ),
                // Line (except for last step)
                if (index != steps.length - 1)
                  Container(
                    width: 2,
                    height: 42,
                    color: Colors.grey,
                  ),
              ],
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  steps[index],
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: isActive ? Colors.black : Colors.black,
                  ),
                ),
                if (isActive)
                  Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: AppColors.whiteColor,
                        borderRadius: BorderRadius.circular(3),
                        border: Border.all(color: Colors.black),
                      ),
                      child: Text(
                        "Next",
                        style: stylePoppins(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ],
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[100]!),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Top row
            Row(
              children: [
                CircleAvatar(
                  radius: 22,
                  backgroundColor: Colors.grey[400],
                  child: const Icon(Icons.person, color: Colors.white),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(name,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16)),
                      Text(subtitle,
                          style:
                              TextStyle(color: Colors.grey[600], fontSize: 13)),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.purple),
                  onPressed: () {
                    Get.toNamed(LeadSubmissionScreen.pageId, arguments: {
                      'lead_assign_type': data?.leadAssignType,
                      'first': data?.firstName,
                      'last': data?.lastName,
                      'email': data?.email,
                      'phone': data?.phoneNumber,
                    });
                  }, // Edit action
                ),
                const Icon(Icons.keyboard_arrow_down, color: Colors.black),
              ],
            ),
            const SizedBox(height: 12),
            // Stepper
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildTimeline(currentStep: 2),
                  const SizedBox(height: 16),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // See description button
            SizedBox(
              width: 200,
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.purple),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
                onPressed: onSeeDescription,
                child: const Text(
                  'See description',
                  style: TextStyle(
                    color: Colors.purple,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _stepCircle({required bool isActive}) {
    return Container(
      width: 22,
      height: 22,
      decoration: BoxDecoration(
        color: isActive ? Colors.white : Colors.grey[300],
        border: Border.all(
          color: Colors.teal,
          width: isActive ? 3 : 2,
          style: isActive ? BorderStyle.solid : BorderStyle.solid,
        ),
        shape: BoxShape.circle,
      ),
      child: isActive
          ? Center(
              child: Container(
                width: 10,
                height: 10,
                decoration: const BoxDecoration(
                  color: Colors.teal,
                  shape: BoxShape.circle,
                ),
              ),
            )
          : null,
    );
  }
}
