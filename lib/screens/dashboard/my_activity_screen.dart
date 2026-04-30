// ignore_for_file: prefer_interpolation_to_compose_strings, unused_local_variable

import 'dart:io';
import 'dart:ui';

import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:referaly/controller/my_activity_controller.dart';
import 'package:referaly/languages/languagekeys.dart';
import 'package:referaly/models/model_contact_response.dart';
import 'package:referaly/models/model_network_response.dart';
import 'package:referaly/resources/app_assets.dart';
import 'package:referaly/resources/app_colors.dart';
import 'package:referaly/resources/app_helper.dart';
import 'package:referaly/resources/app_preference.dart';
import 'package:referaly/resources/text_style.dart';
import 'package:referaly/screens/busniess_referrers_list.dart';
import 'package:referaly/screens/dashboard/add_agency_coworker_dialog.dart';
import 'package:referaly/screens/dashboard/add_business_referrer_screen.dart';
import 'package:referaly/screens/dashboard/membership_screen.dart';
import 'package:referaly/screens/dashboard/track_leads_screen.dart';
import 'package:referaly/screens/deals/business_referrer_contract_screen.dart';
import 'package:referaly/screens/document_screen.dart';
import 'package:referaly/screens/send_notification_screen.dart';
import 'package:referaly/screens/statistics/detailed_statistics_screen.dart';
import 'package:referaly/utils/translations.dart';
import 'package:referaly/widgets/dialog/activity_info_dialog.dart';
import 'package:referaly/widgets/dialog/delete_business_referrer_dialog.dart';
import 'package:referaly/widgets/dialog/premium_upgrade_dialog.dart';
import 'package:referaly/widgets/dialog/share_form_bottom_sheet.dart';
import 'package:referaly/widgets/my_network_tab.dart';
import 'package:referaly/widgets/salesforce_partnership_card.dart';
import 'package:referaly/widgets/share_popup.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../get/screens.dart';
import '../../resources/app_log.dart';

class MyActivityScreen extends StatefulWidget {
  static String pageId = "/myActivity";
  final int initialPage;

  const MyActivityScreen({super.key, this.initialPage = 0});

  @override
  State<MyActivityScreen> createState() => _MyWidgetState();
}

enum MyActivitySelectedAction { save, statistics }

class _MyWidgetState extends State<MyActivityScreen> {
  late MyActivityController controller;
  int? expandedIndex;

  /// Expanded row index for the new partnership cards list (multi-contract layout).
  int? expandedPartnershipDealIndex;
  int? expandedReferrerIndex;
  int? expandedDealCasesIndex;

  @override
  void initState() {
    super.initState();
    final args = Get.arguments as Map<String, dynamic>?;
    final initialPage = args?['initialPage'] ?? widget.initialPage;
    controller = Get.put(MyActivityController(initialPage: initialPage));
    // Set initial page
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.pageController.jumpToPage(initialPage);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        title: Text(
          tr(LanguageKeys.myDealinner),
          style: stylePoppins(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),
            buildSegmentControl(),
            const SizedBox(height: 20),
            Expanded(
              child: PageView(
                controller: controller.pageController,
                onPageChanged: (index) {
                  final isContracts = index == 0;
                  if (controller.isMyContractsSelected.value != isContracts) {
                    controller.toggleTabSelection(isContracts);
                  }
                },
                children: [
                  // Page 0 - My Deals (New Design)
                  buildNewDealsListView(),

                  // Page 1 - My Network (Figma redesign; legacy block kept below)
                  SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        MyNetworkTabContent(
                          controller: controller,
                          expandedReferrerIndex: expandedReferrerIndex,
                          onReferrerExpandChanged: (i) => setState(() => expandedReferrerIndex = i),
                          onFilterOrSortChanged: () => setState(() => expandedReferrerIndex = null),
                          buildReferrerRow: (index, ref, expanded, onTap, embedInDottedParent) =>
                              ReferrerListItem(
                            name: '${ref.firstName ?? ''} ${ref.lastName ?? ''}'.trim(),
                            data1Referrer: ref,
                            isExpanded: expanded,
                            onHeaderTap: onTap,
                            embedInDottedParent: embedInDottedParent,
                          ),
                        ),
                        buildVersionInfo(),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                  /*
                  // Legacy My Network layout
                  SingleChildScrollView(
                    child: Column(
                      children: [
                        buildPurpleCard(),
                        const SizedBox(height: 20),
                        buildActionButtonsRow(),
                        const SizedBox(height: 30),
                        buildBusinessReferrersSection(),
                        const SizedBox(height: 20),
                        buildVersionInfo(),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                  */
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildSegmentControl() {
    return Obx(
      () {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: const Color(0xfff9fafb),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => controller.toggleTabSelection(true),
                  child: Container(
                    margin: const EdgeInsets.all(5),
                    height: 46,
                    decoration: BoxDecoration(
                      color:
                          controller.isMyContractsSelected.value ? AppColors.primary : AppColors.transparent,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      tr(LanguageKeys.myPrograms),
                      style: stylePoppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: controller.isMyContractsSelected.value ? Colors.white : Colors.grey,
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () => controller.toggleTabSelection(false),
                  child: Stack(
                    children: [
                      Container(
                        margin: const EdgeInsets.all(5),
                        height: 46,
                        decoration: BoxDecoration(
                          color: !controller.isMyContractsSelected.value
                              ? AppColors.primary
                              : AppColors.transparent,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          tr(LanguageKeys.myNetwork),
                          style: stylePoppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: controller.isMyContractsSelected.value ? Colors.grey : Colors.white,
                          ),
                        ),
                      ),
                      (controller.networkList.value?.data?.notificationCount ?? 0) > 0
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
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: Colors.red,
                                    shape: BoxShape.circle,
                                    border: Border.all(color: Colors.red, width: 1),
                                  ),
                                  child: Center(
                                    child: Text(
                                      '${controller.networkList.value?.data?.notificationCount}',
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
            ],
          ),
        );
      },
    );
  }

  // ---------------------------------------------------------------------------
  // Reference-only: previous `buildNewDealsListView` (Git HEAD before partnership
  // card redesign). Kept for rollback / comparison; active code follows below.
  // ---------------------------------------------------------------------------
  /*
  // New Deals List View using SalesforcePartnershipCard
  Widget buildNewDealsListView() {
    return Obx(() {
      final hasData = controller.contactList.value?.data?.isNotEmpty ?? false;
      return Column(
        children: [
          Expanded(
            child: hasData
                ? RefreshIndicator(
                    onRefresh: () async {
                      await controller.updateInit();
                    },
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount:
                          controller.contactList.value?.data?.length ?? 0,
                      itemBuilder: (context, index) {
                        final contract =
                            controller.contactList.value?.data?[index];
                        final firstDealCase =
                            (contract?.dealCases?.isNotEmpty ?? false)
                                ? contract!.dealCases!.first
                                : null;

                        return SalesforcePartnershipCard(
                          companyName:
                              contract?.companyName ?? "Unknown Company",
                          dealType: contract?.dealName ?? "Partnership Deal",
                          leadsReceived: "${contract?.leadCount ?? "0"} " +
                              tr(LanguageKeys.leadsReceived),
                          commissionRate: contract?.dealCommissionType == 1
                              ? contract?.commissionValue ?? "0"
                              : "${firstDealCase?.commissionValue ?? "0"}",
                          commissionType: contract?.dealCommissionType == 1
                              ? contract?.commissionType ?? "no_commission"
                              : firstDealCase?.commissionType ??
                                  "no_commission",
                          isRecurring: (contract?.dealCommissionType == 1
                                  ? contract?.commissionType
                                  : firstDealCase?.commissionType) ==
                              "percentage_commission",
                          companyLogoUrl:
                              contract?.createdDetail?.companyLogoUrl,
                          onViewContract: () {
                            controller.openPdfBottomSheet(
                              context,
                              contract?.documentUrl ?? '',
                            );
                          },
                          onEdit: () {
                            Get.toNamed(BusinessReferrerContractScreen.pageId,
                                arguments: {
                                  'is_edit': true,
                                  'deal_id': contract?.id.toString() ?? '',
                                  'deal_name': contract?.dealName ?? '',
                                  'multi_level_referral':
                                      contract?.multiLevelReferral ?? '0',
                                  'level_2_commission_percentage':
                                      contract?.level2CommissionPercentage ??
                                          '',
                                  'commission_type':
                                      contract?.commissionType ?? '',
                                  'track_names': contract?.dealSteps ?? [],
                                  'commission_value':
                                      contract?.commissionValue ?? '',
                                  'deal_commission_type':
                                      contract?.dealCommissionType ?? '',
                                  'deal_cases': contract?.dealCases ?? [],
                                })?.then((value) {
                              if (value == true) {
                                controller.getContactList();
                              }
                            });
                          },
                          onAttachFiles: () {
                            // Implement file attachment functionality
                            AppHelper.showLog(
                                "Attach files for ${contract?.dealName}");
                            if (controller.mainController.profile.value!.data!
                                    .isPaid! !=
                                0) {
                              Get.toNamed(DocumentScreen.pageId, arguments: {
                                'id': contract?.id.toString() ?? '',
                                'type': 'active',
                              });
                            } else {
                              Get.dialog(PremiumUpgradeDialog(
                                onSeeOffers: () {
                                  Get.back();
                                  Get.toNamed(MembershipPlanNewScreen.pageId)?.then((value) {})
                                      ?.then((value) {});
                                  // Get.toNamed(MembershipScreen.pageId)
                                  //     ?.then((value) {});
                                },
                              ));
                            }
                          },
                          onInvitePartner: () {
                            // Implement partner invitation functionality
                            Get.dialog(
                              SharePopup(
                                title: contract?.dealName ?? '',
                                link: contract?.deepLink ?? '',
                              ),
                            );
                          },
                          onInviteManually: () {
                            // Send invitation via email - same share flow
                           Get.toNamed(AddBusinessReferrerScreen.pageId,arguments: {
                            'created_by_parent':"false",
                           });
                          },
                          onShareForm: () {
                            _showShareFormBottomSheet(
                              context,
                              contract?.referalFormUrl ?? '',
                              contract?.commissionValue,
                              contract?.companyName ?? '',
                              contract?.id.toString() ?? '',
                            );
                          },
                          onHowItWorks: () {
                            // Show how it works dialog
                            _showHowItWorksDialog(context);
                          },
                          onMoreOptions: () {
                            // Show more options menu
                            _showMoreOptionsDialog(
                                context, contract?.id.toString() ?? '');
                          },
                        );
                      },
                    ),
                  )
                : _buildNoDealsEmptyState(context),
          ),
          if (hasData)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: SizedBox(
                width: Get.width - 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    Get.toNamed(
                      BusinessReferrerContractScreen.pageId,
                    )?.then((value) {
                      AppHelper.showLog("value: $value");
                      controller.getContactList();
                    });
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.add,
                        color: Colors.white,
                        size: 30,
                      ),
                      const SizedBox(width: 10),
                      Text(tr(LanguageKeys.createDeal),
                          style:
                              TextStyle(fontSize: 14.sp, color: Colors.white)),
                    ],
                  ),
                ),
              ),
            ),
        ],
      );
    });
  }
  */

  // New Deals List View using SalesforcePartnershipCard
  Widget buildNewDealsListView() {
    return Obx(() {
      final deals = controller.contactList.value?.data ?? [];
      final hasData = deals.isNotEmpty;
      final isSingleDeal = deals.length == 1;

      return Column(
        children: [
          Expanded(
            child: hasData
                ? RefreshIndicator(
                    onRefresh: () async {
                      await controller.updateInit();
                    },
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: deals.length,
                      itemBuilder: (context, index) {
                        final contract = deals[index];
                        final firstDealCase =
                            (contract.dealCases?.isNotEmpty ?? false) ? contract.dealCases!.first : null;

                        final layout = isSingleDeal
                            ? SalesforcePartnershipLayout.single
                            : (expandedPartnershipDealIndex == index
                                ? SalesforcePartnershipLayout.listExpanded
                                : SalesforcePartnershipLayout.listCollapsed);

                        return SalesforcePartnershipCard(
                          layout: layout,
                          contractName: contract.dealName ?? '',
                          referrersCount: contract.referrersCount ?? '0',
                          leadsCount: contract.leadCount ?? '0',
                          commissionRate: contract.dealCommissionType == 1
                              ? contract.commissionValue ?? '0'
                              : '${firstDealCase?.commissionValue ?? '0'}',
                          commissionType: contract.dealCommissionType == 1
                              ? contract.commissionType ?? 'no_commission'
                              : firstDealCase?.commissionType ?? 'no_commission',
                          isRecurring: (contract.dealCommissionType == 1
                                  ? contract.commissionType
                                  : firstDealCase?.commissionType) ==
                              'percentage_commission',
                          companyLogoUrl: contract.createdDetail?.companyLogoUrl,
                          onToggleExpand: isSingleDeal
                              ? null
                              : () {
                                  setState(() {
                                    expandedPartnershipDealIndex =
                                        expandedPartnershipDealIndex == index ? null : index;
                                  });
                                },
                          onViewContract: () {
                            controller.openPdfBottomSheet(
                              context,
                              contract.documentUrl ?? '',
                            );
                          },
                          onEdit: () {
                            Get.toNamed(BusinessReferrerContractScreen.pageId, arguments: {
                              'is_edit': true,
                              'deal_id': contract.id.toString(),
                              'deal_name': contract.dealName ?? '',
                              'multi_level_referral': contract.multiLevelReferral ?? '0',
                              'level_2_commission_percentage': contract.level2CommissionPercentage ?? '',
                              'commission_type': contract.commissionType ?? '',
                              'track_names': contract.dealSteps ?? [],
                              'commission_value': contract.commissionValue ?? '',
                              'deal_commission_type': contract.dealCommissionType ?? '',
                              'deal_cases': contract.dealCases ?? [],
                            })?.then((value) {
                              if (value == true) {
                                controller.getContactList();
                              }
                            });
                          },
                          onAttachFiles: () {
                            AppHelper.showLog("Attach files for ${contract.dealName}");
                            if (controller.mainController.profile.value!.data!.isPaid! != 0) {
                              Get.toNamed(DocumentScreen.pageId, arguments: {
                                'id': contract.id.toString(),
                                'type': 'active',
                              });
                            } else {
                              Get.dialog(PremiumUpgradeDialog(
                                onSeeOffers: () {
                                  Get.back();
                                   Get.toNamed(MembershipPlanNewScreen.pageId)?.then((value) {});
                                  // Get.toNamed(MembershipScreen.pageId)?.then((value) {});
                                },
                              ));
                            }
                          },
                          onInvitePartner: () {
                            Get.dialog(
                              SharePopup(
                                title: contract.dealName ?? '',
                                link: contract.deepLink ?? '',
                              ),
                            );
                          },
                          onInviteManually: () {
                            Get.toNamed(AddBusinessReferrerScreen.pageId, arguments: {
                              'created_by_parent': 'false',
                            });
                          },
                          onShareForm: () {
                            _showShareFormBottomSheet(
                              context,
                              contract.referalFormUrl ?? '',
                              contract.commissionValue,
                              contract.companyName ?? '',
                              contract.id.toString(),
                            );
                          },
                          onHowItWorks: () {
                            _showHowItWorksDialog(context);
                          },
                          onMoreOptions: () {
                            _showMoreOptionsDialog(context, contract.id.toString());
                          },
                        );
                      },
                    ),
                  )
                : _buildNoDealsEmptyState(context),
          ),
          if (hasData)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: SizedBox(
                width: Get.width - 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    Get.toNamed(
                      BusinessReferrerContractScreen.pageId,
                    )?.then((value) {
                      AppHelper.showLog("value: $value");
                      controller.getContactList();
                    });
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.add,
                        color: Colors.white,
                        size: 30,
                      ),
                      const SizedBox(width: 10),
                      Text(tr(LanguageKeys.addNewContractButton),
                          style: TextStyle(fontSize: 14.sp, color: Colors.white)),
                    ],
                  ),
                ),
              ),
            ),
        ],
      );
    });
  }

