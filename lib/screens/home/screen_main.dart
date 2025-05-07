
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:referaly/resources/app_colors.dart';
import 'package:referaly/screens/home/professional_home.dart';

import '../../controller/controller_main_professional.dart';
import 'package:get/get.dart';

import '../../resources/app_helper.dart';
import '../../widgets/custom_bottom_bar.dart';
import '../archeive/archeive_list.dart';

class ScreenMain extends GetView<ControllerMainProfessional> {
  ScreenMain({super.key});

  static String pageId = '/screenMain';
  final controllerr = Get.put(ControllerMainProfessional());

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return   exit(0);
      },
      child: Scaffold(
        backgroundColor: AppColors.whiteColor,
        body: Obx(
              () {
            AppHelper.showLog(
                "++++++++++PageCount: ${controllerr.pageIndex.value}");
           if (controllerr.pageIndex.value == 0) {
              return ProfessionalHome();
            }
            else if (controllerr.pageIndex.value == 1) {

              return const ArchiveList();
            }

            else {
              return Container();
            }
          },
        ),
        bottomNavigationBar:const CustomBottomSheet(),
      ),
    );
  }
}
