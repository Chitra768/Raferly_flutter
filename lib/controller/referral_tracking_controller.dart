import 'package:get/get.dart';
import 'package:referaly/apis/api_result.dart';
import 'package:referaly/apis/rest_auth.dart';
import 'package:referaly/languages/languagekeys.dart';
import 'package:referaly/models/model_parent_referral_statistics.dart';
import 'package:referaly/utils/translations.dart';

class ReferralTrackingController extends GetxController {
  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;
  final Rxn<ParentReferralStatisticsData> stats = Rxn<ParentReferralStatisticsData>();
  final RxInt dealId = 0.obs;

  @override
  void onInit() {
    super.onInit();
    _readArgs();
    fetchStatistics();
  }

  void _readArgs() {
    final args = Get.arguments as Map<String, dynamic>? ?? {};
    final dynamic rawDealId = args['dealId'] ?? args['deal_id'];
    if (rawDealId is int) {
      dealId.value = rawDealId;
      return;
    }
    dealId.value = int.tryParse(rawDealId?.toString() ?? '') ?? 0;
  }

  Future<void> fetchStatistics() async {
    if (dealId.value <= 0) {
      error.value = tr(LanguageKeys.somethingWentWrong);
      return;
    }

    isLoading.value = true;
    error.value = '';
    try {
      final response = await RESTAuth.getStatisticsForParent(dealId: dealId.value);
      if (response is ApiSuccess<ModelParentReferralStatistics>) {
        if (response.data.status == true) {
          stats.value = response.data.data;
        } else {
          error.value = response.data.message ?? tr(LanguageKeys.somethingWentWrong);
        }
      } else if (response is ApiFailure) {
        error.value = response.error.message ?? tr(LanguageKeys.somethingWentWrong);
      }
    } catch (_) {
      error.value = tr(LanguageKeys.somethingWentWrong);
    } finally {
      isLoading.value = false;
    }
  }
}
