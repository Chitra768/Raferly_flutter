// ignore_for_file: non_constant_identifier_names, unnecessary_this, prefer_collection_literals

class ModelReferralStatistics {
  int? code;
  bool? status;
  String? message;
  ReferralStatisticsData? data;
  List<String>? pagination;

  ModelReferralStatistics({
    this.code,
    this.status,
    this.message,
    this.data,
    this.pagination,
  });

  ModelReferralStatistics.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    status = json['status'];
    message = json['message'];
    data = json['data'] != null
        ? ReferralStatisticsData.fromJson(json['data'])
        : null;
    if (json['pagination'] != null) {
      pagination = <String>[];
      json['pagination'].forEach((v) {
        pagination!.add(v.toString());
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['code'] = this.code;
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    if (this.pagination != null) {
      data['pagination'] = this.pagination!;
    }
    return data;
  }
}

class ReferralStatisticsData {
  int? lead_sent;
  int? success_leads;
  int? lost_leads;
  int? completed_leads;
  int? pending_leads;
  int? lead_ranking;
  int? conversion_ranking;
  int? total_referrers;
  num? conversion_rate;
  num? total_commission_amount;
  num? turn_over_generated;
  num? profit_generated;
  int? monthly_avg;
  String? referrer_avatar;
  String? referrer_full_name;
  String? referrer_job;
  int? ranking;

  ReferralStatisticsData({
    this.lead_sent,
    this.success_leads,
    this.lost_leads,
    this.completed_leads,
    this.pending_leads,
    this.lead_ranking,
    this.conversion_ranking,
    this.total_referrers,
    this.conversion_rate,
    this.total_commission_amount,
    this.turn_over_generated,
    this.profit_generated,
    this.monthly_avg,
    this.referrer_avatar,
    this.referrer_full_name,
    this.referrer_job,
    this.ranking,
  });

  ReferralStatisticsData.fromJson(Map<String, dynamic> json) {
    lead_sent = json['lead_sent'];
    success_leads = json['success_leads'];
    lost_leads = json['lost_leads'];
    completed_leads = json['completed_leads'];
    pending_leads = json['pending_leads'];
    lead_ranking = json['lead_ranking'];
    conversion_ranking = json['conversion_ranking'];
    total_referrers = json['total_referrers'];
    conversion_rate = json['conversion_rate'];
    total_commission_amount = json['total_commission_amount'];
    turn_over_generated = json['turn_over_generated'];
    profit_generated = json['profit_generated'];
    monthly_avg = json['monthly_avg'] ?? 0;
    referrer_avatar = json['referrer_avatar'];
    referrer_full_name = json['referrer_full_name'];
    referrer_job = json['referrer_job'];
    ranking = json['ranking'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['lead_sent'] = this.lead_sent;
    data['success_leads'] = this.success_leads;
    data['lost_leads'] = this.lost_leads;
    data['completed_leads'] = this.completed_leads;
    data['pending_leads'] = this.pending_leads;
    data['lead_ranking'] = this.lead_ranking;
    data['conversion_ranking'] = this.conversion_ranking;
    data['total_referrers'] = this.total_referrers;
    data['conversion_rate'] = this.conversion_rate;
    data['total_commission_amount'] = this.total_commission_amount;
    data['turn_over_generated'] = this.turn_over_generated;
    data['profit_generated'] = this.profit_generated;
    data['monthly_avg'] = this.monthly_avg;
    data['referrer_avatar'] = this.referrer_avatar;
    data['referrer_full_name'] = this.referrer_full_name;
    data['referrer_job'] = this.referrer_job;
    data['ranking'] = this.ranking;
    return data;
  }
}
