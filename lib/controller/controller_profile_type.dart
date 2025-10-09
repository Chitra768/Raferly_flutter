import 'package:get/get.dart';
import 'package:referaly/apis/rest_auth.dart';
import 'package:referaly/resources/app_log.dart';
import 'package:referaly/resources/app_preference.dart';
import 'package:referaly/screens/auth/screen_registration.dart';
import 'package:flutter/material.dart';
import 'package:referaly/screens/home/screen_main.dart';
import 'package:referaly/widgets/custom_toast_msg.dart';
import 'package:referaly/apis/api_result.dart';
import 'package:referaly/models/model_register.dart';
import 'package:referaly/controller/controller_main_professional.dart';

import '../models/model_company_type.dart';

class ControllerProfileType extends GetxController {
  final selectedProfileType = 'individual'.obs;
  final isLoading = false.obs;

  void selectProfileType(String type) {
    AppLog.d("$type");
    selectedProfileType.value = type;
  }

  Future<void> goToNextScreen(BuildContext context) async {
    isLoading.value = true;
    try {
      final result = await RESTAuth.updateCompanyType(
          companyType: selectedProfileType.value);
      if (result is ApiSuccess<ModelCompanyType>) {
        final data = result.data;

        print('data: $data');
        if (data.status == true) {
          // Check for pending deep link data
        // Check for pending deep link data
                                              final pendingDealId = AppPreference.readString('pending_deal_id');
                                              if (pendingDealId != null && pendingDealId.isNotEmpty) {
                                                debugPrint('------> Found pending deep link data: dealId=$pendingDealId');
                                                
                                                // Get pending campaign and stage data
                                                final pendingCampaign = AppPreference.readString('pending_campaign');
                                                final pendingStage = AppPreference.readString('pending_stage');
                                                
                                                // Clear pending data
                                                AppPreference.writeString('pending_deal_id', '');
                                                AppPreference.writeString('pending_campaign', '');
                                                AppPreference.writeString('pending_stage', '');
                                                
                                                // Handle the deep link
                                                try {
                                                  print('------> Pending deal ID: $pendingDealId');
                                                  print('------> Pending campaign: $pendingCampaign');
                                                  print('------> Pending stage: $pendingStage');
                                                        Get.put(ControllerMainProfessional());
                                                  Get.find<ControllerMainProfessional>()
                                                      .handleDealId(pendingDealId, pendingCampaign, pendingStage);
                                                } catch (e) {
                                                  debugPrint('Error handling pending deal: $e');
                                                }
                                                
                                                Get.offAllNamed(ScreenMain.pageId, arguments: {
                                                  'dealId': pendingDealId,
                                                });
                                              } else {
                                                Get.offAllNamed(ScreenMain.pageId);
                                              }
            // Get.offAllNamed(ScreenMain.pageId);
         
        } else {}
      } else if (result is ApiFailure) {
      } else {}
    } catch (e) {
    } finally {
      isLoading.value = false;
    }
  }
}
