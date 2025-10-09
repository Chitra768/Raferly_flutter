import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:referaly/controller/controller_main_professional.dart';
import 'package:referaly/languages/languagekeys.dart';
import 'package:referaly/resources/app_assets.dart';
import 'package:referaly/resources/app_colors.dart';
import 'package:referaly/resources/app_preference.dart';
import 'package:referaly/resources/text_style.dart';
import 'package:referaly/screens/dashboard/membership_screen.dart';
import 'package:referaly/screens/deals/business_referrer_contract_screen.dart';
import 'package:referaly/screens/deals/invited_deals_screen.dart'
    show InvitedDealsScreen;
import 'package:referaly/screens/deals/out_of_referaly_dialog.dart'
    show OutOfReferalyScreen;
import 'package:referaly/utils/translations.dart';
import 'package:referaly/widgets/dialog/invite_contact_dialog.dart'
    show InviteContactDialog;
import 'package:referaly/widgets/dialog/premium_upgrade_dialog.dart';

/// Dialog to send a contact to a professional who does not have Referaly
class SendContactDialogCopy extends StatelessWidget {
  final VoidCallback? onCreateReferral;

  const SendContactDialogCopy({
    super.key,
    this.onCreateReferral,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ControllerMainProfessional>();
    return AlertDialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 20),
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      titlePadding: EdgeInsets.zero,
      title: Padding(
        padding: const EdgeInsets.only(top: 8, right: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            GestureDetector(
              onTap: () => Get.back(),
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: SvgPicture.asset(
                  height: 38,
                  AppAssets.imgCloseBtn,
                  colorFilter: ColorFilter.mode(
                    AppColors.blackColor.withOpacity(0.8),
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      content: SizedBox(
        width: double.maxFinite,
        child: GestureDetector(
          onTap: () {
            Get.back();
            // Get.dialog(InviteContactDialog(
            //   onAlreadyInvited: () {
            //     Get.toNamed(InvitedDealsScreen.pageId);
            //   },
            //   onNotInvited: () {
            //     Get.toNamed(OutOfReferalyScreen.pageId, arguments: {
            //       'title': tr(LanguageKeys.sendAContact),
                 
            //     });
            //   },
            // ));
          },
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: Get.width * .65,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 10,
                        spreadRadius: 1,
                        offset: const Offset(1, 5))
                  ],
                ),
                padding:
                    const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 65,
                      height: 65,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle, // Makes it perfectly circular
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: SvgPicture.asset(
                          AppAssets.imgTelegram,
                          colorFilter: ColorFilter.mode(
                            AppColors.whiteColor,
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      tr(LanguageKeys.sendAContact),
                      textAlign: TextAlign.center,
                      style: stylePoppins(
                          fontSize: 20,
                          color: AppColors.blackColor,
                          fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      tr(LanguageKeys.toAProfessional1),
                      textAlign: TextAlign.center,
                      style: stylePoppins(
                          fontSize: 16,
                          color: AppColors.blackColor.withOpacity(0.8),
                          fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Obx(
                () => controller.profile.value?.data?.companyType ==
                        "individual"
                    ? const SizedBox()
                    : GestureDetector(
                        onTap: () {
                          Get.back();
                          if (AppPreference.readString(AppPreference.isPaid) ==
                              "0") {
                            Get.dialog(PremiumUpgradeDialog(
                              onSeeOffers: () {
                                Get.back();
                                  Get.toNamed(MembershipScreen.pageId)?.then((value) {
                              controller.getProfile();
                            });
                              },
                            ));
                          } else {
                            Get.toNamed(BusinessReferrerContractScreen.pageId,
                                )?.then((value) {});
                          }
                        },
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 10),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 6),
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          alignment: Alignment.center,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Flexible(
                                child: Center(
                                  child: Text(
                                    tr(LanguageKeys.createDealOutOf),
                                    textAlign: TextAlign.center,
                                    style: stylePoppins(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              AppPreference.readString(AppPreference.isPaid) ==
                                      "0"
                                  ? SvgPicture.asset(
                                      AppAssets.imgHDashboardCrown,
                                      width: 20,
                                      height: 20,
                                    )
                                  : const SizedBox.shrink(),
                            ],
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
