import 'package:get/get.dart';
import 'package:referaly/apis/api_result.dart';
import 'package:referaly/apis/rest_auth.dart';
import 'package:referaly/models/model_referral_statistics.dart';
import 'package:referaly/resources/app_helper.dart';

class DetailedStatisticsController extends GetxController {
  // Header/profile
  final RxString userName = ''.obs;
  final RxString userRole = ''.obs;
  final RxString userBadge = ''.obs;
  final RxString userAvatar = ''.obs;

  // Rankings
  final RxInt leadsRanking = 0.obs;
  final RxInt leadsRankingTotal = 0.obs;
  final RxInt conversionRanking = 0.obs;
  final RxInt conversionRankingTotal = 0.obs;

  // Lead statistics
  final RxInt leadsSent = 0.obs;
  final RxInt lostLeads = 0.obs;
  final RxInt successfulLeads = 0.obs;
  final RxInt pendingLeads = 0.obs;

  // Performance
  final RxDouble conversionRate = 0.0.obs; // percent
  final RxString conversionNote = ''.obs;
  // Financials
  final RxDouble totalCommissionAmount = 0.0.obs;
  final RxDouble turnoverGenerated = 0.0.obs;
  final RxDouble profitGenerated = 0.0.obs;
  final RxBool isLoading = false.obs;
  final RxInt monthlyConversionRate = 0.obs;
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

          leadsSent.value = data.lead_sent ?? 0;
          successfulLeads.value = data.success_leads ?? 0;
          lostLeads.value = data.lost_leads ?? 0;
          pendingLeads.value = data.pending_leads ?? 0;

          leadsRanking.value = data.lead_ranking ?? 0;
          conversionRanking.value = data.conversion_ranking ?? 0;
          leadsRankingTotal.value = data.total_referrers ?? 0;
          conversionRankingTotal.value = data.total_referrers ?? 0;
          monthlyConversionRate.value = data.monthly_avg ?? 0;

          final rateNum = data.conversion_rate ?? 0;
          conversionRate.value = rateNum is int
              ? rateNum.toDouble()
              : (rateNum is double ? rateNum : 0.0);

          final completed = data.completed_leads ?? 0;
          conversionNote.value =
              '${successfulLeads.value} successful out of $completed completed';

          // Financials
          final commission = data.total_commission_amount ?? 0;
          totalCommissionAmount.value = commission is int
              ? commission.toDouble()
              : (commission is double ? commission : 0.0);

          final turnover = data.turn_over_generated ?? 0;
          turnoverGenerated.value = turnover is int
              ? turnover.toDouble()
              : (turnover is double ? turnover : 0.0);

          final profit = data.profit_generated ?? 0;
          profitGenerated.value = profit is int
              ? profit.toDouble()
              : (profit is double ? profit : 0.0);
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
