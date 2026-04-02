// ignore_for_file: non_constant_identifier_names, unnecessary_this, prefer_collection_literals

class ModelParentReferralStatistics {
  int? code;
  bool? status;
  String? message;
  ParentReferralStatisticsData? data;
  List<dynamic>? pagination;

  ModelParentReferralStatistics({
    this.code,
    this.status,
    this.message,
    this.data,
    this.pagination,
  });

  ModelParentReferralStatistics.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    status = json['status'];
    message = json['message']?.toString();
    data = json['data'] != null
        ? ParentReferralStatisticsData.fromJson(json['data'])
        : null;
    if (json['pagination'] is List) {
      pagination = List<dynamic>.from(json['pagination']);
    }
  }
}

class ParentReferralStatisticsData {
  int? referrer_added;
  int? total_leads;
  int? won_leads;
  double? won_leads_percentage;
  int? lost_leads;
  double? lost_leads_percentage;
  int? pending_leads;
  double? pending_leads_percentage;
  double? total_commission_amount;
  double? commission_rate;
  double? parent_commission_amount;
  List<ParentBusinessReferrer>? business_referrers;

  ParentReferralStatisticsData({
    this.referrer_added,
    this.total_leads,
    this.won_leads,
    this.won_leads_percentage,
    this.lost_leads,
    this.lost_leads_percentage,
    this.pending_leads,
    this.pending_leads_percentage,
    this.total_commission_amount,
    this.commission_rate,
    this.parent_commission_amount,
    this.business_referrers,
  });

  ParentReferralStatisticsData.fromJson(Map<String, dynamic> json) {
    referrer_added = _toInt(json['referrer_added']);
    total_leads = _toInt(json['total_leads']);
    won_leads = _toInt(json['won_leads']);
    won_leads_percentage = _toDouble(json['won_leads_percentage']);
    lost_leads = _toInt(json['lost_leads']);
    lost_leads_percentage = _toDouble(json['lost_leads_percentage']);
    pending_leads = _toInt(json['pending_leads']);
    pending_leads_percentage = _toDouble(json['pending_leads_percentage']);
    total_commission_amount = _toDouble(json['total_commission_amount']);
    commission_rate = _toDouble(json['commission_rate']);
    parent_commission_amount = _toDouble(json['parent_commission_amount']);
    if (json['business_referrers'] is List) {
      business_referrers = <ParentBusinessReferrer>[];
      for (final v in json['business_referrers']) {
        business_referrers!.add(ParentBusinessReferrer.fromJson(v));
      }
    }
  }
}

class ParentBusinessReferrer {
  int? id;
  String? full_name;
  String? avatar_url;
  int? leads_sent;

  ParentBusinessReferrer({
    this.id,
    this.full_name,
    this.avatar_url,
    this.leads_sent,
  });

  ParentBusinessReferrer.fromJson(Map<String, dynamic> json) {
    id = _toInt(json['id']);
    full_name = json['full_name']?.toString();
    avatar_url = json['avatar_url']?.toString();
    leads_sent = _toInt(json['leads_sent']);
  }
}

int _toInt(dynamic value) {
  if (value == null) return 0;
  if (value is int) return value;
  return int.tryParse(value.toString()) ?? 0;
}

double _toDouble(dynamic value) {
  if (value == null) return 0;
  if (value is num) return value.toDouble();
  return double.tryParse(value.toString()) ?? 0;
}
