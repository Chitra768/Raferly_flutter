// ignore_for_file: prefer_const_constructors_in_immutables

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_contacts/diacritics.dart';
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
import 'package:referaly/screens/home/screen_main.dart';
import 'package:referaly/screens/lead_submission_screen.dart';
import 'package:referaly/utils/translations.dart';
import 'package:referaly/widgets/common_popup.dart';
import 'package:referaly/widgets/dialog/add_lead_dialog.dart'
    show AddLeadDialog;
import 'package:url_launcher/url_launcher.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter_animated_button/flutter_animated_button.dart';

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

class DecimalTextInputFormatter extends TextInputFormatter {
  final int decimalRange;

  DecimalTextInputFormatter({required this.decimalRange});

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    String text = newValue.text;

    // Allow empty string
    if (text.isEmpty) {
      return newValue;
    }

    // Remove all commas first to work with clean number
    String cleanText = text.replaceAll(',', '');

    // Allow only digits and decimal points
    if (!RegExp(r'^\d*\.?\d*$').hasMatch(cleanText)) {
      return oldValue;
    }

    // Check for multiple decimal points
    if ((cleanText.split('.').length - 1) > 1) {
      return oldValue;
    }

    // Check decimal places
    if (cleanText.contains('.')) {
      List<String> parts = cleanText.split('.');
      if (parts.length == 2 && parts[1].length > decimalRange) {
        return oldValue; // Too many decimal places
      }
    }

    // Don't format if user is typing a decimal point
    if (text.endsWith('.') && !oldValue.text.endsWith('.')) {
      return newValue;
    }

