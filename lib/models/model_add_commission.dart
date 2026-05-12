class ModelAddCommission {
  int? code;
  bool? status;
  String? message;
  Data? data;
  List<Pagination>? pagination;

  ModelAddCommission({this.code, this.status, this.message, this.data, this.pagination});

  ModelAddCommission.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
    if (json['pagination'] != null) {
      pagination = <Pagination>[];
      json['pagination'].forEach((v) {
        pagination!.add(Pagination.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['code'] = code;
    data['status'] = status;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    if (pagination != null) {
      data['pagination'] = pagination!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

String? _asString(dynamic value) {
  if (value == null) return null;
  return value.toString();
}

class Data {
  int? id;
  String? firstName;
  String? lastName;
  String? email;
  String? phoneNumber;
  int? dealId;
  String? description;
  String? leadAssignType;
  String? businessReferralId;
  int? isLevelTwo;
  int? createdBy;
  String? completedAt;
  int? commisionValue;
  int? revenue;
  CommissionData? commissionData;
  int? transactionId;
  bool? isPaid;
  String? paymentMode;
  bool? paymentCompleted;
  bool? payoutCompleted;
  int? isLost;
  bool? isNew;
  bool? isApproved;
  String? lostReason;
  int? isActive;
  bool? lastReqToUpdateAt;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;
  Level2Details? level2details;
  String? companyLogoUrl;
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
      this.isLevelTwo,
      this.createdBy,
      this.completedAt,
      this.commisionValue,
      this.revenue,
      this.commissionData,
      this.transactionId,
      this.isPaid,
      this.paymentMode,
      this.paymentCompleted,
      this.payoutCompleted,
      this.isLost,
      this.isNew,
      this.isApproved,
      this.lostReason,
      this.isActive,
      this.lastReqToUpdateAt,
      this.createdAt,
      this.updatedAt,
      this.deletedAt,
      this.level2details,
      this.companyLogoUrl,
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
    isLevelTwo = json['is_level_two'];
    createdBy = json['created_by'];
    completedAt = json['completed_at'];
    commisionValue = json['commision_value'];
    revenue = json['revenue'];
    commissionData =
        json['commission_data'] != null ? CommissionData.fromJson(json['commission_data']) : null;
    transactionId = json['transaction_id'];
    isPaid = json['is_paid'];
    paymentMode = json['payment_mode'];
    paymentCompleted = json['payment_completed'];
    payoutCompleted = json['payout_completed'];
    isLost = json['is_lost'];
    isNew = json['is_new'];
    isApproved = json['is_approved'];
    lostReason = json['lost_reason'];
    isActive = json['is_active'];
    lastReqToUpdateAt = json['last_req_to_update_at'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
    level2details =
        json['level2details'] != null ? Level2Details.fromJson(json['level2details']) : null;
    companyLogoUrl = json['company_logo_url'];
    deal = json['deal'] != null ? Deal.fromJson(json['deal']) : null;
    user = json['user'] != null ? User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['email'] = email;
    data['phone_number'] = phoneNumber;
    data['deal_id'] = dealId;
    data['description'] = description;
    data['lead_assign_type'] = leadAssignType;
    data['business_referral_id'] = businessReferralId;
    data['is_level_two'] = isLevelTwo;
    data['created_by'] = createdBy;
    data['completed_at'] = completedAt;
    data['commision_value'] = commisionValue;
    data['revenue'] = revenue;
    if (commissionData != null) {
      data['commission_data'] = commissionData!.toJson();
    }
    data['transaction_id'] = transactionId;
    data['is_paid'] = isPaid;
    data['payment_mode'] = paymentMode;
    data['payment_completed'] = paymentCompleted;
    data['payout_completed'] = payoutCompleted;
    data['is_lost'] = isLost;
    data['is_new'] = isNew;
    data['is_approved'] = isApproved;
    data['lost_reason'] = lostReason;
    data['is_active'] = isActive;
    data['last_req_to_update_at'] = lastReqToUpdateAt;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['deleted_at'] = deletedAt;
    if (level2details != null) {
      data['level2details'] = level2details!.toJson();
    }
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

class Level2Details {
  String? leadName;
  num? dealValue;
  String? originalReferrer;
  String? firstLevelReferrer;
  num? firstLevelReferrerCommission;
  num? originalReferrerCommission;
  num? level2CommissionPercentage;

  Level2Details({
    this.leadName,
    this.dealValue,
    this.originalReferrer,
    this.firstLevelReferrer,
    this.firstLevelReferrerCommission,
    this.originalReferrerCommission,
    this.level2CommissionPercentage,
  });

  Level2Details.fromJson(Map<String, dynamic> json) {
    leadName = _asString(json['leadName']);
    dealValue = _parseCommissionValue(json['dealValue']);
    originalReferrer = _asString(json['originalReferrer']);
    firstLevelReferrer = _asString(json['firstLevelReferrer']);
    firstLevelReferrerCommission = _parseCommissionValue(json['firstLevelReferrerCommission']);
    originalReferrerCommission = _parseCommissionValue(json['originalReferrerCommission']);
    level2CommissionPercentage = _parseCommissionValue(json['level2CommissionPercentage']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['leadName'] = leadName;
    data['dealValue'] = dealValue;
    data['originalReferrer'] = originalReferrer;
    data['firstLevelReferrer'] = firstLevelReferrer;
    data['firstLevelReferrerCommission'] = firstLevelReferrerCommission;
    data['originalReferrerCommission'] = originalReferrerCommission;
    data['level2CommissionPercentage'] = level2CommissionPercentage;
    return data;
  }
}

class CommissionData {
  FirstLevelCommission? firstLevelCommission;
  SecondLevelCommission? secondLevelCommission;

  CommissionData({this.firstLevelCommission, this.secondLevelCommission});

  CommissionData.fromJson(Map<String, dynamic> json) {
    firstLevelCommission = json['first_level_commission'] != null
        ? FirstLevelCommission.fromJson(json['first_level_commission'])
        : null;
    secondLevelCommission = json['second_level_commission'] != null
        ? SecondLevelCommission.fromJson(json['second_level_commission'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (firstLevelCommission != null) {
      data['first_level_commission'] = firstLevelCommission!.toJson();
    }
    if (secondLevelCommission != null) {
      data['second_level_commission'] = secondLevelCommission!.toJson();
    }
    return data;
  }
}

class FirstLevelCommission {
  int? userId;
  num? commission;

  FirstLevelCommission({this.userId, this.commission});

  FirstLevelCommission.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    commission = _parseCommissionValue(json['commission']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user_id'] = userId;
    data['commission'] = commission;
    return data;
  }
}

class SecondLevelCommission {
  int? userId;
  num? commission;

  SecondLevelCommission({this.userId, this.commission});

  SecondLevelCommission.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    commission = _parseCommissionValue(json['commission']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user_id'] = userId;
    data['commission'] = commission;
    return data;
  }
}

num? _parseCommissionValue(dynamic value) {
  if (value == null) return null;
  if (value is num) return value;
  if (value is String) return num.tryParse(value);
  return null;
}

class Deal {
  int? id;
  String? encryptedId;
  String? uuid;
  int? createdBy;
  String? dealName;
  int? dealType;
  int? dealCommissionType;
  String? commissionType;
  String? commissionValue;
  String? multiLevelReferral;
  String? level2CommissionPercentage;
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

  Deal(
      {this.id,
      this.encryptedId,
      this.uuid,
      this.createdBy,
      this.dealName,
      this.dealType,
      this.dealCommissionType,
      this.commissionType,
      this.commissionValue,
      this.multiLevelReferral,
      this.level2CommissionPercentage,
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
      this.createdDetail});

  Deal.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    encryptedId = _asString(json['encrypted_id']);
    uuid = _asString(json['uuid']);
    createdBy = json['created_by'];
    dealName = _asString(json['deal_name']);
    dealType = json['deal_type'];
    dealCommissionType = json['deal_commission_type'];
    commissionType = _asString(json['commission_type']);
    commissionValue = _asString(json['commission_value']);
    multiLevelReferral = _asString(json['multi_level_referral']);
    level2CommissionPercentage = _asString(json['level_2_commission_percentage']);
    description = _asString(json['description']);
    document = _asString(json['document']);
    documentUploadedManually = json['document_uploaded_manually'];
    suggestion = json['suggestion'];
    isDelete = json['is_delete'];
    deepLink = _asString(json['deep_link']);
    sharingTempLink = _asString(json['sharing_temp_link']);
    sendLeadOut = json['send_lead_out'];
    isActive = json['is_active'];
    createdAt = _asString(json['created_at']);
    updatedAt = _asString(json['updated_at']);
    deletedAt = _asString(json['deleted_at']);
    inviteQrCode = _asString(json['invite_qr_code']);
    documentUrl = _asString(json['document_url']);
    commissionTransType = _asString(json['commission_trans_type']);
    inviteLink = _asString(json['invite_link']);
    createdDetail =
        json['created_detail'] != null ? CreatedDetail.fromJson(json['created_detail']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['encrypted_id'] = encryptedId;
    data['uuid'] = uuid;
    data['created_by'] = createdBy;
    data['deal_name'] = dealName;
    data['deal_type'] = dealType;
    data['deal_commission_type'] = dealCommissionType;
    data['commission_type'] = commissionType;
    data['commission_value'] = commissionValue;
    data['multi_level_referral'] = multiLevelReferral;
    data['level_2_commission_percentage'] = level2CommissionPercentage;
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

class CreatedDetail {
  int? id;
  String? firstName;
  String? lastName;
  String? email;
  String? phoneNumber;
  String? avatar;
  String? socialType;
  String? socialId;
  String? uiType;
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
  String? stripeCustomerId;
  String? stripeAccountId;
  int? hasSubscribedOnce;
  String? paidStartAt;
  String? paidEndAt;
  int? isActive;
  String? createdByReferal;
  String? passwordResetOtp;
  String? emailVerifiedAt;
  String? lang;
  int? sendLeadOut;
  String? createdBy;
  String? parentId;
  int? isDirectAdded;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;
  String? companyLogoUrl;
  String? avatarUrl;
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
      this.uiType,
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
      this.stripeCustomerId,
      this.stripeAccountId,
      this.hasSubscribedOnce,
      this.paidStartAt,
      this.paidEndAt,
      this.isActive,
      this.createdByReferal,
      this.passwordResetOtp,
      this.emailVerifiedAt,
      this.lang,
      this.sendLeadOut,
      this.createdBy,
      this.parentId,
      this.isDirectAdded,
      this.createdAt,
      this.updatedAt,
      this.deletedAt,
      this.companyLogoUrl,
      this.avatarUrl,
      this.productId,
      this.fullName,
      this.roles});

  CreatedDetail.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = _asString(json['first_name']);
    lastName = _asString(json['last_name']);
    email = _asString(json['email']);
    phoneNumber = _asString(json['phone_number']);
    avatar = _asString(json['avatar']);
    socialType = _asString(json['social_type']);
    socialId = _asString(json['social_id']);
    uiType = _asString(json['ui_type']);
    companyType = _asString(json['company_type']);
    companyName = _asString(json['company_name']);
    companyId = _asString(json['company_id']);
    companyLogo = _asString(json['company_logo']);
    companyCountryCode = _asString(json['company_country_code']);
    companyNumber = _asString(json['company_number']);
    companyAddress = _asString(json['company_address']);
    companyDescription = _asString(json['company_description']);
    jobId = _asString(json['job_id']);
    job = _asString(json['job']);
    industry = _asString(json['industry']);
    city = _asString(json['city']);
    countryCode = _asString(json['country_code']);
    country = _asString(json['country']);
    referralCode = _asString(json['referral_code']);
    isPaid = json['is_paid'];
    stripeCustomerId = _asString(json['stripe_customer_id']);
    stripeAccountId = _asString(json['stripe_account_id']);
    hasSubscribedOnce = json['has_subscribed_once'];
    paidStartAt = _asString(json['paid_start_at']);
    paidEndAt = _asString(json['paid_end_at']);
    isActive = json['is_active'];
    createdByReferal = _asString(json['created_by_referal']);
    passwordResetOtp = _asString(json['password_reset_otp']);
    emailVerifiedAt = _asString(json['email_verified_at']);
    lang = _asString(json['lang']);
    sendLeadOut = json['send_lead_out'];
    createdBy = _asString(json['created_by']);
    parentId = _asString(json['parent_id']);
    isDirectAdded = json['is_direct_added'];
    createdAt = _asString(json['created_at']);
    updatedAt = _asString(json['updated_at']);
    deletedAt = _asString(json['deleted_at']);
    companyLogoUrl = _asString(json['company_logo_url']);
    avatarUrl = _asString(json['avatar_url']);
    productId = _asString(json['product_id']);
    fullName = _asString(json['full_name']);
    if (json['roles'] != null) {
      roles = <Roles>[];
      json['roles'].forEach((v) {
        roles!.add(Roles.fromJson(v));
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
    data['ui_type'] = uiType;
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
    data['stripe_customer_id'] = stripeCustomerId;
    data['stripe_account_id'] = stripeAccountId;
    data['has_subscribed_once'] = hasSubscribedOnce;
    data['paid_start_at'] = paidStartAt;
    data['paid_end_at'] = paidEndAt;
    data['is_active'] = isActive;
    data['created_by_referal'] = createdByReferal;
    data['password_reset_otp'] = passwordResetOtp;
    data['email_verified_at'] = emailVerifiedAt;
    data['lang'] = lang;
    data['send_lead_out'] = sendLeadOut;
    data['created_by'] = createdBy;
    data['parent_id'] = parentId;
    data['is_direct_added'] = isDirectAdded;
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

class Roles {
  int? id;
  String? name;
  String? guardName;
  String? createdAt;
  String? updatedAt;
  Pivot? pivot;

  Roles({this.id, this.name, this.guardName, this.createdAt, this.updatedAt, this.pivot});

  Roles.fromJson(Map<String, dynamic> json) {
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

  Pivot({this.modelType, this.modelId, this.roleId});

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

class User {
  int? id;
  String? firstName;
  String? lastName;
  String? email;
  String? phoneNumber;
  String? avatar;
  String? socialType;
  String? socialId;
  String? uiType;
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
  String? stripeCustomerId;
  String? stripeAccountId;
  int? hasSubscribedOnce;
  String? paidStartAt;
  String? paidEndAt;
  int? isActive;
  String? createdByReferal;
  String? passwordResetOtp;
  String? emailVerifiedAt;
  String? lang;
  int? sendLeadOut;
  String? createdBy;
  String? parentId;
  int? isDirectAdded;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;
  String? companyLogoUrl;
  String? avatarUrl;
  String? productId;
  String? fullName;
  UserNotificationControl? userNotificationControl;
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
      this.uiType,
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
      this.stripeCustomerId,
      this.stripeAccountId,
      this.hasSubscribedOnce,
      this.paidStartAt,
      this.paidEndAt,
      this.isActive,
      this.createdByReferal,
      this.passwordResetOtp,
      this.emailVerifiedAt,
      this.lang,
      this.sendLeadOut,
      this.createdBy,
      this.parentId,
      this.isDirectAdded,
      this.createdAt,
      this.updatedAt,
      this.deletedAt,
      this.companyLogoUrl,
      this.avatarUrl,
      this.productId,
      this.fullName,
      this.userNotificationControl,
      this.roles});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = _asString(json['first_name']);
    lastName = _asString(json['last_name']);
    email = _asString(json['email']);
    phoneNumber = _asString(json['phone_number']);
    avatar = _asString(json['avatar']);
    socialType = _asString(json['social_type']);
    socialId = _asString(json['social_id']);
    uiType = _asString(json['ui_type']);
    companyType = _asString(json['company_type']);
    companyName = _asString(json['company_name']);
    companyId = _asString(json['company_id']);
    companyLogo = _asString(json['company_logo']);
    companyCountryCode = _asString(json['company_country_code']);
    companyNumber = _asString(json['company_number']);
    companyAddress = _asString(json['company_address']);
    companyDescription = _asString(json['company_description']);
    jobId = _asString(json['job_id']);
    job = _asString(json['job']);
    industry = _asString(json['industry']);
    city = _asString(json['city']);
    countryCode = _asString(json['country_code']);
    country = _asString(json['country']);
    referralCode = _asString(json['referral_code']);
    isPaid = json['is_paid'];
    stripeCustomerId = _asString(json['stripe_customer_id']);
    stripeAccountId = _asString(json['stripe_account_id']);
    hasSubscribedOnce = json['has_subscribed_once'];
    paidStartAt = _asString(json['paid_start_at']);
    paidEndAt = _asString(json['paid_end_at']);
    isActive = json['is_active'];
    createdByReferal = _asString(json['created_by_referal']);
    passwordResetOtp = _asString(json['password_reset_otp']);
    emailVerifiedAt = _asString(json['email_verified_at']);
    lang = _asString(json['lang']);
    sendLeadOut = json['send_lead_out'];
    createdBy = _asString(json['created_by']);
    parentId = _asString(json['parent_id']);
    isDirectAdded = json['is_direct_added'];
    createdAt = _asString(json['created_at']);
    updatedAt = _asString(json['updated_at']);
    deletedAt = _asString(json['deleted_at']);
    companyLogoUrl = _asString(json['company_logo_url']);
    avatarUrl = _asString(json['avatar_url']);
    productId = _asString(json['product_id']);
    fullName = _asString(json['full_name']);
    userNotificationControl = json['user_notification_control'] != null
        ? UserNotificationControl.fromJson(json['user_notification_control'])
        : null;
    if (json['roles'] != null) {
      roles = <Roles>[];
      json['roles'].forEach((v) {
        roles!.add(Roles.fromJson(v));
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
    data['ui_type'] = uiType;
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
    data['stripe_customer_id'] = stripeCustomerId;
    data['stripe_account_id'] = stripeAccountId;
    data['has_subscribed_once'] = hasSubscribedOnce;
    data['paid_start_at'] = paidStartAt;
    data['paid_end_at'] = paidEndAt;
    data['is_active'] = isActive;
    data['created_by_referal'] = createdByReferal;
    data['password_reset_otp'] = passwordResetOtp;
    data['email_verified_at'] = emailVerifiedAt;
    data['lang'] = lang;
    data['send_lead_out'] = sendLeadOut;
    data['created_by'] = createdBy;
    data['parent_id'] = parentId;
    data['is_direct_added'] = isDirectAdded;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['deleted_at'] = deletedAt;
    data['company_logo_url'] = companyLogoUrl;
    data['avatar_url'] = avatarUrl;
    data['product_id'] = productId;
    data['full_name'] = fullName;
    if (userNotificationControl != null) {
      data['user_notification_control'] = userNotificationControl!.toJson();
    }
    if (roles != null) {
      data['roles'] = roles!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class UserNotificationControl {
  bool? emailNotification;
  bool? pushNotification;

  UserNotificationControl({this.emailNotification, this.pushNotification});

  UserNotificationControl.fromJson(Map<String, dynamic> json) {
    emailNotification = json['email_notification'];
    pushNotification = json['push_notification'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['email_notification'] = emailNotification;
    data['push_notification'] = pushNotification;
    return data;
  }
}

class Pagination {
  String? currentPage;
  String? lastPage;
  String? perPage;
  String? total;

  Pagination({this.currentPage, this.lastPage, this.perPage, this.total});

  Pagination.fromJson(Map<String, dynamic> json) {
    currentPage = json['current_page'].toString();
    lastPage = json['last_page'].toString();
    perPage = json['per_page'].toString();
    total = json['total'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['current_page'] = this.currentPage;
    data['last_page'] = this.lastPage;
    data['per_page'] = this.perPage;
    data['total'] = this.total;
    return data;
  }
}
