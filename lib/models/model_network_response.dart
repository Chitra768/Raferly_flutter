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
    data['code'] = code;
    data['status'] = status;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  int? totalLeads;

  /// Total business referrers in network (API: `total_business_referrers`).
  int? totalBusinessReferrers;
  int? totalCollaborators;
  int? notificationCount;

  /// Active (non-pending) referrers count (API: `active_business_referrers`).
  int? activeBusinessReferrers;

  /// Pending invitations count (API: `pending_business_referrers`; legacy: `pending_request_count`).
  int? pendingBusinessReferrers;
  List<BusinessReferrers>? businessReferrers;
  List<Leads>? leads;

  Data(
      {this.totalLeads,
      this.totalBusinessReferrers,
      this.totalCollaborators,
      this.businessReferrers,
      this.notificationCount,
      this.activeBusinessReferrers,
      this.pendingBusinessReferrers,
      this.leads});

  static int? _parseOptionalInt(dynamic raw) {
    if (raw == null) return null;
    if (raw is int) return raw;
    if (raw is num) return raw.toInt();
    return int.tryParse(raw.toString().trim());
  }

  Data.fromJson(Map<String, dynamic> json) {
    totalLeads = _parseOptionalInt(json['total_leads']);
    totalBusinessReferrers = _parseOptionalInt(json['total_business_referrers']);
    totalCollaborators = _parseOptionalInt(json['total_collaborators']);
    notificationCount = _parseOptionalInt(json['notification_count']);
    activeBusinessReferrers = _parseOptionalInt(
      json['active_business_referrers'],
    );
    pendingBusinessReferrers = _parseOptionalInt(
      json['pending_business_referrers'],
    );
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
    data['total_leads'] = totalLeads;
    data['total_business_referrers'] = totalBusinessReferrers;
    data['total_collaborators'] = totalCollaborators;
    data['notification_count'] = notificationCount;
    if (activeBusinessReferrers != null) {
      data['active_business_referrers'] = activeBusinessReferrers;
    }
    if (pendingBusinessReferrers != null) {
      data['pending_business_referrers'] = pendingBusinessReferrers;
    }
    if (businessReferrers != null) {
      data['business_referrers'] = businessReferrers!.map((v) => v.toJson()).toList();
    }
    if (leads != null) {
      data['leads'] = leads!.map((v) => v.toJson()).toList();
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
  String? companyType;
  String? isShareReferral;
  String? sponsoredBy;
  bool? isPendingInvitation;

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
      this.job,
      this.companyType,
      this.isShareReferral,
      this.sponsoredBy,
      this.isPendingInvitation});

  static String? _parseSponsoredBy(dynamic raw) {
    if (raw == null) return null;
    if (raw is String) return raw.trim().isEmpty ? null : raw.trim();
    if (raw is Map) {
      final n = raw['name'] ?? raw['full_name'];
      if (n != null) return n.toString();
    }
    final s = raw.toString();
    return s.isEmpty ? null : s;
  }

  BusinessReferrers.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    avatarUrl = json['avatar_url'];
    email = json['email'];
    countryCode = json['country_code']?.toString();
    phoneNumber = json['phone_number'];
    createdAt = json['created_at'];
    dealId = json['deal_id'];
    lastAcceptedDealName = json['last_accepted_deal_name'];
    leadCount = json['LeadsCount'].toString();
    companyName = json['company_name'];
    job = json['job'];
    companyType = json['company_type'];
    isShareReferral = json['is_share_referral'].toString();
    sponsoredBy = _parseSponsoredBy(json['sponsored_by']);
    isPendingInvitation = json['is_pending_invitation'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['avatar_url'] = avatarUrl;
    data['email'] = email;
    data['country_code'] = countryCode;
    data['phone_number'] = phoneNumber;
    data['created_at'] = createdAt;
    data['deal_id'] = dealId;
    data['last_accepted_deal_name'] = lastAcceptedDealName;
    data['LeadsCount'] = leadCount;
    data['company_name'] = companyName;
    data['job'] = job;
    data['company_type'] = companyType;
    data['is_share_referral'] = isShareReferral;
    if (sponsoredBy != null) data['sponsored_by'] = sponsoredBy;
    if (isPendingInvitation != null) data['is_pending_invitation'] = isPendingInvitation;
    return data;
  }
}

class Leads {
  int? id;
  String? firstName;
  String? lastName;
  String? email;
  String? countryCode;
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
    countryCode = json['country_code']?.toString();
    phoneNumber = json['phone_number'];
    createdAt = json['created_at'];
    companyLogoUrl = json['company_logo_url'];
    businessReferrerName = json['business_referrer_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['email'] = email;
    data['country_code'] = countryCode;
    data['phone_number'] = phoneNumber;
    data['created_at'] = createdAt;
    data['company_logo_url'] = companyLogoUrl;
    data['business_referrer_name'] = businessReferrerName;
    return data;
  }
}
