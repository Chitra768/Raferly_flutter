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
  final RxString selectedFilterCriteria =
      'leads_sent'.obs; // '', 'leads_sent', 'conversion_rate', 'turnover'

  void setFilterCriteria(String? criteria) {
    selectedFilterCriteria.value = criteria ?? '';
    fetchOverallStatistics();
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

      String orderBy = '';
      if (selectedFilterCriteria.value == 'leads_sent') {
        orderBy = 'lead_sent';
      } else if (selectedFilterCriteria.value == 'conversion_rate') {
        orderBy = 'conversion_rate';
      } else if (selectedFilterCriteria.value == 'turnover') {
        orderBy = 'turn_over_generated';
      } else {
        orderBy = '';
      }

      final result = await RESTAuth.getOverallStatistics(orderBy: orderBy);
      if (result is ApiSuccess<ModelOverallStatistics>) {
        final payload = result.data;
        if (payload.status == true && payload.data != null) {
          final d = payload.data!;
          // Core counts
          leadsSent.value = int.parse(d.lead_sent ?? '0');
          successfulLeads.value = int.parse(d.success_leads ?? '0');
          lostLeads.value = int.parse(d.lost_leads ?? '0');
          pendingLeads.value = int.parse(d.pending_leads ?? '0');
          // Rates and averages
          conversionRate.value = double.parse(d.conversion_rate ?? '0');
          perMonth.value = double.parse(d.monthly_avg ?? '0');
          avgPerReferrer.value = double.parse(d.referrer_avg ?? '0');
          receivedPerMonth.value = double.parse(d.monthly_avg ?? '0');
          annualReceived.value = double.parse(d.annual_avg ?? '0');
          // Financials
          commission.value = double.parse(d.total_commission_amount ?? '0');
          turnover.value = double.parse(d.total_turn_over ?? '0');
          totalIncomeGenerated.value = double.parse(d.total_net_income ?? '0').toString();
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