  /// Empty state for "My Programs" / My Contacts tab when there are no deals.
  Widget _buildNoDealsEmptyState(BuildContext context) {
    const purpleLight = Color(0xFFF3E8FF);
    const purpleDark = Color(0xFF7C3AED);
    const cardGrey = Color(0xFFF5F5F5);
    final descStyle = stylePoppins(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      color: const Color(0xFF374151),
    );
    final boldStyle = stylePoppins(
      fontSize: 14,
      fontWeight: FontWeight.w600,
      color: purpleDark,
    );
    final headingStyle = stylePoppins(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      color: Colors.black,
    );

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      child: Column(
        children: [
          SizedBox(
            width: 200,
            height: 200,
            child: Center(
              child: Image.asset(
                AppAssets.imgEmptyDeal,
              ),
            ),
          ),
          const SizedBox(height: 32),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: cardGrey,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: const BoxDecoration(
                    color: purpleDark,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.keyboard_arrow_down,
                    size: 20,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        tr(LanguageKeys.alreadyInvited),
                        style: headingStyle,
                      ),
                      const SizedBox(height: 8),
                      _buildDescriptionWithBold(
                        tr(LanguageKeys.alreadyInvitedDescription),
                        descStyle,
                        boldStyle,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(child: Divider(color: Colors.grey[300])),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Text(
                  tr(LanguageKeys.or),
                  style: stylePoppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[600],
                  ),
                ),
              ),
              Expanded(child: Divider(color: Colors.grey[300])),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: cardGrey,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: const BoxDecoration(
                    color: purpleDark,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.keyboard_arrow_down,
                    size: 20,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        tr(LanguageKeys.startNewPartnership),
                        style: headingStyle,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        tr(LanguageKeys.startNewPartnershipDescription),
                        style: descStyle,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              onPressed: () {
                Get.toNamed(BusinessReferrerContractScreen.pageId)?.then((value) {
                  if (value == true) controller.getContactList();
                });
              },
              icon: const Icon(Icons.add, size: 22),
              label: Text(
                tr(LanguageKeys.createReferralDeal),
                style: stylePoppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildDescriptionWithBold(
    String text,
    TextStyle normalStyle,
    TextStyle boldStyle,
  ) {
    final spans = <TextSpan>[];
    int start = 0;
    final regex = RegExp(r'\*\*(.+?)\*\*');
    for (final match in regex.allMatches(text)) {
      if (match.start > start) {
        spans.add(TextSpan(
          text: text.substring(start, match.start),
          style: normalStyle,
        ));
      }
      spans.add(TextSpan(
        text: match.group(1),
        style: boldStyle,
      ));
      start = match.end;
    }
    if (start < text.length) {
      spans.add(TextSpan(
        text: text.substring(start),
        style: normalStyle,
      ));
    }
    return RichText(
      textAlign: TextAlign.left,
      text: TextSpan(children: spans),
    );
  }

  void _showMoreOptionsDialog(BuildContext context, String contractId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        insetPadding: const EdgeInsets.symmetric(horizontal: 10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        contentPadding: const EdgeInsets.fromLTRB(40, 32, 40, 0),
        content: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                tr(LanguageKeys.deleteCofirmation),
                style: stylePoppins(fontSize: 13),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(color: Colors.black, width: 1),
                        ),
                        child: Center(
                          child: Text(tr(LanguageKeys.cancel), style: stylePoppins(color: Colors.black)),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                        controller.deleteContract(contractId).then((value) => controller.getContactList());
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Center(
                          child: Text(tr(LanguageKeys.yes), style: stylePoppins(color: Colors.white)),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // LEGACY — "How it works" (My Activity), pre–Figma redesign (nodes 4935-*).
  // Preserved for future reference / rollback. Not compiled.
  // To restore: remove the active `_showHowItWorksDialog` + Figma helpers below,
  // uncomment this block (remove slash-asterisk wrappers only), delete duplicate
  // method names if any.
  // ---------------------------------------------------------------------------
  /*
  void _showHowItWorksDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 20),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            tr(LanguageKeys.howitworktitle),
                            style: stylePoppins(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          Text(
                            tr(LanguageKeys.howitworkdescription),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: stylePoppins(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          shape: BoxShape.circle,
                        ),
                        child: SvgPicture.asset(
                          AppAssets.imgCloseBtn,
                          width: 20,
                          height: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Flexible(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                  child: Column(
                    children: [
                      _buildHowItWorksSection(
                        icon: Container(
                          width: 48,
                          height: 48,
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFEDD5),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: SvgPicture.asset(
                            AppAssets.imgInvitePartner,
                            width: 8,
                          ),
                        ),
                        title: tr(LanguageKeys.invitePartnerTitle),
                        description: tr(LanguageKeys.invitePartnerDescription),
                      ),
                      const SizedBox(height: 24),
                      _buildHowItWorksSection(
                        icon: Container(
                          width: 48,
                          height: 48,
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFECACA),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(Icons.share, color: Color(0xFFDC2626), size: 24),
                        ),
                        title: tr(LanguageKeys.shareTitle),
                        description: tr(LanguageKeys.shareDescription),
                      ),
                      const SizedBox(height: 24),
                      _buildHowItWorksSection(
                        icon: Container(
                          width: 48,
                          height: 48,
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: const Color(0xFFDCFCE7),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: SvgPicture.asset(
                            AppAssets.imgAttachFiles,
                            width: 8,
                          ),
                        ),
                        title: tr(LanguageKeys.attchfiles),
                        description: tr(LanguageKeys.attachFilesDescription),
                      ),
                      const SizedBox(height: 24),
                      _buildHowItWorksSection(
                        icon: Container(
                          width: 48,
                          height: 48,
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: const Color(0xFEEBE5FF),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: SvgPicture.asset(
                            AppAssets.imgDocumentContract,
                            width: 8,
                          ),
                        ),
                        title: tr(LanguageKeys.viewContractTitle),
                        description: tr(LanguageKeys.viewContractDescription),
                      ),
                      const SizedBox(height: 24),
                      _buildHowItWorksSection(
                        icon: Container(
                          width: 48,
                          height: 48,
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: const Color(0xFEDBEAFE),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: SvgPicture.asset(
                            AppAssets.imgEditProgram,
                            width: 8,
                          ),
                        ),
                        title: tr(LanguageKeys.editProgram),
                        description: tr(LanguageKeys.editProgramDescription),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHowItWorksSection({
    required Widget icon,
    required String title,
    required String description,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        icon,
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title.replaceAll("\n", " "),
                style: stylePoppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                description,
                style: stylePoppins(
                  fontSize: 12,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
  */
  // ---------------------------------------------------------------------------
  // Current UI: Figma-aligned dialog (4935:355 FR, 4935:434 EN, 4935:513 ES).
  // ---------------------------------------------------------------------------

  void _showHowItWorksDialog(BuildContext context) {
    final mq = MediaQuery.of(context);
    // Dialog `insetPadding` vertical 24*2; keep below safe area so Column + header fit viewport.
    const dialogVerticalInset = 48.0;
    final verticalReserve = mq.padding.vertical + dialogVerticalInset + 8;
    final dialogHeight = (mq.size.height - verticalReserve).clamp(320.0, mq.size.height * 0.88);

    showDialog<void>(
      context: context,
      barrierColor: Colors.black54,
      builder: (dialogContext) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          child: SizedBox(
            width: double.infinity,
            height: dialogHeight,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              clipBehavior: Clip.antiAlias,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ClipRect(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
                      child: Container(
                        height: 56,
                        decoration: const BoxDecoration(
                          color: Color(0xF2FFFFFF),
                          border: Border(
                            bottom: BorderSide(color: Color(0xFFF3F4F6)),
                          ),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  customBorder: const CircleBorder(),
                                  onTap: () => Navigator.of(dialogContext).pop(),
                                  child: Container(
                                    width: 40,
                                    height: 40,
                                    alignment: Alignment.center,
                                    child: SvgPicture.asset(
                                      AppAssets.imgCloseBtn,
                                      width: 18,
                                      height: 18,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Text(
                              tr(LanguageKeys.howitworktitle),
                              style: stylePoppins(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF111827),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Column(
                            children: [
                              Container(
                                width: 80,
                                height: 80,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(24),
                                  gradient: const LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      Color(0xFF8B5CF6),
                                      Color(0xFF3B82F6),
                                    ],
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.12),
                                      blurRadius: 12,
                                      offset: const Offset(0, 6),
                                    ),
                                  ],
                                ),
                                alignment: Alignment.center,
                                child: Container(
                                  width: 44,
                                  height: 44,
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.info_outline_rounded,
                                    color: Color(0xFF8B5CF6),
                                    size: 26,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                tr(LanguageKeys.howItWorksDialogHeroTitle),
                                textAlign: TextAlign.center,
                                style: stylePoppins(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFF111827),
                                ).copyWith(height: 1.25, letterSpacing: -0.6),
                              ),
                            ],
                          ),
                          const SizedBox(height: 32),
                          for (var i = 0; i < _howItWorksFigmaSpecs.length; i++) ...[
                            if (i > 0) const SizedBox(height: 14),
                            _buildHowItWorksFigmaStepCard(
                              step: i + 1,
                              spec: _howItWorksFigmaSpecs[i],
                              title: _howItWorksStepTitle(i),
                              body: _howItWorksStepBody(i),
                            ),
                          ],
                        ],
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
  }

  String _howItWorksStepTitle(int index) {
    switch (index) {
      case 0:
        return tr(LanguageKeys.howItWorksStep1Title);
      case 1:
        return tr(LanguageKeys.howItWorksStep2Title);
      case 2:
        return tr(LanguageKeys.howItWorksStep3Title);
      case 3:
        return tr(LanguageKeys.howItWorksStep4Title);
      default:
        return '';
    }
  }

  String _howItWorksStepBody(int index) {
    switch (index) {
      case 0:
        return tr(LanguageKeys.howItWorksStep1Body);
      case 1:
        return tr(LanguageKeys.howItWorksStep2Body);
      case 2:
        return tr(LanguageKeys.howItWorksStep3Body);
      case 3:
        return tr(LanguageKeys.howItWorksStep4Body);
      default:
        return '';
    }
  }

  Widget _buildHowItWorksFigmaStepCard({
    required int step,
    required _HowItWorksFigmaStepSpec spec,
    required String title,
    required String body,
  }) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(21),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: spec.borderColor),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: spec.cardGradient,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 2,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: spec.iconBackground,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.12),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                alignment: Alignment.center,
                child: Icon(spec.icon, color: Colors.white, size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: stylePoppins(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF111827),
                        ).copyWith(height: 1.5),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        body,
                        style: stylePoppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xFF374151),
                        ).copyWith(height: 1.6),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        Positioned(
          top: 12,
          right: 12,
          child: Container(
            width: 32,
            height: 32,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: spec.badgeBackground,
              shape: BoxShape.circle,
            ),
            child: Text(
              '$step',
              style: stylePoppins(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: spec.badgeForeground,
              ),
            ),
          ),
        ),
      ],
    );
  }

  // Original Deals List View (My Contracts tab)
  Widget buildDealsListView() {
    return Obx(() {
      final hasData = controller.contactList.value?.data?.isNotEmpty ?? false;
      return Column(
        children: [
          Expanded(
            child: hasData
                ? Obx(() {
                    return RefreshIndicator(
                      onRefresh: () async {
                        await controller.updateInit();
                      },
                      child: ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: controller.contactList.value?.data?.length ?? 0,
                        itemBuilder: (context, index) {
                          final contract = controller.contactList.value?.data?[index];
                          final isExpanded = expandedIndex == index;

                          return Container(
                            margin: const EdgeInsets.only(bottom: 10),
                            decoration: BoxDecoration(
                              color: const Color(0xfff9fafb),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.grey[200]!),
                            ),
                            child: Column(
                              children: [
                                buildDealHeader(
                                  title: contract?.companyName ?? "",
                                  referrer: contract?.dealName ?? "",
                                  id: contract?.id.toString() ?? "",
                                  index: index,
                                ),
                                const Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 16),
                                  child: Divider(height: 1),
                                ),
                                GestureDetector(
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
                                    width: double.infinity,
                                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          tr(LanguageKeys.companyDetailsMydeal),
                                          style: const TextStyle(fontWeight: FontWeight.w500),
                                        ),
                                        Icon(
                                          expandedIndex == index ? Icons.remove : Icons.add,
                                          size: 20,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                if (expandedIndex == index)
                                  Container(
                                    width: double.infinity,
                                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.05),
                                          blurRadius: 4,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Text(tr(LanguageKeys.commision),
                                            style: const TextStyle(fontWeight: FontWeight.w500)),
                                        if (contract?.dealCommissionType == 1)
                                          Text(
                                            contract?.commissionType == "no_commission"
                                                ? tr(LanguageKeys.no_commission)
                                                : contract?.commissionType == "fix_commission"
                                                    ? ("${tr(LanguageKeys.fix_commission)} : ${contract?.commissionValue ?? ""} €")
                                                    : ("${tr(LanguageKeys.percentage_commission)}  : ${contract?.commissionValue ?? ""} % HT du montant facturé"),
                                          ),
                                        if (contract?.dealCommissionType == 2)
                                          if (contract?.dealCases != null &&
                                              contract!.dealCases!.isNotEmpty) ...[
                                            const SizedBox(height: 8),
                                            // Show first deal case
                                            Padding(
                                              padding: const EdgeInsets.only(bottom: 8),
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    contract.dealCases![0].commissionType == "no_commission"
                                                        ? tr(LanguageKeys.no_commission)
                                                        : contract.dealCases![0].commissionType ==
                                                                "fix_commission"
                                                            ? ("${tr(LanguageKeys.fix_commission)} : ${contract.dealCases![0].commissionValue ?? ""} €")
                                                            : ("${tr(LanguageKeys.percentage_commission)}  : ${contract.dealCases![0].commissionValue ?? ""} % HT du montant facturé"),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            // Show remaining deal cases if expanded
                                            if (expandedDealCasesIndex == index) ...[
                                              ...contract.dealCases!.skip(1).map(
                                                    (dealCase) => Padding(
                                                      padding: const EdgeInsets.only(bottom: 8),
                                                      child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                        children: [
                                                          Text(
                                                            dealCase.commissionType == "no_commission"
                                                                ? tr(LanguageKeys.no_commission)
                                                                : dealCase.commissionType == "fix_commission"
                                                                    ? ("${tr(LanguageKeys.fix_commission)} : ${dealCase.commissionValue ?? ""} €")
                                                                    : ("${tr(LanguageKeys.percentage_commission)}  : ${dealCase.commissionValue ?? ""} % HT du montant facturé"),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                            ],
                                            // Show See more/See less button
                                            if (contract.dealCases!.length > 1) ...[
                                              const SizedBox(height: 8),
                                              GestureDetector(
                                                onTap: () {
                                                  setState(() {
                                                    if (expandedDealCasesIndex == index) {
                                                      expandedDealCasesIndex = null;
                                                    } else {
                                                      expandedDealCasesIndex = index;
                                                    }
                                                  });
                                                },
                                                child: Text(
                                                  expandedDealCasesIndex == index
                                                      ? tr(LanguageKeys.seeLess)
                                                      : tr(LanguageKeys.seeMore),
                                                  style: const TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w500,
                                                    color: AppColors.primary,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ],
                                      ],
                                    ),
                                  ),
                                buildDealActionButtons(contract),
                              ],
                            ),
                          );
                        },
                      ),
                    );
                  })
                : Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        textAlign: TextAlign.center,
                        tr(LanguageKeys.createYourFirst),
                        style: stylePoppins(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: SizedBox(
              width: Get.width - 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  Get.toNamed(
                    BusinessReferrerContractScreen.pageId,
                  )?.then((value) {
                    AppHelper.showLog("value: $value");
                    controller.getContactList();
                  });
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.add,
                      color: Colors.white,
                      size: 30,
                    ),
                    const SizedBox(width: 10),
                    Text(tr(LanguageKeys.createDeal), style: TextStyle(fontSize: 14.sp, color: Colors.white)),
                  ],
                ),
              ),
            ),
          ),
        ],
      );
    });
  }

