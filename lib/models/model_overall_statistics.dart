// ignore_for_file: non_constant_identifier_names, prefer_collection_literals

class ModelOverallStatistics {
  int? code;
  bool? status;
  String? message;
  OverallStatisticsData? data;
  List<dynamic>? pagination;

  ModelOverallStatistics({
    this.code,
    this.status,
    this.message,
    this.data,
    this.pagination,
  });

  ModelOverallStatistics.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    status = json['status'];
    message = json['message'];
    data = json['data'] != null
        ? OverallStatisticsData.fromJson(json['data'])
        : null;
    pagination = json['pagination'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['code'] = code;
    data['status'] = status;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    if (pagination != null) {
      data['pagination'] = pagination;
    }
    return data;
  }
}

class OverallStatisticsData {
  List<ReferrerRanking>? referrer_rankings;
  String? total_commission_amount;
  String? total_turn_over;
  String? total_net_income;
  String? total_referrers;
  String? lead_sent;
  String? success_leads;
  String? lost_leads;
  String? completed_leads;
  String? pending_leads;
  String? conversion_rate;
  String? monthly_avg;
  String? referrer_avg;
  String? annual_avg;
  OverallStatisticsData({
    this.referrer_rankings,
    this.total_commission_amount,
    this.total_turn_over,
    this.total_net_income,
    this.total_referrers,
    this.lead_sent,
    this.success_leads,
    this.lost_leads,
    this.completed_leads,
    this.pending_leads,
    this.conversion_rate,
    this.monthly_avg,
    this.referrer_avg,
    this.annual_avg,
  });

  OverallStatisticsData.fromJson(Map<String, dynamic> json) {
    if (json['referrer_rankings'] != null) {
      referrer_rankings = <ReferrerRanking>[];
      json['referrer_rankings'].forEach((v) {
        referrer_rankings!.add(ReferrerRanking.fromJson(v));
      });
    }
    total_commission_amount = json['total_commission_amount'].toString();
    total_turn_over = json['total_turn_over'].toString();
    total_net_income = json['total_net_income'].toString();
    total_referrers = json['total_referrers'].toString();
    lead_sent = json['lead_sent'].toString();
    success_leads = json['success_leads'].toString();
    lost_leads = json['lost_leads'].toString();
    completed_leads = json['completed_leads'].toString();
    pending_leads = json['pending_leads'].toString();
    conversion_rate = json['conversion_rate'].toString();
    monthly_avg = json['monthly_avg'].toString();
    referrer_avg = json['referrer_avg'].toString();
    annual_avg = json['year_avg'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (referrer_rankings != null) {
      data['referrer_rankings'] =
          referrer_rankings!.map((v) => v.toJson()).toList();
    }
    data['total_commission_amount'] = total_commission_amount;
    data['total_turn_over'] = total_turn_over;
    data['total_net_income'] = total_net_income;
    data['total_referrers'] = total_referrers;
    data['lead_sent'] = lead_sent;
    data['success_leads'] = success_leads;
    data['lost_leads'] = lost_leads;
    data['completed_leads'] = completed_leads;
    data['pending_leads'] = pending_leads;
    data['conversion_rate'] = conversion_rate;
    data['monthly_avg'] = monthly_avg;
    data['referrer_avg'] = referrer_avg;
    data['year_avg'] = annual_avg;
    return data;
  }
}

class ReferrerRanking {
  String? rank;
  String? first_name;
  String? last_name;
  String? last_name_short;
  String? avatar;
  String? job;
  String? lead_sent;
  String? conversion_rate;
  String? turnover;

  ReferrerRanking({
    this.rank,
    this.first_name,
    this.last_name,
    this.last_name_short,
    this.avatar,
    this.job,
    this.lead_sent,
    this.conversion_rate,
    this.turnover,
  });

  ReferrerRanking.fromJson(Map<String, dynamic> json) {
    rank = json['rank'].toString();
    first_name = json['first_name'].toString();
    last_name = json['last_name'].toString();
    last_name_short = json['last_name_short'].toString();
    avatar = json['avatar'].toString();
    job = json['job'].toString();
    lead_sent = json['lead_sent'].toString();
    conversion_rate = json['conversion_rate'].toString();
    turnover = json['turn_over_generated'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['rank'] = rank;
    data['first_name'] = first_name;
    data['last_name'] = last_name;
    data['last_name_short'] = last_name_short;
    data['avatar'] = avatar;
    data['job'] = job;
    data['lead_sent'] = lead_sent;
    data['conversion_rate'] = conversion_rate;
    data['turn_over_generated'] = turnover;
    return data;
  }
}
