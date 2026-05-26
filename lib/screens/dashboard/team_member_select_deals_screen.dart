import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:referaly/controller/team_member_select_deals_controller.dart';
import 'package:referaly/languages/languagekeys.dart';
import 'package:referaly/resources/app_colors.dart';
import 'package:referaly/utils/translations.dart';
import 'package:referaly/widgets/logo_loader.dart';

class TeamMemberSelectDealsScreen extends GetView<TeamMemberSelectDealsController> {
  static const String pageId = '/teamMemberSelectDeals';

  const TeamMemberSelectDealsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.teamTitle),
          onPressed: () => Get.back(),
        ),
        centerTitle: true,
        title: Text(
          tr(LanguageKeys.teamManagementSelectDealsTitle),
          style: const TextStyle(
            color: AppColors.teamTitle,
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
        backgroundColor: AppColors.whiteColor,
        elevation: 0,
        surfaceTintColor: AppColors.whiteColor,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 1, color: AppColors.teamBorderGrey),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.deals.isEmpty) {
          return const Center(child: LogoLoader());
        }
        return Column(
          children: [
            if (controller.error.value.isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  controller.error.value,
                  style: const TextStyle(color: AppColors.red600, fontSize: 14),
                  textAlign: TextAlign.center,
                ),
              ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    decoration: BoxDecoration(
                      color: AppColors.gray100,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Obx(
                      () => CheckboxListTile(
                        title: Text(tr(LanguageKeys.selectAll)),
                        value: controller.selectAll.value,
                        onChanged: controller.toggleSelectAll,
                        controlAffinity: ListTileControlAffinity.trailing,
                        activeColor: AppColors.primary,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                      ),
                    ),
                  ),
                  Obx(
                    () => Column(
                      children: List.generate(controller.deals.length, (index) {
                        return Container(
                          margin: const EdgeInsets.only(bottom: 8),
                          decoration: BoxDecoration(
                            color: AppColors.gray100,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: CheckboxListTile(
                            activeColor: AppColors.primary,
                            title: Text(controller.deals[index].dealName ?? ''),
                            value: index < controller.selected.length
                                ? controller.selected[index]
                                : false,
                            onChanged: (val) => controller.toggleItem(index, val),
                            controlAffinity: ListTileControlAffinity.trailing,
                            contentPadding:
                                const EdgeInsets.symmetric(horizontal: 16),
                          ),
                        );
                      }),
                    ),
                  ),
                ],
              ),
            ),
            SafeArea(
              minimum: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: Obx(
                () => SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: controller.hasSelection
                          ? AppColors.primary
                          : AppColors.primary.withOpacity(0.5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    onPressed: controller.hasSelection && !controller.isLoading.value
                        ? controller.onContinue
                        : null,
                    child: controller.isLoading.value
                        ? const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : Text(
                            tr(LanguageKeys.Continue),
                            style: TextStyle(
                              color: controller.hasSelection
                                  ? Colors.white
                                  : Colors.white.withOpacity(0.7),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}
