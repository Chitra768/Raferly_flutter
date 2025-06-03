import 'package:get/get.dart';
import 'package:referaly/apis/rest_auth.dart';
import 'package:referaly/resources/app_preference.dart';
import 'package:referaly/screens/auth/screen_registration.dart';
import 'package:flutter/material.dart';
import 'package:referaly/screens/home/screen_main.dart';
import 'package:referaly/widgets/custom_toast_msg.dart';
import 'package:referaly/apis/api_result.dart';
import 'package:referaly/models/model_register.dart';

import '../models/model_company_type.dart';

class ControllerProfileType extends GetxController {
  final selectedProfileType = 'professional'.obs;
  final isLoading = false.obs;

  void selectProfileType(String type) {
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

       
          Get.offAllNamed(ScreenMain.pageId);
        } else {
        }
      } else if (result is ApiFailure) {
     
      } else {
      
      }
    } catch (e) {
     
    } finally {
      isLoading.value = false;
    }
  }
}
