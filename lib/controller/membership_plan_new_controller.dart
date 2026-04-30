import 'package:get/get.dart';
import 'package:referaly/apis/api_result.dart';
import 'package:referaly/apis/rest_auth.dart';
import 'package:referaly/models/model_plan_detail.dart';

class MembershipPlanNewController extends GetxController {
  final RxBool isLoading = false.obs;
  final RxString selectedType = 'Yearly'.obs; // Yearly / Monthly

  final RxList<SubscriptionPlan> subscriptions = <SubscriptionPlan>[].obs;
  final RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchPlanDetail();
  }

  Future<void> fetchPlanDetail() async {
    isLoading.value = true;
    errorMessage.value = '';

    final result = await RESTAuth.getPlanDetail(type: selectedType.value);
    if (result is ApiSuccess) {
      final data = result.data as PlanDetailResponse?;
      if (data == null) {
        subscriptions.clear();
        errorMessage.value = 'Unexpected response';
      } else {
        subscriptions.assignAll(data.data?.subscriptions ?? const <SubscriptionPlan>[]);
      }
    } else if (result is ApiFailure) {
      final err = result.error;
      errorMessage.value = err.message ?? 'Something went wrong';
      subscriptions.clear();
    }

    isLoading.value = false;
  }

  Future<void> setTypeAndReload(String type) async {
    if (type == selectedType.value) return;
    selectedType.value = type;
    await fetchPlanDetail();
  }

  SubscriptionPlan? findPlanForCard(String card) {
    final list = subscriptions;
    if (list.isEmpty) return null;

    String normalize(String s) => s.toLowerCase();
    bool hasType(SubscriptionPlan p, String expected) =>
        normalize(p.subscriptionType ?? '').trim() == expected;

    if (card == 'independent') {
      return list.firstWhereOrNull(
            (p) =>
                hasType(p, 'independent') ||
                normalize(p.name ?? '').contains('independent') ||
                normalize(p.name ?? '').contains('indépendant'),
          ) ??
          list.firstWhereOrNull((p) => normalize(p.subscriptionType ?? '').contains('independent'));
    }
    if (card == 'agency') {
      return list.firstWhereOrNull(
            (p) =>
                hasType(p, 'agency') ||
                normalize(p.name ?? '').contains('agency') ||
                normalize(p.name ?? '').contains('agence'),
          ) ??
          list.firstWhereOrNull((p) => normalize(p.subscriptionType ?? '').contains('agency'));
    }
    return null;
  }
}

