
// ignore_for_file: non_constant_identifier_names, unnecessary_this, prefer_collection_literals

class ModelDashboardResponse {
  int? code;
  bool? status;
  String? message;
  DashboardResponse ? data;
  List<String>? pagination;

  ModelDashboardResponse (
      {this.code, this.status, this.message, this.data, this.pagination});

  ModelDashboardResponse .fromJson(Map<String, dynamic> json) {
    code = json['code'];
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? DashboardResponse .fromJson(json['data']) : null;
    if (json['pagination'] != null) {
      pagination = <String>[];
      json['pagination'].forEach((v) {
        pagination!.add(v.toString());
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
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

class DashboardResponse  {
  int? myDeals;
  int? totalLeads;
  int? incomeGenerated;
  int? totalReceivedLeads;
  int? invitedDealsCount;
  int? numberOfPartner;
  List<String>? activeDeals;
  List<DealDocuments>? dealDocuments;
  String? url;
  String? documentUrl;
  String? notificationsCount="0";
  AllNotification? allNotification;
  String? calendly_url;

  DashboardResponse (
      {this.myDeals,
      this.totalLeads,
      this.incomeGenerated,
      this.totalReceivedLeads,
      this.invitedDealsCount,
      this.numberOfPartner,
      this.activeDeals,
        this.dealDocuments,
      this.url,
      this.documentUrl,
       this.notificationsCount,
        this.allNotification,
        this.calendly_url
      });

  DashboardResponse .fromJson(Map<String, dynamic> json) {
    myDeals = json['my_deals'];
    totalLeads = json['total_leads'];
    incomeGenerated = json['income_generated'];
    totalReceivedLeads = json['total_received_leads'];
    invitedDealsCount = json['invited_deals_count'];
    numberOfPartner = json['number_of_partner'];
    if (json['activeDeals'] != null) {
      activeDeals = <String>[];
      json['activeDeals'].forEach((v) {
        activeDeals!.add(v.toString());
      });
    }
    if (json['dealDocuments'] != null) {
      dealDocuments = <DealDocuments>[];
      json['dealDocuments'].forEach((v) {
        dealDocuments!.add(DealDocuments(
          name: v['name'],
          document: v['document']
        ));
      });
    }
    url = json['url'];
    documentUrl = json['document_url'];
    notificationsCount = json['notificationsCount'].toString();
     allNotification = json['AllNotification'] != null
        ? new AllNotification.fromJson(json['AllNotification'])
        : null;
    calendly_url = json['calendly_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['my_deals'] = this.myDeals;
    data['total_leads'] = this.totalLeads;
    data['income_generated'] = this.incomeGenerated;
    data['total_received_leads'] = this.totalReceivedLeads;
    data['invited_deals_count'] = this.invitedDealsCount;
    data['number_of_partner'] = this.numberOfPartner;
    if (this.activeDeals != null) {
      data['activeDeals'] = this.activeDeals!;
    }
      if (this.dealDocuments != null) {
      data['dealDocuments'] = this.dealDocuments!.map((v) => {
        'name': v.name,
        'document': v.document
      }).toList();
    }
    data['url'] = this.url;
    data['document_url'] = this.documentUrl;
    data['notificationsCount'] = this.notificationsCount;
     if (this.allNotification != null) {
      data['AllNotification'] = this.allNotification!.toJson();
    }
    data['calendly_url'] = this.calendly_url;
    return data;
  }
}

class DealDocuments {
  String? name;
  String? document;

  DealDocuments({this.name, this.document});
}
class AllNotification {
  MyActivityNotification? myActivityNotification;
  MyActivityNotification? referrerNotifications;
  MyActivityNotification? trackingNotifications;

  AllNotification(
      {this.myActivityNotification,
      this.referrerNotifications,
      this.trackingNotifications});

  AllNotification.fromJson(Map<String, dynamic> json) {
    myActivityNotification = json['my_activity_notification'] != null
        ? new MyActivityNotification.fromJson(json['my_activity_notification'])
        : null;
    referrerNotifications = json['referrer_notifications'] != null
        ? new MyActivityNotification.fromJson(json['referrer_notifications'])
        : null;
    trackingNotifications = json['tracking_notifications'] != null
        ? new MyActivityNotification.fromJson(json['tracking_notifications'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.myActivityNotification != null) {
      data['my_activity_notification'] = this.myActivityNotification!.toJson();
    }
    if (this.referrerNotifications != null) {
      data['referrer_notifications'] = this.referrerNotifications!.toJson();
    }
    if (this.trackingNotifications != null) {
      data['tracking_notifications'] = this.trackingNotifications!.toJson();
    }
    return data;
  }
}

class MyActivityNotification {
  int? count;

  MyActivityNotification({this.count});

  MyActivityNotification.fromJson(Map<String, dynamic> json) {
    count = json['count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['count'] = this.count;
    return data;
  }
}