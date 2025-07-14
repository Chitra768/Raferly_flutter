
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
 List<ActiveDeals>? activeDeals;
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
      activeDeals = <ActiveDeals>[];
      json['activeDeals'].forEach((v) {
        activeDeals!.add(new ActiveDeals.fromJson(v));
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
      data['activeDeals'] = this.activeDeals!.map((v) => v.toJson()).toList();
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
class ActiveDeals {
  String? id;
  String? createdBy;
  String? dealName;
  String? dealCommissionType;
  String? commissionType;
  String? commissionValue;
  String? description;
  String? document;
  String? documentUploadedManually;
  String? suggestion;
  String? isDelete;
  String? deepLink;
  String? sharingTempLink;
  String? sendLeadOut;
  String? isActive;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;
  bool? accepted;
  String? inviteLink;
  String? inviteQrCode;
  String? documentUrl;
  String? commissionTransType;
  CreatedDetail? createdDetail;

  ActiveDeals(
      {this.id,
      this.createdBy,
      this.dealName,
      this.dealCommissionType,
      this.commissionType,
      this.commissionValue,
      this.description,
      this.document,
      this.documentUploadedManually,
      this.suggestion,
      this.isDelete,
      this.deepLink,
      this.sharingTempLink,
      this.sendLeadOut,
      this.isActive,
      this.createdAt,
      this.updatedAt,
      this.deletedAt,
      this.accepted,
      this.inviteLink,
      this.inviteQrCode,
      this.documentUrl,
      this.commissionTransType,
      this.createdDetail});

  ActiveDeals.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    createdBy = json['created_by'].toString();
    dealName = json['deal_name'].toString();
    dealCommissionType = json['deal_commission_type'].toString();
    commissionType = json['commission_type'].toString();
    commissionValue = json['commission_value'].toString();
    description = json['description'];
    document = json['document'].toString();
    documentUploadedManually = json['document_uploaded_manually'].toString();
    suggestion = json['suggestion'].toString();
    isDelete = json['is_delete'].toString();
    deepLink = json['deep_link'].toString();
    sharingTempLink = json['sharing_temp_link'].toString();
    sendLeadOut = json['send_lead_out'].toString();
    isActive = json['is_active'].toString();
    createdAt = json['created_at'].toString();
    updatedAt = json['updated_at'].toString();
    deletedAt = json['deleted_at'].toString();
    accepted = json['accepted'];
    inviteLink = json['invite_link'].toString();
    inviteQrCode = json['invite_qr_code'].toString();
    documentUrl = json['document_url'].toString();
    commissionTransType = json['commission_trans_type'].toString();
    createdDetail = json['created_detail'] != null
        ? new CreatedDetail.fromJson(json['created_detail'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['created_by'] = this.createdBy;
    data['deal_name'] = this.dealName;
    data['deal_commission_type'] = this.dealCommissionType;
    data['commission_type'] = this.commissionType;
    data['commission_value'] = this.commissionValue;
    data['description'] = this.description;
    data['document'] = this.document;
    data['document_uploaded_manually'] = this.documentUploadedManually;
    data['suggestion'] = this.suggestion;
    data['is_delete'] = this.isDelete;
    data['deep_link'] = this.deepLink;
    data['sharing_temp_link'] = this.sharingTempLink;
    data['send_lead_out'] = this.sendLeadOut;
    data['is_active'] = this.isActive;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['deleted_at'] = this.deletedAt;
    data['accepted'] = this.accepted;
    data['invite_link'] = this.inviteLink;
    data['invite_qr_code'] = this.inviteQrCode;
    data['document_url'] = this.documentUrl;
    data['commission_trans_type'] = this.commissionTransType;
    if (this.createdDetail != null) {
      data['created_detail'] = this.createdDetail!.toJson();
    }
    return data;
  }
}
class CreatedDetail {
  String? id;
  String? firstName;
  String? lastName;
  String? email;
  String? phoneNumber;
  String? avatar;
  String? socialType;
  String? socialId;
  String? companyType;
  String? companyName;
  String? companyId;
  String? companyLogo;
  String? companyCountryCode;
  String? companyNumber;
  String? companyAddress;
  String? companyDescription;
  String? jobId;
  String? job;
  String? industry;
  String? city;
  String? countryCode;
  String? country;
  String? referralCode;
  int? isPaid;
  int? hasSubscribedOnce;
  String? paidStartAt;
  String? paidEndAt;
  int? isActive;
  String? passwordResetOtp;
  String? emailVerifiedAt;
  String? lang;
  int? sendLeadOut;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;
  String? companyUrl;
  String? avatarUrl;
  String? companyLogoUrl;
  String? productId;
  String? fullName;
  List<Roles>? roles;

  CreatedDetail(
      {this.id,
      this.firstName,
      this.lastName,
      this.email,
      this.phoneNumber,
      this.avatar,
      this.socialType,
      this.socialId,
      this.companyType,
      this.companyName,
      this.companyId,
      this.companyLogo,
      this.companyCountryCode,
      this.companyNumber,
      this.companyAddress,
      this.companyDescription,
      this.jobId,
      this.job,
      this.industry,
      this.city,
      this.countryCode,
      this.country,
      this.referralCode,
      this.isPaid,
      this.hasSubscribedOnce,
      this.paidStartAt,
      this.paidEndAt,
      this.isActive,
      this.passwordResetOtp,
      this.emailVerifiedAt,
      this.lang,
      this.sendLeadOut,
      this.createdAt,
      this.updatedAt,
      this.deletedAt,
      this.companyUrl,
      this.avatarUrl,
      this.companyLogoUrl,
      this.productId,
      this.fullName,
      this.roles});

  CreatedDetail.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString()  ;
    firstName = json['first_name'].toString();
    lastName = json['last_name'].toString();
    email = json['email'].toString();
    phoneNumber = json['phone_number'].toString();
    avatar = json['avatar'].toString();
    socialType = json['social_type'].toString();
    socialId = json['social_id'].toString();
    companyType = json['company_type'].toString();
    companyName = json['company_name'].toString();
    companyId = json['company_id'].toString();
    companyLogo = json['company_logo'].toString();
    companyCountryCode = json['company_country_code'].toString();
    companyNumber = json['company_number'].toString();
    companyAddress = json['company_address'].toString();
    companyDescription = json['company_description'].toString();
    jobId = json['job_id'].toString();
    job = json['job'].toString();
    industry = json['industry'].toString();
    city = json['city'].toString();
    countryCode = json['country_code'].toString();
    country = json['country'].toString();
    referralCode = json['referral_code'].toString();
    isPaid = json['is_paid'];
    hasSubscribedOnce = json['has_subscribed_once'];
    paidStartAt = json['paid_start_at'].toString();
    paidEndAt = json['paid_end_at'].toString();
    isActive = json['is_active'];
    passwordResetOtp = json['password_reset_otp'].toString();
    emailVerifiedAt = json['email_verified_at'].toString();
    lang = json['lang'].toString();
    sendLeadOut = json['send_lead_out'];
    createdAt = json['created_at'].toString();
    updatedAt = json['updated_at'].toString();
    deletedAt = json['deleted_at'].toString();
    companyUrl = json['company_url'].toString();
    avatarUrl = json['avatar_url'].toString();
    companyLogoUrl = json['company_logo_url'].toString();
    productId = json['product_id'].toString();
    fullName = json['full_name'].toString();
    if (json['roles'] != null) {
      roles = <Roles>[];
      json['roles'].forEach((v) {
        roles!.add(new Roles.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['email'] = this.email;
    data['phone_number'] = this.phoneNumber;
    data['avatar'] = this.avatar;
    data['social_type'] = this.socialType;
    data['social_id'] = this.socialId;
    data['company_type'] = this.companyType;
    data['company_name'] = this.companyName;
    data['company_id'] = this.companyId;
    data['company_logo'] = this.companyLogo;
    data['company_country_code'] = this.companyCountryCode;
    data['company_number'] = this.companyNumber;
    data['company_address'] = this.companyAddress;
    data['company_description'] = this.companyDescription;
    data['job_id'] = this.jobId;
    data['job'] = this.job;
    data['industry'] = this.industry;
    data['city'] = this.city;
    data['country_code'] = this.countryCode;
    data['country'] = this.country;
    data['referral_code'] = this.referralCode;
    data['is_paid'] = this.isPaid;
    data['has_subscribed_once'] = this.hasSubscribedOnce;
    data['paid_start_at'] = this.paidStartAt;
    data['paid_end_at'] = this.paidEndAt;
    data['is_active'] = this.isActive;
    data['password_reset_otp'] = this.passwordResetOtp;
    data['email_verified_at'] = this.emailVerifiedAt;
    data['lang'] = this.lang;
    data['send_lead_out'] = this.sendLeadOut;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['deleted_at'] = this.deletedAt;
    data['company_url'] = this.companyUrl;
    data['avatar_url'] = this.avatarUrl;
    data['company_logo_url'] = this.companyLogoUrl;
    data['product_id'] = this.productId;
    data['full_name'] = this.fullName;
    if (this.roles != null) {
      data['roles'] = this.roles!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
class Roles {
  int? id;
  String? name;
  String? guardName;
  String? createdAt;
  String? updatedAt;
  Pivot? pivot;

  Roles(
      {this.id,
      this.name,
      this.guardName,
      this.createdAt,
      this.updatedAt,
      this.pivot});

  Roles.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    guardName = json['guard_name'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    pivot = json['pivot'] != null ? new Pivot.fromJson(json['pivot']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['guard_name'] = this.guardName;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.pivot != null) {
      data['pivot'] = this.pivot!.toJson();
    }
    return data;
  }
}

class Pivot {
  String? modelType;
  int? modelId;
  int? roleId;

  Pivot({this.modelType, this.modelId, this.roleId});

  Pivot.fromJson(Map<String, dynamic> json) {
    modelType = json['model_type'];
    modelId = json['model_id'];
    roleId = json['role_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['model_type'] = this.modelType;
    data['model_id'] = this.modelId;
    data['role_id'] = this.roleId;
    return data;
  }
}