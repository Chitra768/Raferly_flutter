import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:referaly/apis/api_result.dart';
import 'package:referaly/apis/rest_auth.dart';
import 'package:referaly/languages/languagekeys.dart';
import 'package:referaly/models/model_collaboratorList.dart';
import 'package:referaly/models/model_coworkerlist_deal.dart';
import 'package:referaly/resources/app_colors.dart';
import 'package:referaly/screens/referrers_screen.dart';
import 'package:referaly/utils/translations.dart';

class AddCoworkerAgencyController extends GetxController {
  RxList<bool> selected = <bool>[].obs;
  RxBool selectAll = false.obs;
  final RxList<CoworkerlistDealData> coworkers = <CoworkerlistDealData>[].obs;

  @override
  void onInit() {
    super.onInit();
    getUserDealList();
  }

  void toggleSelectAll(bool? value) {
    selectAll.value = value ?? false;
    selected.value = List.generate(coworkers.length, (_) => selectAll.value);
  }

  void toggleItem(int index, bool? value) {
    if (index < selected.length) {
      selected[index] = value ?? false;
      selectAll.value = selected.every((e) => e);
    }
  }

  // Get selected coworker IDs
  List<int> getSelectedIds() {
    List<int> selectedIds = [];
    for (int i = 0; i < selected.length && i < coworkers.length; i++) {
      if (selected[i] && coworkers[i].id != null) {
        selectedIds.add(coworkers[i].id!);
      }
    }
    return selectedIds;
  }

  // Get selected coworker data
  List<CoworkerlistDealData> getSelectedCoworkers() {
    List<CoworkerlistDealData> selectedCoworkers = [];
    for (int i = 0; i < selected.length && i < coworkers.length; i++) {
      if (selected[i]) {
        selectedCoworkers.add(coworkers[i]);
      }
    }
    return selectedCoworkers;
  }

  final Rx<ModelCoworkerlistDeal?> userDealList =
      Rx<ModelCoworkerlistDeal?>(null);

  Future<void> getUserDealList() async {
    try {
      final response = await RESTAuth.getUserDealList();

      if (response is ApiSuccess<ModelCoworkerlistDeal>) {
        if (response.data.status == true) {
          coworkers.value = response.data.data ?? [];
          // Update selected list to match the new coworkers length
          selected.value = List.generate(coworkers.length, (_) => false);
        } else {}
      } else if (response is ApiFailure) {}
    } catch (e) {
    } finally {}
  }

  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;

  Future<void> getAgencyCoworkerList(List<String> id) async {
    try {
      isLoading.value = true;
      error.value = '';

      final response = await RESTAuth.getAgencyCoworkerList(id);
      if (response is ApiSuccess<CollaboratorListModel>) {
        if (response.data.status == true) {
          Get.toNamed(ReferrersScreen.pageId, arguments: {
            "coworkers": response.data.data,
            "id": id,
          })?.then((value) {
            Get.back();
          });
        } else {}
      } else if (response is ApiFailure) {}
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }
}

class AddAgencyCoworkerDialog extends StatelessWidget {
  final AddCoworkerAgencyController controller =
      Get.put(AddCoworkerAgencyController());

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(width: 32), // for alignment
                  Expanded(
                    child: Text(
                      tr(LanguageKeys.addCoworker),
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, size: 28),
                    onPressed: () => Get.back(),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Share access button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  onPressed: () {},
                  child: Text(
                    tr(LanguageKeys.shareAccessOf),
                    style: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // List of coworkers with checkboxes
              Obx(() => Column(
                    children: [
                      // Select All
                      Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: CheckboxListTile(
                          title: Text(tr(LanguageKeys.selectAll)),
                          value: controller.selectAll.value,
                          onChanged: controller.toggleSelectAll,
                          controlAffinity: ListTileControlAffinity.trailing,
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 16),
                        ),
                      ),
                      // Coworkers
                      ...List.generate(controller.coworkers.length, (index) {
                        return Container(
                          margin: const EdgeInsets.only(bottom: 8),
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: CheckboxListTile(
                            activeColor: AppColors.primary,
                            title: Text(
                                controller.coworkers[index].dealName ?? ''),
                            value: index < controller.selected.length
                                ? controller.selected[index]
                                : false,
                            onChanged: (val) =>
                                controller.toggleItem(index, val),
                            controlAffinity: ListTileControlAffinity.trailing,
                            contentPadding:
                                const EdgeInsets.symmetric(horizontal: 16),
                          ),
                        );
                      }),
                    ],
                  )),
              const SizedBox(height: 16),
              // Continue button
              Obx(() => SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            controller.selected.any((element) => element)
                                ? AppColors.primary
                                : AppColors.primary.withOpacity(0.5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      onPressed: controller.selected.any((element) => element)
                          ? () {
                              // Get selected IDs
                              List<int> selectedIds =
                                  controller.getSelectedIds();
                              List<CoworkerlistDealData> selectedCoworkers =
                                  controller.getSelectedCoworkers();

                              print('Selected IDs: $selectedIds');
                              print(
                                  'Selected Coworkers: ${selectedCoworkers.map((c) => '${c.id}: ${c.dealName}').toList()}');
                              controller.getAgencyCoworkerList(selectedIds.map((id) => id.toString()).toList());

                              // Handle continue
                              // Get.back();
                            }
                          : null,
                      child: Text(
                        tr(LanguageKeys.Continue),
                        style: TextStyle(
                            color: controller.selected.any((element) => element)
                                ? Colors.white
                                : Colors.white.withOpacity(0.7),
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
