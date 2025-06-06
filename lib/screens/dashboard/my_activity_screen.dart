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

  const MyActivityScreen({super.key});

  @override
  State<MyActivityScreen> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyActivityScreen> {
  late MyActivityController controller;
  Set<int> expandedIndices = {};

  @override
  void initState() {
    super.initState();
    controller = Get.put(MyActivityController());
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
                    return ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount:
                          controller.contactList.value?.data?.length ?? 0,
                      itemBuilder: (context, index) {
                        final contract =
                            controller.contactList.value?.data?[index];
                        final isExpanded = expandedIndices.contains(index);

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
                              ),
                              const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 16),
                                child: Divider(height: 1),
                              ),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    if (isExpanded) {
                                      expandedIndices.remove(index);
                                    } else {
                                      expandedIndices.add(index);
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
                                        isExpanded ? Icons.remove : Icons.add,
                                        size: 20,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              if (isExpanded)
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
                                    children: [
                                      Text(tr(LanguageKeys.commision),
                                          style: TextStyle(
                                              fontWeight: FontWeight.w500)),
                                      Text(
                                        contract?.commissionType ==
                                                "no_commission"
                                            ? tr(LanguageKeys.no_commission)
                                            : contract?.commissionType ==
                                                    "fix_commission"
                                                ? ("${tr(LanguageKeys.fix_commission)} : ${contract?.commissionValue ?? ""} €")
                                                : ("${tr(LanguageKeys.percentage_commission)} % : ${contract?.commissionValue ?? ""} % HT du montant facturé"),
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
                    controller.updateInit();
                  });
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.add,
                      color: Colors.white,
                      size: 30,
                    ),
                    SizedBox(width: 10),
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
      {required String title, required String referrer, required String id}) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
      child: Row(
        children: [
          Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.circular(6),
            ),
            child: const Center(
              child: Icon(
                Icons.person,
                color: Colors.white,
                size: 30,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: stylePoppins(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
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
                  Get.toNamed(DocumentScreen.pageId, arguments: {
                    'id': id,
                  })
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
                                        // Add your delete logic here
                                        controller.deleteContract(id);
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
                    padding: EdgeInsets.all(0),
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
                  // 'is_unique_commission': contract?.isUniqueCommission ?? true,
                  // 'is_generate_contract': contract?.isGenerateContract ?? true,
                  // 'track_names': contract?.dynamicFields ?? [],
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
          border: Border.all(color: AppColors.grey200, width: 2)),
      padding: const EdgeInsets.fromLTRB(10, 5, 10, 20),
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: SizedBox(
        width: Get.width - 52,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            GestureDetector(
                onTap: () => Get.dialog(const ActivityInfoDialog()),
                child: Padding(
                  padding: const EdgeInsets.all(2),
                  child: Icon(
                    Icons.info_outline,
                    color: AppColors.primary,
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
                    scale: 1.1,
                    request: 1,
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
                    scale: 1.8,
                    type: ""),
                singlePrItem(
                    image: AppAssets.imgShare,
                    isBlue: true,
                    onTap: () {
                      Get.dialog(LikeAddCoworkerDialog(
                        coworkers: controller.userDealList.value?.data ?? [],
                        onQrTap: (index) {
                          AppHelper.showLog(
                              'https://referaly.com/deal/${controller.userDealList.value?.data?[index].id}');
                          Get.back();
                          Get.dialog(
                            SharePopup(
                              title: controller.userDealList.value?.data?[index]
                                      .dealName ??
                                  '',
                              link: controller.userDealList.value?.data?[index]
                                      .inviteLink ??
                                  '',
                            ),
                          );
                        },
                      ));
                    },
                    scale: 2,
                    type: ""),
                singlePrItem(
                    image: AppAssets.imgAddNotification,
                    isBlue: true,
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
                    scale: 1.2,
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
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppColors.grey200),
                    color: AppColors.grey100.withOpacity(0.5)),
                child:
                    Image.asset(image, scale: scale, color: AppColors.primary),
              ),
            ),
            if (AppPreference.readString(AppPreference.isPaid) != "3" &&
                type == "referal")
              Positioned(
                left: 10,
                top: 0,
                child: Image.asset(AppAssets.imgpointBlue, height: 20),
              ),
            if (AppPreference.readString(AppPreference.isPaid) == "0")
              Positioned(
                left: 10,
                top: 0,
                child: Image.asset(AppAssets.imgpointBlue, height: 20),
              ),
            if (request != 0)
              Positioned(
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
          ],
        ),
      ),
    );
  }

  Widget buildBusinessReferrersSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
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
            () => ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: controller
                      .networkList.value?.data?.businessReferrers!.length ??
                  0,
              separatorBuilder: (context, index) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                return ReferrerListItem(
                  data1Referrer: controller
                      .networkList.value?.data?.businessReferrers![index],
                  name:
                      "${controller.networkList.value?.data?.businessReferrers![index].firstName} ${controller.networkList.value?.data?.businessReferrers![index].lastName}",
                );
              },
            ),
          )
        ],
      ),
    );
  }

  Widget buildVersionInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppPreference.readString(AppPreference.isPaid) == "0"
            ? Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                child: Text(
                  tr(LanguageKeys.premiumInformativeText),
                  style: stylePoppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.grey[800],
                  ),
                  textAlign: TextAlign.left,
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

