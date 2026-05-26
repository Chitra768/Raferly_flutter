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
          leadsSent.value = _toInt(d.lead_sent);
          successfulLeads.value = _toInt(d.success_leads);
          lostLeads.value = _toInt(d.lost_leads);
          pendingLeads.value = _toInt(d.pending_leads);
          // Rates and averages
          conversionRate.value = _toDouble(d.conversion_rate);
          perMonth.value = _toDouble(d.monthly_avg);
          avgPerReferrer.value = _toDouble(d.referrer_avg);
          receivedPerMonth.value = _toDouble(d.monthly_avg);
          annualReceived.value = _toDouble(d.annual_avg);
          // Financials
          commission.value = _toDouble(d.total_commission_amount);
          turnover.value = _toDouble(d.total_turn_over);
          totalIncomeGenerated.value = _toDouble(d.total_net_income).toString();
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

  // Safely parses an API string-like value into an int, tolerating null,
  // empty strings, the literal string "null", and decimal values like "1.0".
  int _toInt(String? raw) {
    if (raw == null) return 0;
    final cleaned = raw.trim();
    if (cleaned.isEmpty || cleaned.toLowerCase() == 'null') return 0;
    return int.tryParse(cleaned) ?? double.tryParse(cleaned)?.toInt() ?? 0;
  }

  // Safely parses an API string-like value into a double, tolerating null,
  // empty strings, and the literal string "null".
  double _toDouble(String? raw) {
    if (raw == null) return 0.0;
    final cleaned = raw.trim();
    if (cleaned.isEmpty || cleaned.toLowerCase() == 'null') return 0.0;
    return double.tryParse(cleaned) ?? 0.0;
  }
}
