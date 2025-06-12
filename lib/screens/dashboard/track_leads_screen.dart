import 'dart:ui';

import 'package:flutter/material.dart';
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

import '../../resources/app_colors.dart';
import '../../resources/text_style.dart';
import '../../widgets/dialog/premium_upgrade_dialog.dart';
import '../../widgets/dialog/success_popup.dart';
import 'membership_screen.dart';

class TrackLeadsScreen extends StatefulWidget {
  static String pageId = "/trackLeads";
  final TrackLeadsController controller;

  TrackLeadsScreen({super.key, required this.controller});

  @override
  State<TrackLeadsScreen> createState() => _TrackLeadsScreenState();
}

class _TrackLeadsScreenState extends State<TrackLeadsScreen> {
  Set<int> expandedIndices = {};
  Map<int, Map<String, dynamic>> leadComments =
      {}; // {index: {"text": ..., "date": ...}}
  Map<int, int> itemCurrentSteps = {}; // Track current step per item

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Get.offAllNamed(ScreenMain.pageId);
        return false;
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
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 30, 20, 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            tr(LanguageKeys.trackYourLead),
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
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 8.0),
                                    child: Text(
                                      tr(LanguageKeys.leadReceivedTab),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.center,
                                      style: stylePoppins(
                                        color: widget.controller.isLeadsReceived
                                                .value
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
                        tr(LanguageKeys.leadSentTab),
                        style: stylePoppins(
                          color: !widget.controller.isLeadsReceived.value
                              ? Colors.white
                              : Colors.black87,
                          fontWeight: !widget.controller.isLeadsReceived.value
                              ? FontWeight.w400
                              : FontWeight.w400,
                        ),
                      ),
                    ),
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
      title: tr(LanguageKeys.archive),
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
                AppHelper.showLog("expandedIndices: $expandedIndices");
                setState(() {});
              },
              index: index,
              name: widget
                      .controller.receivedLead.value?.data?[index].firstName ??
                  '',
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
                value,
                style: stylePoppins(
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
              ),
            )
          else
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
    final isExpanded = expandedIndices.contains(index);
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
                          height: 50,
                          width: 50,
                          child: Image.network(
                            widget.controller.receivedLead.value?.data?[index]
                                    .user?.avatarUrl ??
                                '',
                            height: 50,
                            width: 50,
                          ),
                        )
                      : Container(),
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
                              "3") {
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
                                        message: widget.controller.receivedLead
                                                .value?.message ??
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
                            Get.toNamed(MyActivityInfoScreen.pageId);
                          }
                        }
                      : () {
                          Get.dialog(PremiumUpgradeDialog(
                            onSeeOffers: () {
                              Get.back();
                              Get.toNamed(MembershipScreen.pageId);
                            },
                          ));
                        },
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 3, vertical: 10),
                    child: Image.asset(
                      widget.controller.receivedLead.value?.data?[index]
                                  .leadAssignType ==
                              "3"
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
                          tr(LanguageKeys.phoneNumber),
                          widget.controller.receivedLead.value?.data?[index]
                                  .phoneNumber ??
                              ''),
                      infoRow(
                          tr(LanguageKeys.email),
                          (widget.controller.receivedLead.value?.data?[index]
                                      .email !=
                                  "null"
                              ? "${widget.controller.receivedLead.value?.data?[index].email}"
                              : "Not Provided")),
                      infoRow(
                        tr(LanguageKeys.createdDate),
                        _formatCreatedAt(widget.controller.receivedLead.value
                                ?.data?[index].createdAt ??
                            ''),
                      ),
                      const SizedBox(height: 10),
                    ],
                  )
                : Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        buildTimeline(
                          receivedLeadData: widget
                              .controller.receivedLead.value?.data?[index],
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
                                                    const SizedBox(width: 12),
                                                    Expanded(
                                                      child: GestureDetector(
                                                        onTap: () {
                                                          Get.dialog(
                                                            SharePopup(
                                                              title: widget
                                                                      .controller
                                                                      .receivedLead
                                                                      .value
                                                                      ?.data?[
                                                                          index]
                                                                      .firstName ??
                                                                  '',
                                                              link: widget
                                                                      .controller
                                                                      .receivedLead
                                                                      .value
                                                                      ?.data?[
                                                                          index]
                                                                      .firstName ??
                                                                  '',
                                                            ),
                                                          );
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
                                                        BorderRadius.circular(
                                                            20),
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
                                                          tr(LanguageKeys
                                                              .email),
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
                                    border:
                                        Border.all(color: AppColors.primary),
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
                                                      .receivedLead
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
                                    border:
                                        Border.all(color: AppColors.primary),
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
          if (expandedIndices.contains(index)) {
            expandedIndices.remove(index);
          } else {
            expandedIndices.add(index);
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
            final isExpanded = expandedIndices.contains(index);
            final data = widget.controller.sendLead.value?.data?[index];

            return LeadStepperCard(
              name: data?.firstName ?? '',
              subtitle: data?.companyName ?? '',
              currentStep: 0,
              data: data,
              isExpanded: isExpanded,
              onToggleExpand: () {
                setState(() {
                  if (isExpanded) {
                    expandedIndices.remove(index);
                  } else {
                    expandedIndices.clear();
                    expandedIndices.add(index);
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
                    return SizedBox(
                      height: MediaQuery.of(context).size.height * 0.4,
                      width: Get.width,
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Stack(
                              alignment: Alignment.center,
                              children: [
                                Center(
                                  child: Text(
                                    tr(LanguageKeys.description),
                                    style: stylePoppins(
                                        fontSize: 24,
                                        fontWeight: FontWeight.w400),
                                  ),
                                ),
                                Positioned(
                                  right: 0,
                                  child: GestureDetector(
                                    onTap: () => Navigator.of(context).pop(),
                                    child: const Icon(
                                      Icons.close,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            _infoRow(tr(LanguageKeys.phoneNumber),
                                data?.phoneNumber ?? ''),
                            _infoRow(tr(LanguageKeys.email),
                                "${data?.email ?? ''} ${data?.lastName ?? ''}"),
                            _infoRow(tr(LanguageKeys.fullName),
                                "${data?.firstName ?? ''} ${data?.lastName ?? ''}"),
                            _infoRow(tr(LanguageKeys.description),
                                data?.description ?? ''),
                          ],
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

  Widget buildTimeline({
    List<ReceivedLeadTrack>? leadTrack,
    required int currentStep,
    required int parentIndex,
    Map<String, dynamic>? commentData,
    required Future<void> Function() onCommentTap,
    ReceivedLeadData? receivedLeadData,
  }) {
    final int completedTrack =
        int.tryParse(receivedLeadData?.completedTrack ?? '0') ?? 0;

    return Column(
      children: List.generate(leadTrack?.length ?? 0, (index) {
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
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            /// Dots & Connector
            Column(
              children: [
                Container(
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(
                    color: dotColor,
                    shape: BoxShape.circle,
                    border: Border.all(
                        color: isCompleted ? AppColors.primary : Colors.black,
                        width: 2),
                  ),
                  child: isCompleted
                      ? Container(
                          margin: const EdgeInsets.all(2),
                          width: 16,
                          height: 16,
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                          ),
                        )
                      : const SizedBox(),
                ),
                if (index != (leadTrack?.length ?? 0) - 1)
                  Container(
                    width: 2,
                    height: 62,
                    color: Colors.grey,
                  ),
              ],
            ),
            const SizedBox(width: 12),

            /// Step content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
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
                      if (isActive)
                        GestureDetector(
                          onTap: onCommentTap,
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
                          if (step?.comment != null)
                            Row(
                              children: [
                                Text(
                                  step?.comment ?? '',
                                  style: TextStyle(
                                      fontSize: 11, color: Colors.grey[600]),
                                ),
                                const SizedBox(width: 8),
                                const Icon(Icons.edit,
                                    size: 18, color: Colors.deepPurple),
                              ],
                            ),
                        ],
                      ),
                    ),

                  /// Comment bubble (optional)
                  ///
                  if (isActive)
                    if (commentData != null &&
                        (commentData['text']?.isNotEmpty ?? false))
                      Padding(
                        padding: const EdgeInsets.only(top: 1),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  commentData['text'],
                                  style: stylePoppins(
                                      fontSize: 11, color: Colors.black87),
                                ),
                              ],
                            ),
                            const SizedBox(width: 8),
                            SvgPicture.asset(AppAssets.imgAddCommentIcon,
                                color: AppColors.primary,
                                width: 18,
                                height: 18),
                          ],
                        ),
                      ),

                  /// NEXT button
                  if (isActive)
                    Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: GestureDetector(
                        onTap: () async {
                          setState(() {
                            itemCurrentSteps[parentIndex] = currentStep + 1;

                            widget.controller
                                .sendLeadComment(
                              id: int.parse(widget.controller.receivedLead.value
                                      ?.data?[parentIndex].leadTrack?[index].id
                                      .toString() ??
                                  '0'),
                              comment: commentData?['text'] ?? '',
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
                              commentData?['text'] = '';
                            });
                          });
                        },
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
      // Request contacts permission
      final status = await Permission.contacts.request();
      if (status.isGranted) {
        // Create new contact
        final contact = Contact(
          displayName:
              '${leadData?.firstName ?? ''} ${leadData?.lastName ?? ''}',
          emails: [Email(leadData?.email ?? '')],
          phones: [Phone(leadData?.phoneNumber ?? '')],
        );

        // Add contact to device
        await contact.insert();

        // Show success message
        Get.snackbar(
          'Success',
          'Contact added successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        // Show error message if permission denied
        Get.snackbar(
          'Error',
          'Permission to access contacts was denied',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
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
  final Data? data;
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

  Widget buildTimeline(
      {required int currentStep, required List<LeadTrack> leadTrack}) {
    AppHelper.showLog("currentStep: $currentStep");
    return Column(
      children: List.generate(leadTrack.length, (index) {
        final bool isCompleted = index <= currentStep;
        final bool isActive = index == currentStep;
        final bool isLastStep = index == (leadTrack.length) - 1;

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
            : (isActive ? AppColors.primary : Colors.grey);
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
                          decoration: BoxDecoration(
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
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  leadTrack[index].name ?? '',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: isActive ? Colors.black : Colors.black,
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
    return GestureDetector(
      onTap: () {
        if (isExpanded) {
          onToggleExpand();
        }
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
                  if (data?.user?.avatarUrl != null)
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.grey[400],
                        shape: BoxShape.circle,
                      ),
                      child: Image.network(
                        data?.user?.avatarUrl ?? '',
                        fit: BoxFit.cover,
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
                        'description': data?.description,
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
                      buildTimeline(
                        currentStep: int.parse(data?.completedTrack ?? '0'),
                        leadTrack: data?.leadTrack ?? [],
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: 200,
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: AppColors.primary),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                    onPressed: onSeeDescription,
                    child: Text(
                      tr(LanguageKeys.seeDescription),
                      style: TextStyle(
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
      Icon(icon, color: AppColors.primary),
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
            else
              Text(
                value,
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
