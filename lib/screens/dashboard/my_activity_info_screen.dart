import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:referaly/controller/my_activity_info_controller.dart';
import 'package:referaly/languages/languagekeys.dart';
import 'package:referaly/models/model_network_response.dart';
import 'package:referaly/resources/app_assets.dart';
import 'package:referaly/resources/app_colors.dart';
import 'package:referaly/resources/app_helper.dart';
import 'package:referaly/resources/app_preference.dart';
import 'package:referaly/resources/text_style.dart';
import 'package:referaly/screens/active_goal_screen.dart';
import 'package:referaly/screens/dashboard/membership_screen.dart';
import 'package:referaly/screens/referrers_screen.dart';
import 'package:referaly/screens/send_notification_screen.dart';
import 'package:referaly/utils/translations.dart';
import 'package:referaly/widgets/dialog/activity_info_dialog.dart';
import 'package:referaly/widgets/dialog/like_add_coworker_dialog.dart';
import 'package:referaly/widgets/dialog/premium_upgrade_dialog.dart';
import 'package:referaly/widgets/logo_loader.dart';
import 'package:referaly/widgets/share_popup.dart';
import 'package:url_launcher/url_launcher.dart';

class MyActivityInfoScreen extends StatelessWidget {
  static String pageId = "/myActivityInfo";
  final MyActivityInfoController controller =
      Get.put(MyActivityInfoController());

  MyActivityInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 10),
          child: GestureDetector(
            onTap: () => Get.back(),
            child: const Center(
              child: Icon(Icons.arrow_back_ios_new, size: 20),
            ),
          ),
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
        child: Obx(() {
          if (controller.isLoading.value) {
            return Center(
                child: SizedBox(
                    width: 24,
                    height: 24,
                    child: LogoLoader()));
          } else {
            return SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  buildPurpleCard(),
                  const SizedBox(height: 20),
                  buildActionButtonsRow(),
                  const SizedBox(height: 30),
                  buildBusinessReferrersSection(),
                  const SizedBox(height: 20),
                  buildVersionInfo(),
                ],
              ),
            );
          }
        }),
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
              fontSize: 22,
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
                            Get.toNamed(MembershipScreen.pageId)?.then((value) {
                            });
                          },
                        ));
                      } else {
                        Get.toNamed(ReferrersScreen.pageId);
                      }
                    },
                    scale: 1.4,
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
                    scale: 2.5,
                    type: ""),
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
                              link: controller.userDealList.value?.data?[index]
                                      .inviteLink ??
                                  '',
                            ),
                          );
                        },
                      ));
                    },
                    scale: 3,
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
                    scale: 1.5,
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
                    color: AppColors.grey200),
                child:
                    Image.asset(image, scale: scale, color: AppColors.primary),
              ),
            ),
            if (type == "referal")
              Positioned(
                left: 10,
                top: 0,
                child: SvgPicture.asset(AppAssets.imgHomeCrown,
                    height: 20, color: AppColors.blueColor),
              ),
            if (AppPreference.readString(AppPreference.isPaid) != "2")
              Positioned(
                left: 10,
                top: 0,
                child: SvgPicture.asset(
                    isBlue ? AppAssets.imgpointBlue : AppAssets.imgHomeCrown,
                    height: 20),
              ),
            Obx(
              () => controller.userDealList.value?.data?.length != 0 &&
                      request != 0
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            tr(LanguageKeys.bussinessreferrence),
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
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: SizedBox(
            width: double.infinity,
            child: GestureDetector(
              onTap: () {
                if (AppPreference.readString(AppPreference.isPaid) != "0") {
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
                  border: Border.all(color: AppColors.primary, width: 1),
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

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child:
                label.toLowerCase() == tr(LanguageKeys.email).toLowerCase() &&
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
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            decoration: TextDecoration.underline,
                            color: AppColors.primary,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          textAlign: TextAlign.right,
                        ),
                      )
                    : Text(
                        displayValue,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        textAlign: TextAlign.right,
                      ),
          ),
        ],
      ),
    );
  }
}
