import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:referaly/controller/track_lead.dart';
import 'package:referaly/languages/languagekeys.dart';
import 'package:referaly/models/model_received_lead.dart';
import 'package:referaly/models/model_send_lead.dart';
import 'package:referaly/resources/app_assets.dart';
import 'package:referaly/resources/app_helper.dart';
import 'package:referaly/resources/app_preference.dart';
import 'package:referaly/screens/archeive/archeive_list.dart';
import 'package:referaly/screens/dashboard/my_activity_info_screen.dart';
import 'package:referaly/screens/home/screen_main.dart';
import 'package:referaly/screens/lead_submission_screen.dart';
import 'package:referaly/utils/translations.dart';
import 'package:referaly/widgets/common_popup.dart';
import 'package:referaly/widgets/dialog/add_lead_dialog.dart'
    show AddLeadDialog;
import 'package:referaly/widgets/share_popup.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';
import 'package:app_settings/app_settings.dart';

import '../../controller/language_controller.dart';
import '../../resources/app_colors.dart';
import '../../resources/text_style.dart';
import '../../widgets/dialog/premium_upgrade_dialog.dart';
import '../../widgets/dialog/success_popup.dart';
import 'membership_screen.dart';

class HalfCircleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.addOval(Rect.fromLTWH(0, 0, size.width, size.height));
    path.addRect(Rect.fromLTWH(0, 0, size.width, size.height / 2));
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class TrackLeadsScreen extends StatefulWidget {
  static String pageId = "/trackLeads";
  final TrackLeadsController controller;

  TrackLeadsScreen({super.key, required this.controller});

  @override
  State<TrackLeadsScreen> createState() => _TrackLeadsScreenState();
}

class _TrackLeadsScreenState extends State<TrackLeadsScreen> {
  int? expandedIndex; // Only one item can be expanded at a time
  Map<int, Map<String, dynamic>> leadComments =
      {}; // {index: {"text": ..., "date": ...}}
  Map<int, int> itemCurrentSteps = {}; // Track current step per item

  void _clearLocalState() {
    setState(() {
      expandedIndex = null;
      leadComments.clear();
      itemCurrentSteps.clear();
    });
  }

