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
  num? total_commission_amount;
  num? total_turn_over;
  num? total_net_income;
  int? total_referrers;
  int? lead_sent;
  int? success_leads;
  int? lost_leads;
  int? completed_leads;
  int? pending_leads;
  num? conversion_rate;
  num? monthly_avg;
  num? referrer_avg;

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
  });

  OverallStatisticsData.fromJson(Map<String, dynamic> json) {
    if (json['referrer_rankings'] != null) {
      referrer_rankings = <ReferrerRanking>[];
      json['referrer_rankings'].forEach((v) {
        referrer_rankings!.add(ReferrerRanking.fromJson(v));
      });
    }
    total_commission_amount = json['total_commission_amount'];
    total_turn_over = json['total_turn_over'];
    total_net_income = json['total_net_income'];
    total_referrers = json['total_referrers'];
    lead_sent = json['lead_sent'];
    success_leads = json['success_leads'];
    lost_leads = json['lost_leads'];
    completed_leads = json['completed_leads'];
    pending_leads = json['pending_leads'];
    conversion_rate = json['conversion_rate'];
    monthly_avg = json['monthly_avg'];
    referrer_avg = json['referrer_avg'];
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
    return data;
  }
}

class ReferrerRanking {
  int? rank;
  String? first_name;
  String? last_name;
  String? last_name_short;
  String? avatar;
  String? job;
  int? lead_sent;

  ReferrerRanking({
    this.rank,
    this.first_name,
    this.last_name,
    this.last_name_short,
    this.avatar,
    this.job,
    this.lead_sent,
  });

  ReferrerRanking.fromJson(Map<String, dynamic> json) {
    rank = json['rank'];
    first_name = json['first_name'];
    last_name = json['last_name'];
    last_name_short = json['last_name_short'];
    avatar = json['avatar'];
    job = json['job'];
    lead_sent = json['lead_sent'];
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
    return data;
  }
}