class ReferrerListItem extends StatefulWidget {
  final String name;
  final bool showPrimium;
  final BusinessReferrers? data1Referrer;
  const ReferrerListItem({
    super.key,
    required this.name,
    this.showPrimium = false,
    this.data1Referrer,
  });

  @override
  State<ReferrerListItem> createState() => _ReferrerListItemState();
}

class _ReferrerListItemState extends State<ReferrerListItem> {
  bool expanded = false;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        data(),
        if (widget.showPrimium)
          Positioned.fill(
              child: ClipRect(
                  child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: const SizedBox(),
          )))
      ],
    );
  }

  Widget data() {
    return GestureDetector(
      onTap: () {
        if (!widget.showPrimium) {
          setState(() {
            expanded = !expanded;
          });
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 45,
                  height: 45,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.grey.withOpacity(.2)),
                  child: Image.asset(
                    AppAssets.imgPerson,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    widget.name,
                    style: stylePoppins(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Icon(expanded
                    ? Icons.keyboard_arrow_up
                    : Icons.keyboard_arrow_down),
              ],
            ),
            if (expanded) ...[
              const SizedBox(height: 12),
              const Divider(),
              const SizedBox(height: 8),
              _infoRow(tr(LanguageKeys.phoneNumber),
                  widget.data1Referrer?.phoneNumber ?? "", context,
                  isLink: true),
              const SizedBox(height: 8),
              _infoRow(tr(LanguageKeys.email),
                  widget.data1Referrer?.email ?? "", context,
                  isLink: true),
              const SizedBox(height: 8),
              _infoRow(tr(LanguageKeys.lastContractAccepted),
                  widget.data1Referrer?.lastAcceptedDealName ?? "", context),
              const SizedBox(height: 8),
              _infoRow(tr(LanguageKeys.acceptedDate),
                  widget.data1Referrer?.createdAt ?? "", context),
              const SizedBox(height: 8),
            ],
          ],
        ),
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

  Widget _infoRow(String label, String value, BuildContext context,
      {bool isLink = false}) {
    // Format the value if it's the Accepted Date field
    final displayValue =
        label.toLowerCase() == tr(LanguageKeys.acceptedDate).toLowerCase()
            ? _formatCreatedAt(value)
            : value;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 120.w,
          child: Text(
            label,
            style: stylePoppins(
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
              color: Colors.grey,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: label.toLowerCase() == tr(LanguageKeys.email).toLowerCase() &&
                  value.isNotEmpty &&
                  value != "Not Provided"
              ? GestureDetector(
                  onTap: () async {
                    final Uri emailUri = Uri(
                      scheme: 'mailto',
                      path: value,
                    );
                    if (await canLaunchUrl(emailUri)) {
                      await launchUrl(emailUri);
                    }
                  },
                  child: Text(
                    displayValue,
                    style: stylePoppins(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColors.primary,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    textAlign: TextAlign.right,
                  ),
                )
              : Text(
                  displayValue,
                  style: stylePoppins(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  textAlign: TextAlign.right,
                ),
        ),
      ],
    );
  }
}
