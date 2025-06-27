import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:referaly/controller/my_activity_controller.dart';
import 'package:referaly/languages/languagekeys.dart';
import 'package:referaly/models/model_contact_response.dart';
import 'package:referaly/models/model_coworkerlist_deal.dart';
import 'package:referaly/models/model_network_response.dart';
import 'package:referaly/resources/app_assets.dart';
import 'package:referaly/resources/app_colors.dart';
import 'package:referaly/resources/app_helper.dart';
import 'package:referaly/resources/app_preference.dart';
import 'package:referaly/resources/text_style.dart';
import 'package:referaly/screens/active_goal_screen.dart';
import 'package:referaly/screens/dashboard/add_coworker_dialog.dart';
import 'package:referaly/screens/dashboard/membership_screen.dart';
import 'package:referaly/screens/deals/business_referrer_contract_screen.dart';
import 'package:referaly/screens/referrers_screen.dart';
import 'package:referaly/screens/send_notification_screen.dart';
import 'package:referaly/utils/translations.dart';
import 'package:referaly/widgets/dialog/activity_info_dialog.dart';
import 'package:referaly/widgets/dialog/like_add_coworker_dialog.dart';
import 'package:referaly/widgets/dialog/premium_upgrade_dialog.dart';
import 'package:referaly/widgets/share_popup.dart';
import 'package:url_launcher/url_launcher.dart';

import '../document_screen.dart';

class MyActivityScreen extends StatefulWidget {
  static String pageId = "/myActivity";
  final int initialPage;

  const MyActivityScreen({super.key, this.initialPage = 0});