    // Format with commas
    String formattedText = _formatWithCommas(cleanText);
    return TextEditingValue(
      text: formattedText,
      selection: TextSelection.collapsed(offset: formattedText.length),
    );
  }

  String _formatWithCommas(String text) {
    if (text.isEmpty) return text;

    // Split into integer and decimal parts
    List<String> parts = text.split('.');
    String integerPart = parts[0];
    String decimalPart = parts.length > 1 ? parts[1] : '';

    // Format integer part with commas
    String formattedInteger = '';
    for (int i = 0; i < integerPart.length; i++) {
      if (i > 0 && (integerPart.length - i) % 3 == 0) {
        formattedInteger += ',';
      }
      formattedInteger += integerPart[i];
    }

    // Combine with decimal part
    if (decimalPart.isNotEmpty) {
      return '$formattedInteger.$decimalPart';
    } else {
      return formattedInteger;
    }
  }
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

  // Search controllers moved to class level to prevent recreation on rebuilds
  late TextEditingController receivedLeadsSearchController;
  late TextEditingController sentLeadsSearchController;

  // Filtered lists moved to class level to preserve state across rebuilds
  final RxList<ReceivedLeadData> filteredReceivedLeads =
      RxList<ReceivedLeadData>();
  final RxList<SendLeadData> filteredSentLeads = RxList<SendLeadData>();

  @override
  void initState() {
    super.initState();
    receivedLeadsSearchController = TextEditingController();
    sentLeadsSearchController = TextEditingController();

    // Add listeners to handle data changes while preserving search state
    ever(widget.controller.receivedLead, (dynamic _) {
      if (receivedLeadsSearchController.text.isEmpty) {
        // Only reset if no search is active
        filteredReceivedLeads
            .assignAll(widget.controller.receivedLead.value?.data ?? []);
      }
    });

    ever(widget.controller.sendLead, (dynamic _) {
      if (sentLeadsSearchController.text.isEmpty) {
        // Only reset if no search is active
        filteredSentLeads
            .assignAll(widget.controller.sendLead.value?.data ?? []);
      }
    });
  }

  @override
  void dispose() {
    receivedLeadsSearchController.dispose();
    sentLeadsSearchController.dispose();
    super.dispose();
  }

  void _clearLocalState() {
    setState(() {
      expandedIndex = null;
      leadComments.clear();
      itemCurrentSteps.clear();
    });
  }

  void _clearSearchState() {
    receivedLeadsSearchController.clear();
    sentLeadsSearchController.clear();
    // Clear filtered lists when switching tabs
    filteredReceivedLeads.clear();
    filteredSentLeads.clear();
  }

  /// Get the original index from the filtered index for received leads
  int? getOriginalReceivedLeadIndex(int filteredIndex) {
    if (filteredIndex >= 0 && filteredIndex < filteredReceivedLeads.length) {
      final filteredLead = filteredReceivedLeads[filteredIndex];
      final originalData = widget.controller.receivedLead.value?.data ?? [];

      // Find the original index by matching the lead data
      for (int i = 0; i < originalData.length; i++) {
        if (originalData[i].id == filteredLead.id) {
          return i;
        }
      }
    }
    return filteredIndex; // Fallback to filtered index if not found
  }

  /// Get the original index from the filtered index for sent leads
  int? getOriginalSentLeadIndex(int filteredIndex) {
    if (filteredIndex >= 0 && filteredIndex < filteredSentLeads.length) {
      final filteredLead = filteredSentLeads[filteredIndex];
      final originalData = widget.controller.sendLead.value?.data ?? [];

      // Find the original index by matching the lead data
      for (int i = 0; i < originalData.length; i++) {
        if (originalData[i].id == filteredLead.id) {
          return i;
        }
      }
    }
    return filteredIndex; // Fallback to filtered index if not found
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
                _clearSearchState();
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
                _clearSearchState();
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
                            _clearSearchState();
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
                                              AppAssets.imgHDashboardCrown,
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
                    _clearSearchState();
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
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildActionButton(
                      type: "add",
                      title: tr(LanguageKeys.addLeadManually),
                      icon: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: AppColors.whiteColor.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Icon(
                          Icons.person_add_alt_1,
                          color: AppColors.whiteColor,
                          size: 16,
                        ),
                      ),
                      onTap: () {
                        Get.dialog(AddLeadDialog()).then((value) {
                          widget.controller.getLeads();
                        });
                      },
                    ),
                    const SizedBox(height: 10),
                    archiveBtn(type: "receive"),
                  ],
                )
              : Align(
                  alignment: Alignment.center,
                  child: SizedBox(
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
          type: "archive",
          title: tr(LanguageKeys.archive),
          icon: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Image.asset(
                AppAssets.imgRefreshIcon,
                height: 20,
                width: 20,
                fit: BoxFit.cover,
                color: AppColors.whiteColor,
              ),
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
    required String type,
    required String title,
    required Widget icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: type == "archive" ? 43 : 53,
        width: type == "archive" ? Get.width / 1.5 : Get.width,
        decoration: BoxDecoration(
          color: type == "archive" ? AppColors.whiteColor : AppColors.primary,
          border: Border.all(
              color: type == "archive"
                  ? AppColors.primary.withOpacity(0.2)
                  : Colors.transparent,
              width: 1.5),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            icon,
            if (type == "add") const SizedBox(width: 10),
            Flexible(
              child: Text(
                title,
                style: stylePoppins(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  color: type == "archive" ? AppColors.primary : Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void filterLeads(String query) {
    print('Filtering leads with query: $query');
    final leads = widget.controller.receivedLead.value?.data ?? [];
    if (query.isEmpty) {
      filteredReceivedLeads.assignAll(leads);
    } else {
      filteredReceivedLeads.assignAll(
        leads.where((lead) {
          final leadName = '${lead.firstName ?? ''} ${lead.lastName ?? ''}'
              .toLowerCase()
              .trim();
          final referralName =
              '${lead.deal?.createdDetail?.firstName ?? ''} ${lead.deal?.createdDetail?.lastName ?? ''}'
                  .toLowerCase()
                  .trim();
          final userName =
              '${lead.user?.firstName ?? ''} ${lead.user?.lastName ?? ''}'
                  .toLowerCase()
                  .trim();
          // Normalize for comparison (remove accents, lowercase, trim)
          final normalizedLeadName =
              removeDiacritics(leadName.toLowerCase().trim());
          final normalizedReferralName =
              removeDiacritics(referralName.toLowerCase().trim());
          final normalizedUserName =
              removeDiacritics(userName.toLowerCase().trim());
          final normalizedQuery = removeDiacritics(query.toLowerCase().trim());

          // Match search query against normalized names
          return normalizedLeadName.contains(normalizedQuery) ||
              normalizedReferralName.contains(normalizedQuery) ||
              normalizedUserName.contains(normalizedQuery);
          // return leadName.contains(lowerQuery) || referralName.contains(lowerQuery);
        }).toList(),
      );
    }
    // Debug print to verify filtered data
    print('Filtered Leads: ${filteredReceivedLeads.map((lead) => {
          'name': '${lead.firstName} ${lead.lastName}',
          'subTitle': lead.leadAssignType != "3"
              ? '${lead.user?.firstName ?? ''} ${lead.user?.lastName ?? ''}'
              : 'N/A',
          'image': lead.user?.avatarUrl,
          'leadAssignType': lead.leadAssignType,
          'isPaid': widget.controller.isPaid.value
        }).toList()}');
  }

  Widget _buildLeadsList() {
    // Initialize filtered leads if empty and no search is active
    if (filteredReceivedLeads.isEmpty &&
        receivedLeadsSearchController.text.isEmpty) {
      filteredReceivedLeads
          .assignAll(widget.controller.receivedLead.value?.data ?? []);
    }

    return Obx(() {
      print(
          '_buildLeadsList called, receivedLead count: ${widget.controller.receivedLead.value?.data?.length ?? 0}');
      final leads = widget.controller.receivedLead.value?.data;
      final leadsCount = leads?.length ?? 0;

      if (leads == null || leads.isEmpty) {
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

      print('filteredReceivedLeads: ${filteredReceivedLeads.length}');
      return Column(
        children: [
          if (leadsCount > 5)
            Card(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              color: Colors.white,
              elevation: 0.05,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: const BorderSide(color: Color(0xFFCED4DA)),
              ),
              child: Row(
                children: [
                  const SizedBox(width: 12),
                  Icon(Icons.search, color: Colors.grey[600]),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: receivedLeadsSearchController,
                      onChanged: filterLeads,
                      decoration: InputDecoration(
                        hintText: tr(LanguageKeys.searchPlaceholderLeads),
                        hintStyle: TextStyle(color: Colors.grey[500]),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          const SizedBox(height: 20),
          Expanded(
            child: Obx(
              () => ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: filteredReceivedLeads.length,
                itemBuilder: (context, index) {
                  final lead = filteredReceivedLeads[index];
                  return _buildLeadItem(
                    onTap: () {
                      AppHelper.showLog("expandedIndex: $index");
                      // widget.controller.readRequestToUpdateLeadNotification();
                    },
                    receivedLeadData: lead,
                    index: index,
                    name:
                        '${lead.firstName ?? ''} ${lead.lastName ?? ''}'.trim(),
                    subTitle: lead.leadAssignType != "3"
                        ? '${lead.user?.firstName ?? ''} ${lead.user?.lastName ?? ''}'
                            .trim()
                        : null,
                    isPrimum:
                        widget.controller.isPaid.value == "0" && index > 1,
                  );
                },
              ),
            ),
          ),
        ],
      );
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
              value != "null")
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
              value != "null")
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
                value != "null" ? value : tr(LanguageKeys.nullDataText),
                style: stylePoppins(
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
              ),
            )
          else
            Text(
              value != "null" ? value : tr(LanguageKeys.nullDataText),
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

  void _showRequestConfirmPopup() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          insetPadding: const EdgeInsets.symmetric(horizontal: 16),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Container(
            width: MediaQuery.of(context).size.width * 0.9,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Obx(
                  () => Text(
                    tr(LanguageKeys.updatePopupTitle),
                    textAlign: TextAlign.center,
                    style: stylePoppins(
                        fontSize: 16,
                        color: AppColors.fontBlack,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Obx(
                        () => Text(
                          tr(LanguageKeys.updatePopupDescription),
                          textAlign: TextAlign.center,
                          style: stylePoppins(
                              fontSize: 15, color: AppColors.fontBlack),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Center(
                  child: SizedBox(
                    width: 120,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () {
                        widget.controller.readRequestToUpdateLeadNotification();
                        Navigator.of(context).pop();
                      },
                      child: Obx(
                        () => Text(tr(LanguageKeys.okay),
                            style: stylePoppins(color: AppColors.whiteColor)),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildLeadItem({
    required int index,
    required String name,
    required bool isPrimum,
    String? subTitle,
    required VoidCallback onTap,
    required ReceivedLeadData receivedLeadData,
  }) {
    final isExpanded = expandedIndex == index;
    final originalIndex = getOriginalReceivedLeadIndex(index) ?? index;
    final commentData = leadComments[originalIndex];
    int currentStep = itemCurrentSteps[originalIndex] ?? 0;

    Widget leadContent = Container(
      decoration: BoxDecoration(
        gradient: receivedLeadData.isNew == "true"
            ? const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFFF3E8FF),
                  Color(0xFFFFFFFF),
                ],
              )
            : null,
        color: receivedLeadData.isNew == "true" ? null : Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          receivedLeadData.isNew == "true"
              ? Container(
                  width: 5,
                  height: 5,
                  margin: const EdgeInsets.only(top: 5, right: 8, left: 8),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle, // Makes the container circular
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withOpacity(0.5),
                        spreadRadius: 2,
                        offset: const Offset(0, 3), // Shadow effect
                      ),
                    ],
                  ),
                )
              : const SizedBox.shrink(),
          Padding(
            padding:
                const EdgeInsets.only(top: 8, bottom: 8, left: 8, right: 8),
            child: Row(
              children: [
                receivedLeadData?.leadAssignType != "3"
                    ? Container(
                        height: 55.w,
                        width: 55.w,
                        decoration: BoxDecoration(
                          color: AppColors.whiteColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.network(
                            receivedLeadData.user?.avatarUrl ?? '',
                            height: 50.w,
                            width: 50.w,
                            fit: BoxFit.cover,
                          ),
                        ),
                      )
                    : Container(
                        height: 55.w,
                        width: 55.w,
                        decoration: BoxDecoration(
                          color: AppColors.whiteColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.network(
                            receivedLeadData.user?.avatarUrl ?? '',
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
                      if (receivedLeadData.isNew == "true")
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
                            const SizedBox(width: 6),
                            Text(
                              tr(LanguageKeys.newLead),
                              style: stylePoppins(
                                fontSize: 12.sp,
                                color: AppColors.primary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      children: [
                        GestureDetector(
                          behavior: HitTestBehavior.translucent,
                          onTap: !isPrimum
                              ? () {
                                  if (receivedLeadData.leadAssignType == "5") {
                                    showDialog(
                                      context: context,
                                      builder: (context) => CommonPopup(
                                        title: tr(
                                            LanguageKeys.lostLeadConfirmation),
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
                                            leadId: int.parse(
                                                receivedLeadData.id ?? '0'),
                                            lostReasons: [
                                              {
                                                "id": receivedLeadData
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
                                              borderRadius:
                                                  BorderRadius.vertical(
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
                                                                FontWeight
                                                                    .w500),
                                                      ),
                                                      IconButton(
                                                        icon: const Icon(
                                                            Icons.close,
                                                            color: Colors.grey),
                                                        onPressed: () =>
                                                            Navigator.of(
                                                                    context)
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
                                                            _addToContacts(
                                                                receivedLeadData);
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
                                                            final contactInfo =
                                                                '''
 ${receivedLeadData.firstName ?? ''} ${receivedLeadData.lastName ?? ''}
 ${receivedLeadData.phoneNumber!.trim() ?? ''}
 ${receivedLeadData.email!.trim() ?? ''}

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
                                                    padding:
                                                        const EdgeInsets.all(
                                                            20),
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
                                                            tr(LanguageKeys
                                                                .name),
                                                            "${receivedLeadData.firstName ?? ''} ${receivedLeadData.lastName ?? ''}"),
                                                        const Divider(),
                                                        _infoTile(
                                                            Icons.business,
                                                            tr(LanguageKeys
                                                                .nameOfTheBusinessReferrer),
                                                            "${receivedLeadData.user?.firstName ?? ''} ${receivedLeadData.user?.lastName ?? ''}"),
                                                        const Divider(),
                                                        _infoTile(
                                                            Icons.phone,
                                                            tr(LanguageKeys
                                                                .phoneNumber),
                                                            receivedLeadData
                                                                    .phoneNumber ??
                                                                ''),
                                                        const Divider(),
                                                        _infoTile(
                                                            Icons.email,
                                                            tr(LanguageKeys
                                                                .email),
                                                            receivedLeadData
                                                                    .email ??
                                                                ''),
                                                        const Divider(),
                                                        _infoTile(
                                                            Icons.description,
                                                            tr(LanguageKeys
                                                                .description),
                                                            receivedLeadData
                                                                    .description ??
                                                                ''),
                                                        const Divider(),
                                                        _infoTile(
                                                            Icons
                                                                .calendar_month,
                                                            tr(LanguageKeys
                                                                .dateArchive),
                                                            DateFormat('dd/MM/yyyy').format(
                                                                    DateTime.parse(
                                                                        receivedLeadData.createdAt ??
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
                                        widget.controller.mainController
                                            .getProfile();
                                      });
                                    },
                                  ));
                                },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 3, vertical: 10),
                            child: SvgPicture.asset(
                              AppAssets.imgInfoSvg,
                              height: 25,
                              color: AppColors.primary.withOpacity(
                                  isPrimum ? 0.5 : 1.0), // faded for premium
                            ),
                          ),
                        ),
                        const SizedBox(width: 5),
                        // GestureDetector(
                        //   behavior: HitTestBehavior.translucent,
                        //   onTap: !isPrimum
                        //       ? () {
                        //           setState(() {
                        //             // if (isExpanded) {
                        //             //   expandedIndex = null;
                        //             // } else {
                        //             //   expandedIndex = index;
                        //             // }
                        //           });
                        //         }
                        //       : null, // Disabled for premium
                        //   child: Padding(
                        //     padding: const EdgeInsets.symmetric(
                        //         horizontal: 2, vertical: 10),
                        //     child: Icon(
                        //       Icons.keyboard_arrow_down,
                        //       color: isPrimum ? Colors.black26 : Colors.black26,
                        //       size: 20, // faded for premium
                        //     ),
                        //   ),
                        // ),
                        // const SizedBox(width: 5),
                        receivedLeadData.notificationCount != "0"
                            ? Stack(
                                children: [
                                  const Icon(Icons.notifications, size: 30),
                                  Positioned(
                                    top: 0,
                                    right: 0,
                                    child: GestureDetector(
                                      onTap: () {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            // widget.controller.readRequestToUpdateLeadNotification();
                                            return const BusinessFollowUpDialog();
                                          },
                                        );
                                      },
                                      child: ClipPath(
                                        clipper: HalfCircleClipper(),
                                        child: Container(
                                          constraints: const BoxConstraints(
                                            minWidth: 10,
                                            minHeight: 10,
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
                                              receivedLeadData
                                                      .notificationCount ??
                                                  '0',
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 8,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            : const SizedBox.shrink(),
                      ],
                    )
                  ],
                ),
              ],
            ),
          ),
          if (!isPrimum && isExpanded)
            Obx(() => Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      buildTimeline(
                        receivedLeadData: receivedLeadData,
                        leadTrack: receivedLeadData.leadTrack,
                        currentStep: currentStep,
                        parentIndex:
                            getOriginalReceivedLeadIndex(index) ?? index,
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
                                          keyboardType: TextInputType.multiline,
                                          maxLength: 300,
                                          maxLines: 3,
                                          textInputAction: TextInputAction.done,
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
                              final originalIndex =
                                  getOriginalReceivedLeadIndex(index) ?? index;
                              leadComments[originalIndex] = {
                                'text': comment,
                                'date': DateFormat('dd/MM/yyyy hh:mm a')
                                    .format(DateTime.now()),
                              };
                            });
                          }
                        },
                      ),
                      const SizedBox(height: 16),
                      Column(
                        children: [
                          GestureDetector(
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
                                                      _addToContacts(
                                                          receivedLeadData);
                                                    },
                                                    child: Container(
                                                        height: 48,
                                                        decoration:
                                                            BoxDecoration(
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
                                                              textAlign:
                                                                  TextAlign
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
 ${receivedLeadData.firstName ?? ''} ${receivedLeadData.lastName ?? ''}
 ${receivedLeadData.phoneNumber!.trim() ?? ''}
 ${receivedLeadData.email!.trim() ?? ''}

''';
                                                      Share.share(contactInfo);
                                                    },
                                                    child: Container(
                                                        height: 48,
                                                        decoration:
                                                            BoxDecoration(
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
                                                              textAlign:
                                                                  TextAlign
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
                                                      "${receivedLeadData.firstName ?? ''} ${receivedLeadData.lastName ?? ''}"),
                                                  const Divider(),
                                                  _infoTile(
                                                      Icons.business,
                                                      tr(LanguageKeys
                                                          .nameOfTheBusinessReferrer),
                                                      "${receivedLeadData.user?.firstName ?? ''} ${receivedLeadData.user?.lastName ?? ''}"),
                                                  const Divider(),
                                                  _infoTile(
                                                      Icons.phone,
                                                      tr(LanguageKeys
                                                          .phoneNumber),
                                                      receivedLeadData
                                                              .phoneNumber ??
                                                          ''),
                                                  const Divider(),
                                                  _infoTile(
                                                      Icons.email,
                                                      tr(LanguageKeys.email),
                                                      receivedLeadData.email ??
                                                          ''),
                                                  const Divider(),
                                                  _infoTile(
                                                      Icons.description,
                                                      tr(LanguageKeys
                                                          .description),
                                                      receivedLeadData
                                                              .description ??
                                                          ''),
                                                  const Divider(),
                                                  _infoTile(
                                                      Icons.calendar_month,
                                                      tr(LanguageKeys
                                                          .dateArchive),
                                                      DateFormat('dd/MM/yyyy')
                                                              .format(DateTime.parse(
                                                                  receivedLeadData
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
                                color: AppColors.whiteColor.withOpacity(0.05),
                                borderRadius: BorderRadius.circular(5),
                                border: Border.all(color: AppColors.primary),
                              ),
                              child: Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const Icon(
                                      Icons.remove_red_eye,
                                      color: AppColors.primary,
                                      size: 16,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      tr(LanguageKeys.seeDescription),
                                      style: stylePoppins(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.primary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          GestureDetector(
                            onTap: () {
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
                                      leadId:
                                          int.parse(receivedLeadData.id ?? '0'),
                                      lostReasons: [
                                        {
                                          "id": receivedLeadData.leadAssignType,
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
                                color: Colors.red.withOpacity(0.05),
                                borderRadius: BorderRadius.circular(5),
                                border: Border.all(color: Colors.red),
                              ),
                              child: Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: 10,
                                      height: 10,
                                      decoration: BoxDecoration(
                                        color: Colors.red,
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: Colors.red,
                                          width: 1,
                                        ),
                                      ),
                                      child: const Icon(
                                        Icons.close,
                                        color: Colors.white,
                                        size: 8,
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      tr(LanguageKeys.lostLead),
                                      style: stylePoppins(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.red,
                                      ),
                                    ),
                                  ],
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
          print("receivedLeadData.isNew: ${receivedLeadData.isNew}");
          // Call lead-opened API if the lead is new
          if (receivedLeadData.isNew == "true") {
            widget.controller.leadOpened(int.parse(receivedLeadData.id ?? '0'));
          }

          // Get.to(() => LeadTrackingScreen(),
          //     arguments: widget.controller.sendLead.value?.data?[index]);
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
          color:
              receivedLeadData.isNew == "true" ? Colors.purple : Colors.white,
          borderRadius: BorderRadius.circular(12.0),
          border: receivedLeadData.isNew == "true"
              ? const Border(
                  left: BorderSide(
                    color: AppColors.primary,
                    width: 4.0,
                  ),
                )
              : null,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 2,
              offset: const Offset(0, 1), // Shadow effect
            ),
          ],
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
                        AppAssets.imgHDashboardCrown,
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

  Widget _buildSendLeadItem({
    required int index,
    required String name,
    String? subTitle,
    required VoidCallback onTap,
    required SendLeadData sendData,
  }) {
    final isExpanded = expandedIndex == index;
    final originalIndex = getOriginalSentLeadIndex(index) ?? index;
    final commentData = leadComments[originalIndex];
    int currentStep = itemCurrentSteps[originalIndex] ?? 0;

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
                sendData.leadAssignType != "3"
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
                            sendData.user?.avatarUrl ?? '',
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
                            sendData.user?.avatarUrl ?? '',
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
                  onTap: () {
                    Get.toNamed(LeadSubmissionScreen.pageId, arguments: {
                      'lead_assign_type': sendData?.leadAssignType,
                      'first': sendData?.firstName,
                      'last': sendData?.lastName,
                      'email': sendData?.email,
                      'phone': sendData?.phoneNumber,
                      'id': sendData?.id,
                      'deal_id': sendData?.dealId,
                      'deal_name': sendData?.deal?.dealName,
                      'description': sendData?.description,
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
                  behavior: HitTestBehavior.translucent,
                  onTap: () {
                    setState(() {
                      if (isExpanded) {
                        expandedIndex = null;
                      } else {
                        expandedIndex = index;
                      }
                    });
                  }, // Disabled for premium
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 2, vertical: 10),
                    child: Icon(
                      Icons.keyboard_arrow_down,
                      color: Colors.black, // faded for premium
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (isExpanded)
            Obx(() => Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      buildSendTimeline(
                        sendLeadData: sendData,
                        leadTrack: sendData.leadTrack,
                        currentStep: currentStep,
                        parentIndex: getOriginalSentLeadIndex(index) ?? index,
                        commentData: commentData,
                      ),
                      const SizedBox(height: 16),
                      Column(
                        children: [
                          GestureDetector(
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
                                                      _addToSendContacts(
                                                          sendData);
                                                    },
                                                    child: Container(
                                                        height: 48,
                                                        decoration:
                                                            BoxDecoration(
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
                                                              textAlign:
                                                                  TextAlign
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
 ${sendData.firstName ?? ''} ${sendData.lastName ?? ''}
                           ${sendData.phoneNumber!.trim() ?? ''}
                           ${sendData.email!.trim() ?? ''}
                          
                          ''';
                                                      Share.share(contactInfo);
                                                    },
                                                    child: Container(
                                                        height: 48,
                                                        decoration:
                                                            BoxDecoration(
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
                                                              textAlign:
                                                                  TextAlign
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
                                                      "${sendData.firstName ?? ''} ${sendData.lastName ?? ''}"),
                                                  const Divider(),
                                                  _infoTile(
                                                      Icons.business,
                                                      tr(LanguageKeys
                                                          .nameOfTheBusinessReferrer),
                                                      "${sendData.user?.firstName ?? ''} ${sendData.user?.lastName ?? ''}"),
                                                  const Divider(),
                                                  _infoTile(
                                                      Icons.phone,
                                                      tr(LanguageKeys
                                                          .phoneNumber),
                                                      sendData.phoneNumber ??
                                                          ''),
                                                  const Divider(),
                                                  _infoTile(
                                                      Icons.email,
                                                      tr(LanguageKeys.email),
                                                      sendData.email ?? ''),
                                                  const Divider(),
                                                  _infoTile(
                                                      Icons.description,
                                                      tr(LanguageKeys
                                                          .description),
                                                      sendData.description ??
                                                          ''),
                                                  const Divider(),
                                                  _infoTile(
                                                      Icons.calendar_month,
                                                      tr(LanguageKeys
                                                          .dateArchive),
                                                      DateFormat('dd/MM/yyyy')
                                                              .format(DateTime
                                                                  .parse(sendData
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
                                color: AppColors.whiteColor.withOpacity(0.05),
                                borderRadius: BorderRadius.circular(5),
                                border: Border.all(color: AppColors.primary),
                              ),
                              child: Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const Icon(
                                      Icons.remove_red_eye,
                                      color: AppColors.primary,
                                      size: 16,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      tr(LanguageKeys.seeDescription),
                                      style: stylePoppins(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.primary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
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

    return data;
  }

  Widget _buildSentLeadsList() {
    return Obx(() {
      print(
          '_buildSentLeadsList called, sendLead count: ${widget.controller.sendLead.value?.data?.length ?? 0}');
      final leads = widget.controller.sendLead.value?.data;
      final leadsCount = leads?.length ?? 0;
      if (leads == null || leads.isEmpty) {
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

      // Initialize filtered leads if empty and no search is active
      if (filteredSentLeads.isEmpty && sentLeadsSearchController.text.isEmpty) {
        filteredSentLeads.assignAll(leads);
      }

      void filterLeads(String query) {
        print('Filtering sent leads with query: $query');
        if (query.isEmpty) {
          filteredSentLeads.assignAll(leads);
        } else {
          filteredSentLeads.assignAll(leads.where((lead) {
            final leadName = '${lead.firstName ?? ''} ${lead.lastName ?? ''}'
                .toLowerCase()
                .trim();
            final referrerName = lead.leadAssignType != "3"
                ? '${lead.user?.firstName ?? ''} ${lead.user?.lastName ?? ''}'
                    .toLowerCase()
                    .trim()
                : '';
            // Normalize for comparison (remove accents, lowercase, trim)
            final normalizedLeadName =
                removeDiacritics(leadName.toLowerCase().trim());
            final normalizedReferralName =
                removeDiacritics(referrerName.toLowerCase().trim());
            final normalizedQuery =
                removeDiacritics(query.toLowerCase().trim());

            // Match search query against normalized names
            return normalizedLeadName.contains(normalizedQuery) ||
                normalizedReferralName.contains(normalizedQuery);
            // return leadName.contains(query.toLowerCase()) ||
            //     referrerName.contains(query.toLowerCase());
          }).toList());
        }
        // Debug print to verify filtered data
        print('Filtered Sent Leads: ${filteredSentLeads.map((lead) => {
              'name': '${lead.firstName} ${lead.lastName}',
              'subTitle': lead.leadAssignType != "3"
                  ? '${lead.user?.firstName ?? ''} ${lead.user?.lastName ?? ''}'
                  : 'N/A',
              'companyName': lead.companyName,
              'leadAssignType': lead.leadAssignType,
            }).toList()}');
      }

      print('filteredSentLeads: ${filteredSentLeads.length}');
      return Column(
        children: [
          if (leadsCount > 10)
            Card(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              color: Colors.white,
              elevation: 0.05,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: const BorderSide(color: Color(0xFFCED4DA)),
              ),
              child: Row(
                children: [
                  const SizedBox(width: 12),
                  Icon(Icons.search, color: Colors.grey[600]),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: sentLeadsSearchController,
                      onChanged: filterLeads,
                      decoration: InputDecoration(
                        hintText: tr(LanguageKeys.searchPlaceholderLeads),
                        hintStyle: TextStyle(color: Colors.grey[500]),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          const SizedBox(height: 10),
          Expanded(
            child: Obx(
              () => ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: filteredSentLeads.length,
                  itemBuilder: (context, index) {
                    return _buildSendLeadItem(
                      sendData: filteredSentLeads[index],
                      onTap: () {
                        AppHelper.showLog("expandedIndex: $expandedIndex");
                      },
                      index: index,
                      name:
                          '${filteredSentLeads[index].firstName ?? ''} ${filteredSentLeads[index].lastName ?? ''}'
                              .trim(),
                      subTitle: filteredSentLeads[index].leadAssignType != "3"
                          ? ('${filteredSentLeads[index].companyName}' ?? '')
                          : null,
                    );
                  }),
            ),
          ),
        ],
      );
    });
  }

// Utility function to estimate text height
  double estimateTextHeight(String text, double maxWidth, TextStyle style) {
    final avgCharPerLine = (maxWidth / (style.fontSize ?? 14)) * 1.8;
    final lines = (text.length / avgCharPerLine).ceil();
    return text.isEmpty ? 52 : lines * (style.fontSize ?? 14) * 1.4;
  }

  // Get stage status icon
  IconData getStageStatusIcon(String? status) {
    switch (status) {
      case 'completed':
        return Icons.check;
      case 'current':
        return Icons.circle;
      case 'upcoming':
        return Icons.circle;
      default:
        return Icons.circle;
    }
  }

  // Get stage status color
  Color getStageStatusColor(String? status) {
    switch (status) {
      case 'completed':
        return AppColors.primary;
      case 'current':
        return AppColors.grey300;
      case 'upcoming':
        return AppColors.grey300;
      default:
        return AppColors.grey300;
    }
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
        final isActive = index == completedTrack;
        final bool isCompleted = index < completedTrack;

        final bool isLastStep = index == (leadTrack?.length ?? 0) - 1;
        final step = leadTrack?[index];
        String? displayComment = "";
        String stepDate = '';

        AppHelper.showLog("isActive: $isActive");
        AppHelper.showLog("isCompleted: $isCompleted");
        AppHelper.showLog("isLastStep: $isLastStep");
        AppHelper.showLog("step: ${step?.name}");
        AppHelper.showLog("stepDate: $stepDate");
        AppHelper.showLog("leadComments: $leadComments");
        AppHelper.showLog("parentIndex: $parentIndex");
        // Determine the actual comment to display
        final localComment = leadComments['${parentIndex * 1000 + index}'];
        if (step?.comment?.isNotEmpty == true) {
          displayComment = step?.comment;
        } else if (localComment?['text']?.isNotEmpty == true) {
          displayComment = localComment?['text'];
        }
        AppHelper.showLog("displayComment: $displayComment");
        AppHelper.showLog("localComment: $localComment?['text']");

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
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    color: getStageStatusColor(isCompleted
                        ? "completed"
                        : isActive
                            ? "current"
                            : "upcoming"),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    getStageStatusIcon(isCompleted
                        ? "completed"
                        : isActive
                            ? "current"
                            : "upcoming"),
                    color: Colors.white,
                    size: 15,
                  ),
                ),
                const SizedBox(height: 5),
                if (!isLastStep)
                  Container(
                    width: 2,
                    height: 60,
                    color: isCompleted
                        ? AppColors.primary
                        : isActive
                            ? AppColors.grey300
                            : AppColors.grey300,
                  ),
                const SizedBox(height: 20),
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
                      // Allow adding a comment when step is active or completed and no comment exists yet
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
                                TextEditingController(text: '');
                            final String? updatedComment =
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
                                            maxLength: 300,
                                            maxLines: 2,
                                            textInputAction:
                                                TextInputAction.done,
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
                                                    color: Colors.white),
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

                            if (updatedComment != null &&
                                updatedComment.isNotEmpty) {
                              await widget.controller.editLeadComment(
                                id: int.parse(
                                  widget
                                          .controller
                                          .receivedLead
                                          .value
                                          ?.data?[parentIndex]
                                          .leadTrack?[index]
                                          .id
                                          .toString() ??
                                      '0',
                                ),
                                comment: updatedComment,
                                leadId: int.parse(
                                  widget
                                          .controller
                                          .receivedLead
                                          .value
                                          ?.data?[parentIndex]
                                          .leadTrack?[index]
                                          .leadId
                                          .toString() ??
                                      '0',
                                ),
                              );

                              setState(() {
                                final currentComment = widget
                                        .controller
                                        .receivedLead
                                        .value
                                        ?.data?[parentIndex]
                                        .leadTrack?[index]
                                        .comment ??
                                    '';
                                widget
                                        .controller
                                        .receivedLead
                                        .value
                                        ?.data?[parentIndex]
                                        .leadTrack?[index]
                                        .comment =
                                    currentComment.isEmpty
                                        ? updatedComment
                                        : "$currentComment $updatedComment";

                                filterLeads(receivedLeadsSearchController.text);

                                leadComments[parentIndex * 1000 + index] = {
                                  'text': updatedComment,
                                  'date': DateFormat('dd/MM/yyyy hh:mm a')
                                      .format(DateTime.now()),
                                };
                              });
                            }
                          },
                          child: SvgPicture.asset(
                            AppAssets.imgAddComment,
                            color: AppColors.primary,
                            width: 30,
                            height: 30,
                          ),
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
                          // Completion date for completed steps
                          if (isCompleted && stepDate.isNotEmpty)
                            Text(
                              '${tr(LanguageKeys.completed)} • $stepDate',
                              style: stylePoppins(
                                fontSize: 12,
                                color: AppColors.grey600,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          const SizedBox(height: 10),

                          if (step?.comment != null ||
                              leadComments[parentIndex * 1000 + index] != null)
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(12),
                              alignment: Alignment.topLeft,
                              decoration: BoxDecoration(
                                color: AppColors.primaryLightPink,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                    color: AppColors.primary.withOpacity(0.2)),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          step?.comment ??
                                              leadComments[parentIndex * 1000 +
                                                  index]?['text'] ??
                                              '',
                                          style: const TextStyle(
                                              fontSize: 12,
                                              color: AppColors.primary),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      GestureDetector(
                                        onTap: () async {
                                          final currentComment =
                                              step?.comment ?? "";
                                          TextEditingController controller =
                                              TextEditingController(text: "");

                                          final updatedComment =
                                              await showModalBottomSheet<
                                                  String>(
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
                                                  padding:
                                                      const EdgeInsets.all(20),
                                                  decoration:
                                                      const BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.vertical(
                                                            top:
                                                                Radius.circular(
                                                                    30)),
                                                  ),
                                                  child: SingleChildScrollView(
                                                    child: Column(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        TextField(
                                                          controller:
                                                              controller,
                                                          maxLength: 300,
                                                          maxLines: 2,
                                                          textInputAction:
                                                              TextInputAction
                                                                  .done,
                                                          decoration:
                                                              InputDecoration(
                                                            hintText: tr(
                                                                LanguageKeys
                                                                    .enterComment),
                                                            filled: true,
                                                            fillColor: Colors
                                                                .grey[100],
                                                            contentPadding:
                                                                const EdgeInsets
                                                                    .symmetric(
                                                                    horizontal:
                                                                        12,
                                                                    vertical:
                                                                        8),
                                                            border: OutlineInputBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            10),
                                                                borderSide:
                                                                    BorderSide
                                                                        .none),
                                                            enabledBorder: OutlineInputBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            10),
                                                                borderSide:
                                                                    BorderSide
                                                                        .none),
                                                            focusedBorder: OutlineInputBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            10),
                                                                borderSide:
                                                                    BorderSide
                                                                        .none),
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                            height: 16),
                                                        SizedBox(
                                                          width:
                                                              double.infinity,
                                                          child: ElevatedButton(
                                                            style:
                                                                ElevatedButton
                                                                    .styleFrom(
                                                              backgroundColor:
                                                                  AppColors
                                                                      .primary,
                                                              shape:
                                                                  RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            10),
                                                              ),
                                                            ),
                                                            onPressed: () {
                                                              if (controller
                                                                  .text
                                                                  .trim()
                                                                  .isNotEmpty) {
                                                                Navigator.of(
                                                                        context)
                                                                    .pop(controller
                                                                        .text
                                                                        .trim());
                                                              }
                                                            },
                                                            child: Text(
                                                              tr(LanguageKeys
                                                                  .submit),
                                                              style: stylePoppins(
                                                                  color: Colors
                                                                      .white),
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
                                            await widget.controller
                                                .editLeadComment(
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
                                              final currentComment = widget
                                                      .controller
                                                      .receivedLead
                                                      .value
                                                      ?.data?[parentIndex]
                                                      .leadTrack?[index]
                                                      .comment ??
                                                  '';
                                              widget
                                                      .controller
                                                      .receivedLead
                                                      .value
                                                      ?.data?[parentIndex]
                                                      .leadTrack?[index]
                                                      .comment =
                                                  currentComment +
                                                      " " +
                                                      updatedComment;

                                              filterLeads(
                                                  receivedLeadsSearchController
                                                      .text);

                                              // Also update the local leadComments map
                                              leadComments[parentIndex * 1000 +
                                                  index] = {
                                                'text': updatedComment,
                                                'date': DateFormat(
                                                        'dd/MM/yyyy hh:mm a')
                                                    .format(DateTime.now()),
                                              };
                                            });

                                            // Refresh the controller data
                                            widget.controller.receivedLead
                                                .refresh();
                                            widget.controller.getLeads();
                                            widget.controller.update();
                                          }
                                        },
                                        child: const Icon(Icons.edit,
                                            size: 14, color: Colors.deepPurple),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    '${tr(LanguageKeys.commentTo)} ${widget.controller.receivedLead.value?.data?[parentIndex].deal?.createdDetail?.companyName}',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: AppColors.grey600,
                                      decoration: TextDecoration.none,
                                      fontWeight: FontWeight.w500,
                                      fontFamily: 'Inter',
                                    ),
                                  )
                                ],
                              ),
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
                        const SizedBox(height: 5),
                        Text(
                          tr(LanguageKeys.payTheCommission),
                          style: stylePoppins(
                            fontSize: 11,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 5),
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () async {
                                TextEditingController controllerCommission =
                                    TextEditingController();
                                FocusNode commissionFocusNode =
                                    FocusNode(); // Add FocusNode for first bottom sheet

                                String? commission =
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
                                                controller:
                                                    controllerCommission,
                                                focusNode: commissionFocusNode,
                                                keyboardType:
                                                    const TextInputType
                                                        .numberWithOptions(
                                                        decimal: true),
                                                textInputAction:
                                                    TextInputAction.done,
                                                inputFormatters: [
                                                  DecimalTextInputFormatter(
                                                      decimalRange: 2),
                                                ],
                                                decoration: InputDecoration(
                                                  suffixText: '€',
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
                                                onTap: () {
                                                  commissionFocusNode
                                                      .requestFocus(); // Ensure focus on single tap
                                                },
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
                                                    if (controllerCommission
                                                        .text
                                                        .trim()
                                                        .isNotEmpty) {
                                                      Navigator.of(context).pop(
                                                          controllerCommission
                                                              .text
                                                              .trim());
                                                    }
                                                  },
                                                  child: Text(
                                                    tr(LanguageKeys.submit),
                                                    style: stylePoppins(
                                                        color: Colors.white),
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

                                // Dispose of commission controller and focus node after first bottom sheet
                                commissionFocusNode.dispose();
                                controllerCommission.dispose();

                                if (commission != null &&
                                    commission.isNotEmpty) {
                                  TextEditingController controllerRevenue =
                                      TextEditingController();
                                  FocusNode revenueFocusNode = FocusNode();

                                  String? revenue =
                                      await showModalBottomSheet<String>(
                                    context: context,
                                    isScrollControlled: true,
                                    backgroundColor: Colors.transparent,
                                    builder: (context) {
                                      return StatefulBuilder(
                                        builder: (BuildContext context,
                                            StateSetter setState) {
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
                                                        top: Radius.circular(
                                                            30)),
                                              ),
                                              child: SingleChildScrollView(
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    TextField(
                                                      controller:
                                                          controllerRevenue,
                                                      focusNode:
                                                          revenueFocusNode,
                                                      maxLines: 2,
                                                      keyboardType:
                                                          const TextInputType
                                                              .numberWithOptions(
                                                              decimal: true),
                                                      textInputAction:
                                                          TextInputAction.done,
                                                      inputFormatters: [
                                                        DecimalTextInputFormatter(
                                                            decimalRange: 2),
                                                      ],
                                                      decoration:
                                                          InputDecoration(
                                                        suffixText: '€',
                                                        hintText: tr(LanguageKeys
                                                            .enterRevenueText),
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
                                                                  .circular(10),
                                                          borderSide:
                                                              BorderSide.none,
                                                        ),
                                                        enabledBorder:
                                                            OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                          borderSide:
                                                              BorderSide.none,
                                                        ),
                                                        focusedBorder:
                                                            OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                          borderSide:
                                                              BorderSide.none,
                                                        ),
                                                      ),
                                                      onTap: () {
                                                        revenueFocusNode
                                                            .requestFocus(); // Ensure focus on single tap
                                                      },
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
                                                                    .circular(
                                                                        10),
                                                          ),
                                                        ),
                                                        onPressed: () {
                                                          if (controllerRevenue
                                                              .text
                                                              .trim()
                                                              .isNotEmpty) {
                                                            Navigator.of(
                                                                    context)
                                                                .pop(controllerRevenue
                                                                    .text
                                                                    .trim());
                                                          }
                                                        },
                                                        child: Text(
                                                          tr(LanguageKeys
                                                              .submit),
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
                                    },
                                  );

                                  // Dispose of revenue controller and focus node after second bottom sheet
                                  revenueFocusNode.dispose();
                                  controllerRevenue.dispose();

                                  // Call addCommisionAmount with stored values
                                  if (revenue != null && revenue.isNotEmpty) {
                                    AppHelper.showLog(
                                        "Submitting: commission=$commission, revenue=$revenue");
                                    widget.controller.addCommisionAmount(
                                      id: int.parse(step?.id ?? '0'),
                                      amount:
                                          commission, // Use stored value instead of controller
                                      leadId: int.parse(step?.leadId ?? '0'),
                                      revenue:
                                          revenue, // Use stored value instead of controller
                                    );
                                  }
                                }
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 3),
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
                                  horizontal: 15, vertical: 3),
                              decoration: BoxDecoration(
                                color: AppColors.primary.withOpacity(0.5),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Column(
                                children: [
                                  Text(
                                    tr(LanguageKeys.viaReferaly),
                                    style: stylePoppins(
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w500,
                                      color: AppColors.whiteColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
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
                          return Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(12),
                            alignment: Alignment.topLeft,
                            decoration: BoxDecoration(
                              color: AppColors.primaryLightPink,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                  color: AppColors.primary.withOpacity(0.2)),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(top: 1),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: Text(
                                      displayComment ?? '',
                                      style: stylePoppins(
                                          fontSize: 8, color: Colors.black87),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),

                  /// NEXT button
                  if (isActive)
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 6),
                            child: AnimatedButton(
                              height: 35,
                              width: double.infinity,
                              text: tr(LanguageKeys.nextStep),
                              isReverse: true,
                              selectedTextColor: Colors.white,
                              selectedBackgroundColor:
                                  AppColors.whiteColor.withOpacity(0.2),
                              transitionType: TransitionType.LEFT_TO_RIGHT,
                              textStyle: stylePoppins(
                                fontSize: 11,
                                color: AppColors.whiteColor,
                                fontWeight: FontWeight.w500,
                              ),
                              backgroundColor: AppColors.primary,
                              borderColor: Colors.transparent,
                              borderRadius: 6,
                              borderWidth: 0,
                              onPress: () async {
                                // Get the locally stored comment
                                final localComment =
                                    leadComments[parentIndex * 1000 + index];
                                final commentText = localComment?['text'] ?? '';

                                // Call the API to send the comment
                                await widget.controller
                                    .sendLeadComment(
                                  id: int.parse(widget
                                          .controller
                                          .receivedLead
                                          .value
                                          ?.data?[parentIndex]
                                          .leadTrack?[index]
                                          .id
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
                                  leadLength: widget
                                          .controller
                                          .receivedLead
                                          .value
                                          ?.data?[parentIndex]
                                          .leadTrack
                                          ?.length ??
                                      0,
                                  parentIndex: parentIndex,
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
                                    leadComments
                                        .remove(parentIndex * 1000 + index);
                                  });

                                  widget.controller.receivedLead.refresh();
                                  widget.controller.getLeads();
                                  widget.controller.update();
                                });
                              },
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 6),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
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
                                                  maxLength: 300,
                                                  maxLines: 2,
                                                  textInputAction:
                                                      TextInputAction.done,
                                                  // magnifierConfiguration: MagnifierConfiguration(
                                                  //   magnifierColor: Colors.red,
                                                  //   magnifierSize: 100,
                                                  //   magnifierPosition: MagnifierPosition.topRight,
                                                  // ),
                                                  decoration: InputDecoration(
                                                    hintText: tr(LanguageKeys
                                                        .enterComment),
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
                                                      borderSide:
                                                          BorderSide.none,
                                                    ),
                                                    enabledBorder:
                                                        OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      borderSide:
                                                          BorderSide.none,
                                                    ),
                                                    focusedBorder:
                                                        OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      borderSide:
                                                          BorderSide.none,
                                                    ),
                                                  ),
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
                                                            .pop(controller.text
                                                                .trim());
                                                        // Store comment locally without API call
                                                        setState(() {
                                                          leadComments[
                                                              parentIndex *
                                                                      1000 +
                                                                  index] = {
                                                            'text': controller
                                                                .text
                                                                .trim(),
                                                            'date': DateFormat(
                                                                    'dd/MM/yyyy hh:mm a')
                                                                .format(DateTime
                                                                    .now()),
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
                                borderRadius: BorderRadius.circular(6),
                                splashColor: AppColors.primary.withOpacity(0.2),
                                highlightColor:
                                    AppColors.primary.withOpacity(0.1),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 4, vertical: 6),
                                  decoration: BoxDecoration(
                                    border:
                                        Border.all(color: AppColors.primary),
                                    borderRadius: BorderRadius.circular(6),
                                    color: Colors.transparent,
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SvgPicture.asset(AppAssets.imgChat,
                                          width: 16,
                                          height: 16,
                                          color: AppColors.primary),
                                      const SizedBox(width: 4),
                                      Text(tr(LanguageKeys.comment),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 2,
                                          style: stylePoppins(
                                              fontSize: 11,
                                              color: AppColors.primary,
                                              fontWeight: FontWeight.w500)),
                                    ],
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
            ),
          ],
        );
      }),
    );
  }

  Widget buildSendTimeline({
    List<LeadTrack>? leadTrack,
    required int currentStep,
    required int parentIndex,
    Map<String, dynamic>? commentData,
    SendLeadData? sendLeadData,
  }) {
    int completedTrack = int.tryParse(sendLeadData?.completedTrack ?? '0') ?? 0;

    return Column(
      children: List.generate(leadTrack?.length ?? 0, (index) {
        final bool isCompleted = index < completedTrack;
        final isActive = index == completedTrack - 1;
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

        final dynamicHeight = estimateTextHeight(displayComment ?? "", 220,
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
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    color: getStageStatusColor(isCompleted
                        ? "completed"
                        : isActive
                            ? "current"
                            : "upcoming"),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    getStageStatusIcon(isCompleted
                        ? "completed"
                        : isActive
                            ? "current"
                            : "upcoming"),
                    color: Colors.white,
                    size: 15,
                  ),
                ),
                const SizedBox(height: 5),
                if (!isLastStep)
                  Container(
                    width: 2,
                    height: 60,
                    color: isCompleted
                        ? AppColors.primary
                        : isActive
                            ? AppColors.primary.withOpacity(0.5)
                            : AppColors.grey300,
                  ),
                const SizedBox(height: 20),
              ],
            ),
            const SizedBox(width: 12),
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
                          // Completion date for completed steps
                          if (isCompleted && stepDate.isNotEmpty)
                            Text(
                              '${tr(LanguageKeys.completed)} • $stepDate',
                              style: stylePoppins(
                                fontSize: 12,
                                color: AppColors.grey600,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          const SizedBox(height: 10),
                          if ((step?.comment != null &&
                                  step?.comment != "null") ||
                              (leadComments[parentIndex * 1000 + index] !=
                                      null &&
                                  leadComments[parentIndex * 1000 + index]![
                                          'text'] !=
                                      null &&
                                  leadComments[parentIndex * 1000 + index]![
                                          'text'] !=
                                      "null" &&
                                  leadComments[parentIndex * 1000 + index]![
                                          'text']
                                      .trim()
                                      .isNotEmpty))
                            Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.all(12),
                                    alignment: Alignment.topLeft,
                                    decoration: BoxDecoration(
                                      color: AppColors.primaryLightPink,
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                          color: AppColors.primary
                                              .withOpacity(0.2)),
                                    ),
                                    child: Text(
                                      step?.comment ??
                                          leadComments[parentIndex * 1000 +
                                              index]?['text'] ??
                                          '',
                                      style: const TextStyle(
                                          fontSize: 12,
                                          color: AppColors.primary),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                        ],
                      ),
                    ),

                  /// NEXT button
                  if (sendLeadData?.lastReqToUpdateAt == "true" &&
                      (isActive || (completedTrack == 0 && index == 0)))
                    Padding(
                      padding: const EdgeInsets.only(top: 16, bottom: 16),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                            onTap: () async {
                              if (Get.context != null) {
                                await showDialog(
                                  context: Get.context!,
                                  builder: (context) => SuccessPopup(
                                    message:
                                        tr(LanguageKeys.requestUpdateMessage),
                                    onOk: () {
                                      widget.controller.requestToUpdateLead(
                                          leadId: int.parse(
                                              sendLeadData?.id ?? '0'));
                                    },
                                  ),
                                  barrierDismissible: false,
                                );
                              }
                            },
                            borderRadius: BorderRadius.circular(3),
                            splashColor: AppColors.primary.withOpacity(0.2),
                            highlightColor: AppColors.primary.withOpacity(0.1),
                            child: Container(
                              width: Get.width / 2,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 6),
                              decoration: BoxDecoration(
                                border: Border.all(color: AppColors.primary),
                                borderRadius: BorderRadius.circular(6),
                                color: AppColors.primary,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(tr(LanguageKeys.requestUpdate),
                                      style: stylePoppins(
                                          fontSize: 12,
                                          color: AppColors.whiteColor,
                                          fontWeight: FontWeight.w500)),
                                  const SizedBox(width: 4),
                                  Icon(Icons.notifications,
                                      size: 16, color: AppColors.whiteColor),
                                ],
                              ),
                            )),
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

// Helper widget for info row
Widget _infoTile(IconData icon, String label, String value) {
  AppHelper.showLog("value: $value");
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
                (value != "null"))
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
                  value != "null" ? value : tr(LanguageKeys.nullDataText),
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
                value != "null")
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
                  value != "null" ? value : tr(LanguageKeys.nullDataText),
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
                value != "null" ? value : tr(LanguageKeys.nullDataText),
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

class BusinessFollowUpDialog extends StatelessWidget {
  const BusinessFollowUpDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      insetPadding: const EdgeInsets.all(10),
      backgroundColor: AppColors.whiteColor,
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisSize: MainAxisSize.min, // Ensures the dialog is compact
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with icon, title, and subtitle
            Container(
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.all(16.0),
              decoration: const BoxDecoration(
                color: AppColors.primary, // Purple color from the image
                borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 12),
                  SvgPicture.asset(AppAssets.image1),
                  const SizedBox(height: 12),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        tr(LanguageKeys.title1),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        tr(LanguageKeys.title2),
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      )
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Column(
                children: [
                  // Contact info section
                  Column(
                    children: [
                      SvgPicture.asset(AppAssets.image2),
                      const SizedBox(height: 8),
                      Text(
                        tr(LanguageKeys.title3),
                        style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Highlighted note
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                    decoration: BoxDecoration(
                        color: AppColors.lightorange,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AppColors.orange)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset(AppAssets.image5),
                            const SizedBox(width: 8),
                            Text(
                              tr(LanguageKeys.title4),
                              style: const TextStyle(
                                  fontSize: 14, color: AppColors.Darkorange),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          tr(LanguageKeys.title5),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 12, color: Colors.orange[800]),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Bulleted list
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildListItem(AppAssets.image3, tr(LanguageKeys.title6)),
                      _buildListItem(AppAssets.image4, tr(LanguageKeys.title7)),
                    ],
                  ),
                  const SizedBox(height: 24),
                  // Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        // Add your action here (e.g., navigate or update state)
                        Navigator.of(context).pop();
                        // Close the dialog
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: Text(
                        tr(LanguageKeys.title8),
                        style:
                            const TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildListItem(String icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SvgPicture.asset(icon),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(fontSize: 14, color: Colors.grey[700]),
            ),
          ),
        ],
      ),
    );
  }
}
