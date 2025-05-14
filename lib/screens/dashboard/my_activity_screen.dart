import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:referaly/controller/my_activity_controller.dart';
import 'package:referaly/models/model_coworkerlist_deal.dart';
import 'package:referaly/resources/app_assets.dart';
import 'package:referaly/resources/app_colors.dart';
import 'package:referaly/resources/app_helper.dart';
import 'package:referaly/resources/text_style.dart';
import 'package:referaly/screens/active_goal_screen.dart';
import 'package:referaly/screens/dashboard/add_coworker_dialog.dart';
import 'package:referaly/screens/dashboard/membership_screen.dart';
import 'package:referaly/screens/deals/business_referrer_contract_screen.dart';
import 'package:referaly/screens/send_notification_screen.dart';
import 'package:referaly/widgets/dialog/activity_info_dialog.dart';
import 'package:referaly/widgets/dialog/like_add_coworker_dialog.dart';
import 'package:referaly/widgets/dialog/premium_upgrade_dialog.dart';
import 'package:referaly/widgets/share_popup.dart';

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
          "For my activity",
          style: stylePoppins(
            fontSize: 18,
            fontWeight: FontWeight.w700,
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
              child: Obx(() {
                return controller.isMyContractsSelected.value
                    ? buildDealsListView()
                    : SingleChildScrollView(
                        child: Column(
                          children: [
                            buildPurpleCard(),
                            const SizedBox(height: 20),
                            buildActionButtonsRow(),
                            const SizedBox(height: 30),
                            buildBusinessReferrersSection(),
                            buildVersionInfo(),
                          ],
                        ),
                      );
              }),
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
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => controller.toggleTabSelection(true),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 15),
                    margin:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                    decoration: BoxDecoration(
                      color: controller.isMyContractsSelected.value
                          ? AppColors.primary
                          : AppColors.transparent,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      'My Contracts',
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
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 15),
                    margin:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                    decoration: BoxDecoration(
                      color: !controller.isMyContractsSelected.value
                          ? AppColors.primary
                          : AppColors.transparent,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      'My Network',
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
                          child: Card(
                            color: Colors.grey[100],
                            child: Column(
                              children: [
                                buildDealHeader(
                                  title: contract?.dealName ?? "",
                                  referrer: contract?.companyName ?? "",
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
                                        const Text(
                                          "More information",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
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
                                        const Text("Commission",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold)),
                                        Text(
                                          contract?.commissionType ==
                                                  "no_commission"
                                              ? "No Commission"
                                              : contract?.commissionType ==
                                                      "fix_commission"
                                                  ? "Fix Commission"
                                                  : (contract?.commissionType ??
                                                      ""),
                                        ),
                                        // Add more details as needed
                                      ],
                                    ),
                                  ),
                                buildDealActionButtons(),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  })
                : Center(
                    child: Text(
                      "Create your first referral deal",
                      style: stylePoppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
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
                  Get.toNamed(BusinessReferrerContractScreen.pageId);
                },
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.add,
                      color: Colors.white,
                      size: 30,
                    ),
                    SizedBox(width: 10),
                    Text('Create Deal',
                        style: TextStyle(fontSize: 18, color: Colors.white)),
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
                  style: stylePoppins(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  "Business referral - $referrer",
                  style: stylePoppins(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: [
              GestureDetector(
                onTap: () => Get.dialog(const ActivityInfoDialog()),
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
                                "Please note that deleting this contract will result in the removal of all business referrers invited to the former. To retain their participation, you will need to re-invite them to a new deal.",
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
                                          child: Text('Cancel',
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
                                        Navigator.of(context).pop();
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 14),
                                        decoration: BoxDecoration(
                                          color: Colors.purple,
                                          borderRadius:
                                              BorderRadius.circular(5),
                                        ),
                                        child: const Center(
                                          child: Text('Delete',
                                              style: TextStyle(
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
                  const PopupMenuItem(
                    padding: EdgeInsets.all(0),
                    height: 20,
                    value: 'delete',
                    child: Center(
                      child: Text('Delete'),
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

  Widget buildDealActionButtons() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.primary,
                side: BorderSide(color: AppColors.primary),
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                "Edit Deal",
                style: stylePoppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                "Share Deal",
                style: stylePoppins(
                  fontSize: 16,
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
          Image.asset(AppAssets.imgReferrelsPeople, height: 60),
          const SizedBox(height: 5),
          Text(
            'Referreals',
            style: stylePoppins(
              fontSize: 22,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 5),
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
                    Get.dialog(PremiumUpgradeDialog(
                      onSeeOffers: () {
                        Get.back();
                        Get.toNamed(MembershipScreen.pageId);
                      },
                    ));
                  },
                  scale: 1.4,
                  request: 1,
                ),
                singlePrItem(
                  image: AppAssets.imgAddDoc,
                  isBlue: false,
                  onTap: () {
                    Get.toNamed(ActiveGoalScreen.pageId);
                  },
                  scale: 2.5,
                ),
                singlePrItem(
                  image: AppAssets.imgShare,
                  isBlue: false,
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
                            link:
                                'https://referaly.com/deal/${controller.userDealList.value?.data?[index].id}',
                          ),
                        );
                      },
                    ));
                  },
                  scale: 3,
                ),
                singlePrItem(
                  image: AppAssets.imgAddNotification,
                  isBlue: false,
                  onTap: () {
                    Get.toNamed(SendNotificationScreen.pageId);
                  },
                  scale: 1.5,
                ),
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
      required double scale}) {
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
                    color: AppColors.grey200),
                child:
                    Image.asset(image, scale: scale, color: AppColors.primary),
              ),
            ),
            Positioned(
              left: 0,
              top: 0,
              child: Image.asset(
                  isBlue ? AppAssets.imgpointBlue : AppAssets.imgPoint,
                  height: 25),
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
            "Business Referrers",
            style: stylePoppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
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
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Text(
            "With the free version, you can add a maximum of 5 business referrers.",
            style: stylePoppins(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Colors.grey[800],
            ),
            textAlign: TextAlign.left,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: SizedBox(
            width: double.infinity,
            child: GestureDetector(
              onTap: () {
                Get.dialog(PremiumUpgradeDialog(
                  onSeeOffers: () {
                    Get.back();
                    Get.toNamed(MembershipScreen.pageId);
                  },
                ));
              },
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.whiteColor,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.primary, width: 1),
                ),
                padding: const EdgeInsets.symmetric(vertical: 14),
                child: Center(
                  child: Text(
                    'See All',
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
        ),
      ],
    );
  }
}

class ReferrerListItem extends StatefulWidget {
  final String name;
  final bool showPrimium;
  const ReferrerListItem({
    super.key,
    required this.name,
    this.showPrimium = false,
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
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
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
              _infoRow("Phone Number", "1234567890", context, isLink: true),
              const SizedBox(height: 8),
              _infoRow("Email", "test@test.com", context, isLink: true),
              const SizedBox(height: 8),
              _infoRow("Last contract accepted", "1234567890", context),
              const SizedBox(height: 8),
              _infoRow("Accepted Date", "1234567890", context),
              const SizedBox(height: 8),
            ],
          ],
        ),
      ),
    );
  }

  Widget _infoRow(String label, String value, BuildContext context,
      {bool isLink = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: stylePoppins(fontSize: 14)),
        const SizedBox(width: 8),
        if (isLink)
          GestureDetector(
            child: Text(value,
                style: stylePoppins(fontSize: 14, color: AppColors.primary)),
          )
        else
          Text(value, style: stylePoppins(fontSize: 14)),
      ],
    );
  }
}
