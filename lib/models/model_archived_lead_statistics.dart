// ignore_for_file: non_constant_identifier_names, unnecessary_this, prefer_collection_literals

class ModelArchivedLeadStatistics {
  int? code;
  bool? status;
  String? message;
  ArchivedLeadStatisticsData? data;
  List<String>? pagination;

  ModelArchivedLeadStatistics({
    this.code,
    this.status,
    this.message,
    this.data,
    this.pagination,
  });

  ModelArchivedLeadStatistics.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    status = json['status'];
    message = json['message'];
    data = json['data'] != null
        ? ArchivedLeadStatisticsData.fromJson(json['data'])
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

class ArchivedLeadStatisticsData {
  double? totalCommissionAmount;
  double? totalLeads;
  double? completedLeads;
  double? lostLeads;
  ArchivedLeadStatisticsData({
    this.totalCommissionAmount,
    this.totalLeads,
    this.completedLeads,
    this.lostLeads,
  });

  ArchivedLeadStatisticsData.fromJson(Map<String, dynamic> json) {
    totalCommissionAmount = json['total_commission_amount']?.toDouble();
    totalLeads = json['total_leads']?.toDouble();
    completedLeads = json['completed_leads']?.toDouble();
    lostLeads = json['lost_leads']?.toDouble();

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['total_commission_amount'] = this.totalCommissionAmount;
    data['total_leads'] = this.totalLeads;
    data['completed_leads'] = this.completedLeads;
    data['lost_leads'] = this.lostLeads;
    return data;
  }
}
