class ModelShareReferralFormRequest {
  String? dealId;
  String? firstName;
  String? lastName;
  String? email;
  String? phoneNumber;
  String? job;
  String? city;
  LeadInfo? lead;
  int? terms;

  ModelShareReferralFormRequest({
    this.dealId,
    this.firstName,
    this.lastName,
    this.email,
    this.phoneNumber,
    this.job,
    this.city,
    this.lead,
    this.terms,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['deal_id'] = dealId;
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['email'] = email;
    data['phone_number'] = phoneNumber;
    data['job'] = job;
    data['city'] = city;
    if (lead != null) {
      data['lead'] = lead!.toJson();
    }
    data['terms'] = terms;
    return data;
  }
}

class LeadInfo {
  String? firstName;
  String? lastName;
  String? email;
  String? phoneNumber;
  String? description;

  LeadInfo({
    this.firstName,
    this.lastName,
    this.email,
    this.phoneNumber,
    this.description,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['email'] = email;
    data['phone_number'] = phoneNumber;
    data['description'] = description;
    return data;
  }
}

class ModelShareReferralFormResponse {
  int? code;
  bool? status;
  String? message;
  ShareReferralFormData? data;
  List<dynamic>? pagination;

  ModelShareReferralFormResponse({
    this.code,
    this.status,
    this.message,
    this.data,
    this.pagination,
  });

  ModelShareReferralFormResponse.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    status = json['status'];
    message = json['message'];
    data = json['data'] != null
        ? ShareReferralFormData.fromJson(json['data'])
        : null;
    pagination = json['pagination'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['code'] = code;
    data['status'] = status;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['pagination'] = pagination;
    return data;
  }
}

class ShareReferralFormData {
  String? firstName;
  String? lastName;
  String? email;
  int? dealId;
  String? phoneNumber;
  String? description;
  int? leadAssignType;
  bool? isNew;
  int? createdBy;
  String? updatedAt;
  String? createdAt;
  int? id;
  String? companyLogoUrl;
  DealInfo? deal;
  UserInfo? user;

  ShareReferralFormData({
    this.firstName,
    this.lastName,
    this.email,
    this.dealId,
    this.phoneNumber,
    this.description,
    this.leadAssignType,
    this.isNew,
    this.createdBy,
    this.updatedAt,
    this.createdAt,
    this.id,
    this.companyLogoUrl,
    this.deal,
    this.user,
  });

  ShareReferralFormData.fromJson(Map<String, dynamic> json) {
    firstName = json['first_name'];
    lastName = json['last_name'];
    email = json['email'];
    dealId = json['deal_id'];
    phoneNumber = json['phone_number'];
    description = json['description'];
    leadAssignType = json['lead_assign_type'];
    isNew = json['is_new'];
    createdBy = json['created_by'];
    updatedAt = json['updated_at'];
    createdAt = json['created_at'];
    id = json['id'];
    companyLogoUrl = json['company_logo_url'];
    deal = json['deal'] != null ? DealInfo.fromJson(json['deal']) : null;
    user = json['user'] != null ? UserInfo.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['email'] = email;
    data['deal_id'] = dealId;
    data['phone_number'] = phoneNumber;
    data['description'] = description;
    data['lead_assign_type'] = leadAssignType;
    data['is_new'] = isNew;
    data['created_by'] = createdBy;
    data['updated_at'] = updatedAt;
    data['created_at'] = createdAt;
    data['id'] = id;
    data['company_logo_url'] = companyLogoUrl;
    if (deal != null) {
      data['deal'] = deal!.toJson();
    }
    if (user != null) {
      data['user'] = user!.toJson();
    }
    return data;
  }
}

class DealInfo {
  int? id;
  String? uuid;
  int? createdBy;
  String? dealName;
  int? dealCommissionType;
  String? commissionType;
  String? commissionValue;
  String? description;
  String? document;
  int? documentUploadedManually;
  int? suggestion;
  int? isDelete;
  String? deepLink;
  String? sharingTempLink;
  int? sendLeadOut;
  int? isActive;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;
  String? inviteQrCode;
  String? documentUrl;
  String? commissionTransType;
  String? inviteLink;
  CreatedDetail? createdDetail;

  DealInfo({
    this.id,
    this.uuid,
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
    this.inviteLink,
    this.createdDetail,
  });

  DealInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    uuid = json['uuid'];
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
    createdDetail = json['created_detail'] != null
        ? CreatedDetail.fromJson(json['created_detail'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['uuid'] = uuid;
    data['created_by'] = createdBy;
    data['deal_name'] = dealName;
    data['deal_commission_type'] = dealCommissionType;
    data['commission_type'] = commissionType;
    data['commission_value'] = commissionValue;
    data['description'] = description;
    data['document'] = document;
    data['document_uploaded_manually'] = documentUploadedManually;
    data['suggestion'] = suggestion;
    data['is_delete'] = isDelete;
    data['deep_link'] = deepLink;
    data['sharing_temp_link'] = sharingTempLink;
    data['send_lead_out'] = sendLeadOut;
    data['is_active'] = isActive;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['deleted_at'] = deletedAt;
    data['invite_qr_code'] = inviteQrCode;
    data['document_url'] = documentUrl;
    data['commission_trans_type'] = commissionTransType;
    data['invite_link'] = inviteLink;
    if (createdDetail != null) {
      data['created_detail'] = createdDetail!.toJson();
    }
    return data;
  }
}

class UserInfo {
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
  String? companyLogoUrl;
  String? avatarUrl;
  String? productId;
  String? fullName;
  List<dynamic>? roles;