  @override
  State<MyActivityScreen> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyActivityScreen> {
  late MyActivityController controller;
  int? expandedIndex;
  int? expandedReferrerIndex;

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
                  // Page 0 - My Deals
                  buildDealsListView(),

                  // Page 1 - My Network
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
                      color: controller.isMyContractsSelected.value
                          ? AppColors.primary
                          : AppColors.transparent,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      tr(LanguageKeys.myPrograms),
                      style: stylePoppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: controller.isMyContractsSelected.value
                            ? Colors.white
                            : Colors.grey,
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () => controller.toggleTabSelection(false),
                  child: Container(
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
                        color: controller.isMyContractsSelected.value
                            ? Colors.grey
                            : Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // Deals List View (My Contracts tab)
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
                        itemCount:
                            controller.contactList.value?.data?.length ?? 0,
                        itemBuilder: (context, index) {
                          final contract =
                              controller.contactList.value?.data?[index];
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
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 12, horizontal: 16),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          tr(LanguageKeys.companyDetailsMydeal),
                                          style: const TextStyle(
                                              fontWeight: FontWeight.w500),
                                        ),
                                        Icon(
                                          expandedIndex == index
                                              ? Icons.remove
                                              : Icons.add,
                                          size: 20,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                if (expandedIndex == index)
                                  Container(
                                    width: double.infinity,
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 8),
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text(tr(LanguageKeys.commision),
                                            style: const TextStyle(
                                                fontWeight: FontWeight.w500)),
                                        Text(
                                          contract?.commissionType ==
                                                  "no_commission"
                                              ? tr(LanguageKeys.no_commission)
                                              : contract?.commissionType ==
                                                      "fix_commission"
                                                  ? ("${tr(LanguageKeys.fix_commission)} : ${contract?.commissionValue ?? ""} €")
                                                  : ("${tr(LanguageKeys.percentage_commission)}  : ${contract?.commissionValue ?? ""} % HT du montant facturé"),
                                        ),
                                        // Add more details as needed
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
                  Get.toNamed(BusinessReferrerContractScreen.pageId,
                      arguments: {
                        'is_edit': false,
                      })?.then((value) {
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

  Widget buildDealHeader(
      {required String title,
      required String referrer,
      required String id,
      required int index}) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: controller.contactList.value?.data?[index].createdDetail
                        ?.companyLogoUrl?.isNotEmpty ==
                    true
                ? Image.network(
                    controller.contactList.value?.data?[index].createdDetail!
                            .companyLogoUrl ??
                        '',
                    width: 48,
                    height: 48,
                    fit: BoxFit.cover,
                  )
                : Container(
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
                  AppHelper.showLog(
                      "${controller.contactList.value?.data?[index].documentUrl ?? ''}"),
                  controller.openPdfBottomSheet(
                      context,
                      controller.contactList.value?.data?[index].documentUrl ??
                          '')
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
                icon: Icon(Icons.more_vert, color: AppColors.primary),
                onSelected: (value) {
                  if (value == 'delete') {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        backgroundColor: Colors.white,
                        insetPadding:
                            const EdgeInsets.symmetric(horizontal: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        contentPadding:
                            const EdgeInsets.fromLTRB(40, 32, 40, 0),
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
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 14),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          border: Border.all(
                                              color: Colors.black, width: 1),
                                        ),
                                        child: Center(
                                          child: Text(tr(LanguageKeys.cancel),
                                              style: stylePoppins(
                                                  color: Colors.black)),
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
                                        controller.deleteContract(id).then(
                                            (value) =>
                                                controller.getContactList());
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 14),
                                        decoration: BoxDecoration(
                                          color: AppColors.primary,
                                          borderRadius:
                                              BorderRadius.circular(5),
                                        ),
                                        child: Center(
                                          child: Text(tr(LanguageKeys.yes),
                                              style: stylePoppins(
                                                  color: Colors.white)),
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
                  'commission_type': contract?.commissionType ?? '',
                  'track_names': contract?.dealSteps ?? [],
                  'commission_value': contract?.commissionValue ?? '',
                })?.then((value) {
                  if (value == true) {
                    controller.getContactList();
                  }
                });
              },
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.primary,
                side: BorderSide(color: AppColors.primary),
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
      padding: const EdgeInsets.symmetric(vertical: 15),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Obx(
            () => Text(
              controller.networkList.value?.data?.totalBusinessReferrers
                      .toString() ??
                  "0",
              style: stylePoppins(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 5),
          Image.asset(AppAssets.imgReferrelsPeople, height: 60),
          const SizedBox(height: 5),
          Text(
            tr(LanguageKeys.referreals),
            style: stylePoppins(
              fontSize: 20.sp,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 5),
        ],
      ),
    );
  }

  Widget buildActionButtonsRow() {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border:
              Border.all(color: AppColors.primary.withOpacity(0.2), width: 1)),
      padding: const EdgeInsets.fromLTRB(0, 5, 0, 10),
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: SizedBox(
        width: Get.width - 50,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            GestureDetector(
                onTap: () => Get.dialog(const ActivityInfoDialog()),
                child: Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: Icon(
                    Icons.info_outline,
                    color: AppColors.primary,
                    size: 20,
                  ),
                )),
            Row(
              children: [
                singlePrItem(
                    image: AppAssets.imgRefreal,
                    isBlue: true,
                    onTap: () {
                      // Get.dialog(AddCoworkerDialog());
                      if (AppPreference.readString(AppPreference.isPaid) !=
                          "3") {
                        Get.dialog(PremiumUpgradeDialog(
                          onSeeOffers: () {
                            Get.back();
                            Get.toNamed(MembershipScreen.pageId);
                          },
                        ));
                      } else {
                        Get.toNamed(ReferrersScreen.pageId);
                      }
                    },
                    scale:4.1,
                    request: controller.referrers.length,
                    type: "referal"),
                singlePrItem(
                    image: AppAssets.imgAddDoc,
                    isBlue: false,
                    onTap: () {
                      if (AppPreference.readString(AppPreference.isPaid) ==
                          "0") {
                        Get.dialog(PremiumUpgradeDialog(
                          onSeeOffers: () {
                            Get.back();
                            Get.toNamed(MembershipScreen.pageId);
                          },
                        ));
                      } else {
                        Get.toNamed(ActiveGoalScreen.pageId);
                      }
                    },
                    scale: 4.1,
                    type: ""),
                singlePrItem(
                    image: AppAssets.imgShare,
                    isBlue: false,
                    onTap: () {
                      if (controller.userDealList.value?.data?.length == 0) {
                        return;
                      }
                      if (controller.userDealList.value?.data?.length == 1) {
                        Get.dialog(
                          SharePopup(
                            title: controller
                                    .userDealList.value?.data?[0].dealName ??
                                '',
                            link: controller
                                    .userDealList.value?.data?[0].inviteLink ??
                                '',
                          ),
                        );
                      } else {
                        Get.dialog(LikeAddCoworkerDialog(
                          coworkers: controller.userDealList.value?.data ?? [],
                          onQrTap: (index) {
                            Get.back();
                            Get.dialog(
                              SharePopup(
                                title: controller.userDealList.value
                                        ?.data?[index].dealName ??
                                    '',
                                link: controller.userDealList.value
                                        ?.data?[index].inviteLink ??
                                    '',
                              ),
                            );
                          },
                        ));
                      }
                    },
                    scale: 4.1,
                    type: ""),
                singlePrItem(
                    image: AppAssets.imgAddNotification,
                    isBlue: false,
                    onTap: () {
                      if (AppPreference.readString(AppPreference.isPaid) ==
                          "0") {
                        Get.dialog(PremiumUpgradeDialog(
                          onSeeOffers: () {
                            Get.back();
                            Get.toNamed(MembershipScreen.pageId);
                          },
                        ));
                      } else {
                        Get.toNamed(SendNotificationScreen.pageId);
                      }
                    },
                    scale: 4.1,
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
      required VoidCallback onTap,
      int request = 0,
      required bool isBlue,
      required double scale,
      String? type}) {
    final width = ((Get.width - 62) / 4);
    const double imageContaierHeight = 60;
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: width,
        height: 70,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
              left: 10,
              top: 10,
              child: Container(
                width: width - 10,
                height: imageContaierHeight,
                child: Image.asset(image,
                    scale: scale, color: AppColors.primary.withOpacity(0.9)),
              ),
            ),
            if (type == "referal" &&
                AppPreference.readString(AppPreference.isPaid) != "3")
              Positioned(
                left: 10,
                top: 0,
                child: SvgPicture.asset(AppAssets.imgHomeCrown,
                    height: 18, color: AppColors.blueColor),
              ),
            if (AppPreference.readString(AppPreference.isPaid) == "0")
              Positioned(
                left: 10,
                top: 0,
                child: SvgPicture.asset(
                    isBlue ? AppAssets.imgpointBlue : AppAssets.imgHomeCrown,
                    height: 18),
              ),
            Obx(
              () => controller.referrers.length != 0 && request != 0
                  ? Positioned(
                      right: 15,
                      bottom: 5,
                      child: Container(
                        decoration: BoxDecoration(
                            shape: BoxShape.circle, color: AppColors.pdfBg),
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
        () => controller.networkList.value?.data?.businessReferrers!.length != 0
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    tr(LanguageKeys.bussinessreferrence),
                    style: stylePoppins(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Obx(
                    () => ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: controller.networkList.value?.data
                              ?.businessReferrers!.length ??
                          0,
                      itemBuilder: (context, index) {
                        return ReferrerListItem(
                          data1Referrer: controller.networkList.value?.data
                              ?.businessReferrers![index],
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
                  padding:
                      const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
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

  Widget buildVersionInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppPreference.readString(AppPreference.isPaid) == "0"
            ? Center(
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
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
          () => (controller
                          .networkList.value?.data?.businessReferrers?.length ??
                      0) >
                  6
              ? Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: SizedBox(
                    width: double.infinity,
                    child: GestureDetector(
                      onTap: () {
                        if (AppPreference.readString(AppPreference.isPaid) !=
                            "0") {
                          Get.toNamed(ReferrersScreen.pageId);
                        } else {
                          Get.dialog(PremiumUpgradeDialog(
                            onSeeOffers: () {
                              Get.back();
                              Get.toNamed(MembershipScreen.pageId);
                            },
                          ));
                        }
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.whiteColor,
                          borderRadius: BorderRadius.circular(8),
                          border:
                              Border.all(color: AppColors.primary, width: 1),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        child: Center(
                          child: Text(
                            tr(LanguageKeys.seeAll),
                            style: stylePoppins(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              : const SizedBox.shrink(),
        ),
      ],
    );
  }
}

class ReferrerListItem extends StatelessWidget {
  final String name;
  final bool showPrimium;
  final BusinessReferrers? data1Referrer;
  final bool isExpanded;
  final VoidCallback? onHeaderTap;
  const ReferrerListItem({
    super.key,
    required this.name,
    this.showPrimium = false,
    this.data1Referrer,
    this.isExpanded = false,
    this.onHeaderTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onHeaderTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: const Color(0xFFF3E9FB), // Light purple
          borderRadius: BorderRadius.circular(16),
        ),
        child: Stack(
          children: [
            data(context),
            if (showPrimium)
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
    return Column(
      children: [
        GestureDetector(
          onTap: onHeaderTap,
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
                  child: data1Referrer?.avatarUrl != null
                      ? Image.network(
                          data1Referrer?.avatarUrl ?? "",
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
                        name,
                        style: stylePoppins(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          SvgPicture.asset(
                            AppAssets.imgHomeSent,
                            height: 16,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            data1Referrer?.leadCount ?? "",
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
                  isExpanded
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                  size: 28,
                ),
              ],
            ),
          ),
        ),
        if (isExpanded)
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
                  value: data1Referrer?.phoneNumber ?? "",
                  context: context,
                  isLink: true,
                ),
                const Divider(height: 24),
                _infoRow(
                  icon: AppAssets.imgEmailIcon,
                  label: tr(LanguageKeys.email),
                  value: data1Referrer?.email ?? "",
                  context: context,
                  isLink: true,
                ),
                const Divider(height: 24),
                _infoRow(
                  icon: AppAssets.imgCalendar,
                  label: tr(LanguageKeys.lastContractAccepted),
                  value: data1Referrer?.lastAcceptedDealName ?? "",
                  context: context,
                ),
                const Divider(height: 24),
                _infoRow(
                  icon: AppAssets.imgContract,
                  label: tr(LanguageKeys.acceptedDate),
                  value: data1Referrer?.createdAt ?? "",
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
                          if (label.toLowerCase() ==
                              tr(LanguageKeys.email).toLowerCase()) {
                            final Uri emailUri =
                                Uri(scheme: 'mailto', path: value);
                            if (await canLaunchUrl(emailUri)) {
                              await launchUrl(emailUri);
                            }
                          } else if (label.toLowerCase() ==
                              tr(LanguageKeys.phoneNumber).toLowerCase()) {
                            final Uri phoneUri =
                                Uri(scheme: 'tel', path: value);
                            if (await canLaunchUrl(phoneUri)) {
                              await launchUrl(phoneUri);
                            }
                          }
                        },
                        child: Text(
                          displayValue != "Not Provided"
                              ? displayValue
                              : tr(LanguageKeys.noProvided),
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
                        displayValue != "Not Provided"
                            ? displayValue
                            : tr(LanguageKeys.noProvided),
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
}