  void _forceRefresh() {
    setState(() {
      // Force widget rebuild
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Get.offAllNamed(ScreenMain.pageId);
        return false;
      },
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onHorizontalDragEnd: (details) async {
          // Detect swipe direction
          if (details.primaryVelocity != null) {
            // Check if company type is individual
            final isIndividual = widget.controller.mainController.profile.value
                    ?.data?.companyType ==
                "individual";

            if (details.primaryVelocity! < 0) {
              // Swiped Left: Show Sent Leads
              if (widget.controller.isLeadsReceived.value) {
                _clearLocalState();
                widget.controller.toggleLeadType(false);
                await Future.delayed(const Duration(milliseconds: 200));
                _forceRefresh();
              }
            } else if (details.primaryVelocity! > 0) {
              // Swiped Right: Show Received Leads
              // For individual users, ignore right swipe
              if (isIndividual) {
                return;
              }
              if (!widget.controller.isLeadsReceived.value) {
                _clearLocalState();
                widget.controller.toggleLeadType(true);
                await Future.delayed(const Duration(milliseconds: 200));
                _forceRefresh();
              }
            }
          }
        },
        child: SafeArea(
          child: Column(
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
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 30, 20, 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            tr(LanguageKeys.trackMyLeads),
            style: stylePoppins(
              fontSize: 20,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildToggleButtons() {
    AppHelper.showLog(
        "widget.controller.isLeadsReceived.value: ${widget.controller.isLeadsReceived.value}");
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: const Color(0xffF9FAFB),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Obx(() => Row(
            children: [
              Obx(
                () => widget.controller.mainController.profile.value?.data
                            ?.companyType ==
                        "individual"
                    ? const SizedBox(height: 46, width: 46)
                    : Expanded(
                        child: GestureDetector(
                          onTap: () async {
                            _clearLocalState();
                            widget.controller.toggleLeadType(true);
                            await Future.delayed(
                                const Duration(milliseconds: 200));
                            _forceRefresh();
                          },
                          child: Stack(
                            children: [
                              Container(
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
                                    Expanded(
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(left: 8.0),
                                        child: Text(
                                          tr(LanguageKeys.leadReceivedTab),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          textAlign: TextAlign.center,
                                          style: stylePoppins(
                                            color: widget.controller
                                                    .isLeadsReceived.value
                                                ? Colors.white
                                                : Colors.black87,
                                            fontWeight: widget.controller
                                                    .isLeadsReceived.value
                                                ? FontWeight.w400
                                                : FontWeight.w400,
                                          ),
                                        ),
                                      ),
                                    ),
                                    AppPreference.readString(
                                                AppPreference.isPaid) ==
                                            "0"
                                        ? Container(
                                            padding: const EdgeInsets.all(10),
                                            child: SvgPicture.asset(
                                              AppAssets.imgHomeCrown,
                                              height: 18,
                                              width: 18,
                                            ),
                                          )
                                        : const SizedBox(),
                                  ],
                                ),
                              ),
                              (int.tryParse(widget
                                                  .controller
                                                  .receivedLead
                                                  .value
                                                  ?.notifications
                                                  ?.leadReceive
                                                  ?.count
                                                  ?.toString() ??
                                              '0') ??
                                          0) >
                                      0
                                  ? Positioned(
                                      right: 0,
                                      bottom: 0,
                                      child: ClipPath(
                                        clipper: HalfCircleClipper(),
                                        child: Container(
                                          constraints: const BoxConstraints(
                                            minWidth: 20,
                                            minHeight: 20,
                                          ),
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 6, vertical: 2),
                                          decoration: BoxDecoration(
                                            color: Colors.red,
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                                color: Colors.red, width: 1),
                                          ),
                                          child: Center(
                                            child: Text(
                                              '${widget.controller.receivedLead.value?.notifications?.leadReceive?.count}',
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                  : const SizedBox(),
                            ],
                          ),
                        ),
                      ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () async {
                    _clearLocalState();
                    widget.controller.toggleLeadType(false);
                    await Future.delayed(const Duration(milliseconds: 200));
                    _forceRefresh();
                  },
                  child: Stack(
                    children: [
                      Container(
                        height: 46,
                        decoration: BoxDecoration(
                          color: !widget.controller.isLeadsReceived.value
                              ? AppColors.primary
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Center(
                          child: Text(
                            tr(LanguageKeys.leadSentTab),
                            style: stylePoppins(
                              color: !widget.controller.isLeadsReceived.value
                                  ? Colors.white
                                  : Colors.black87,
                              fontWeight:
                                  !widget.controller.isLeadsReceived.value
                                      ? FontWeight.w400
                                      : FontWeight.w400,
                            ),
                          ),
                        ),
                      ),
                      (int.tryParse(widget.controller.sendLead.value
                                          ?.notifications?.leadSent?.count
                                          ?.toString() ??
                                      '0') ??
                                  0) >
                              0
                          ? Positioned(
                              right: 0,
                              bottom: 0,
                              child: ClipPath(
                                clipper: HalfCircleClipper(),
                                child: Container(
                                  constraints: const BoxConstraints(
                                    minWidth: 20,
                                    minHeight: 20,
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: Colors.red,
                                    shape: BoxShape.circle,
                                    border:
                                        Border.all(color: Colors.red, width: 1),
                                  ),
                                  child: Center(
                                    child: Text(
                                      '${widget.controller.sendLead.value?.notifications?.leadSent?.count}',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            )
                          : const SizedBox(),
                    ],
                  ),
                ),
              ),
              Obx(
                () => widget.controller.mainController.profile.value?.data
                            ?.companyType ==
                        "individual"
                    ? const SizedBox(height: 46, width: 46)
                    : const SizedBox(),
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
          child: widget.controller.isLeadsReceived.value &&
                  widget.controller.mainController.profile.value?.data
                          ?.companyType !=
                      "individual"
              ? Row(
                  children: [
                    Expanded(
                      child: _buildActionButton(
                        title: tr(LanguageKeys.addLead),
                        icon: Image.asset(
                          AppAssets.imgAddLead,
                          height: 50,
                          width: 50,
                          alignment: Alignment.centerRight,
                        ),
                        onTap: () {
                          Get.dialog(AddLeadDialog()).then((value) {
                            widget.controller.getLeads();
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(child: archiveBtn(type: "receive")),
                  ],
                )
              : Align(
                  alignment: Alignment.centerLeft,
                  child: SizedBox(
                    width: (Get.width / 2) - 16,
                    child: archiveBtn(type: "send"),
                  ),
                ),
        );
      },
    );
  }

  Widget archiveBtn({required String type}) {
    return Stack(
      children: [
        _buildActionButton(
          title: tr(LanguageKeys.archive),
          icon: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: SvgPicture.asset(
              AppAssets.imgArchive,
              color: AppColors.primary,
              height: 30,
            ),
          ),
          onTap: () =>
              Get.toNamed((ArchiveList.pageId), arguments: {"type": type})
                  ?.then((value) {
            if (type == "receive") {
            } else {
              widget.controller.getSendLeads();
            }
          }),
        ),
        Obx(
          () => (int.tryParse(widget.controller.sendLead.value?.notifications
                                  ?.archived?.count
                                  ?.toString() ??
                              '0') ??
                          0) >
                      0 &&
                  type == "send"
              ? Positioned(
                  right: 2,
                  top: 1,
                  child: ClipPath(
                    clipper: HalfCircleClipper(),
                    child: Container(
                      constraints: const BoxConstraints(
                        minWidth: 20,
                        minHeight: 20,
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.red, width: 1),
                      ),
                      child: Center(
                        child: Text(
                          '${widget.controller.sendLead.value?.notifications?.archived?.count}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              : const SizedBox(),
        ),
      ],
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
        height: 53,
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.primary, width: 1.5),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            icon,
            Flexible(
              child: Text(
                title,
                style: stylePoppins(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLeadsList() {
    return Obx(() {
      print(
          '_buildLeadsList called, receivedLead count: ${widget.controller.receivedLead.value?.data?.length ?? 0}');
      if (widget.controller.receivedLead.value?.data == null ||
          widget.controller.receivedLead.value?.data?.isEmpty == true) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  tr(LanguageKeys
                      .yourReferrersRecommendationsWillAppearHereAsSoonAsSomeoneHasSentYouAContact),
                  textAlign: TextAlign.center,
                  style: stylePoppins(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        );
      }

      return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          itemCount: widget.controller.receivedLead.value?.data?.length ?? 0,
          itemBuilder: (context, index) {
            return _buildLeadItem(
              onTap: () {
                AppHelper.showLog("expandedIndex: $expandedIndex");
              },
              index: index,
              name:
                  '${widget.controller.receivedLead.value?.data?[index].firstName ?? ''} ${widget.controller.receivedLead.value?.data?[index].lastName ?? ''}'
                      .trim(),
              subTitle: widget.controller.receivedLead.value?.data?[index]
                          .leadAssignType !=
                      "3"
                  ? ('${widget.controller.receivedLead.value?.data?[index].user?.firstName} ${widget.controller.receivedLead.value?.data?[index].user!.lastName}' ??
                      '')
                  : null,
              isPrimum: widget.controller.isPaid.value == "0" && index > 1
                  ? true
                  : false,
            );
          });
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
          Flexible(
            child: Text(
              value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: stylePoppins(
                fontWeight: FontWeight.w600,
              ),
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
          if (label == tr(LanguageKeys.email) &&
              value.isNotEmpty &&
              value != "Not Provided")
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
                value,
                style: stylePoppins(
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ).copyWith(
                  decoration: TextDecoration.underline,
                ),
              ),
            )
          else if (label == tr(LanguageKeys.phoneNumber) &&
              value.isNotEmpty &&
              value != "Not Provided")
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
                value != "Not Provided" ? value : tr(LanguageKeys.nullDataText),
                style: stylePoppins(
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
              ),
            )
          else
            Text(
              value != "Not Provided" ? value : tr(LanguageKeys.nullDataText),
              style: stylePoppins(
                fontWeight: FontWeight.w600,
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

  Widget _buildLeadItem({
    required int index,
    required String name,
    required bool isPrimum,
    String? subTitle,
    required VoidCallback onTap,
  }) {
    final isExpanded = expandedIndex == index;
    final commentData = leadComments[index];
    int currentStep = itemCurrentSteps[index] ?? 0;

    Widget leadContent = Container(
      decoration: BoxDecoration(
        color: const Color(0x00000000),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Obx(
                  () => widget.controller.receivedLead.value?.data?[index]
                              .leadAssignType !=
                          "3"
                      ? Container(
                          height: 50.w,
                          width: 50.w,
                          decoration: BoxDecoration(
                            color: AppColors.whiteColor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.network(
                              widget.controller.receivedLead.value?.data?[index]
                                      .user?.avatarUrl ??
                                  '',
                              height: 50.w,
                              width: 50.w,
                              fit: BoxFit.cover,
                            ),
                          ),
                        )
                      : Container(
                          height: 50.w,
                          width: 50.w,
                          decoration: BoxDecoration(
                            color: AppColors.whiteColor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.network(
                              widget.controller.receivedLead.value?.data?[index]
                                      .user?.avatarUrl ??
                                  '',
                              height: 50.w,
                              width: 50.w,
                              fit: BoxFit.cover,
                            ),
                          ),
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
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      if (subTitle != null)
                        Text(
                          subTitle,
                          style: stylePoppins(
                            fontSize: 12.sp,
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
                          if (widget.controller.receivedLead.value?.data?[index]
                                  .leadAssignType ==
                              "5") {
                            showDialog(
                              context: context,
                              builder: (context) => CommonPopup(
                                title: tr(LanguageKeys.lostLeadConfirmation),
                                description: "",
                                options: [
                                  tr(LanguageKeys.notInterested),
                                  tr(LanguageKeys.neverReplies),
                                  tr(LanguageKeys.incorrectInfo),
                                  tr(LanguageKeys.other),
                                ],
                                onYes: (selectedIndices) {
                                  // Handle selected options
                                  print("selectedIndices: $selectedIndices");
                                  widget.controller.deleteReceivedLead(
                                    leadId: int.parse(widget
                                            .controller
                                            .receivedLead
                                            .value
                                            ?.data?[index]
                                            .id ??
                                        '0'),
                                    lostReasons: [
                                      {
                                        "id": widget.controller.receivedLead
                                            .value?.data?[index].leadAssignType,
                                        "reason": selectedIndices,
                                        "check": true,
                                        "isOther": true
                                      }
                                    ],
                                  ).then((value) {
                                    if (Get.isDialogOpen ?? false) {
                                      Get.back();
                                    }
                                    Get.dialog(
                                      SuccessPopup(
                                        message: widget
                                                .controller
                                                .receiveLeadDelete
                                                .value
                                                ?.message ??
                                            '',
                                        onOk: () {
                                          Get.back();
                                          widget.controller.getLeads();
                                        },
                                      ),
                                      barrierDismissible: false,
                                    );
                                  });
                                },
                                onCancel: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                            );
                          } else {
                            // Get.toNamed(MyActivityInfoScreen.pageId);
                            showModalBottomSheet(
                              backgroundColor: Colors.white,
                              context: context,
                              isScrollControlled: true,
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(30)),
                              ),
                              builder: (context) {
                                return Padding(
                                  padding: EdgeInsets.only(
                                    bottom: MediaQuery.of(context)
                                        .viewInsets
                                        .bottom,
                                  ),
                                  child: Container(
                                    padding: const EdgeInsets.all(20),
                                    decoration: const BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.vertical(
                                          top: Radius.circular(30)),
                                    ),
                                    child: SingleChildScrollView(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          // Top bar with title and close button
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              const SizedBox(
                                                  width: 40), // For alignment
                                              Text(
                                                tr(LanguageKeys.description),
                                                style: stylePoppins(
                                                    fontSize: 24,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                              IconButton(
                                                icon: const Icon(Icons.close,
                                                    color: Colors.grey),
                                                onPressed: () =>
                                                    Navigator.of(context).pop(),
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
                                                    _addToContacts(widget
                                                        .controller
                                                        .receivedLead
                                                        .value
                                                        ?.data?[index]);
                                                  },
                                                  child: Container(
                                                      height: 48,
                                                      decoration: BoxDecoration(
                                                        color:
                                                            AppColors.primary,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(12),
                                                      ),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Icon(
                                                            Icons.person_add,
                                                            color: AppColors
                                                                .whiteColor,
                                                          ),
                                                          const SizedBox(
                                                            width: 10,
                                                          ),
                                                          Text(
                                                            tr(LanguageKeys
                                                                .addContact),
                                                            textAlign: TextAlign
                                                                .center,
                                                            maxLines: 2,
                                                            style: stylePoppins(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500),
                                                          ),
                                                        ],
                                                      )),
                                                ),
                                              ),
                                              const SizedBox(width: 12),
                                              Expanded(
                                                child: GestureDetector(
                                                  onTap: () {
                                                    final contactInfo = '''
 ${widget.controller.receivedLead.value?.data?[index].firstName ?? ''} ${widget.controller.receivedLead.value?.data?[index].lastName ?? ''}
 ${widget.controller.receivedLead.value?.data?[index].phoneNumber!.trim() ?? ''}
 ${widget.controller.receivedLead.value?.data?[index].email!.trim() ?? ''}

''';
                                                    Share.share(contactInfo);
                                                  },
                                                  child: Container(
                                                      height: 48,
                                                      decoration: BoxDecoration(
                                                        color:
                                                            AppColors.primary,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(12),
                                                      ),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Icon(
                                                            Icons.share,
                                                            color: AppColors
                                                                .whiteColor,
                                                          ),
                                                          const SizedBox(
                                                            width: 10,
                                                          ),
                                                          Text(
                                                            tr(LanguageKeys
                                                                .share),
                                                            textAlign: TextAlign
                                                                .center,
                                                            maxLines: 2,
                                                            style: stylePoppins(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500),
                                                          ),
                                                        ],
                                                      )),
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
                                              borderRadius:
                                                  BorderRadius.circular(20),
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
                                                    "${widget.controller.receivedLead.value?.data?[index].firstName ?? ''} ${widget.controller.receivedLead.value?.data?[index].lastName ?? ''}"),
                                                const Divider(),
                                                _infoTile(
                                                    Icons.business,
                                                    tr(LanguageKeys
                                                        .nameOfTheBusinessReferrer),
                                                    "${widget.controller.receivedLead.value?.data?[index].user?.firstName ?? ''} ${widget.controller.receivedLead.value?.data?[index].user?.lastName ?? ''}"),
                                                const Divider(),
                                                _infoTile(
                                                    Icons.phone,
                                                    tr(LanguageKeys
                                                        .phoneNumber),
                                                    widget
                                                            .controller
                                                            .receivedLead
                                                            .value
                                                            ?.data?[index]
                                                            .phoneNumber ??
                                                        ''),
                                                const Divider(),
                                                _infoTile(
                                                    Icons.email,
                                                    tr(LanguageKeys.email),
                                                    widget
                                                            .controller
                                                            .receivedLead
                                                            .value
                                                            ?.data?[index]
                                                            .email ??
                                                        ''),
                                                const Divider(),
                                                _infoTile(
                                                    Icons.description,
                                                    tr(LanguageKeys
                                                        .description),
                                                    widget
                                                            .controller
                                                            .receivedLead
                                                            .value
                                                            ?.data?[index]
                                                            .description ??
                                                        ''),
                                                const Divider(),
                                                _infoTile(
                                                    Icons.calendar_month,
                                                    tr(LanguageKeys
                                                        .dateArchive),
                                                    DateFormat('dd/MM/yyyy').format(
                                                            DateTime.parse(widget
                                                                    .controller
                                                                    .receivedLead
                                                                    .value
                                                                    ?.data?[
                                                                        index]
                                                                    .createdAt ??
                                                                '')) ??
                                                        ''),
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
                        }
                      : () {
                          Get.dialog(PremiumUpgradeDialog(
                            onSeeOffers: () {
                              Get.back();
                              Get.toNamed(MembershipScreen.pageId)
                                  ?.then((value) {
                                widget.controller.mainController.getProfile();
                              });
                            },
                          ));
                        },
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 3, vertical: 10),
                    child: Image.asset(
                      widget.controller.receivedLead.value?.data?[index]
                                  .leadAssignType ==
                              "5"
                          ? AppAssets.imgDeleteicon
                          : AppAssets.imgInfo,
                      height: 28,
                      color: AppColors.primary.withOpacity(
                          isPrimum ? 0.5 : 1.0), // faded for premium
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
                              expandedIndex = null;
                            } else {
                              expandedIndex = index;
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
            Obx(() =>
                // widget.controller.receivedLead.value?.data?[index]
                //             .leadAssignType ==
                //         "5"
                //     ? Column(
                //         children: [
                //           Divider(
                //             color: Colors.grey[200],
                //             thickness: 1,
                //           ),
                //           infoRow(
                //               tr(LanguageKeys.phoneNumber),
                //               widget.controller.receivedLead.value?.data?[index]
                //                       .phoneNumber ??
                //                   ''),
                //           infoRow(
                //               tr(LanguageKeys.email),
                //               (widget.controller.receivedLead.value?.data?[index]
                //                           .email !=
                //                       "null"
                //                   ? "${widget.controller.receivedLead.value?.data?[index].email}"
                //                   : "Not Provided")),
                //           infoRow(
                //             tr(LanguageKeys.createdDate),
                //             _formatCreatedAt(widget.controller.receivedLead.value
                //                     ?.data?[index].createdAt ??
                //                 ''),
                //           ),
                //           const SizedBox(height: 10),
                //         ],
                //       )
                //     :
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      buildTimeline(
                        receivedLeadData:
                            widget.controller.receivedLead.value?.data?[index],
                        leadTrack: widget.controller.receivedLead.value
                            ?.data?[index].leadTrack,
                        currentStep: currentStep,
                        parentIndex: index,
                        commentData: commentData,
                        onCommentTap: () async {
                          TextEditingController controller =
                              TextEditingController(
                                  text: commentData != null
                                      ? commentData['text']
                                      : '');
                          String? comment = await showModalBottomSheet<String>(
                            context: context,
                            isScrollControlled: true,
                            backgroundColor: Colors.transparent,
                            builder: (context) {
                              return Padding(
                                padding: EdgeInsets.only(
                                  bottom:
                                      MediaQuery.of(context).viewInsets.bottom,
                                ),
                                child: Container(
                                  padding: const EdgeInsets.all(20),
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(30)),
                                  ),
                                  child: SingleChildScrollView(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        TextField(
                                          controller: controller,
                                          decoration: InputDecoration(
                                            hintText:
                                                tr(LanguageKeys.enterComment),
                                            filled: true,
                                            fillColor: Colors.grey[100],
                                            contentPadding:
                                                const EdgeInsets.symmetric(
                                                    horizontal: 12,
                                                    vertical: 8),
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              borderSide: BorderSide.none,
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              borderSide: BorderSide.none,
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              borderSide: BorderSide.none,
                                            ),
                                          ),
                                          maxLines: 2,
                                        ),
                                        const SizedBox(height: 16),
                                        SizedBox(
                                          width: double.infinity,
                                          child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  AppColors.primary,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                            ),
                                            onPressed: () {
                                              if (controller.text
                                                  .trim()
                                                  .isNotEmpty) {
                                                Navigator.of(context).pop(
                                                    controller.text.trim());
                                              }
                                            },
                                            child: Text(
                                              tr(LanguageKeys.submit),
                                              style: stylePoppins(
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                          if (comment != null && comment.isNotEmpty) {
                            setState(() {
                              leadComments[index] = {
                                'text': comment,
                                'date': DateFormat('dd/MM/yyyy hh:mm a')
                                    .format(DateTime.now()),
                              };
                            });
                          }
                        },
                      ),
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
                                    return Padding(
                                      padding: EdgeInsets.only(
                                        bottom: MediaQuery.of(context)
                                            .viewInsets
                                            .bottom,
                                      ),
                                      child: Container(
                                        padding: const EdgeInsets.all(20),
                                        decoration: const BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.vertical(
                                              top: Radius.circular(30)),
                                        ),
                                        child: SingleChildScrollView(
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              // Top bar with title and close button
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  const SizedBox(
                                                      width:
                                                          40), // For alignment
                                                  Text(
                                                    tr(LanguageKeys
                                                        .description),
                                                    style: stylePoppins(
                                                        fontSize: 24,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                  ),
                                                  IconButton(
                                                    icon: const Icon(
                                                        Icons.close,
                                                        color: Colors.grey),
                                                    onPressed: () =>
                                                        Navigator.of(context)
                                                            .pop(),
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
                                                        _addToContacts(widget
                                                            .controller
                                                            .receivedLead
                                                            .value
                                                            ?.data?[index]);
                                                      },
                                                      child: Container(
                                                          height: 48,
                                                          decoration:
                                                              BoxDecoration(
                                                            color: AppColors
                                                                .primary,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        12),
                                                          ),
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Icon(
                                                                Icons
                                                                    .person_add,
                                                                color: AppColors
                                                                    .whiteColor,
                                                              ),
                                                              const SizedBox(
                                                                width: 10,
                                                              ),
                                                              Text(
                                                                tr(LanguageKeys
                                                                    .addContact),
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                maxLines: 2,
                                                                style: stylePoppins(
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize:
                                                                        14,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500),
                                                              ),
                                                            ],
                                                          )),
                                                    ),
                                                  ),
                                                  const SizedBox(width: 12),
                                                  Expanded(
                                                    child: GestureDetector(
                                                      onTap: () {
                                                        final contactInfo = '''
 ${widget.controller.receivedLead.value?.data?[index].firstName ?? ''} ${widget.controller.receivedLead.value?.data?[index].lastName ?? ''}
 ${widget.controller.receivedLead.value?.data?[index].phoneNumber!.trim() ?? ''}
 ${widget.controller.receivedLead.value?.data?[index].email!.trim() ?? ''}

''';
                                                        Share.share(
                                                            contactInfo);
                                                      },
                                                      child: Container(
                                                          height: 48,
                                                          decoration:
                                                              BoxDecoration(
                                                            color: AppColors
                                                                .primary,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        12),
                                                          ),
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Icon(
                                                                Icons.share,
                                                                color: AppColors
                                                                    .whiteColor,
                                                              ),
                                                              const SizedBox(
                                                                width: 10,
                                                              ),
                                                              Text(
                                                                tr(LanguageKeys
                                                                    .share),
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                maxLines: 2,
                                                                style: stylePoppins(
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize:
                                                                        14,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500),
                                                              ),
                                                            ],
                                                          )),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 24),
                                              // Card with details
                                              Container(
                                                padding:
                                                    const EdgeInsets.all(20),
                                                decoration: BoxDecoration(
                                                  color: Colors.grey[50],
                                                  borderRadius:
                                                      BorderRadius.circular(20),
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
                                                        "${widget.controller.receivedLead.value?.data?[index].firstName ?? ''} ${widget.controller.receivedLead.value?.data?[index].lastName ?? ''}"),
                                                    const Divider(),
                                                    _infoTile(
                                                        Icons.business,
                                                        tr(LanguageKeys
                                                            .nameOfTheBusinessReferrer),
                                                        "${widget.controller.receivedLead.value?.data?[index].user?.firstName ?? ''} ${widget.controller.receivedLead.value?.data?[index].user?.lastName ?? ''}"),
                                                    const Divider(),
                                                    _infoTile(
                                                        Icons.phone,
                                                        tr(LanguageKeys
                                                            .phoneNumber),
                                                        widget
                                                                .controller
                                                                .receivedLead
                                                                .value
                                                                ?.data?[index]
                                                                .phoneNumber ??
                                                            ''),
                                                    const Divider(),
                                                    _infoTile(
                                                        Icons.email,
                                                        tr(LanguageKeys.email),
                                                        widget
                                                                .controller
                                                                .receivedLead
                                                                .value
                                                                ?.data?[index]
                                                                .email ??
                                                            ''),
                                                    const Divider(),
                                                    _infoTile(
                                                        Icons.description,
                                                        tr(LanguageKeys
                                                            .description),
                                                        widget
                                                                .controller
                                                                .receivedLead
                                                                .value
                                                                ?.data?[index]
                                                                .description ??
                                                            ''),
                                                    const Divider(),
                                                    _infoTile(
                                                        Icons.calendar_month,
                                                        tr(LanguageKeys
                                                            .dateArchive),
                                                        DateFormat('dd/MM/yyyy').format(
                                                                DateTime.parse(widget
                                                                        .controller
                                                                        .receivedLead
                                                                        .value
                                                                        ?.data?[
                                                                            index]
                                                                        .createdAt ??
                                                                    '')) ??
                                                            ''),
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
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 10),
                                decoration: BoxDecoration(
                                  color: Colors.grey[100],
                                  borderRadius: BorderRadius.circular(5),
                                  border: Border.all(color: AppColors.primary),
                                ),
                                child: Center(
                                  child: Text(
                                    tr(LanguageKeys.seeDescription),
                                    style: stylePoppins(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.primary,
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
                                showDialog(
                                  context: context,
                                  builder: (context) => CommonPopup(
                                    title:
                                        tr(LanguageKeys.lostLeadConfirmation),
                                    description: "",
                                    options: [
                                      tr(LanguageKeys.notInterested),
                                      tr(LanguageKeys.neverReplies),
                                      tr(LanguageKeys.incorrectInfo),
                                      tr(LanguageKeys.other),
                                    ],
                                    onYes: (selectedIndices) {
                                      // Handle selected options
                                      print(
                                          "selectedIndices: $selectedIndices");
                                      widget.controller.deleteReceivedLead(
                                        leadId: int.parse(widget
                                                .controller
                                                .receivedLead
                                                .value
                                                ?.data?[index]
                                                .id ??
                                            '0'),
                                        lostReasons: [
                                          {
                                            "id": widget
                                                .controller
                                                .receivedLead
                                                .value
                                                ?.data?[index]
                                                .leadAssignType,
                                            "reason": selectedIndices,
                                            "check": true,
                                            "isOther": true
                                          }
                                        ],
                                      ).then((value) {
                                        if (Get.isDialogOpen ?? false) {
                                          Get.back();
                                        }
                                        Get.dialog(
                                          SuccessPopup(
                                            message: widget
                                                    .controller
                                                    .receiveLeadDelete
                                                    .value
                                                    ?.message ??
                                                '',
                                            onOk: () {
                                              Get.back();
                                              widget.controller.getLeads();
                                            },
                                          ),
                                          barrierDismissible: false,
                                        );
                                      });
                                    },
                                    onCancel: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                );
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 10),
                                decoration: BoxDecoration(
                                  color: Colors.grey[100],
                                  borderRadius: BorderRadius.circular(5),
                                  border: Border.all(color: AppColors.primary),
                                ),
                                child: Center(
                                  child: Text(
                                    tr(LanguageKeys.lostLead),
                                    style: stylePoppins(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
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
      ),
    );

    Widget data = GestureDetector(
      onTap: () {
        setState(() {
          if (expandedIndex == index) {
            expandedIndex = null;
          } else {
            expandedIndex = index;
          }
        });
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: const Color(0xfff9fafb),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey[200]!),
        ),
        child: leadContent,
      ),
    );

    if (isPrimum) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (index == 2)
            Align(
              alignment: Alignment.center,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  // Main container
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 14),
                    margin: const EdgeInsets.only(bottom: 10),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.lock_outline,
                          color: AppColors.primary,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          "Get premium to see new leads",
                          style: stylePoppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Positioned crown icon (emoji_events)
                  Positioned(
                    top: -8,
                    right: -2,
                    child: Container(
                      child: SvgPicture.asset(
                        AppAssets.imgHomeCrown,
                        width: 20,
                        height: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          Stack(
            children: [
              data,
              Positioned.fill(
                child: GestureDetector(
                  onTap: () {
                    Get.dialog(PremiumUpgradeDialog(
                      onSeeOffers: () {
                        Get.back();
                        Get.toNamed(MembershipScreen.pageId)?.then((value) {
                          widget.controller.mainController.getProfile();
                        });
                      },
                    ));
                  },
                  child: ClipRect(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                      child: Container(
                        color: Colors.transparent,
                      ),
                    ),
                  ),
                ),
              ),
            ],
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
        print(
            '_buildSentLeadsList called, sendLead count: ${widget.controller.sendLead.value?.data?.length ?? 0}');
        if (widget.controller.sendLead.value?.data == null ||
            widget.controller.sendLead.value?.data?.isEmpty == true) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    tr(LanguageKeys
                        .theRecommendationsYouSendToProfessionalsWillAppearHereWithStepByStepTrackingOfEachCaseProgress),
                    textAlign: TextAlign.center,
                    style: stylePoppins(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          itemCount: widget.controller.sendLead.value?.data?.length ?? 0,
          itemBuilder: (context, index) {
            final isExpanded = expandedIndex == index;
            final data = widget.controller.sendLead.value?.data?[index];

            return LeadStepperCard(
              name: '${data?.firstName ?? ''} ${data?.lastName ?? ''}',
              subtitle: data?.companyName ?? '',
              currentStep: 0,
              data: data,
              isExpanded: isExpanded,
              onToggleExpand: () {
                setState(() {
                  if (isExpanded) {
                    expandedIndex = null;
                  } else {
                    expandedIndex = index;
                  }
                });
              },
              onSeeDescription: () {
                showModalBottomSheet(
                  backgroundColor: Colors.white,
                  context: context,
                  isScrollControlled: true,
                  shape: const RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(30)),
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
                          borderRadius:
                              BorderRadius.vertical(top: Radius.circular(30)),
                        ),
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Top bar with title and close button
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const SizedBox(width: 40), // For alignment
                                  Text(
                                    tr(LanguageKeys.description),
                                    style: stylePoppins(
                                        fontSize: 24,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.close,
                                        color: Colors.grey),
                                    onPressed: () =>
                                        Navigator.of(context).pop(),
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
                                        _addToSendContacts(widget.controller
                                            .sendLead.value?.data?[index]);
                                      },
                                      child: Container(
                                          height: 48,
                                          decoration: BoxDecoration(
                                            color: AppColors.primary,
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Icons.person_add,
                                                color: AppColors.whiteColor,
                                              ),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              Text(
                                                tr(LanguageKeys.addContact),
                                                textAlign: TextAlign.center,
                                                maxLines: 2,
                                                style: stylePoppins(
                                                    color: Colors.white,
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                            ],
                                          )),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () {
                                        final contactInfo = '''
 ${widget.controller.sendLead.value?.data?[index].firstName ?? ''} ${widget.controller.sendLead.value?.data?[index].lastName ?? ''}
 ${widget.controller.sendLead.value?.data?[index].phoneNumber!.trim() ?? ''}
 ${widget.controller.sendLead.value?.data?[index].email!.trim() ?? ''}

''';
                                        Share.share(contactInfo);
                                      },
                                      child: Container(
                                          height: 48,
                                          decoration: BoxDecoration(
                                            color: AppColors.primary,
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Icons.share,
                                                color: AppColors.whiteColor,
                                              ),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              Text(
                                                tr(LanguageKeys.share),
                                                textAlign: TextAlign.center,
                                                maxLines: 2,
                                                style: stylePoppins(
                                                    color: Colors.white,
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                            ],
                                          )),
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
                                        "${widget.controller.sendLead.value?.data?[index].firstName ?? ''} ${widget.controller.sendLead.value?.data?[index].lastName ?? ''}"),
                                    const Divider(),
                                    _infoTile(
                                        Icons.business,
                                        tr(LanguageKeys
                                            .nameOfTheBusinessReferrer),
                                        "${widget.controller.sendLead.value?.data?[index].user?.firstName ?? ''} ${widget.controller.sendLead.value?.data?[index].user?.lastName ?? ''}"),
                                    const Divider(),
                                    _infoTile(
                                        Icons.phone,
                                        tr(LanguageKeys.phoneNumber),
                                        widget.controller.sendLead.value
                                                ?.data?[index].phoneNumber ??
                                            ''),
                                    const Divider(),
                                    _infoTile(
                                        Icons.email,
                                        tr(LanguageKeys.email),
                                        widget.controller.sendLead.value
                                                ?.data?[index].email ??
                                            ''),
                                    const Divider(),
                                    _infoTile(
                                        Icons.description,
                                        tr(LanguageKeys.description),
                                        widget.controller.sendLead.value
                                                ?.data?[index].description ??
                                            ''),
                                    const Divider(),
                                    _infoTile(
                                        Icons.calendar_month,
                                        tr(LanguageKeys.dateArchive),
                                        DateFormat('dd/MM/yyyy').format(
                                                DateTime.parse(widget
                                                        .controller
                                                        .sendLead
                                                        .value
                                                        ?.data?[index]
                                                        .createdAt ??
                                                    '')) ??
                                            ''),
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
              },
            );
          },
        );
      },
    );
  }

// Utility function to estimate text height
  double estimateTextHeight(String text, double maxWidth, TextStyle style) {
    final avgCharPerLine = (maxWidth / (style.fontSize ?? 14)) * 1.8;
    final lines = (text.length / avgCharPerLine).ceil();
    return text.isEmpty ? 52 : lines * (style.fontSize ?? 14) * 1.4;
  }

  Widget buildTimeline({
    List<ReceivedLeadTrack>? leadTrack,
    required int currentStep,
    required int parentIndex,
    Map<String, dynamic>? commentData,
    required Future<void> Function() onCommentTap,
    ReceivedLeadData? receivedLeadData,
  }) {
    int completedTrack =
        int.tryParse(receivedLeadData?.completedTrack ?? '0') ?? 0;

    return Column(
      children: List.generate(leadTrack?.length ?? 0, (index) {
        final bool isCompleted = index < completedTrack;
        final isActive = index == completedTrack;
        final bool isLastStep = index == (leadTrack?.length ?? 0) - 1;
        final step = leadTrack?[index];
        String? displayComment = "";
        String stepDate = '';

        // Determine the actual comment to display
        final localComment = leadComments['${parentIndex * 1000 + index}'];
        if (step?.comment?.isNotEmpty == true) {
          displayComment = step?.comment;
        } else if (localComment?['text']?.isNotEmpty == true) {
          displayComment = localComment?['text'];
        }
        AppHelper.showLog("displayComment: $displayComment");
        AppHelper.showLog("localComment: $localComment?['text']");

        final dynamicHeight = estimateTextHeight(displayComment ?? "", 200,
                stylePoppins(fontSize: 13, color: Colors.grey[600])) +
            16;
        AppHelper.showLog("dynamicHeight: $dynamicHeight");

        AppHelper.showLog("displayComment: $displayComment");

        final stepComment = leadComments['${parentIndex * 1000 + index}'] ?? {};
        AppHelper.showLog("stepComment: $stepComment");
        try {
          if (step?.completedAt != null &&
              step?.completedAt?.isNotEmpty == true) {
            stepDate = DateFormat('dd/MM/yyyy')
                .format(DateTime.parse(step!.completedAt!));
          }
        } catch (e) {
          AppHelper.showLog("Error formatting date: ${e.toString()}");
        }

        // bool isMatchingLocalizedValue(
        //     String? valueFromApi, String languageKey) {
        //   if (valueFromApi == null) return false;
        //   final translations = LanguageController.to.translations;
        //   AppHelper.showLog("translations: $translations");

        //   for (final locale in ['en', 'es', 'fr']) {
        //     final translated = translations[locale]?[languageKey];
        //     if (translated != null && translated == valueFromApi) {
        //       return true;
        //     }
        //   }
        //   return false;
        // }

        Color dotColor = isCompleted
            ? AppColors.whiteColor
            : (isActive ? Colors.black : Colors.black);

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            /// Dots & Connector
            ///

            Column(
              children: [
                Container(
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(
                    color: dotColor,
                    shape: BoxShape.circle,
                    border: Border.all(
                        color: isCompleted ? AppColors.primary : Colors.grey,
                        width: 2),
                  ),
                  child: isCompleted
                      ? Container(
                          margin: const EdgeInsets.all(2),
                          width: 16,
                          height: 16,
                          decoration: const BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                          ),
                        )
                      : const SizedBox(),
                ),
                if (index != (leadTrack?.length ?? 0) - 1)
                  Container(
                    width: 2,
                    height: 100,
                    color: isCompleted ? AppColors.primary : Colors.grey,
                  ),
              ],
            ),
            const SizedBox(width: 12),

            /// Step content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  /// Title + Comment Icon
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Text(
                          step?.name ?? '',
                          style: stylePoppins(
                            fontWeight: FontWeight.w500,
                            fontSize: 15,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      // Only show add comment icon if no comment exists for this step
                      if ((isActive || isCompleted) &&
                          (step?.comment == null ||
                              step?.comment?.isEmpty == true) &&
                          (leadComments[parentIndex * 1000 + index] == null ||
                              leadComments[parentIndex * 1000 + index]?['text']
                                      ?.isEmpty ==
                                  true))
                        GestureDetector(
                          onTap: () async {
                            TextEditingController controller =
                                TextEditingController(
                                    text: stepComment != null
                                        ? stepComment['text']
                                        : '');
                            String? comment =
                                await showModalBottomSheet<String>(
                              context: context,
                              isScrollControlled: true,
                              backgroundColor: Colors.transparent,
                              builder: (context) {
                                return Padding(
                                  padding: EdgeInsets.only(
                                    bottom: MediaQuery.of(context)
                                        .viewInsets
                                        .bottom,
                                  ),
                                  child: Container(
                                    padding: const EdgeInsets.all(20),
                                    decoration: const BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.vertical(
                                          top: Radius.circular(30)),
                                    ),
                                    child: SingleChildScrollView(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          TextField(
                                            controller: controller,
                                            maxLength: 200,
                                            decoration: InputDecoration(
                                              hintText:
                                                  tr(LanguageKeys.enterComment),
                                              filled: true,
                                              fillColor: Colors.grey[100],
                                              contentPadding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 12,
                                                      vertical: 8),
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                borderSide: BorderSide.none,
                                              ),
                                              enabledBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                borderSide: BorderSide.none,
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                borderSide: BorderSide.none,
                                              ),
                                            ),
                                            maxLines: 2,
                                          ),
                                          const SizedBox(height: 16),
                                          SizedBox(
                                            width: double.infinity,
                                            child: ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                    AppColors.primary,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                              ),
                                              onPressed: () {
                                                if (controller.text
                                                    .trim()
                                                    .isNotEmpty) {
                                                  Navigator.of(context).pop(
                                                      controller.text.trim());
                                                  // Store comment locally without API call
                                                  setState(() {
                                                    leadComments[
                                                        parentIndex * 1000 +
                                                            index] = {
                                                      'text': controller.text
                                                          .trim(),
                                                      'date': DateFormat(
                                                              'dd/MM/yyyy hh:mm a')
                                                          .format(
                                                              DateTime.now()),
                                                    };
                                                  });
                                                }
                                              },
                                              child: Text(
                                                tr(LanguageKeys.submit),
                                                style: stylePoppins(
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );

                            // Comment is now stored locally in the onPressed callback above
                            // No need to store it again here
                          },
                          child: SvgPicture.asset(AppAssets.imgAddComment,
                              color: AppColors.primary, width: 30, height: 30),
                        ),
                    ],
                  ),

                  /// Completed Date
                  if (isCompleted && stepDate.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            stepDate,
                            style: TextStyle(
                                fontSize: 13, color: Colors.grey[600]),
                          ),
                          if (step?.comment != null ||
                              leadComments[parentIndex * 1000 + index] != null)
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    step?.comment ??
                                        leadComments[parentIndex * 1000 + index]
                                            ?['text'] ??
                                        '',
                                    style: TextStyle(
                                        fontSize: 10, color: Colors.grey[600]),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                GestureDetector(
                                  onTap: () async {
                                    final currentComment = step?.comment ?? "";
                                    TextEditingController controller =
                                        TextEditingController(text: "");

                                    final updatedComment =
                                        await showModalBottomSheet<String>(
                                      context: context,
                                      isScrollControlled: true,
                                      backgroundColor: Colors.transparent,
                                      builder: (context) {
                                        return Padding(
                                          padding: EdgeInsets.only(
                                            bottom: MediaQuery.of(context)
                                                .viewInsets
                                                .bottom,
                                          ),
                                          child: Container(
                                            padding: const EdgeInsets.all(20),
                                            decoration: const BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.vertical(
                                                      top: Radius.circular(30)),
                                            ),
                                            child: SingleChildScrollView(
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  TextField(
                                                    controller: controller,
                                                    maxLength: 200,
                                                    decoration: InputDecoration(
                                                      hintText: tr(LanguageKeys
                                                          .enterComment),
                                                      filled: true,
                                                      fillColor:
                                                          Colors.grey[100],
                                                      contentPadding:
                                                          const EdgeInsets
                                                              .symmetric(
                                                              horizontal: 12,
                                                              vertical: 8),
                                                      border:
                                                          OutlineInputBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10),
                                                              borderSide:
                                                                  BorderSide
                                                                      .none),
                                                      enabledBorder:
                                                          OutlineInputBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10),
                                                              borderSide:
                                                                  BorderSide
                                                                      .none),
                                                      focusedBorder:
                                                          OutlineInputBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10),
                                                              borderSide:
                                                                  BorderSide
                                                                      .none),
                                                    ),
                                                    maxLines: 2,
                                                  ),
                                                  const SizedBox(height: 16),
                                                  SizedBox(
                                                    width: double.infinity,
                                                    child: ElevatedButton(
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                        backgroundColor:
                                                            AppColors.primary,
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                        ),
                                                      ),
                                                      onPressed: () {
                                                        if (controller.text
                                                            .trim()
                                                            .isNotEmpty) {
                                                          Navigator.of(context)
                                                              .pop(controller
                                                                  .text
                                                                  .trim());
                                                        }
                                                      },
                                                      child: Text(
                                                        tr(LanguageKeys.submit),
                                                        style: stylePoppins(
                                                            color:
                                                                Colors.white),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                    AppHelper.showLog(
                                        "updatedComment: $updatedComment");

                                    if (updatedComment != null &&
                                        updatedComment.isNotEmpty) {
                                      // Update the comment on backend
                                      await widget.controller.editLeadComment(
                                        id: int.parse(widget
                                                .controller
                                                .receivedLead
                                                .value
                                                ?.data?[parentIndex]
                                                .leadTrack?[index]
                                                .id
                                                .toString() ??
                                            '0'),
                                        comment:
                                            "$currentComment $updatedComment",
                                        leadId: int.parse(widget
                                                .controller
                                                .receivedLead
                                                .value
                                                ?.data?[parentIndex]
                                                .leadTrack?[index]
                                                .leadId
                                                .toString() ??
                                            '0'),
                                      );

                                      // Update local state immediately
                                      setState(() {
                                        widget
                                            .controller
                                            .receivedLead
                                            .value
                                            ?.data?[parentIndex]
                                            .leadTrack?[index]
                                            .comment = updatedComment;

                                        // Also update the local leadComments map
                                        leadComments[
                                            parentIndex * 1000 + index] = {
                                          'text': updatedComment,
                                          'date':
                                              DateFormat('dd/MM/yyyy hh:mm a')
                                                  .format(DateTime.now()),
                                        };
                                      });

                                      // Refresh the controller data
                                      widget.controller.receivedLead.refresh();
                                      widget.controller.getLeads();
                                      widget.controller.update();
                                    }
                                  },
                                  child: const Icon(Icons.edit,
                                      size: 18, color: Colors.deepPurple),
                                ),
                              ],
                            ),
                        ],
                      ),
                    ),

                  ///For Payment Received
                  // if (step?.name == "Payment received" &&
                  //     leadTrack?.length == 5)
                  if (index == 3 &&
                      (leadTrack?.length ?? 0) >=
                          4) // Show at 4th position (index 3) when there are at least 4 steps
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          tr(LanguageKeys.payTheCommission),
                        ),
                        const SizedBox(height: 5),
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () async {
                                TextEditingController controller =
                                    TextEditingController();
                                String? comment =
                                    await showModalBottomSheet<String>(
                                  context: context,
                                  isScrollControlled: true,
                                  backgroundColor: Colors.transparent,
                                  builder: (context) {
                                    return Padding(
                                      padding: EdgeInsets.only(
                                        bottom: MediaQuery.of(context)
                                            .viewInsets
                                            .bottom,
                                      ),
                                      child: Container(
                                        padding: const EdgeInsets.all(20),
                                        decoration: const BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.vertical(
                                              top: Radius.circular(30)),
                                        ),
                                        child: SingleChildScrollView(
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              TextField(
                                                controller: controller,
                                                maxLength: 200,
                                                decoration: InputDecoration(
                                                  hintText: tr(LanguageKeys
                                                      .enterCommission),
                                                  filled: true,
                                                  fillColor: Colors.grey[100],
                                                  contentPadding:
                                                      const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 12,
                                                          vertical: 8),
                                                  border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    borderSide: BorderSide.none,
                                                  ),
                                                  enabledBorder:
                                                      OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    borderSide: BorderSide.none,
                                                  ),
                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    borderSide: BorderSide.none,
                                                  ),
                                                ),
                                                maxLines: 2,
                                              ),
                                              const SizedBox(height: 16),
                                              SizedBox(
                                                width: double.infinity,
                                                child: ElevatedButton(
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        AppColors.primary,
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                    ),
                                                  ),
                                                  onPressed: () {
                                                    if (controller.text
                                                        .trim()
                                                        .isNotEmpty) {
                                                      Navigator.of(context).pop(
                                                          controller.text
                                                              .trim());
                                                      widget.controller
                                                          .addCommisionAmount(
                                                        id: int.parse(
                                                            step?.id ?? '0'),
                                                        amount: controller.text
                                                            .trim(),
                                                        leadId: int.parse(
                                                            step?.leadId ??
                                                                '0'),
                                                      );
                                                    }
                                                  },
                                                  child: Text(
                                                    tr(LanguageKeys.submit),
                                                    style: stylePoppins(
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                );
                                if (comment != null && comment.isNotEmpty) {
                                  // Handle the comment (e.g., save, update state, call API, etc.)
                                }
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 5),
                                decoration: BoxDecoration(
                                  color: AppColors.whiteColor,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Column(
                                  children: [
                                    Text(
                                      tr(LanguageKeys.external),
                                      style: stylePoppins(
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w400,
                                        color: AppColors.primary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(width: 20),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 5),
                              decoration: BoxDecoration(
                                color: AppColors.primary.withOpacity(0.5),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Column(
                                children: [
                                  Text(tr(LanguageKeys.viaReferaly),
                                      style: stylePoppins(
                                          fontSize: 12.sp,
                                          fontWeight: FontWeight.w500,
                                          color: AppColors.whiteColor)),
                                ],
                              ),
                            ),
                          ],
                        )
                      ],
                    ),

                  /// Comment bubble (optional)
                  ///
                  if (isActive)
                    Builder(
                      builder: (context) {
                        final localComment =
                            leadComments[parentIndex * 1000 + index];
                        AppHelper.showLog(
                            "localComment: $localComment?['text']");
                        final stepComment = step?.comment;

                        // Show step comment first, then local comment

                        if (stepComment?.isNotEmpty == true) {
                          displayComment = stepComment;
                        } else if (localComment?['text']?.isNotEmpty == true) {
                          displayComment = localComment?['text'];
                        }

                        if (displayComment != null &&
                            displayComment!.isNotEmpty) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 1),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Text(
                                    displayComment ?? '',
                                    style: stylePoppins(
                                        fontSize: 10, color: Colors.black87),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                SvgPicture.asset(AppAssets.imgAddCommentIcon,
                                    color: AppColors.primary,
                                    width: 18,
                                    height: 18),
                              ],
                            ),
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),

                  /// NEXT button
                  if (isActive)
                    Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () async {
                            // Get the locally stored comment
                            final localComment =
                                leadComments[parentIndex * 1000 + index];
                            final commentText = localComment?['text'] ?? '';

                            // Call the API to send the comment
                            await widget.controller
                                .sendLeadComment(
                              id: int.parse(widget.controller.receivedLead.value
                                      ?.data?[parentIndex].leadTrack?[index].id
                                      .toString() ??
                                  '0'),
                              comment: commentText,
                              leadId: int.parse(widget
                                      .controller
                                      .receivedLead
                                      .value
                                      ?.data?[parentIndex]
                                      .leadTrack?[index]
                                      .leadId
                                      .toString() ??
                                  '0'),
                              leadLength: widget.controller.receivedLead.value
                                      ?.data?[parentIndex].leadTrack?.length ??
                                  0,
                              parentIndex: index,
                            )
                                .then((value) {
                              // widget.controller.getLeads();
                              widget
                                  .controller
                                  .receivedLead
                                  .value
                                  ?.data?[parentIndex]
                                  .completedTrack = (index + 1).toString();
                              widget
                                  .controller
                                  .receivedLead
                                  .value
                                  ?.data?[parentIndex]
                                  .leadTrack?[index]
                                  .comment = commentText;
                              final now = DateTime.now().toUtc();
                              final formatted =
                                  '${now.toIso8601String().split('.').first}.000000Z';
                              widget
                                  .controller
                                  .receivedLead
                                  .value
                                  ?.data?[parentIndex]
                                  .leadTrack?[index]
                                  .completedAt = formatted;

                              // Clear the local comment since it's now stored in the backend
                              setState(() {
                                leadComments.remove(parentIndex * 1000 + index);
                              });

                              widget.controller.receivedLead.refresh();
                              widget.controller.getLeads();
                              widget.controller.update();
                            });
                          },
                          borderRadius: BorderRadius.circular(3),
                          splashColor: AppColors.primary.withOpacity(0.2),
                          highlightColor: AppColors.primary.withOpacity(0.1),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 14, vertical: 3),
                            decoration: BoxDecoration(
                              border: Border.all(color: AppColors.primary),
                              borderRadius: BorderRadius.circular(3),
                              color: Colors.transparent,
                            ),
                            child: Text(
                              tr(LanguageKeys.next),
                              style: stylePoppins(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }

  Future<void> _addToContacts(ReceivedLeadData? leadData) async {
    try {
      // Request both READ and WRITE contacts permissions
      final status = await FlutterContacts.requestPermission();
      if (status) {
        final fullName =
            '${leadData?.firstName ?? ''} ${leadData?.lastName ?? ''}';
        final parts = fullName.split(' ');
        final firstName = parts.isNotEmpty ? parts.first : '';
        final lastName = parts.length > 1 ? parts.sublist(1).join(' ') : '';

        final contact = Contact()
          ..name = Name(
              first:
                  '${'$firstName $lastName'} (${leadData?.user?.firstName ?? ''} ${leadData?.user?.lastName ?? ''})',
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

  Future<void> _addToSendContacts(SendLeadData? leadData) async {
    try {
      // Request both READ and WRITE contacts permissions
      final status = await FlutterContacts.requestPermission();
      if (status) {
        final fullName =
            '${leadData?.firstName ?? ''} ${leadData?.lastName ?? ''}';
        final parts = fullName.split(' ');
        final firstName = parts.isNotEmpty ? parts.first : '';
        final lastName = parts.length > 1 ? parts.sublist(1).join(' ') : '';

        final contact = Contact()
          ..name = Name(
              first:
                  '${'$firstName $lastName'} (${leadData?.user?.firstName ?? ''} ${leadData?.user?.lastName ?? ''})',
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
}

class LeadStepperCard extends StatelessWidget {
  final String name;
  final String subtitle;
  final int currentStep; // 0-based index of the active step
  final VoidCallback? onSeeDescription;
  final SendLeadData? data;
  final bool isExpanded;
  final VoidCallback onToggleExpand;

  const LeadStepperCard({
    super.key,
    required this.name,
    required this.subtitle,
    required this.currentStep,
    this.onSeeDescription,
    this.data,
    required this.isExpanded,
    required this.onToggleExpand,
  });

  Widget buildTimelineSendLead(
      {required int currentStep, required List<LeadTrack> leadTrack}) {
    AppHelper.showLog("currentStep: $currentStep");
    final int completedTrack = int.tryParse(data?.completedTrack ?? '0') ?? 0;
    return Column(
      children: List.generate(leadTrack.length, (index) {
        final bool isCompleted = index < completedTrack;
        final bool isActive = index == completedTrack;
        final bool isLastStep = index == (leadTrack?.length ?? 0) - 1;

        final step = leadTrack?[index];
        String stepDate = '';

        try {
          if (step?.completedAt != null &&
              step?.completedAt?.isNotEmpty == true) {
            stepDate = DateFormat('dd/MM/yyyy')
                .format(DateTime.parse(step!.completedAt!));
          }
        } catch (e) {
          AppHelper.showLog("Error formatting date: ${e.toString()}");
        }

        Color dotColor = isCompleted
            ? AppColors.whiteColor
            : (isActive ? Colors.black : Colors.black);

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                const SizedBox(
                  height: 5,
                ),
                Container(
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(
                    color: dotColor,
                    shape: BoxShape.circle,
                    border: Border.all(
                        color: isCompleted ? AppColors.primary : Colors.grey,
                        width: 2),
                  ),
                  child: isCompleted
                      ? Container(
                          margin: const EdgeInsets.all(2),
                          width: 16,
                          height: 16,
                          decoration: const BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                          ),
                        )
                      : const SizedBox(),
                ),
                if (index != leadTrack.length - 1)
                  Container(
                    width: 2,
                    height: 42,
                    color: Colors.grey,
                  ),
              ],
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    leadTrack[index].name ?? '',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: isActive ? Colors.black : Colors.black,
                    ),
                  ),

                  /// Completed Date
                  // if (isCompleted && stepDate.isNotEmpty)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        stepDate,
                        style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                      ),
                      if (step?.comment != null && step?.comment != "null")
                        Text(
                          step?.comment ?? '',
                          maxLines: 5,
                          overflow: TextOverflow.ellipsis,
                          style:
                              TextStyle(fontSize: 11, color: Colors.grey[600]),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        AppHelper.showLog("onTap: $onToggleExpand");
        onToggleExpand();
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
        decoration: BoxDecoration(
          color: const Color(0xfff9fafb),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey[200]!),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            children: [
              Row(
                children: [
                  if (data?.deal?.createdDetail?.companyLogoUrl != null)
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: AppColors.whiteColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          data?.deal?.createdDetail?.companyLogoUrl ?? '',
                          height: 50.w,
                          width: 50.w,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(name,
                            style: stylePoppins(
                                fontWeight: FontWeight.w400, fontSize: 16)),
                        Text(subtitle,
                            style: TextStyle(
                                color: Colors.grey[600], fontSize: 13)),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Get.toNamed(LeadSubmissionScreen.pageId, arguments: {
                        'lead_assign_type': data?.leadAssignType,
                        'first': data?.firstName,
                        'last': data?.lastName,
                        'email': data?.email,
                        'phone': data?.phoneNumber,
                        'id': data?.id,
                        'deal_id': data?.dealId,
                        'deal_name': data?.deal?.dealName,
                        'description': data?.description,
                        "type": "edit",
                      })?.then((value) {
                        if (value == true) {
                          Get.find<TrackLeadsController>().getSendLeads();
                        }
                      });
                    },
                    child: SvgPicture.asset(AppAssets.imgEdit,
                        color: AppColors.primary),
                  ),
                  const SizedBox(width: 4),
                  GestureDetector(
                    onTap: onToggleExpand,
                    child: Icon(
                      isExpanded
                          ? Icons.keyboard_arrow_up
                          : Icons.keyboard_arrow_down,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              if (isExpanded) ...[
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      buildTimelineSendLead(
                        currentStep: int.parse(data?.completedTrack ?? '0'),
                        leadTrack: data?.leadTrack ?? [],
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
                SizedBox(
                  width: 200,
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: AppColors.primary),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                    onPressed: onSeeDescription,
                    child: Text(
                      tr(LanguageKeys.seeDescription),
                      style: const TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
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

// Helper widget for info row
Widget _infoTile(IconData icon, String label, String value) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Icon(icon, color: AppColors.blackColor),
      const SizedBox(width: 12),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: stylePoppins(color: Colors.grey, fontSize: 13)),
            const SizedBox(height: 2),
            if (label == tr(LanguageKeys.phoneNumber) &&
                value.isNotEmpty &&
                value != "Not Provided")
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
                value != "Not Provided")
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
                  value != "Not Provided"
                      ? value
                      : tr(LanguageKeys.nullDataText),
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
                value != "Not Provided" ? value : tr(LanguageKeys.nullDataText),
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
