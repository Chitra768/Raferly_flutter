
// ignore_for_file: unnecessary_new

class ModelArchiveListReceive {
  int? code;
  bool? status;
  String? message;
  List<Data>? data;

  ModelArchiveListReceive({this.code, this.status, this.message, this.data});

  ModelArchiveListReceive.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  int? id;
  String? firstName;
  String? lastName;
  Null? email;
  String? phoneNumber;
  int? dealId;
  String? description;
  String? leadAssignType;
  Null? businessReferralId;
  int? createdBy;
  int? isLost;
  String? lostReason;
  int? isActive;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;
  String? dealName;
  String? companyLogoUrl;
  List<Null>? leadTrack;
  Deal? deal;
  User? user;

  Data(
      {this.id,
      this.firstName,
      this.lastName,
      this.email,
      this.phoneNumber,
      this.dealId,
      this.description,
      this.leadAssignType,
      this.businessReferralId,
      this.createdBy,
      this.isLost,
      this.lostReason,
      this.isActive,
      this.createdAt,
      this.updatedAt,
      this.deletedAt,
      this.dealName,
      this.companyLogoUrl,
      this.leadTrack,
      this.deal,
      this.user});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    email = json['email'];
    phoneNumber = json['phone_number'];
    dealId = json['deal_id'];
    description = json['description'];
    leadAssignType = json['lead_assign_type'];
    businessReferralId = json['business_referral_id'];
    createdBy = json['created_by'];
    isLost = json['is_lost'];
    lostReason = json['lost_reason'];
    isActive = json['is_active'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
    dealName = json['deal_name'];
    companyLogoUrl = json['company_logo_url'];
    if (json['lead_track'] != null) {
      leadTrack = json['lead_track'].cast<dynamic>();
    }
    deal = json['deal'] != null ? new Deal.fromJson(json['deal']) : null;
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['email'] = this.email;
    data['phone_number'] = this.phoneNumber;
    data['deal_id'] = this.dealId;
    data['description'] = this.description;
    data['lead_assign_type'] = this.leadAssignType;
    data['business_referral_id'] = this.businessReferralId;
    data['created_by'] = this.createdBy;
    data['is_lost'] = this.isLost;
    data['lost_reason'] = this.lostReason;
    data['is_active'] = this.isActive;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['deleted_at'] = this.deletedAt;
    data['deal_name'] = this.dealName;
    data['company_logo_url'] = this.companyLogoUrl;
    if (this.leadTrack != null) {
      data['lead_track'] = leadTrack!;
    }
    if (this.deal != null) {
      data['deal'] = this.deal!.toJson();
    }
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    return data;
  }
}

class Deal {
  int? id;
  int? createdBy;
  String? dealName;
  int? dealCommissionType;
  String? commissionType;
  String? commissionValue;
  Null? description;
  Null? document;
  int? documentUploadedManually;
  int? suggestion;
  int? isDelete;
  String? deepLink;
  String? sharingTempLink;
  int? sendLeadOut;
  int? isActive;
  String? createdAt;
  String? updatedAt;
  Null? deletedAt;
  String? inviteQrCode;
  String? documentUrl;
  String? commissionTransType;
  String? inviteLink;

  Deal(
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
      this.inviteQrCode,
      this.documentUrl,
      this.commissionTransType,
      this.inviteLink});

  Deal.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdBy = json['created_by'];
    dealName = json['deal_name'];
    dealCommissionType = json['deal_commission_type'];
    commissionType = json['commission_type'];
    commissionValue = json['commission_value'];
    description = json['description'];
    document = json['document'];
    documentUploadedManually = json['document_uploaded_manually'];
    suggestion = json['suggestion'];
    isDelete = json['is_delete'];
    deepLink = json['deep_link'];
    sharingTempLink = json['sharing_temp_link'];
    sendLeadOut = json['send_lead_out'];
    isActive = json['is_active'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
    inviteQrCode = json['invite_qr_code'];
    documentUrl = json['document_url'];
    commissionTransType = json['commission_trans_type'];
    inviteLink = json['invite_link'];
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
    data['invite_qr_code'] = this.inviteQrCode;
    data['document_url'] = this.documentUrl;
    data['commission_trans_type'] = this.commissionTransType;
    data['invite_link'] = this.inviteLink;
    return data;
  }
}

class User {
  int? id;
  String? firstName;
  String? lastName;
  String? email;
  String? phoneNumber;
  String? avatar;
  String? socialType;
  String? socialId;
  String? companyType;
  String? companyName;
  Null? companyId;
  String? companyLogo;
  String? companyCountryCode;
  String? companyNumber;
  String? companyAddress;
  String? companyDescription;
  Null? jobId;
  String? job;
  Null? industry;
  String? city;
  String? countryCode;
  Null? country;
  String? referralCode;
  int? isPaid;
  int? hasSubscribedOnce;
  String? paidStartAt;
  String? paidEndAt;
  int? isActive;
  String? passwordResetOtp;
  Null? emailVerifiedAt;
  String? lang;
  int? sendLeadOut;
  String? createdAt;
  String? updatedAt;
  Null? deletedAt;
  String? companyLogoUrl;
  String? avatarUrl;
  Null? productId;
  List<Roles>? roles;

  User(
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
      this.companyLogoUrl,
      this.avatarUrl,
      this.productId,
      this.roles});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    email = json['email'];
    phoneNumber = json['phone_number'];
    avatar = json['avatar'];
    socialType = json['social_type'];
    socialId = json['social_id'];
    companyType = json['company_type'];
    companyName = json['company_name'];
    companyId = json['company_id'];
    companyLogo = json['company_logo'];
    companyCountryCode = json['company_country_code'];
    companyNumber = json['company_number'];
    companyAddress = json['company_address'];
    companyDescription = json['company_description'];
    jobId = json['job_id'];
    job = json['job'];
    industry = json['industry'];
    city = json['city'];
    countryCode = json['country_code'];
    country = json['country'];
    referralCode = json['referral_code'];
    isPaid = json['is_paid'];
    hasSubscribedOnce = json['has_subscribed_once'];
    paidStartAt = json['paid_start_at'];
    paidEndAt = json['paid_end_at'];
    isActive = json['is_active'];
    passwordResetOtp = json['password_reset_otp'];
    emailVerifiedAt = json['email_verified_at'];
    lang = json['lang'];
    sendLeadOut = json['send_lead_out'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
    companyLogoUrl = json['company_logo_url'];
    avatarUrl = json['avatar_url'];
    productId = json['product_id'];
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
    data['company_logo_url'] = this.companyLogoUrl;
    data['avatar_url'] = this.avatarUrl;
    data['product_id'] = this.productId;
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