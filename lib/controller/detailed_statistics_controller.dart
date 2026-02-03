import 'package:get/get.dart';
import 'package:referaly/apis/api_result.dart';
import 'package:referaly/apis/rest_auth.dart';
import 'package:referaly/languages/languagekeys.dart';
import 'package:referaly/models/model_referral_statistics.dart';
import 'package:referaly/resources/app_helper.dart';
import 'package:referaly/utils/translations.dart';

class DetailedStatisticsController extends GetxController {
  // Header/profile
  final RxString userName = ''.obs;
  final RxString userRole = ''.obs;
  final RxString userBadge = ''.obs;
  final RxString userAvatar = ''.obs;

  // Rankings
  final RxString leadsRanking = ''.obs;
  final RxString leadsRankingTotal = ''.obs;
  final RxString conversionRanking = ''.obs;
  final RxString conversionRankingTotal = ''.obs;

  // Lead statistics
  final RxString leadsSent = ''.obs;
  final RxString lostLeads = ''.obs;
  final RxString successfulLeads = ''.obs;
  final RxString pendingLeads = ''.obs;

  // Performance
  final RxString conversionRate = ''.obs; // percent
  final RxString conversionNote = ''.obs;
  // Financials
  final RxString totalCommissionAmount = ''.obs;
  final RxString turnoverGenerated = ''.obs;
  final RxString profitGenerated = ''.obs;
  final RxBool isLoading = false.obs;
  final RxString monthlyConversionRate = ''.obs;
  RxInt referrerId = 0.obs;
  var arguments = Get.arguments;

  @override
  void onInit() {
    super.onInit();
    if (arguments != null && arguments is Map<String, dynamic>) {
      if (arguments.containsKey('referrer_id')) {
        referrerId.value = arguments['referrer_id'];
      } else if (arguments.containsKey('referrerId')) {
        referrerId.value = arguments['referrerId'];
      }
    }
    if (referrerId.value > 0) {
      fetchReferralStatistics();
    }
  }

  Future<void> fetchReferralStatistics() async {
    isLoading.value = true;
    try {
      final response =
          await RESTAuth.getReferralStatistics(referrerId: referrerId.value);
      if (response is ApiSuccess<ModelReferralStatistics>) {
        final data = response.data.data;
        if (data != null) {
          // Header
          userName.value = data.referrer_full_name ?? '';
          userRole.value = data.referrer_job ?? '';
          userAvatar.value = data.referrer_avatar ?? '';
          if (data.ranking != null) {
            userBadge.value = 'Top ${data.ranking}';
          } else {
            userBadge.value = '';
          }

          leadsSent.value = data.lead_sent ?? '';
          successfulLeads.value = data.success_leads ?? '';
          lostLeads.value = data.lost_leads ?? '';
          pendingLeads.value = data.pending_leads ?? '';

          leadsRanking.value = data.lead_ranking ?? '';
          conversionRanking.value = data.conversion_ranking ?? '';
          leadsRankingTotal.value = data.total_referrers ?? '';
          conversionRankingTotal.value = data.total_referrers ?? '';
          monthlyConversionRate.value = data.monthly_avg ?? '';

          final rateNum = data.conversion_rate ?? 0;
          conversionRate.value =
              rateNum is String ? rateNum : (rateNum is String ? rateNum : '');

          final completed = data.completed_leads ?? 0;
          conversionNote.value =
              '${successfulLeads.value} ${tr(LanguageKeys.successfulOutOf)} $completed ${tr(LanguageKeys.completedLeads)}';

          // Financials
          final commission = data.total_commission_amount ?? 0;
          totalCommissionAmount.value = commission is String
              ? commission
              : (commission is String ? commission : '');

          final turnover = data.turn_over_generated ?? 0;
          turnoverGenerated.value = turnover is String
              ? turnover
              : (turnover is String ? turnover : '');

          final profit = data.profit_generated ?? 0;
          profitGenerated.value =
              profit is String ? profit : (profit is String ? profit : '');
        }
      } else if (response is ApiFailure) {
        AppHelper.showLog(
            'Referral statistics error: ${response.error.message ?? 'Unknown error'}');
      }
    } catch (e) {
      AppHelper.showLog('Referral statistics exception: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