  UserInfo({
    this.id,
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
    this.fullName,
    this.roles,
  });

  UserInfo.fromJson(Map<String, dynamic> json) {
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
    fullName = json['full_name'];
    roles = json['roles'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['email'] = email;
    data['phone_number'] = phoneNumber;
    data['avatar'] = avatar;
    data['social_type'] = socialType;
    data['social_id'] = socialId;
    data['company_type'] = companyType;
    data['company_name'] = companyName;
    data['company_id'] = companyId;
    data['company_logo'] = companyLogo;
    data['company_country_code'] = companyCountryCode;
    data['company_number'] = companyNumber;
    data['company_address'] = companyAddress;
    data['company_description'] = companyDescription;
    data['job_id'] = jobId;
    data['job'] = job;
    data['industry'] = industry;
    data['city'] = city;
    data['country_code'] = countryCode;
    data['country'] = country;
    data['referral_code'] = referralCode;
    data['is_paid'] = isPaid;
    data['has_subscribed_once'] = hasSubscribedOnce;
    data['paid_start_at'] = paidStartAt;
    data['paid_end_at'] = paidEndAt;
    data['is_active'] = isActive;
    data['password_reset_otp'] = passwordResetOtp;
    data['email_verified_at'] = emailVerifiedAt;
    data['lang'] = lang;
    data['send_lead_out'] = sendLeadOut;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['deleted_at'] = deletedAt;
    data['company_logo_url'] = companyLogoUrl;
    data['avatar_url'] = avatarUrl;
    data['product_id'] = productId;
    data['full_name'] = fullName;
    data['roles'] = roles;
    return data;
  }
}

class CreatedDetail {
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
  String? companyLogoUrl;
  String? avatarUrl;
  String? productId;
  String? fullName;
  List<Role>? roles;

  CreatedDetail({
    this.id,
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
    this.fullName,
    this.roles,
  });

  CreatedDetail.fromJson(Map<String, dynamic> json) {
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
    fullName = json['full_name'];
    if (json['roles'] != null) {
      roles = <Role>[];
      json['roles'].forEach((v) {
        roles!.add(Role.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['email'] = email;
    data['phone_number'] = phoneNumber;
    data['avatar'] = avatar;
    data['social_type'] = socialType;
    data['social_id'] = socialId;
    data['company_type'] = companyType;
    data['company_name'] = companyName;
    data['company_id'] = companyId;
    data['company_logo'] = companyLogo;
    data['company_country_code'] = companyCountryCode;
    data['company_number'] = companyNumber;
    data['company_address'] = companyAddress;
    data['company_description'] = companyDescription;
    data['job_id'] = jobId;
    data['job'] = job;
    data['industry'] = industry;
    data['city'] = city;
    data['country_code'] = countryCode;
    data['country'] = country;
    data['referral_code'] = referralCode;
    data['is_paid'] = isPaid;
    data['has_subscribed_once'] = hasSubscribedOnce;
    data['paid_start_at'] = paidStartAt;
    data['paid_end_at'] = paidEndAt;
    data['is_active'] = isActive;
    data['password_reset_otp'] = passwordResetOtp;
    data['email_verified_at'] = emailVerifiedAt;
    data['lang'] = lang;
    data['send_lead_out'] = sendLeadOut;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['deleted_at'] = deletedAt;
    data['company_logo_url'] = companyLogoUrl;
    data['avatar_url'] = avatarUrl;
    data['product_id'] = productId;
    data['full_name'] = fullName;
    if (roles != null) {
      data['roles'] = roles!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Role {
  int? id;
  String? name;
  String? guardName;
  String? createdAt;
  String? updatedAt;
  Pivot? pivot;

  Role({
    this.id,
    this.name,
    this.guardName,
    this.createdAt,
    this.updatedAt,
    this.pivot,
  });

  Role.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    guardName = json['guard_name'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    pivot = json['pivot'] != null ? Pivot.fromJson(json['pivot']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['guard_name'] = guardName;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if (pivot != null) {
      data['pivot'] = pivot!.toJson();
    }
    return data;
  }
}

class Pivot {
  String? modelType;
  int? modelId;
  int? roleId;

  Pivot({
    this.modelType,
    this.modelId,
    this.roleId,
  });

  Pivot.fromJson(Map<String, dynamic> json) {
    modelType = json['model_type'];
    modelId = json['model_id'];
    roleId = json['role_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['model_type'] = modelType;
    data['model_id'] = modelId;
    data['role_id'] = roleId;
    return data;
  }
}
