import 'package:get/get.dart';
import 'package:referaly/apis/api_result.dart';
import 'package:referaly/apis/rest_auth.dart';
import 'package:referaly/models/model_collaboratorList.dart';
import 'package:referaly/models/model_coworkerlist_deal.dart';
import 'package:referaly/screens/referrers_screen.dart';

class TeamMemberSelectDealsController extends GetxController {
  final RxList<bool> selected = <bool>[].obs;
  final RxBool selectAll = false.obs;
  final RxList<CoworkerlistDealData> deals = <CoworkerlistDealData>[].obs;
  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadDeals();
  }

  void toggleSelectAll(bool? value) {
    selectAll.value = value ?? false;
    selected.value = List.generate(deals.length, (_) => selectAll.value);
  }

  void toggleItem(int index, bool? value) {
    if (index < selected.length) {
      selected[index] = value ?? false;
      selectAll.value = selected.every((e) => e);
    }
  }

  List<int> getSelectedIds() {
    final selectedIds = <int>[];
    for (var i = 0; i < selected.length && i < deals.length; i++) {
      if (selected[i] && deals[i].id != null) {
        selectedIds.add(deals[i].id!);
      }
    }
    return selectedIds;
  }

  bool get hasSelection => selected.any((e) => e);

  Future<void> loadDeals() async {
    isLoading.value = true;
    error.value = '';
    try {
      final response = await RESTAuth.getUserDealList();
      if (response is ApiSuccess<ModelCoworkerlistDeal>) {
        if (response.data.status == true) {
          deals.value = response.data.data ?? [];
          selected.value = List.generate(deals.length, (_) => false);
        }
      } else if (response is ApiFailure) {
        error.value = response.error.message ?? '';
      }
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> onContinue() async {
    final selectedIds = getSelectedIds();
    if (selectedIds.isEmpty) return;

    final dealIdStrings = selectedIds.map((id) => id.toString()).toList();
    isLoading.value = true;
    error.value = '';
    try {
      final response = await RESTAuth.getAgencyCoworkerList(dealIdStrings);
      if (response is ApiSuccess<CollaboratorListModel>) {
        if (response.data.status == true) {
          await Get.toNamed(
            ReferrersScreen.pageId,
            arguments: {
              'coworkers': response.data.data,
              'id': dealIdStrings,
            },
          );
          Get.back(result: true);
        }
      } else if (response is ApiFailure) {
        error.value = response.error.message ?? '';
      }
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }
}
