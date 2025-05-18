import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:referaly/resources/app_colors.dart';
import 'package:referaly/resources/text_style.dart';
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
          icon: Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
        title: Text('Business Network',
            style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Find Your Business Network',
                  style:
                      stylePoppins(fontWeight: FontWeight.w500, fontSize: 20)),
              SizedBox(height: 24),
              Text('Your Activity',
                  style: stylePoppins(
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                      color: Colors.black54)),
              SizedBox(height: 8),
              SizedBox(
                height: 40,
                child: TextField(
                  style:
                      stylePoppins(fontWeight: FontWeight.w400, fontSize: 14),
                  textAlign: TextAlign.left,
                  controller: controller.activityController,
                  decoration: InputDecoration(
                    hintText: 'Enter First Name',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8)),
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                    fillColor: AppColors.textFieldColor,
                  ),
                ),
              ),
              SizedBox(height: 16),
              Text('Type of business referrers you want',
                  style: stylePoppins(
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                      color: Colors.black54)),
              SizedBox(height: 8),
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
                          hintText: 'Enter referrer type and press Add',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8)),
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 10, horizontal: 12),
                          fillColor: AppColors.textFieldColor,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: controller.addReferrerType,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    child: Text('Add',
                        style: stylePoppins(
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                            color: Colors.white)),
                  ),
                ],
              ),
              SizedBox(height: 8),
              Obx(() => Wrap(
                    spacing: 8,
                    children: controller.referrerTypes
                        .map((type) => Chip(
                              label: Text(type),
                              backgroundColor:
                                  AppColors.primary.withOpacity(0.2),
                              deleteIcon: Icon(Icons.close),
                              onDeleted: () =>
                                  controller.removeReferrerType(type),
                            ))
                        .toList(),
                  )),
              SizedBox(height: 8),
              Text('Who you can refer',
                  style: stylePoppins(
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                      color: Colors.black54)),
              SizedBox(height: 8),
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
                          hintText: 'Enter who you can refer and press Add',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8)),
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 10, horizontal: 12),
                          fillColor: AppColors.textFieldColor,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: controller.addCanRefer,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    child: Text('Add',
                        style: stylePoppins(
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                            color: Colors.white)),
                  ),
                ],
              ),
              SizedBox(height: 8),
              Obx(() => Wrap(
                    spacing: 8,
                    children: controller.canReferList
                        .map((item) => Chip(
                              label: Text(item),
                              backgroundColor:
                                  Colors.deepPurpleAccent.withOpacity(0.2),
                              deleteIcon: Icon(Icons.close),
                              onDeleted: () => controller.removeCanRefer(item),
                            ))
                        .toList(),
                  )),
              SizedBox(height: 8),
              Text('Do you share commissions?',
                  style: stylePoppins(
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                      color: Colors.black54)),
              Obx(() => Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Radio(
                            value: true,
                            groupValue: controller.shareCommission.value,
                            onChanged: (val) =>
                                controller.shareCommission.value = true,
                            activeColor: Colors.deepPurpleAccent,
                          ),
                          Text(
                            'Yes',
                            style: stylePoppins(
                              fontWeight: FontWeight.w400,
                              fontSize: 14,
                              color: controller.shareCommission.value
                                  ? Colors.deepPurpleAccent
                                  : Colors.black54,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(width: 16),
                      Row(
                        children: [
                          Radio(
                            value: false,
                            groupValue: controller.shareCommission.value,
                            onChanged: (val) =>
                                controller.shareCommission.value = false,
                            activeColor: Colors.deepPurpleAccent,
                          ),
                          Text(
                            'No',
                            style: stylePoppins(
                              fontWeight: FontWeight.w400,
                              fontSize: 14,
                              color: !controller.shareCommission.value
                                  ? Colors.deepPurpleAccent
                                  : Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ],
                  )),
              SizedBox(height: 8),
              Text('Client Location',
                  style: stylePoppins(
                      fontWeight: FontWeight.w400,
                      fontSize: 16,
                      color: Colors.black54)),
              SizedBox(height: 8),
              Obx(() => Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () =>
                              controller.clientLocation.value = 'Online',
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                controller.clientLocation.value == 'Online'
                                    ? AppColors.primary
                                    : AppColors.textFieldBorderColor,
                            foregroundColor:
                                controller.clientLocation.value == 'Online'
                                    ? AppColors.textFieldBorderColor
                                    : Colors.black,
                            side: BorderSide(
                                color:
                                    controller.clientLocation.value == 'Online'
                                        ? AppColors.primary
                                        : AppColors.textFieldBorderColor),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                          ),
                          child: Text('Online',
                              style: stylePoppins(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14,
                                  color: controller.clientLocation.value ==
                                          'Online'
                                      ? AppColors.textFieldBorderColor
                                      : AppColors.detailsTextColor)),
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () =>
                              controller.clientLocation.value = 'In-Person',
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                controller.clientLocation.value == 'In-Person'
                                    ? AppColors.primary
                                    : AppColors.textFieldBorderColor,
                            foregroundColor:
                                controller.clientLocation.value == 'In-Person'
                                    ? AppColors.textFieldBorderColor
                                    : Colors.black,
                            side: BorderSide(
                                color: controller.clientLocation.value ==
                                        'In-Person'
                                    ? AppColors.primary
                                    : AppColors.textFieldColor),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                          ),
                          child: Text('In-Person',
                              style: stylePoppins(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14,
                                  color: controller.clientLocation.value ==
                                          'In-Person'
                                      ? Colors.white
                                      : AppColors.detailsTextColor)),
                        ),
                      ),
                    ],
                  )),
              SizedBox(height: 32),
              ElevatedButton(
                onPressed: () =>
                    Get.toNamed(OnboardingBusinessNetworkScreen.pageId),
                child: Text('Next'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
