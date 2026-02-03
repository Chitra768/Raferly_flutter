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
  String? lead_sent;
  String? success_leads;
  String? lost_leads;
  String? completed_leads;
  String? pending_leads;
  String? lead_ranking;
  String? conversion_ranking;
  String? total_referrers;
  String? conversion_rate;
  String? total_commission_amount;
  String? turn_over_generated;
  String? profit_generated;
  String? monthly_avg;
  String? referrer_avatar;
  String? referrer_full_name;
  String? referrer_job;
  String? ranking;

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
    lead_sent = json['lead_sent'].toString();
    success_leads = json['success_leads'].toString();
    lost_leads = json['lost_leads'].toString();
    completed_leads = json['completed_leads'].toString();
    pending_leads = json['pending_leads'].toString();
    lead_ranking = json['lead_ranking'].toString();
    conversion_ranking = json['conversion_ranking'].toString();
    total_referrers = json['total_referrers'].toString();
    conversion_rate = json['conversion_rate'].toString();
    total_commission_amount = json['total_commission_amount'].toString();
    turn_over_generated = json['turn_over_generated'].toString();
    profit_generated = json['profit_generated'].toString();
    monthly_avg = json['monthly_avg'].toString();
    referrer_avatar = json['referrer_avatar']?.toString();
    referrer_full_name = json['referrer_full_name']?.toString();
    referrer_job = json['referrer_job']?.toString();
    ranking = json['ranking']?.toString();
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
