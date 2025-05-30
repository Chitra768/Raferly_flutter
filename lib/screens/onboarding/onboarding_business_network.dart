import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:referaly/languages/languagekeys.dart';
import 'package:referaly/resources/app_colors.dart';
import 'package:referaly/resources/text_style.dart';
import 'package:referaly/screens/onboarding/onboarding_consultation_success.dart';
import 'package:referaly/utils/translations.dart';
import '../../controller/onboarding_business_network_controller.dart';

class OnboardingBusinessNetworkScreen
    extends GetView<OnboardingBusinessNetworkController> {
  static const String pageId = '/onboarding_business_network';
  OnboardingBusinessNetworkScreen({Key? key}) : super(key: key);
  final controller = Get.put(OnboardingBusinessNetworkController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
        title: Text(tr(LanguageKeys.busniess),
            style: stylePoppins(fontWeight: FontWeight.w600)),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: SafeArea(
        child: Column(
          children: [
            const Divider(
              color: AppColors.textFieldColor,
              height: 1,
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(tr(LanguageKeys.findbusniess),
                        style: stylePoppins(
                            fontWeight: FontWeight.w600, fontSize: 20)),
                    const SizedBox(height: 24),
                    Text(tr(LanguageKeys.yourBusinessActivity),
                        style: stylePoppins(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                            color: AppColors.textTitle)),
                    const SizedBox(height: 8),
                    SizedBox(
                      height: 65,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 40,
                            child: TextField(
                              style: stylePoppins(
                                  fontWeight: FontWeight.w400, fontSize: 14),
                              textAlign: TextAlign.left,
                              controller: controller.activityController,
                              decoration: InputDecoration(
                                hintText: tr(LanguageKeys.enterReferrerType),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8)),
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 12),
                                fillColor: AppColors.textFieldColor,
                                errorStyle: const TextStyle(height: 0),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(tr(LanguageKeys.typeOfBusiness),
                        style: stylePoppins(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                            color: AppColors.textTitle)),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: 40,
                            child: TextField(
                              style: stylePoppins(
                                  fontWeight: FontWeight.w400, fontSize: 14),
                              textAlign: TextAlign.left,
                              controller: controller.referrerTypeController,
                              decoration: InputDecoration(
                                hintText: tr(LanguageKeys.enterCanRefer),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8)),
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 12),
                                fillColor: AppColors.textFieldColor,
                                errorText: controller
                                        .referrerTypeError.value.isNotEmpty
                                    ? controller.referrerTypeError.value
                                    : null,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: controller.addReferrerType,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                          ),
                          child: Text(tr(LanguageKeys.add),
                              style: stylePoppins(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                  color: Colors.white)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Obx(() => Wrap(
                          spacing: 8,
                          children: controller.referrerTypes
                              .map((type) => Chip(
                                    label: Text(
                                      type,
                                      style: stylePoppins(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 14,
                                          color: AppColors.textTitle),
                                    ),
                                    backgroundColor:
                                        AppColors.primary.withOpacity(0.2),
                                    deleteIcon: const Icon(Icons.close),
                                    onDeleted: () =>
                                        controller.removeReferrerType(type),
                                  ))
                              .toList(),
                        )),
                    const SizedBox(height: 8),
                    Text(tr(LanguageKeys.canRefer),
                        style: stylePoppins(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                            color: AppColors.textTitle)),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: 40,
                            child: TextField(
                              style: stylePoppins(
                                  fontWeight: FontWeight.w400, fontSize: 14),
                              textAlign: TextAlign.left,
                              controller: controller.canReferController,
                              decoration: InputDecoration(
                                hintText: tr(LanguageKeys.enterCanRefer),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8)),
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 12),
                                fillColor: AppColors.textFieldColor,
                                errorText:
                                    controller.canReferError.value.isNotEmpty
                                        ? controller.canReferError.value
                                        : null,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: controller.addCanRefer,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                          ),
                          child: Text(tr(LanguageKeys.add),
                              style: stylePoppins(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                  color: Colors.white)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Obx(() => Wrap(
                          spacing: 8,
                          children: controller.canReferList
                              .map((item) => Chip(
                                    label: Text(item,
                                        style: stylePoppins(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 14,
                                            color: AppColors.textTitle)),
                                    backgroundColor: Colors.deepPurpleAccent
                                        .withOpacity(0.2),
                                    deleteIcon: const Icon(Icons.close),
                                    onDeleted: () =>
                                        controller.removeCanRefer(item),
                                  ))
                              .toList(),
                        )),
                    const SizedBox(height: 8),
                    Text(tr(LanguageKeys.shareCommision),
                        style: stylePoppins(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                            color: AppColors.textTitle)),
                    Obx(() => Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Radio(
                                    value: true,
                                    groupValue:
                                        controller.shareCommission.value,
                                    onChanged: (val) =>
                                        controller.shareCommission.value = true,
                                    activeColor: AppColors.primary),
                                Text(
                                  tr(LanguageKeys.yes),
                                  style: stylePoppins(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14,
                                    color: controller.shareCommission.value
                                        ? AppColors.primary
                                        : Colors.black54,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(width: 16),
                            Row(
                              children: [
                                Radio(
                                  value: false,
                                  groupValue: controller.shareCommission.value,
                                  onChanged: (val) =>
                                      controller.shareCommission.value = false,
                                  activeColor: AppColors.primary,
                                ),
                                Text(
                                  tr(LanguageKeys.no),
                                  style: stylePoppins(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14,
                                    color: !controller.shareCommission.value
                                        ? AppColors.primary
                                        : Colors.black54,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        )),
                    const SizedBox(height: 8),
                    Text(tr(LanguageKeys.clientBusinessLocation),
                        style: stylePoppins(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                            color: AppColors.textTitle)),
                    const SizedBox(height: 8),
                    Obx(() => Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () => controller.clientLocation.value =
                                    tr(LanguageKeys.online),
                                child: Container(
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: controller.clientLocation.value ==
                                            tr(LanguageKeys.online)
                                        ? AppColors.primary
                                        : AppColors.textFieldBorderColor,
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color: controller.clientLocation.value ==
                                              tr(LanguageKeys.online)
                                          ? AppColors.primary
                                          : AppColors.textFieldColor,
                                    ),
                                  ),
                                  child: Center(
                                    child: Text(tr(LanguageKeys.online),
                                        style: stylePoppins(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 14,
                                            color: controller
                                                        .clientLocation.value ==
                                                    tr(LanguageKeys.online)
                                                ? AppColors.textFieldBorderColor
                                                : AppColors.detailsTextColor)),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: GestureDetector(
                                onTap: () => controller.clientLocation.value =
                                    'In-Person',
                                child: Container(
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: controller.clientLocation.value ==
                                            tr(LanguageKeys.inPerson)
                                        ? AppColors.primary
                                        : AppColors.textFieldBorderColor,
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color: controller.clientLocation.value ==
                                              tr(LanguageKeys.inPerson)
                                          ? AppColors.primary
                                          : AppColors.textFieldColor,
                                    ),
                                  ),
                                  child: Center(
                                    child: Text(tr(LanguageKeys.inPerson),
                                        style: stylePoppins(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 14,
                                            color: controller
                                                        .clientLocation.value ==
                                                    tr(LanguageKeys.inPerson)
                                                ? Colors.white
                                                : AppColors.detailsTextColor)),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () async {
                    if (controller.validateForm()) {
                      await controller.sendReferral();
                      if (controller.error.value.isEmpty) {
                        Get.toNamed(OnboardingConsultationSuccessScreen.pageId);
                      }
                    }
                  },
                  child: Obx(
                    () => Text(
                      textAlign: TextAlign.center,
                      tr(LanguageKeys.findMyBusinessReferral),
                      style:
                          TextStyle(fontSize: 18, color: AppColors.whiteColor),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