  Widget buildDealHeader(
      {required String title, required String referrer, required String id, required int index}) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child:
                controller.contactList.value?.data?[index].createdDetail?.companyLogoUrl?.isNotEmpty == true
                    ? Image.network(
                        controller.contactList.value?.data?[index].createdDetail!.companyLogoUrl ?? '',
                        width: 48,
                        height: 48,
                        fit: BoxFit.cover,
                      )
                    : SizedBox(
                        width: 48,
                        height: 48,
                        child: Image.asset(
                          AppAssets.imgDefaultPerson,
                          width: 48,
                          height: 48,
                          fit: BoxFit.cover,
                        ),
                      ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                title != ""
                    ? Text(
                        title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: stylePoppins(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      )
                    : const SizedBox(),
                title != "" ? const SizedBox(height: 4) : const SizedBox(),
                Text(
                  referrer,
                  style: stylePoppins(
                    fontSize: 12.sp,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: [
              GestureDetector(
                onTap: () => {
                  // Get.toNamed(DocumentScreen.pageId, arguments: {
                  //   'id': id,
                  // })
                  AppHelper.showLog(controller.contactList.value?.data?[index].documentUrl ?? ''),
                  controller.openPdfBottomSheet(
                      context, controller.contactList.value?.data?[index].documentUrl ?? '')
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SvgPicture.asset(
                    AppAssets.imgDocIcon,
                    color: AppColors.primary,
                    height: 20,
                    width: 20,
                  ),
                ),
              ),
              PopupMenuButton<String>(
                color: Colors.white,
                icon: const Icon(Icons.more_vert, color: AppColors.primary),
                onSelected: (value) {
                  if (value == 'delete') {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        backgroundColor: Colors.white,
                        insetPadding: const EdgeInsets.symmetric(horizontal: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        contentPadding: const EdgeInsets.fromLTRB(40, 32, 40, 0),
                        content: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                tr(LanguageKeys.deleteCofirmation),
                                style: stylePoppins(fontSize: 13),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 24),
                              Row(
                                children: [
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(vertical: 14),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(5),
                                          border: Border.all(color: Colors.black, width: 1),
                                        ),
                                        child: Center(
                                          child: Text(tr(LanguageKeys.cancel),
                                              style: stylePoppins(color: Colors.black)),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () {
                                        // Close the dialog first
                                        Navigator.of(context).pop();
                                        // Add your delete logic here
                                        controller
                                            .deleteContract(id)
                                            .then((value) => controller.getContactList());
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(vertical: 14),
                                        decoration: BoxDecoration(
                                          color: AppColors.primary,
                                          borderRadius: BorderRadius.circular(5),
                                        ),
                                        child: Center(
                                          child: Text(tr(LanguageKeys.yes),
                                              style: stylePoppins(color: Colors.white)),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }
                },
                itemBuilder: (context) => [
                  PopupMenuItem(
                    padding: const EdgeInsets.all(0),
                    height: 20,
                    value: 'delete',
                    child: Center(
                      child: Text(tr(LanguageKeys.delete)),
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

  Widget buildDealActionButtons(ContractData? contract) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () {
                Get.toNamed(BusinessReferrerContractScreen.pageId, arguments: {
                  'is_edit': true,
                  'deal_id': contract?.id.toString() ?? '',
                  'deal_name': contract?.dealName ?? '',
                  'multi_level_referral': contract?.multiLevelReferral ?? '0',
                  'level_2_commission_percentage': contract?.level2CommissionPercentage ?? '',
                  'commission_type': contract?.commissionType ?? '',
                  'track_names': contract?.dealSteps ?? [],
                  'commission_value': contract?.commissionValue ?? '',
                  'deal_commission_type': contract?.dealCommissionType ?? '',
                  'deal_cases': contract?.dealCases ?? [],
                })?.then((value) {
                  if (value == true) {
                    controller.getContactList();
                  }
                });
              },
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.primary,
                side: const BorderSide(color: AppColors.primary),
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                tr(LanguageKeys.editDeal),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: stylePoppins(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                Get.dialog(
                  SharePopup(
                    title: contract?.dealName ?? '',
                    link: contract?.deepLink ?? '',
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                tr(LanguageKeys.shareDeal),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: stylePoppins(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Network tab content
  Widget buildPurpleCard() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Stack(
        children: [
          // Corner images
          Positioned(
            top: 0,
            right: 0,
            child: SvgPicture.asset(
              AppAssets.imgHalfCircleRightTop,
              width: 40,
              height: 40,
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            child: SvgPicture.asset(
              AppAssets.imgHalfCircleLeftDown,
              width: 40,
              height: 40,
            ),
          ),
          // Main content
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SvgPicture.asset(AppAssets.imgReferrelsPeopleSvg, height: 60),
                const SizedBox(height: 5),
                Obx(
                  () => Text(
                    controller.networkList.value?.data?.totalBusinessReferrers.toString() ?? "0",
                    style: stylePoppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 5),
                // Text(
                //   tr(LanguageKeys.activeReferrals),
                //   style: stylePoppins(
                //     fontSize: 20.sp,
                //     fontWeight: FontWeight.w500,
                //     color: Colors.white,
                //   ),
                // ),
                // const SizedBox(height: 5),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.1),
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    tr(LanguageKeys.activeReferrals),
                    textAlign: TextAlign.center,
                    style: stylePoppins(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 5),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildActionButtonsRow() {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: AppColors.whiteColor,
          boxShadow: [
            BoxShadow(
              color: AppColors.grey600.withOpacity(0.2),
              blurRadius: 1,
              offset: const Offset(0, 1),
            ),
          ],
          border: Border.all(color: AppColors.grey600.withOpacity(0.2), width: 1)),
      padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
      child: SizedBox(
        width: Get.width - 35,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            GestureDetector(
                onTap: () => Get.dialog(const ActivityInfoDialog()),
                child: Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: SvgPicture.asset(
                    AppAssets.imgActivityInfoSvg,
                    height: 20,
                    width: 20,
                  ),
                )),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                singlePrItem(
                    image: AppAssets.imgRefrealSvg,
                    text: tr(LanguageKeys.collaborators),
                    isBlue: true,
                    onTap: () {
                      // Get.dialog(AddAgencyCoworkerDialog(

                      // ));
                      if ((AppPreference.readString(AppPreference.isPaid) != "3") &&
                          AppPreference.readString(AppPreference.isPaid) != "1") {
                        Get.dialog(PremiumUpgradeDialog(
                          onSeeOffers: () {
                            Get.back();
                            Get.toNamed(MembershipPlanNewScreen.pageId)?.then((value) {
                              controller.mainController.getProfile();
                            });
                            // Get.toNamed(MembershipScreen.pageId)?.then((value) {
                            //   controller.mainController.getProfile();
                            // });
                          },
                        ));
                      } else {
                        Get.dialog(AddAgencyCoworkerDialog());
                      }
                    },
                    scale: 30.sp,
                    request: controller.referrers.length,
                    type: "referal"),
                // singlePrItem(
                //     image: AppAssets.imgAddDoc,
                //     isBlue: false,
                //     onTap: () {
                //       if (AppPreference.readString(AppPreference.isPaid) ==
                //           "0") {
                //         Get.dialog(PremiumUpgradeDialog(
                //           onSeeOffers: () {
                //             Get.back();
                //             Get.toNamed(MembershipScreen.pageId)?.then((value) {
                //               controller.mainController.getProfile();
                //             });
                //           },
                //         ));
                //       } else {
                //         Get.toNamed(ActiveGoalScreen.pageId);
                //       }
                //     },
                //     scale: 4.1,
                //     type: ""),
                // singlePrItem(
                //     image: AppAssets.imgShare,
                //     isBlue: false,
                //     onTap: () {
                //       if (controller.userDealList.value?.data?.length == 0) {
                //         return;
                //       }
                //       if (controller.userDealList.value?.data?.length == 1) {
                //         Get.dialog(
                //           SharePopup(
                //             title: controller
                //                     .userDealList.value?.data?[0].dealName ??
                //                 '',
                //             link: controller
                //                     .userDealList.value?.data?[0].inviteLink ??
                //                 '',
                //           ),
                //         );
                //       } else {
                //         Get.dialog(LikeAddCoworkerDialog(
                //           coworkers: controller.userDealList.value?.data ?? [],
                //           onQrTap: (index) {
                //             Get.back();
                //             Get.dialog(
                //               SharePopup(
                //                 title: controller.userDealList.value
                //                         ?.data?[index].dealName ??
                //                     '',
                //                 link: controller.userDealList.value
                //                         ?.data?[index].inviteLink ??
                //                     '',
                //               ),
                //             );
                //           },
                //         ));
                //       }
                //     },
                //     scale: 4.1,
                //     type: ""),
                singlePrItem(
                    image: AppAssets.imgAddNotificationSvg,
                    isBlue: false,
                    text: tr(LanguageKeys.enveyers),
                    onTap: () {
                      if (AppPreference.readString(AppPreference.isPaid) == "0") {
                        Get.dialog(PremiumUpgradeDialog(
                          onSeeOffers: () {
                            Get.back();
                            Get.toNamed(MembershipPlanNewScreen.pageId)?.then((value) {
                              controller.mainController.getProfile();
                            });
                            // Get.toNamed(MembershipScreen.pageId)?.then((value) {
                            //   controller.mainController.getProfile();
                            // });
                          },
                        ));
                      } else {
                        Get.toNamed(SendNotificationScreen.pageId);
                      }
                    },
                    scale: 60.sp,
                    type: ""),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget singlePrItem(
      {required String image,
      String? text,
      required VoidCallback onTap,
      int request = 0,
      required bool isBlue,
      required double scale,
      String? type}) {
    final width = ((Get.width - 52) / 2);
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: width,
        height: 120.h,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
              left: 10,
              top: 10,
              child: SizedBox(
                width: width - 10,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      image,
                      height: 70.h,
                      // height: scale,
                      // color: AppColors.primary.withOpacity(0.9)
                    ),
                    Text(
                      text ?? text.toString(),
                      style: stylePoppins(
                        fontSize: 12,
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (type == "referal" &&
                AppPreference.readString(AppPreference.isPaid) != "3" &&
                AppPreference.readString(AppPreference.isPaid) != "1")
              Positioned(
                top: 0,
                left: MediaQuery.of(context).size.width * 0.15,
                child: SvgPicture.asset(AppAssets.imgHDashboardCrown, height: 18, color: AppColors.blueColor),
              ),
            if (AppPreference.readString(AppPreference.isPaid) == "0")
              Positioned(
                top: 0,
                left: MediaQuery.of(context).size.width * 0.15,
                child: SvgPicture.asset(isBlue ? AppAssets.imgpointBlue : AppAssets.imgHDashboardCrown,
                    height: 18),
              ),
            Obx(
              () => controller.referrers.isNotEmpty && request != 0
                  ? Positioned(
                      right: 15,
                      bottom: 5,
                      child: Container(
                        decoration: BoxDecoration(shape: BoxShape.circle, color: AppColors.pdfBg),
                        padding: const EdgeInsets.all(6),
                        child: Text(
                          request.toString(),
                          style: stylePoppins(
                            fontSize: 12,
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    )
                  : const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildBusinessReferrersSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Obx(
        () => controller.networkList.value?.data?.businessReferrers?.isNotEmpty ?? false
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    tr(LanguageKeys.bussinessreferrence),
                    style: stylePoppins(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Obx(
                    () => ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: (controller.networkList.value?.data?.businessReferrers?.length ?? 0) > 6
                          ? 6
                          : controller.networkList.value?.data?.businessReferrers!.length ?? 0,
                      itemBuilder: (context, index) {
                        return ReferrerListItem(
                          data1Referrer: controller.networkList.value?.data?.businessReferrers![index],
                          name:
                              "${controller.networkList.value?.data?.businessReferrers![index].firstName} ${controller.networkList.value?.data?.businessReferrers![index].lastName}",
                          isExpanded: expandedReferrerIndex == index,
                          onHeaderTap: () {
                            setState(() {
                              if (expandedReferrerIndex == index) {
                                expandedReferrerIndex = null;
                              } else {
                                expandedReferrerIndex = index;
                              }
                            });
                          },
                        );
                      },
                    ),
                  )
                ],
              )
            : Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    textAlign: TextAlign.center,
                    tr(LanguageKeys.addBusinessReferrence),
                    style: stylePoppins(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
      ),
    );
  }

  // ignore: unused_element
  void _showAllDealCases(BuildContext context, List<DealCases> dealCases) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        insetPadding: const EdgeInsets.symmetric(horizontal: 20),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Text(
          "All Deal Cases",
          style: stylePoppins(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ...dealCases.map((dealCase) => Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF9FAFB),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey[200]!),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            dealCase.leadType ?? "",
                            style: stylePoppins(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        Text(
                          "${dealCase.commissionValue ?? ""} ${dealCase.commissionType == "percentage_commission" ? "%" : "€"}",
                          style: stylePoppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                  )),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              "Close",
              style: stylePoppins(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: AppColors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildVersionInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppPreference.readString(AppPreference.isPaid) == "0"
            ? Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    textAlign: TextAlign.center,
                    tr(LanguageKeys.premiumInformativeText),
                    style: stylePoppins(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              )
            : const SizedBox.shrink(),
        Obx(
          () => (controller.networkList.value?.data?.businessReferrers?.length ?? 0) > 3
              ? Column(
                  children: [
                    // Padding(
                    //   padding: const EdgeInsets.symmetric(horizontal: 16),
                    //   child: SizedBox(
                    //     width: double.infinity,
                    //     child: GestureDetector(
                    //       onTap: () {
                    //         Get.toNamed(AddBusinessReferrerScreen.pageId, arguments: {
                    //           'created_by_parent': "false",
                    //         });
                    //       },
                    //       child: Container(
                    //         decoration: BoxDecoration(
                    //           color: AppColors.whiteColor,
                    //           borderRadius: BorderRadius.circular(8),
                    //           border: Border.all(color: AppColors.primary, width: 1),
                    //         ),
                    //         padding: const EdgeInsets.symmetric(vertical: 14),
                    //         child: Center(
                    //           child: Row(
                    //             mainAxisAlignment: MainAxisAlignment.center,
                    //             children: [
                    //               const Icon(Icons.add, size: 16, color: AppColors.primary),
                    //               const SizedBox(width: 8),
                    //               Text(
                    //                 tr(LanguageKeys.addBusinessReferrer),
                    //                 style: stylePoppins(
                    //                   fontSize: 13.sp,
                    //                   fontWeight: FontWeight.w500,
                    //                   color: AppColors.primary,
                    //                 ),
                    //               ),
                    //             ],
                    //           ),
                    //         ),
                    //       ),
                    //     ),
                    //   ),
                    // ),
                    // const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: SizedBox(
                        width: double.infinity,
                        child: GestureDetector(
                          onTap: () {
                            AppLog.d("My Network isPaid: ${AppPreference.readString(AppPreference.isPaid)}");
                            if (AppPreference.readString(AppPreference.isPaid) != "0") {
                              Get.toNamed(BusinessReferrersListScreen.pageId, arguments: {
                                "coworkers": controller.networkList.value?.data?.businessReferrers,
                              });
                            } else {
                              Get.dialog(PremiumUpgradeDialog(
                                onSeeOffers: () {
                                  Get.back();
                                  Get.toNamed(MembershipPlanNewScreen.pageId);
                                  // Get.toNamed(MembershipScreen.pageId)?.then((value) {
                                  //   controller.mainController.getProfile();
                                  // });
                                },
                              ));
                            }
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: AppColors.primary, width: 1),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            child: Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SvgPicture.asset(AppAssets.imgActivityPerson,
                                      height: 16, color: AppColors.whiteColor),
                                  const SizedBox(width: 8),
                                  Text(
                                    tr(LanguageKeys.seeAll),
                                    style: stylePoppins(
                                      fontSize: 13.sp,
                                      fontWeight: FontWeight.w500,
                                      color: AppColors.whiteColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    // const SizedBox(height: 8),
                    // Padding(
                    //   padding: const EdgeInsets.symmetric(horizontal: 16),
                    //   child: SizedBox(
                    //     width: double.infinity,
                    //     child: GestureDetector(
                    //       onTap: () {
                    //         if (AppPreference.readString(AppPreference.isPaid) != "0") {
                    //           Get.toNamed(
                    //             OverallStatisticsScreen.pageId,
                    //           );
                    //         } else {
                    //           Get.dialog(PremiumUpgradeDialog(
                    //             onSeeOffers: () {
                    //               Get.back();
                    //               Get.toNamed(MembershipScreen.pageId)?.then((value) {
                    //                 controller.mainController.getProfile();
                    //               });
                    //             },
                    //           ));
                    //         }
                    //       },
                    //       child: Container(
                    //         decoration: BoxDecoration(
                    //           color: AppColors.whiteColor,
                    //           borderRadius: BorderRadius.circular(8),
                    //           border: Border.all(color: AppColors.primary, width: 1),
                    //         ),
                    //         padding: const EdgeInsets.symmetric(vertical: 14),
                    //         child: Center(
                    //           child: Row(
                    //             mainAxisAlignment: MainAxisAlignment.center,
                    //             children: [
                    //               SvgPicture.asset(AppAssets.imgActivityStatics,
                    //                   height: 16, color: AppColors.primary),
                    //               const SizedBox(width: 8),
                    //               Text(
                    //                 tr(LanguageKeys.seeStatistics),
                    //                 style: stylePoppins(
                    //                   fontSize: 13.sp,
                    //                   fontWeight: FontWeight.w500,
                    //                   color: AppColors.primary,
                    //                 ),
                    //               ),
                    //             ],
                    //           ),
                    //         ),
                    //       ),
                    //     ),
                    //   ),
                    // ),
                  ],
                )
              : const SizedBox.shrink(),
        ),
      ],
    );
  }

  void _showShareFormBottomSheet(
    BuildContext context,
    String formUrl,
    String? commissionValue,
    String? companyName,
    String dealId,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ShareFormBottomSheet(
        formUrl: formUrl,
        commissionValue: commissionValue ?? "0",
        companyName: companyName ?? "",
        dealId: dealId,
        onPreviewForm: () {
          // Close the bottom sheet first
          Navigator.pop(context);
        },
      ),
    );
  }
}

/// Visual tokens for the Figma “How it works” step cards (same layout, all locales).
class _HowItWorksFigmaStepSpec {
  final IconData icon;
  final Color borderColor;
  final List<Color> cardGradient;
  final Color iconBackground;
  final Color badgeBackground;
  final Color badgeForeground;

  const _HowItWorksFigmaStepSpec({
    required this.icon,
    required this.borderColor,
    required this.cardGradient,
    required this.iconBackground,
    required this.badgeBackground,
    required this.badgeForeground,
  });
}

const _howItWorksFigmaSpecs = <_HowItWorksFigmaStepSpec>[
  _HowItWorksFigmaStepSpec(
    icon: Icons.smartphone_rounded,
    borderColor: Color(0xFFE9D5FF),
    cardGradient: [
      Color(0xFFFAF5FF),
      Color.fromRGBO(243, 232, 255, 0.5),
    ],
    iconBackground: Color(0xFF8B5CF6),
    badgeBackground: Color.fromRGBO(139, 92, 246, 0.1),
    badgeForeground: Color(0xFF8B5CF6),
  ),
  _HowItWorksFigmaStepSpec(
    icon: Icons.share_rounded,
    borderColor: Color(0xFFBFDBFE),
    cardGradient: [
      Color(0xFFEFF6FF),
      Color.fromRGBO(219, 234, 254, 0.5),
    ],
    iconBackground: Color(0xFF3B82F6),
    badgeBackground: Color.fromRGBO(59, 130, 246, 0.1),
    badgeForeground: Color(0xFF3B82F6),
  ),
  _HowItWorksFigmaStepSpec(
    icon: Icons.mail_outline_rounded,
    borderColor: Color(0xFFFDE68A),
    cardGradient: [
      Color(0xFFFFFBEB),
      Color.fromRGBO(254, 243, 199, 0.5),
    ],
    iconBackground: Color(0xFFF59E0B),
    badgeBackground: Color.fromRGBO(245, 158, 11, 0.1),
    badgeForeground: Color(0xFFF59E0B),
  ),
  _HowItWorksFigmaStepSpec(
    icon: Icons.attach_file_rounded,
    borderColor: Color(0xFFA7F3D0),
    cardGradient: [
      Color(0xFFECFDF5),
      Color.fromRGBO(209, 250, 229, 0.5),
    ],
    iconBackground: Color(0xFF059669),
    badgeBackground: Color.fromRGBO(5, 150, 105, 0.1),
    badgeForeground: Color(0xFF059669),
  ),
];

class ReferrerListItem extends StatefulWidget {
  final String name;
  final bool showPrimium;
  final BusinessReferrers? data1Referrer;
  final bool isExpanded;
  final VoidCallback? onHeaderTap;

  /// When true (e.g. expanded pending row inside [DottedBorder]), no inner card border/margin so only the parent dash shows.
  final bool embedInDottedParent;
  const ReferrerListItem({
    super.key,
    required this.name,
    this.showPrimium = false,
    this.data1Referrer,
    this.isExpanded = false,
    this.onHeaderTap,
    this.embedInDottedParent = false,
  });

  @override
  State<ReferrerListItem> createState() => _ReferrerListItemState();
}

class _ReferrerListItemState extends State<ReferrerListItem> {
  MyActivitySelectedAction? _selectedAction;
  bool _showMoreOptions = false;
  String get _isShareReferral {
    final flag = widget.data1Referrer?.isShareReferral;
    print("flag: $flag");
    if (flag == null) return "";
    final normalized = flag.trim().toLowerCase();
    return widget.data1Referrer?.isShareReferral == "1"
        ? "referralForm"
        : widget.data1Referrer?.isShareReferral == "2"
            ? "inPersonRecommendation"
            : "";
  }

  @override
  void initState() {
    super.initState();
    _selectedAction = MyActivitySelectedAction.statistics;
  }

  String _formatContactInfo() {
    final referrer = widget.data1Referrer;
    final firstName = referrer?.firstName?.trim() ?? '';
    final lastName = referrer?.lastName?.trim() ?? '';
    final phoneNumber = referrer?.phoneNumber?.trim() ?? '';
    final email = referrer?.email?.trim() ?? '';
    final companyName = referrer?.companyName?.trim() ?? '';
    final job = referrer?.job?.trim() ?? '';

    final contactInfo = '''
${firstName.isNotEmpty || lastName.isNotEmpty ? '$firstName $lastName'.trim() : widget.name}
${phoneNumber.isNotEmpty ? phoneNumber : ''}
${email.isNotEmpty ? email : ''}
${companyName.isNotEmpty ? companyName : ''}
${job.isNotEmpty ? job : ''}

''';
    return contactInfo.trim();
  }

  @override
  Widget build(BuildContext context) {
    final embed = widget.embedInDottedParent;
    return GestureDetector(
      onTap: widget.onHeaderTap,
      child: Container(
        margin: embed ? EdgeInsets.zero : const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: AppColors.whiteColor,
          // color: const Color(0xFFF3E9FB), // Light purple
          borderRadius: BorderRadius.circular(embed ? 12 : 16),
          border: embed
              ? null
              : Border.all(
                  color: widget.data1Referrer?.isShareReferral == "1"
                      ? const Color(0xFF2563EB)
                      : widget.data1Referrer?.isShareReferral == "2"
                          ? const Color(0xFFF5D26A)
                          : AppColors.primary.withOpacity(0.1),
                  width: 1,
                ),
        ),
        child: Stack(
          children: [
            data(context),
            if (widget.showPrimium)
              Positioned.fill(
                  child: ClipRect(
                      child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: const SizedBox(),
              )))
          ],
        ),
      ),
    );
  }

  Widget data(BuildContext context) {
    print("isShareReferral: $_isShareReferral");
    return _isShareReferral == "referralForm"
        ? _buildShareReferralContent(context)
        : _isShareReferral == "inPersonRecommendation"
            ? _buildShareExternalContent(context)
            : _buildStandardContent(context);
  }

  bool get _hasSponsoredBy {
    final s = widget.data1Referrer?.sponsoredBy?.trim();
    return s != null && s.isNotEmpty;
  }

  String get _sponsoredByDisplay => widget.data1Referrer!.sponsoredBy!.trim();

  Widget _buildShareReferralContent(BuildContext context) {
    const shareGold = Color(0xFF1D4ED8);
    final initials = widget.name.isNotEmpty ? widget.name[0].toUpperCase() : '';
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          GestureDetector(
            onTap: widget.onHeaderTap,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 45,
                    height: 45,
                    clipBehavior: Clip.hardEdge,
                    decoration: BoxDecoration(
                      // shape: BoxShape.circle,
                      borderRadius: BorderRadius.circular(12),
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xFF2563EB),
                          Color(0xFF1D4ED8),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: widget.data1Referrer?.avatarUrl != null
                        ? Image.network(
                            widget.data1Referrer!.avatarUrl!,
                            fit: BoxFit.cover,
                          )
                        : Center(
                            child: Text(
                              initials,
                              style: stylePoppins(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.name,
                          style: stylePoppins(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            Container(
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(
                                color: shareGold,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              "${widget.data1Referrer?.leadCount ?? "0"} leads envoyés",
                              style: stylePoppins(
                                fontSize: 11.sp,
                                fontWeight: FontWeight.w500,
                                color: Colors.black.withOpacity(0.6),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    widget.isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                    color: shareGold,
                    size: 28,
                  ),
                ],
              ),
            ),
          ),
          if (widget.isExpanded) ...[
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFF1D4ED8).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFF1D4ED8).withOpacity(0.5)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          width: 30,
                          height: 30,
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: shareGold,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: SvgPicture.asset(AppAssets.imgDocument,
                              width: 20, height: 20, color: Colors.white),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          tr(LanguageKeys.referrerSource),
                          style: stylePoppins(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF8A5A00),
                          ),
                        ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 4),
                          decoration: BoxDecoration(
                            color: shareGold,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Text(
                            tr(LanguageKeys.referralForm),
                            textAlign: TextAlign.center,
                            style: stylePoppins(
                              fontSize: 11.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      tr(LanguageKeys.referralFormDescription),
                      style: stylePoppins(
                        fontSize: 12.sp,
                        color: const Color(0xFF72767F),
                        fontWeight: FontWeight.w400,
                      ).copyWith(height: 1.4),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.primary.withOpacity(0.08)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    _buildShareDetailRow(
                      color: const Color(0xFF1D4ED8),
                      icon: AppAssets.imgPhoneActivity,
                      label: tr(LanguageKeys.phoneNumberNetwork),
                      value: widget.data1Referrer?.phoneNumber ?? tr(LanguageKeys.notAvialble),
                    ),
                    const SizedBox(height: 16),
                    _buildShareDetailRow(
                      color: const Color(0xFF1D4ED8),
                      icon: AppAssets.imgEmailactivity,
                      label: tr(LanguageKeys.email),
                      value: widget.data1Referrer?.email ?? tr(LanguageKeys.notAvialble),
                    ),
                    const SizedBox(height: 16),
                    _buildShareDetailRow(
                      color: const Color(0xFF1D4ED8),
                      icon: AppAssets.imgPersonactivity,
                      label: tr(LanguageKeys.companyType),
                      value: widget.data1Referrer?.companyType == "professional"
                          ? tr(LanguageKeys.professional)
                          : widget.data1Referrer?.companyType == "individual"
                              ? tr(LanguageKeys.individual)
                              : tr(LanguageKeys.notAvialble),
                    ),
                    const SizedBox(height: 16),
                    _buildShareDetailRow(
                      color: const Color(0xFF1D4ED8),
                      icon: AppAssets.imgJobActivity,
                      label: tr(LanguageKeys.job),
                      value: widget.data1Referrer?.job ?? tr(LanguageKeys.notAvialble),
                    ),
                    const SizedBox(height: 16),
                    _buildShareDetailRow(
                      color: const Color(0xFF1D4ED8),
                      icon: AppAssets.imgBusniesActivity,
                      label: tr(LanguageKeys.contract),
                      value: widget.data1Referrer?.lastAcceptedDealName ?? tr(LanguageKeys.notAvialble),
                    ),
                    const SizedBox(height: 16),
                    _buildShareDetailRow(
                      color: const Color(0xFF1D4ED8),
                      icon: AppAssets.imgCalanderActivity,
                      label: tr(LanguageKeys.acceptedDate),
                      value: _formatCreatedAt(widget.data1Referrer?.createdAt),
                    ),
                    if (_hasSponsoredBy) ...[
                      const SizedBox(height: 16),
                      _buildShareDetailRow(
                        color: const Color(0xFF1D4ED8),
                        icon: AppAssets.imgActivityPerson,
                        label: tr(LanguageKeys.sponsoredBy),
                        value: _sponsoredByDisplay,
                      ),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedAction = MyActivitySelectedAction.save;
                        });
                        _showSaveContactDialog(context);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        decoration: BoxDecoration(
                          color: _selectedAction == MyActivitySelectedAction.save ? shareGold : Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: shareGold),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              AppAssets.imgSaveActivity,
                              height: 15,
                              color:
                                  _selectedAction == MyActivitySelectedAction.save ? Colors.white : shareGold,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              //"Sauvegarder",
                              tr(LanguageKeys.save),
                              style: stylePoppins(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w600,
                                color: _selectedAction == MyActivitySelectedAction.save
                                    ? Colors.white
                                    : Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedAction = MyActivitySelectedAction.statistics;
                        });
                        Get.toNamed(DetailedStatisticsScreen.pageId, arguments: {
                          'referrer_id': widget.data1Referrer?.id,
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        decoration: BoxDecoration(
                          color: _selectedAction == MyActivitySelectedAction.statistics
                              ? shareGold
                              : Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: shareGold),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.bar_chart,
                              color: _selectedAction == MyActivitySelectedAction.statistics
                                  ? Colors.white
                                  : shareGold,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              // "Statistiques",
                              tr(LanguageKeys.statistics),
                              style: stylePoppins(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w600,
                                color: _selectedAction == MyActivitySelectedAction.statistics
                                    ? Colors.white
                                    : Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // More options button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: GestureDetector(
                onTap: () {
                  // Toggle menu visibility
                  setState(() {
                    _showMoreOptions = !_showMoreOptions;
                  });
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: _showMoreOptions ? shareGold : Colors.grey[300]!),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.more_vert,
                        color: shareGold,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        tr(LanguageKeys.moreOptions),
                        style: stylePoppins(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // Menu items
            if (_showMoreOptions) ...[
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.grey[200]!),
                  ),
                  child: Column(
                    children: [
                      // Share contact item
                      GestureDetector(
                        onTap: () {
                          final contactInfo = _formatContactInfo();
                          Share.share(contactInfo);
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                          child: Row(
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: shareGold.withOpacity(0.1),
                                  shape: BoxShape.rectangle,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Center(
                                  child: Image.asset(
                                    AppAssets.imgShare,
                                    height: 20,
                                    width: 20,
                                    color: shareGold,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Text(
                                tr(LanguageKeys.shareContactInfo),
                                style: stylePoppins(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Divider(
                        height: 1,
                        thickness: 1,
                        color: Colors.grey[200],
                      ),
                      // Delete business referrer item
                      GestureDetector(
                        onTap: () {
                          // Handle delete action
                          final activityController = Get.find<MyActivityController>();
                          showDialog(
                            context: context,
                            builder: (context) => DeleteBusinessReferrerDialog(
                              refererId: widget.data1Referrer?.id,
                              onConfirm: () {
                                if (widget.data1Referrer?.id != null) {
                                  activityController.deleteNetwork(widget.data1Referrer!.id!);
                                }
                              },
                            ),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                          child: Row(
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: Colors.red.withOpacity(0.1),
                                  shape: BoxShape.rectangle,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Center(
                                  child: Image.asset(
                                    AppAssets.imgDeleteicon,
                                    height: 20,
                                    width: 20,
                                    color: Colors.red,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Text(
                                tr(LanguageKeys.deleteBusinessReferrer),
                                style: stylePoppins(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.red,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
            const SizedBox(height: 24),
          ],
        ],
      ),
    );
  }

  Widget _buildShareExternalContent(BuildContext context) {
    const shareGold = Color(0xFFEAB308);
    final initials = widget.name.isNotEmpty ? widget.name[0].toUpperCase() : '';
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          GestureDetector(
            onTap: widget.onHeaderTap,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 45,
                    height: 45,
                    clipBehavior: Clip.hardEdge,
                    decoration: BoxDecoration(
                      // shape: BoxShape.circle,
                      borderRadius: BorderRadius.circular(12),
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xFFFFCE64),
                          Color(0xFFEAB308),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: widget.data1Referrer?.avatarUrl != null
                        ? Image.network(
                            widget.data1Referrer!.avatarUrl!,
                            fit: BoxFit.cover,
                          )
                        : Center(
                            child: Text(
                              initials,
                              style: stylePoppins(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.name,
                          style: stylePoppins(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            Container(
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(
                                color: shareGold,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              "${widget.data1Referrer?.leadCount ?? "0"} leads envoyés",
                              style: stylePoppins(
                                fontSize: 11.sp,
                                fontWeight: FontWeight.w500,
                                color: Colors.black.withOpacity(0.6),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    widget.isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                    color: shareGold,
                    size: 28,
                  ),
                ],
              ),
            ),
          ),
          if (widget.isExpanded) ...[
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF7DC),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFF5D26A)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                            color: shareGold,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.person,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          tr(LanguageKeys.referrerSource),
                          style: stylePoppins(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF8A5A00),
                          ),
                        ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 4),
                          decoration: BoxDecoration(
                            color: shareGold,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Text(
                            tr(LanguageKeys.inPersonRecommendation),
                            textAlign: TextAlign.center,
                            style: stylePoppins(
                              fontSize: 11.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      tr(LanguageKeys.inPersonRecommendationDescription),
                      style: stylePoppins(
                        fontSize: 12.sp,
                        color: const Color(0xFF72767F),
                        fontWeight: FontWeight.w400,
                      ).copyWith(height: 1.4),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.primary.withOpacity(0.08)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    _buildShareDetailRow(
                      color: shareGold,
                      icon: AppAssets.imgPhoneActivity,
                      label: tr(LanguageKeys.phoneNumberNetwork),
                      value: widget.data1Referrer?.phoneNumber ?? tr(LanguageKeys.notAvialble),
                    ),
                    const SizedBox(height: 16),
                    _buildShareDetailRow(
                      color: shareGold,
                      icon: AppAssets.imgEmailactivity,
                      label: tr(LanguageKeys.email),
                      value: widget.data1Referrer?.email ?? tr(LanguageKeys.notAvialble),
                    ),
                    const SizedBox(height: 16),
                    _buildShareDetailRow(
                      color: shareGold,
                      icon: AppAssets.imgPersonactivity,
                      label: tr(LanguageKeys.companyType),
                      value: widget.data1Referrer?.companyType == "professional"
                          ? tr(LanguageKeys.professional)
                          : widget.data1Referrer?.companyType == "individual"
                              ? tr(LanguageKeys.individual)
                              : tr(LanguageKeys.notAvialble),
                    ),
                    const SizedBox(height: 16),
                    _buildShareDetailRow(
                      color: shareGold,
                      icon: AppAssets.imgJobActivity,
                      label: tr(LanguageKeys.job),
                      value: widget.data1Referrer?.job ?? tr(LanguageKeys.notAvialble),
                    ),
                    const SizedBox(height: 16),
                    _buildShareDetailRow(
                      color: shareGold,
                      icon: AppAssets.imgBusniesActivity,
                      label: tr(LanguageKeys.contract),
                      value: widget.data1Referrer?.lastAcceptedDealName ?? tr(LanguageKeys.notAvialble),
                    ),
                    const SizedBox(height: 16),
                    _buildShareDetailRow(
                      color: shareGold,
                      icon: AppAssets.imgCalanderActivity,
                      label: tr(LanguageKeys.acceptedDate),
                      value: _formatCreatedAt(widget.data1Referrer?.createdAt),
                    ),
                    if (_hasSponsoredBy) ...[
                      const SizedBox(height: 16),
                      _buildShareDetailRow(
                        color: shareGold,
                        icon: AppAssets.imgActivityPerson,
                        label: tr(LanguageKeys.sponsoredBy),
                        value: _sponsoredByDisplay,
                      ),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedAction = MyActivitySelectedAction.save;
                        });
                        _showSaveContactDialog(context);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        decoration: BoxDecoration(
                          color: _selectedAction == MyActivitySelectedAction.save
                              ? const Color(0xFFEAB308)
                              : Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: const Color(0xFFEAB308)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              AppAssets.imgSaveActivity,
                              height: 15,
                              color: _selectedAction == MyActivitySelectedAction.save
                                  ? Colors.white
                                  : const Color(0xFFEAB308),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              // "Sauvegarder",
                              tr(LanguageKeys.save),
                              style: stylePoppins(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w600,
                                color: _selectedAction == MyActivitySelectedAction.save
                                    ? Colors.white
                                    : Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedAction = MyActivitySelectedAction.statistics;
                        });
                        Get.toNamed(DetailedStatisticsScreen.pageId, arguments: {
                          'referrer_id': widget.data1Referrer?.id,
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        decoration: BoxDecoration(
                          color: _selectedAction == MyActivitySelectedAction.statistics
                              ? const Color(0xFFEAB308)
                              : Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: const Color(0xFFEAB308)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.bar_chart,
                              color: _selectedAction == MyActivitySelectedAction.statistics
                                  ? Colors.white
                                  : const Color(0xFFEAB308),
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              // "Statistiques",
                              tr(LanguageKeys.statistics),
                              style: stylePoppins(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w600,
                                color: _selectedAction == MyActivitySelectedAction.statistics
                                    ? Colors.white
                                    : Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // More options button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: GestureDetector(
                onTap: () {
                  // Toggle menu visibility
                  setState(() {
                    _showMoreOptions = !_showMoreOptions;
                  });
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: _showMoreOptions ? shareGold : Colors.grey[300]!),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.more_vert,
                        color: shareGold,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        tr(LanguageKeys.moreOptions),
                        style: stylePoppins(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // Menu items
            if (_showMoreOptions) ...[
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.grey[200]!),
                  ),
                  child: Column(
                    children: [
                      // Share contact item
                      GestureDetector(
                        onTap: () {
                          final contactInfo = _formatContactInfo();
                          Share.share(contactInfo);
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                          child: Row(
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: shareGold.withOpacity(0.1),
                                  shape: BoxShape.rectangle,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Center(
                                  child: Image.asset(
                                    AppAssets.imgShare,
                                    height: 20,
                                    width: 20,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Text(
                                tr(LanguageKeys.shareContactInfo),
                                style: stylePoppins(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Divider(
                        height: 1,
                        thickness: 1,
                        color: Colors.grey[200],
                      ),
                      // Delete business referrer item
                      GestureDetector(
                        onTap: () {
                          // Handle delete action
                          final activityController = Get.find<MyActivityController>();
                          showDialog(
                            context: context,
                            builder: (context) => DeleteBusinessReferrerDialog(
                              refererId: widget.data1Referrer?.id,
                              onConfirm: () {
                                if (widget.data1Referrer?.id != null) {
                                  activityController.deleteNetwork(widget.data1Referrer!.id!);
                                }
                              },
                            ),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                          child: Row(
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: Colors.red.withOpacity(0.1),
                                  shape: BoxShape.rectangle,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Center(
                                  child: Image.asset(
                                    AppAssets.imgDeleteicon,
                                    height: 20,
                                    width: 20,
                                    color: Colors.red,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Text(
                                tr(LanguageKeys.deleteBusinessReferrer),
                                style: stylePoppins(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.red,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
            const SizedBox(height: 24),
          ],
        ],
      ),
    );
  }

  Widget _buildStandardContent(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header section
          GestureDetector(
            onTap: widget.onHeaderTap,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  // Avatar with letter
                  Container(
                    width: 45,
                    height: 45,
                    clipBehavior: Clip.hardEdge,
                    decoration: BoxDecoration(
                      // shape: BoxShape.circle,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey[200]!),
                      color: Colors.white,
                    ),
                    child: widget.data1Referrer?.avatarUrl != null
                        ? Image.network(
                            widget.data1Referrer?.avatarUrl ?? "",
                            fit: BoxFit.cover,
                          )
                        : Container(
                            width: 45,
                            height: 45,
                            decoration: BoxDecoration(
                              color: Colors.grey[400],
                              // shape: BoxShape.circle,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Image.asset(AppAssets.imgDefaultPerson),
                          ),
                  ),
                  const SizedBox(width: 16),
                  // Name and leads count
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.name,
                          style: stylePoppins(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 6),
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
                            const SizedBox(width: 8),
                            Text(
                              "${widget.data1Referrer?.leadCount ?? "0"} leads envoyés",
                              style: stylePoppins(
                                fontSize: 11.sp,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // Expand/collapse arrow
                  Icon(
                    widget.isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                    color: AppColors.grey600,
                    size: 32,
                  ),
                ],
              ),
            ),
          ),

          // Expanded content
          if (widget.isExpanded) ...[
            // Source section
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFF5F3FF),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        width: 25,
                        height: 25,
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: const Icon(
                          Icons.link,
                          color: Colors.white,
                          size: 15,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Source du contact",
                            style: stylePoppins(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          tr(LanguageKeys.viaReferaly),
                          style: stylePoppins(
                            fontSize: 8.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Ce contact a été ajouté via la plateforme Referaly et bénéficie de toutes les fonctionnalités de suivi automatisé.",
                    style: stylePoppins(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w400,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Contact details
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  _buildDetailRow(
                    icon: AppAssets.imgPhoneActivity,
                    iconColor: AppColors.primary,
                    label: tr(LanguageKeys.phoneNumberNetwork),
                    value: widget.data1Referrer?.phoneNumber ?? tr(LanguageKeys.notAvialble),
                  ),
                  const SizedBox(height: 20),
                  _buildDetailRow(
                    icon: AppAssets.imgEmailactivity,
                    iconColor: AppColors.primary,
                    label: tr(LanguageKeys.email),
                    value: widget.data1Referrer?.email ?? tr(LanguageKeys.notAvialble),
                  ),
                  const SizedBox(height: 20),
                  _buildDetailRow(
                    icon: AppAssets.imgPersonactivity,
                    iconColor: AppColors.primary,
                    label: tr(LanguageKeys.companyType),
                    value: widget.data1Referrer?.companyType == "professional"
                        ? tr(LanguageKeys.professional)
                        : widget.data1Referrer?.companyType == "individual"
                            ? tr(LanguageKeys.individual)
                            : tr(LanguageKeys.notAvialble),
                  ),
                  const SizedBox(height: 20),
                  _buildDetailRow(
                    icon: AppAssets.imgJobActivity,
                    iconColor: AppColors.primary,
                    label: tr(LanguageKeys.job),
                    value: widget.data1Referrer?.job ?? tr(LanguageKeys.notAvialble),
                  ),
                  const SizedBox(height: 20),
                  _buildDetailRow(
                    icon: AppAssets.imgBusniesActivity,
                    iconColor: AppColors.primary,
                    label: tr(LanguageKeys.contract),
                    value: widget.data1Referrer?.lastAcceptedDealName ?? tr(LanguageKeys.notAvialble),
                  ),
                  const SizedBox(height: 20),
                  _buildDetailRow(
                    icon: AppAssets.imgCalanderActivity,
                    iconColor: AppColors.primary,
                    label: tr(LanguageKeys.acceptedDate),
                    value: _formatCreatedAt(widget.data1Referrer?.createdAt),
                  ),
                  if (_hasSponsoredBy) ...[
                    const SizedBox(height: 20),
                    _buildDetailRow(
                      icon: AppAssets.imgActivityPerson,
                      iconColor: AppColors.primary,
                      label: tr(LanguageKeys.sponsoredBy),
                      value: _sponsoredByDisplay,
                    ),
                  ],
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Action buttons
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          // Unselect statistics and select save
                          _selectedAction = MyActivitySelectedAction.save;
                        });
                        _showSaveContactDialog(context);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColors.primary),
                          borderRadius: BorderRadius.circular(12),
                          color: _selectedAction == MyActivitySelectedAction.save
                              ? AppColors.primary
                              : AppColors.primary.withOpacity(0.1),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              AppAssets.imgSaveActivity,
                              height: 15,
                              color: _selectedAction == MyActivitySelectedAction.save
                                  ? Colors.white
                                  : AppColors.primary,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              // "Sauvegarder",
                              tr(LanguageKeys.save),
                              style: stylePoppins(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w600,
                                color: _selectedAction == MyActivitySelectedAction.save
                                    ? Colors.white
                                    : AppColors.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          // Unselect save and select statistics
                          _selectedAction = MyActivitySelectedAction.statistics;
                        });
                        Get.toNamed(DetailedStatisticsScreen.pageId, arguments: {
                          'referrer_id': widget.data1Referrer?.id,
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: _selectedAction == MyActivitySelectedAction.statistics
                              ? AppColors.primary
                              : AppColors.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.primary),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.bar_chart,
                              color: _selectedAction == MyActivitySelectedAction.statistics
                                  ? Colors.white
                                  : AppColors.primary,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              // "Statistiques",
                              tr(LanguageKeys.statistics),
                              style: stylePoppins(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w600,
                                color: _selectedAction == MyActivitySelectedAction.statistics
                                    ? Colors.white
                                    : AppColors.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // More options button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: GestureDetector(
                onTap: () {
                  // Toggle menu visibility
                  setState(() {
                    _showMoreOptions = !_showMoreOptions;
                  });
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: _showMoreOptions ? AppColors.primary : Colors.grey[300]!),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.more_vert,
                        color: AppColors.primary,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        tr(LanguageKeys.moreOptions),
                        style: stylePoppins(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // Menu items
            if (_showMoreOptions) ...[
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.grey[200]!),
                  ),
                  child: Column(
                    children: [
                      // Share contact item
                      GestureDetector(
                        onTap: () {
                          final contactInfo = _formatContactInfo();
                          Share.share(contactInfo);
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                          child: Row(
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: AppColors.primary.withOpacity(0.1),
                                  shape: BoxShape.rectangle,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Center(
                                  child: Image.asset(
                                    AppAssets.imgShare,
                                    height: 20,
                                    width: 20,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Text(
                                tr(LanguageKeys.shareContactInfo),
                                style: stylePoppins(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Divider(
                        height: 1,
                        thickness: 1,
                        color: Colors.grey[200],
                      ),
                      // Delete business referrer item
                      GestureDetector(
                        onTap: () {
                          // Handle delete action
                          final activityController = Get.find<MyActivityController>();
                          showDialog(
                            context: context,
                            builder: (context) => DeleteBusinessReferrerDialog(
                              refererId: widget.data1Referrer?.id,
                              onConfirm: () {
                                if (widget.data1Referrer?.id != null) {
                                  activityController.deleteNetwork(widget.data1Referrer!.id!);
                                }
                              },
                            ),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                          child: Row(
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: Colors.red.withOpacity(0.1),
                                  shape: BoxShape.rectangle,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Center(
                                  child: Image.asset(
                                    AppAssets.imgDeleteicon,
                                    height: 20,
                                    width: 20,
                                    color: Colors.red,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Text(
                                tr(LanguageKeys.deleteBusinessReferrer),
                                style: stylePoppins(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.red,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
            const SizedBox(height: 24),
          ],
        ],
      ),
    );
  }

  Widget _buildDetailRow({
    required String icon,
    required Color iconColor,
    required String label,
    required String value,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 32,
          height: 32,
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: iconColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: SvgPicture.asset(
            icon,
            color: iconColor,
            width: 4,
            height: 4,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: stylePoppins(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: stylePoppins(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildShareDetailRow({
    required Color color,
    required String icon,
    required String label,
    required String value,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 40,
          height: 40,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: SvgPicture.asset(
            icon,
            color: color,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: stylePoppins(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500,
                  color: Colors.black.withOpacity(0.6),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: stylePoppins(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget dataOld(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: widget.onHeaderTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 45,
                  height: 45,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey[200]!),
                    color: Colors.white,
                  ),
                  child: widget.data1Referrer?.avatarUrl != null
                      ? Image.network(
                          widget.data1Referrer?.avatarUrl ?? "",
                          fit: BoxFit.cover,
                        )
                      : Container(
                          width: 45,
                          height: 45,
                          decoration: BoxDecoration(
                            color: Colors.grey[400],
                            shape: BoxShape.circle,
                          ),
                          child: Image.asset(AppAssets.imgDefaultPerson),
                        ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        widget.name,
                        style: stylePoppins(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Container(
                            width: 10,
                            height: 10,
                            decoration: const BoxDecoration(
                              color: AppColors.primary,
                              shape: BoxShape.circle,
                            ),
                          ),

                          // SvgPicture.asset(
                          //   AppAssets.imgHomeSent,
                          //   height: 16,
                          // ),
                          const SizedBox(width: 8),
                          Text(
                            widget.data1Referrer?.leadCount ?? "",
                            style: stylePoppins(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Icon(
                  widget.isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                  color: AppColors.grey600,
                  size: 28,
                ),
              ],
            ),
          ),
        ),
        if (widget.isExpanded)
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[200]!),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _infoRow(
                  icon: AppAssets.imgPhone,
                  label: tr(LanguageKeys.phoneNumber),
                  value: widget.data1Referrer?.phoneNumber ?? "",
                  context: context,
                  isLink: true,
                ),
                const Divider(height: 24),
                _infoRow(
                  icon: AppAssets.imgEmailIcon,
                  label: tr(LanguageKeys.email),
                  value: widget.data1Referrer?.email ?? "",
                  context: context,
                  isLink: true,
                ),
                const Divider(height: 24),
                _infoRow(
                  icon: AppAssets.imgCalendar,
                  label: tr(LanguageKeys.lastContractAccepted),
                  value: widget.data1Referrer?.lastAcceptedDealName ?? "",
                  context: context,
                ),
                const Divider(height: 24),
                _infoRow(
                  icon: AppAssets.imgContract,
                  label: tr(LanguageKeys.acceptedDate),
                  value: widget.data1Referrer?.createdAt ?? "",
                  context: context,
                  isDate: true,
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
      ],
    );
  }

  String _formatCreatedAt(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return '';
    try {
      final date = DateTime.parse(dateStr);
      return DateFormat('dd/MM/yyyy').format(date);
    } catch (e) {
      return dateStr;
    }
  }

  Widget _infoRow({
    required String icon,
    required String label,
    required String value,
    required BuildContext context,
    bool isLink = false,
    bool isDate = false,
  }) {
    final displayValue = isDate ? _formatCreatedAt(value) : value;
    final isClickable = isLink && value.isNotEmpty && value != "Not Provided";
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            width: 22,
            height: 22,
            child: SvgPicture.asset(
              icon,
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: stylePoppins(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textTitleHint,
                  ),
                ),
                const SizedBox(height: 2),
                isClickable
                    ? GestureDetector(
                        onTap: () async {
                          if (label.toLowerCase() == tr(LanguageKeys.email).toLowerCase()) {
                            final Uri emailUri = Uri(scheme: 'mailto', path: value);
                            if (await canLaunchUrl(emailUri)) {
                              await launchUrl(emailUri);
                            }
                          } else if (label.toLowerCase() == tr(LanguageKeys.phoneNumber).toLowerCase()) {
                            final Uri phoneUri = Uri(scheme: 'tel', path: value);
                            if (await canLaunchUrl(phoneUri)) {
                              await launchUrl(phoneUri);
                            }
                          }
                        },
                        child: Text(
                          displayValue != "Not Provided" ? displayValue : tr(LanguageKeys.nullDataText),
                          style: stylePoppins(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w500,
                            color: AppColors.primary,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          textAlign: TextAlign.left,
                        ),
                      )
                    : Text(
                        displayValue != "Not Provided" ? displayValue : tr(LanguageKeys.nullDataText),
                        maxLines: 2,
                        style: stylePoppins(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w500,
                        ),
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.left,
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showSaveContactDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 20),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header with close button
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.close,
                          color: Colors.black,
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Profile Picture Section
              Center(
                child: Stack(
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.grey[200]!, width: 2),
                      ),
                      child: widget.data1Referrer?.avatarUrl != null
                          ? ClipOval(
                              child: Image.network(
                                widget.data1Referrer!.avatarUrl!,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    decoration: BoxDecoration(
                                      color: Colors.grey[400],
                                      shape: BoxShape.circle,
                                    ),
                                    child: Image.asset(AppAssets.imgDefaultPerson),
                                  );
                                },
                              ),
                            )
                          : Container(
                              decoration: BoxDecoration(
                                color: Colors.grey[400],
                                shape: BoxShape.circle,
                              ),
                              child: Image.asset(AppAssets.imgDefaultPerson),
                            ),
                    ),
                    // Online indicator
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          color: Colors.green,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Name
              Text(
                widget.name,
                style: stylePoppins(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 24),

              // Contact Information Fields
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  children: [
                    // Phone Field
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey[200]!),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 30,
                            height: 30,
                            decoration: BoxDecoration(
                              color: AppColors.primary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(
                              Icons.phone,
                              color: AppColors.primary,
                              size: 15,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  tr(LanguageKeys.phoneNumber),
                                  style: stylePoppins(
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.grey[600],
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  widget.data1Referrer?.phoneNumber ?? tr(LanguageKeys.notAvialble),
                                  style: stylePoppins(
                                    fontSize: 13.sp,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          GestureDetector(
                            onTap: () async {
                              final Uri phoneUri =
                                  Uri(scheme: 'tel', path: widget.data1Referrer?.phoneNumber);
                              if (await canLaunchUrl(phoneUri)) {
                                await launchUrl(phoneUri);
                              }
                            },
                            child: Container(
                              width: 30,
                              height: 30,
                              decoration: BoxDecoration(
                                color: AppColors.primary,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(
                                Icons.phone,
                                color: Colors.white,
                                size: 15,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Email Field
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey[200]!),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 30,
                            height: 30,
                            decoration: BoxDecoration(
                              color: AppColors.primary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(
                              Icons.email,
                              color: AppColors.primary,
                              size: 15,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  tr(LanguageKeys.email),
                                  style: stylePoppins(
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.grey[600],
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  widget.data1Referrer?.email ?? tr(LanguageKeys.notAvialble),
                                  style: stylePoppins(
                                    fontSize: 13.sp,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          GestureDetector(
                            onTap: () async {
                              final Uri emailUri = Uri(scheme: 'mailto', path: widget.data1Referrer?.email);
                              if (await canLaunchUrl(emailUri)) {
                                await launchUrl(emailUri);
                              }
                            },
                            child: Container(
                              width: 30,
                              height: 30,
                              decoration: BoxDecoration(
                                color: AppColors.primary,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(
                                Icons.email,
                                color: Colors.white,
                                size: 15,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Add Contact Button
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                child: Center(
                  child: GestureDetector(
                    onTap: () {
                      // TODO: Implement add contact functionality
                      Navigator.of(context).pop();
                      // Show success message
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            "Contact ajouté avec succès",
                            style: stylePoppins(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                          ),
                          backgroundColor: AppColors.primary,
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.person_add_alt_1,
                            color: Colors.white,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            "Ajouter le contact",
                            style: stylePoppins(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// =============================================================================
// UPLOAD FILE POPUP
// =============================================================================

class UploadFilePopup extends StatefulWidget {
  final String id;

  const UploadFilePopup({super.key, required this.id});

  @override
  State<UploadFilePopup> createState() => _UploadFilePopupState();
}

class _UploadFilePopupState extends State<UploadFilePopup> {
  // ---------------------------------------------------------------------------
  // STATE VARIABLES
  // ---------------------------------------------------------------------------

  List<PlatformFile> selectedFiles = [];
  Map<String, TextEditingController> fileNameControllers = {};
  Set<String> editingFiles = {};
  bool notifyNetwork = true;
  final MyActivityController controller = Get.find();

  // ---------------------------------------------------------------------------
  // LIFECYCLE METHODS
  // ---------------------------------------------------------------------------

  @override
  void dispose() {
    for (var controller in fileNameControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  // ---------------------------------------------------------------------------
  // FILE PICKER METHOD
  // ---------------------------------------------------------------------------

  Future<void> pickPdfFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
      allowMultiple: true,
    );

    if (result != null && result.files.isNotEmpty) {
      setState(() {
        for (var file in result.files) {
          if (!selectedFiles.any((f) => f.path == file.path)) {
            selectedFiles.add(file);

            // Remove .pdf extension for editing
            final baseName =
                file.name.endsWith('.pdf') ? file.name.substring(0, file.name.length - 4) : file.name;

            fileNameControllers[file.identifier ?? file.path ?? file.name] =
                TextEditingController(text: baseName);
          }
        }
      });
    } else {
      print('File picking cancelled.');
    }
  }

  // ---------------------------------------------------------------------------
  // BUILD METHOD
  // ---------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: Colors.white,
      insetPadding: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.8,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildDialogHeader(),
                const SizedBox(height: 24),
                _buildFileSelectionArea(),
                const SizedBox(height: 16),
                _buildSelectedFilesList(),
                _buildNotificationCheckbox(),
                const SizedBox(height: 16),
                _buildSubmitButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // DIALOG COMPONENTS
  // ---------------------------------------------------------------------------

  Widget _buildDialogHeader() {
    return Row(
      children: [
        const Spacer(),
        Text(
          tr(LanguageKeys.uploadFile),
          style: stylePoppins(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        const Spacer(),
        GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: const Icon(Icons.close),
        ),
      ],
    );
  }

  Widget _buildFileSelectionArea() {
    return GestureDetector(
      onTap: pickPdfFile,
      child: DottedBorder(
        color: Colors.grey,
        strokeWidth: 1.5,
        borderType: BorderType.RRect,
        radius: const Radius.circular(6),
        dashPattern: const [5, 3],
        child: Container(
          height: 130,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.insert_drive_file, size: 32, color: Colors.grey),
                const SizedBox(height: 8),
                Text(tr(LanguageKeys.browseFile)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSelectedFilesList() {
    if (selectedFiles.isEmpty) return const SizedBox.shrink();

    return SizedBox(
      height: 160,
      child: Scrollbar(
        thumbVisibility: true,
        child: ListView(
          children: selectedFiles.map((file) {
            return _buildFileListItem(file);
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildFileListItem(PlatformFile file) {
    final key = file.identifier ?? file.path ?? file.name;
    final isEditing = editingFiles.contains(key);

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      child: Row(
        children: [
          Image.asset(AppAssets.imgPdf, height: 28.h, width: 28.w),
          const SizedBox(width: 10),
          Expanded(child: _buildFileNameField(key, isEditing)),
          const SizedBox(width: 8),
          const Text('.pdf', style: TextStyle(fontSize: 15)),
          const SizedBox(width: 8),
          _buildEditButton(key),
          const SizedBox(width: 8),
          _buildDeleteButton(file, key),
        ],
      ),
    );
  }

  Widget _buildFileNameField(String key, bool isEditing) {
    if (isEditing) {
      return FocusScope(
        child: Focus(
          onFocusChange: (hasFocus) {
            if (!hasFocus) {
              setState(() {
                editingFiles.remove(key);
              });
            }
          },
          child: TextField(
            controller: fileNameControllers[key],
            autofocus: true,
            decoration: const InputDecoration(
              isDense: true,
              contentPadding: EdgeInsets.zero,
              border: InputBorder.none,
            ),
            style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
            onSubmitted: (_) {
              setState(() {
                editingFiles.remove(key);
              });
            },
          ),
        ),
      );
    }

    return GestureDetector(
      onTap: () {
        // Disabled tap to edit
      },
      child: Text(
        fileNameControllers[key]?.text ?? '',
        style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
      ),
    );
  }

  Widget _buildEditButton(String key) {
    return GestureDetector(
      onTap: () {
        setState(() {
          editingFiles.add(key);
        });
      },
      child: const Icon(Icons.edit, color: AppColors.primary, size: 20),
    );
  }

  Widget _buildDeleteButton(PlatformFile file, String key) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedFiles.remove(file);
          fileNameControllers[key]?.dispose();
          fileNameControllers.remove(key);
          editingFiles.remove(key);
        });
      },
      child: const Icon(Icons.delete, color: AppColors.primary, size: 20),
    );
  }

  Widget _buildNotificationCheckbox() {
    return Row(
      children: [
        Checkbox(
          value: notifyNetwork,
          onChanged: (val) => setState(() => notifyNetwork = val ?? true),
          activeColor: AppColors.primary,
        ),
        Obx(() => Text(tr(LanguageKeys.uploadAndNotify))),
      ],
    );
  }

  Widget _buildSubmitButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      onPressed: selectedFiles.isEmpty ? null : _handleSubmit,
      child: Obx(() => Text(
            tr(LanguageKeys.assignModalSubmit),
            style: stylePoppins(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          )),
    );
  }

  // ---------------------------------------------------------------------------
  // SUBMIT HANDLER
  // ---------------------------------------------------------------------------

  Future<void> _handleSubmit() async {
    Navigator.of(context).pop();

    // Collect all files with valid paths and apply new names
    final files = <File>[];
    final renamedFiles = <String, String>{};

    for (var file in selectedFiles) {
      if (file.path != null) {
        files.add(File(file.path!));
        final key = file.identifier ?? file.path ?? file.name;
        final newName = fileNameControllers[key]?.text.trim();

        if (newName != null && newName.isNotEmpty) {
          renamedFiles[file.path!] = newName.endsWith('.pdf') ? newName : '$newName.pdf';
        } else {
          renamedFiles[file.path!] = file.name;
        }
      }
    }

    if (files.isNotEmpty) {
      await controller.uploadDocument(
        widget.id,
        notifyNetwork == true ? '1' : '0',
        files,
        renamedFiles: renamedFiles,
      );
    }
  }
}
