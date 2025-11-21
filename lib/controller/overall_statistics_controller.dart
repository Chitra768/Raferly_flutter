import 'package:get/get.dart';
import 'package:referaly/apis/api_result.dart' show ApiFailure, ApiSuccess;
import 'package:referaly/apis/rest_auth.dart' show RESTAuth;
import 'package:referaly/models/model_overall_statistics.dart';

/// Controller for Overall Statistics screen.
///
/// Mirrors the structure and conventions used by other controllers in the app
/// (GetX observables, `onInit`, and explicit loading/error state handling).
class OverallStatisticsController extends GetxController {
  // Loading and error states
  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;

  // Lead statistics
  final RxInt leadsSent = 0.obs;
  final RxInt lostLeads = 0.obs;
  final RxInt successfulLeads = 0.obs;
  final RxInt pendingLeads = 0.obs;

  // Performance and aggregates
  final RxDouble conversionRate = 0.0.obs; // percent value (0-100)
  final RxDouble perMonth = 0.0.obs; // average per month
  final RxDouble avgPerReferrer = 0.0.obs;
  final RxDouble receivedPerMonth = 0.0.obs;
  final RxDouble annualReceived = 0.0.obs;
  // Financials
  final RxDouble commission = 0.0.obs; // total commission amount
  final RxDouble turnover = 0.0.obs; // total turnover
  final RxString totalIncomeGenerated = ''.obs; // combined value

  // Rankings
  final RxList<ReferrerRanking> rankings = <ReferrerRanking>[].obs;
  
  // Filter criteria - empty string means "Filter by criteria" (default)
  final RxString selectedFilterCriteria = ''.obs; // '', 'leads_sent', 'conversion_rate', 'turnover'
  
  // Computed filtered rankings
  List<ReferrerRanking> get filteredRankings {
    final allRankings = [...rankings];
    final criteria = selectedFilterCriteria.value;
    
    // If no filter selected, use default sorting by leads_sent
    if (criteria.isEmpty) {
      allRankings.sort((a, b) => (b.lead_sent ?? 0).compareTo(a.lead_sent ?? 0));
    } else {
      switch (criteria) {
        case 'leads_sent':
          allRankings.sort((a, b) => (b.lead_sent ?? 0).compareTo(a.lead_sent ?? 0));
          break;
        case 'conversion_rate':
          // Sort by conversion rate (successful leads / total leads)
          // For now, we'll use lead_sent as a proxy since we don't have conversion_rate in the model
          // This would need to be updated when the API provides conversion_rate per referrer
          allRankings.sort((a, b) => (b.lead_sent ?? 0).compareTo(a.lead_sent ?? 0));
          break;
        case 'turnover':
          // Sort by turnover
          // For now, we'll use lead_sent as a proxy since we don't have turnover in the model
          // This would need to be updated when the API provides turnover per referrer
          allRankings.sort((a, b) => (b.lead_sent ?? 0).compareTo(a.lead_sent ?? 0));
          break;
      }
    }
    // Reassign ranks based on sorted order
    for (int i = 0; i < allRankings.length; i++) {
      allRankings[i].rank = i + 1;
    }
    return allRankings;
  }
  
  void setFilterCriteria(String? criteria) {
    selectedFilterCriteria.value = criteria ?? '';
  }

  @override
  void onInit() {
    super.onInit();
    fetchOverallStatistics();
  }

  Future<void> fetchOverallStatistics() async {
    try {
      isLoading.value = true;
      error.value = '';

      final result = await RESTAuth.getOverallStatistics();
      if (result is ApiSuccess<ModelOverallStatistics>) {
        final payload = result.data;
        if (payload.status == true && payload.data != null) {
          final d = payload.data!;

          // Core counts
          leadsSent.value = d.lead_sent ?? 0;
          successfulLeads.value = d.success_leads ?? 0;
          lostLeads.value = d.lost_leads ?? 0;
          pendingLeads.value = d.pending_leads ?? 0;

          // Rates and averages
          conversionRate.value = (d.conversion_rate ?? 0).toDouble();
          perMonth.value = (d.monthly_avg ?? 0).toDouble();
          avgPerReferrer.value = (d.referrer_avg ?? 0).toDouble();
          receivedPerMonth.value = (d.monthly_avg ?? 0).toDouble();
          annualReceived.value = (d.annual_avg ?? 0).toDouble();
          // Financials
          commission.value = (d.total_commission_amount ?? 0).toDouble();
          turnover.value = (d.total_turn_over ?? 0).toDouble();
          totalIncomeGenerated.value = d.total_net_income.toString();

          // Rankings
          rankings.value = d.referrer_rankings ?? [];
          rankings.refresh();
        } else {
          error.value = payload.message ?? 'Failed to fetch statistics';
        }
      } else if (result is ApiFailure) {
        error.value = result.error.message ?? 'Something went wrong';
      } else {
        error.value = 'Unexpected response';
      }
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }
}
