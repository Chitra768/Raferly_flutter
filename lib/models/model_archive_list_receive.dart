
// ignore_for_file: unnecessary_new

class ModelArchiveListReceive {
  int? code;
  bool? status;
  String? message;
  List<ArcheiveData>? data;

  ModelArchiveListReceive({this.code, this.status, this.message, this.data});

  ModelArchiveListReceive.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <ArcheiveData>[];
      json['data'].forEach((v) {
        data!.add(new ArcheiveData.fromJson(v));
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

class ArcheiveData {
  String? id;
  String? firstName;
  String? lastName;
  String? email;
  String? phoneNumber;
  String? dealId;
  String? description;
  String? leadAssignType;
  String? businessReferralId;
  String? createdBy;
  String? isLost;
  String? lostReason;
  String? isActive;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;
  String? dealName;
  String? companyLogoUrl;
  List<String>? leadTrack;
  Deal? deal;
  User? user;

  ArcheiveData(
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

  ArcheiveData.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    firstName = json['first_name'].toString();
    lastName = json['last_name'].toString();
    email = json['email'].toString();
    phoneNumber = json['phone_number'].toString();
    dealId = json['deal_id'].toString();
    description = json['description'].toString();
    leadAssignType = json['lead_assign_type'].toString();
    businessReferralId = json['business_referral_id'].toString();
    createdBy = json['created_by'].toString();
    isLost = json['is_lost'].toString();
    lostReason = json['lost_reason'].toString();
    isActive = json['is_active'].toString();
    createdAt = json['created_at'].toString();
    updatedAt = json['updated_at'].toString();
    deletedAt = json['deleted_at'].toString();
    dealName = json['deal_name'].toString();
    companyLogoUrl = json['company_logo_url'].toString();
    if (json['lead_track'] != null) {
      leadTrack = json['lead_track'].cast<String>();
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
    id = json['id'].toString();
    createdBy = json['created_by'].toString();
    dealName = json['deal_name'].toString();
    dealCommissionType = json['deal_commission_type'].toString();
    commissionType = json['commission_type'].toString();
    commissionValue = json['commission_value'].toString();
    description = json['description'].toString();
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
    inviteQrCode = json['invite_qr_code'].toString();
    documentUrl = json['document_url'].toString();
    commissionTransType = json['commission_trans_type'].toString();
    inviteLink = json['invite_link'].toString();
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
  String? isPaid;
  String? hasSubscribedOnce;
  String? paidStartAt;
  String? paidEndAt;
  String? isActive;
  String? passwordResetOtp;
  String? emailVerifiedAt;
  String? lang;
  String? sendLeadOut;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;
  String? companyLogoUrl;
  String? avatarUrl;
  String? productId;
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
    id = json['id'].toString();
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
    isPaid = json['is_paid'].toString();
    hasSubscribedOnce = json['has_subscribed_once'].toString();
    paidStartAt = json['paid_start_at'].toString();
    paidEndAt = json['paid_end_at'].toString();
    isActive = json['is_active'].toString();
    passwordResetOtp = json['password_reset_otp'].toString();
    emailVerifiedAt = json['email_verified_at'].toString();
    lang = json['lang'].toString();
    sendLeadOut = json['send_lead_out'].toString();
    createdAt = json['created_at'].toString();
    updatedAt = json['updated_at'].toString();
    deletedAt = json['deleted_at'].toString();
    companyLogoUrl = json['company_logo_url'].toString();
    avatarUrl = json['avatar_url'].toString();
    productId = json['product_id'].toString();
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
  String? id;
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
    id = json['id'].toString();
    name = json['name'].toString();
    guardName = json['guard_name'].toString();
    createdAt = json['created_at'].toString();
    updatedAt = json['updated_at'].toString();
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
  String? modelId;
  String? roleId;

  Pivot({this.modelType, this.modelId, this.roleId});

  Pivot.fromJson(Map<String, dynamic> json) {
    modelType = json['model_type'].toString();
    modelId = json['model_id'].toString();
    roleId = json['role_id'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['model_type'] = this.modelType;
    data['model_id'] = this.modelId;
    data['role_id'] = this.roleId;
    return data;
  }
}