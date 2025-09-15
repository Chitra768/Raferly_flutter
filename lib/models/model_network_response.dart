class ModelNetworkResponse {
  int? code;
  bool? status;
  String? message;
  Data? data;

  ModelNetworkResponse({this.code, this.status, this.message, this.data});

  ModelNetworkResponse.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['code'] = this.code;
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  int? totalLeads;
  int? totalBusinessReferrers;
  int? totalCollaborators;
  int? notificationCount;
  List<BusinessReferrers>? businessReferrers;
  List<Leads>? leads;

  Data(
      {this.totalLeads,
      this.totalBusinessReferrers,
      this.totalCollaborators,
      this.businessReferrers,
      this.notificationCount,
      this.leads});

  Data.fromJson(Map<String, dynamic> json) {
    totalLeads = json['total_leads'];
    totalBusinessReferrers = json['total_business_referrers'];
    totalCollaborators = json['total_collaborators'];
    notificationCount = json['notification_count'];
    if (json['business_referrers'] != null) {
      businessReferrers = <BusinessReferrers>[];
      json['business_referrers'].forEach((v) {
        businessReferrers!.add(BusinessReferrers.fromJson(v));
      });
    }
    if (json['leads'] != null) {
      leads = <Leads>[];
      json['leads'].forEach((v) {
        leads!.add(Leads.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['total_leads'] = this.totalLeads;
    data['total_business_referrers'] = this.totalBusinessReferrers;
    data['total_collaborators'] = this.totalCollaborators;
    data['notification_count'] = this.notificationCount;
    if (this.businessReferrers != null) {
      data['business_referrers'] =
          this.businessReferrers!.map((v) => v.toJson()).toList();
    }
    if (this.leads != null) {
      data['leads'] = this.leads!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class BusinessReferrers {
  int? id;
  String? firstName;
  String? lastName;
  String? avatarUrl;
  String? email;
  String? countryCode;
  String? phoneNumber;
  String? createdAt;
  int? dealId;
  String? lastAcceptedDealName;
  String? leadCount;
  String? companyName;
  String? job;

  BusinessReferrers(
      {this.id,
      this.firstName,
      this.lastName,
      this.avatarUrl,
      this.email,
      this.countryCode,
      this.phoneNumber,
      this.createdAt,
      this.dealId,
      this.lastAcceptedDealName,
      this.leadCount,
      this.companyName,
      this.job});

  BusinessReferrers.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    avatarUrl = json['avatar_url'];
    email = json['email'];
    countryCode = json['country_code'];
    phoneNumber = json['phone_number'];
    createdAt = json['created_at'];
    dealId = json['deal_id'];
    lastAcceptedDealName = json['last_accepted_deal_name'];
    leadCount = json['LeadsCount'].toString();
    companyName = json['company_name'];
    job = json['job'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = this.id;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['avatar_url'] = this.avatarUrl;
    data['email'] = this.email;
    data['country_code'] = this.countryCode;
    data['phone_number'] = this.phoneNumber;
    data['created_at'] = this.createdAt;
    data['deal_id'] = this.dealId;
    data['last_accepted_deal_name'] = this.lastAcceptedDealName;
    data['LeadsCount'] = this.leadCount;
    data['company_name'] = this.companyName;
    data['job'] = this.job;
    return data;
  }
}

class Leads {
  int? id;
  String? firstName;
  String? lastName;
  String? email;
  Null? countryCode;
  String? phoneNumber;
  String? createdAt;
  String? companyLogoUrl;
  String? businessReferrerName;

  Leads(
      {this.id,
      this.firstName,
      this.lastName,
      this.email,
      this.countryCode,
      this.phoneNumber,
      this.createdAt,
      this.companyLogoUrl,
      this.businessReferrerName});

  Leads.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    email = json['email'];
    countryCode = json['country_code'];
    phoneNumber = json['phone_number'];
    createdAt = json['created_at'];
    companyLogoUrl = json['company_logo_url'];
    businessReferrerName = json['business_referrer_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = this.id;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['email'] = this.email;
    data['country_code'] = this.countryCode;
    data['phone_number'] = this.phoneNumber;
    data['created_at'] = this.createdAt;
    data['company_logo_url'] = this.companyLogoUrl;
    data['business_referrer_name'] = this.businessReferrerName;
    return data;
  }
}

