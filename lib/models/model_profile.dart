import 'package:referaly/models/model_team_member.dart';

class ModelProfile {
  int? code;
  bool? status;
  String? message;
  Data? data;
  List<String>? pagination;

  ModelProfile(
      {this.code, this.status, this.message, this.data, this.pagination});

  ModelProfile.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
    if (json['pagination'] != null) {
      pagination = <String>[];
      json['pagination'].forEach((v) {
        pagination!.add(v.toString());
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    if (this.pagination != null) {
      data['pagination'] = pagination!;
    }
    return data;
  }
}

class Data {
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
  String? subscriptionType;
  String? stripeCustomerId;
  String? stripeId;
  String? pmType;
  String? pmLastFour;
  String? trialEndsAt;
  String? stripeAccountId;
  int? hasSubscribedOnce;
  String? paidStartAt;
  String? paidEndAt;
  int? isActive;
  String? createdByReferal;
  String? passwordResetOtp;
  String? emailVerifiedAt;
  String? lastLoginAt;
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
  int? walletBalance;
  int? referralCodeUsedCount;
  bool? isProfileCompleted;
  bool? isCompanyCompleted;
  bool? isFinderCompleted;
  List<String>? roleNames;
  bool? premiumProfessional;
  bool? hasReceivedLead;
  int? agencyOwnerId;
  bool? isAgencyColleague;
  bool? isIndependentColleague;
  bool? canManageTeam;
  TeamMemberContentAccess? contentAccess;
  int? sponsoringAgencyOwnerId;
  bool? subscriptionSponsoredByAgency;

  Data({
    this.id,
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
    this.subscriptionType,
    this.stripeCustomerId,
    this.stripeId,
    this.pmType,
    this.pmLastFour,
    this.trialEndsAt,
    this.stripeAccountId,
    this.hasSubscribedOnce,
    this.paidStartAt,
    this.paidEndAt,
    this.isActive,
    this.createdByReferal,
    this.passwordResetOtp,
    this.emailVerifiedAt,
    this.lastLoginAt,
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
    this.roles,
    this.walletBalance,
    this.referralCodeUsedCount,
    this.isProfileCompleted,
    this.isCompanyCompleted,
    this.isFinderCompleted,
    this.roleNames,
    this.premiumProfessional,
    this.hasReceivedLead,
    this.agencyOwnerId,
    this.isAgencyColleague,
    this.isIndependentColleague,
    this.canManageTeam,
    this.contentAccess,
    this.sponsoringAgencyOwnerId,
    this.subscriptionSponsoredByAgency,
  });

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['first_name']?.toString();
    lastName = json['last_name']?.toString();
    email = json['email']?.toString();
    phoneNumber = json['phone_number']?.toString();
    avatar = json['avatar']?.toString();
    socialType = json['social_type']?.toString();
    socialId = json['social_id']?.toString();
    uiType = json['ui_type']?.toString();
    companyType = json['company_type']?.toString();
    companyName = json['company_name']?.toString();
    companyId = json['company_id']?.toString();
    companyLogo = json['company_logo']?.toString();
    companyCountryCode = json['company_country_code']?.toString();
    companyNumber = json['company_number']?.toString();
    companyAddress = json['company_address']?.toString();
    companyDescription = json['company_description']?.toString();
    jobId = json['job_id']?.toString();
    job = json['job']?.toString();
    industry = json['industry']?.toString();
    city = json['city']?.toString();
    countryCode = json['country_code']?.toString();
    country = json['country']?.toString();
    referralCode = json['referral_code']?.toString();
    isPaid = json['is_paid'];
    subscriptionType = json['subscription_type']?.toString();
    stripeCustomerId = json['stripe_customer_id']?.toString();
    stripeId = json['stripe_id']?.toString();
    pmType = json['pm_type']?.toString();
    pmLastFour = json['pm_last_four']?.toString();
    trialEndsAt = json['trial_ends_at']?.toString();
    stripeAccountId = json['stripe_account_id']?.toString();
    hasSubscribedOnce = json['has_subscribed_once'];
    paidStartAt = json['paid_start_at']?.toString();
    paidEndAt = json['paid_end_at']?.toString();
    isActive = json['is_active'];
    createdByReferal = json['created_by_referal']?.toString();
    passwordResetOtp = json['password_reset_otp']?.toString();
    emailVerifiedAt = json['email_verified_at']?.toString();
    lastLoginAt = json['last_login_at']?.toString();
    lang = json['lang']?.toString();
    sendLeadOut = json['send_lead_out'];
    createdBy = json['created_by']?.toString();
    parentId = json['parent_id']?.toString();
    isDirectAdded = json['is_direct_added'];
    createdAt = json['created_at']?.toString();
    updatedAt = json['updated_at']?.toString();
    deletedAt = json['deleted_at']?.toString();
    companyLogoUrl = json['company_logo_url']?.toString();
    avatarUrl = json['avatar_url']?.toString();
    productId = json['product_id']?.toString();
    fullName = json['full_name']?.toString();
    if (json['roles'] != null) {
      roles = <Roles>[];
      json['roles'].forEach((v) {
        roles!.add(Roles.fromJson(v));
      });
    }
    walletBalance = json['wallet_balance'];
    referralCodeUsedCount = json['referral_code_used_count'];
    isProfileCompleted = json['is_profile_completed'] == true ||
        json['is_profile_completed'] == 1;
    isCompanyCompleted = json['is_company_completed'] == true ||
        json['is_company_completed'] == 1;
    isFinderCompleted =
        json['is_finder_completed'] == true || json['is_finder_completed'] == 1;
    if (json['role_names'] != null) {
      roleNames = <String>[];
      json['role_names'].forEach((v) {
        roleNames!.add(v.toString());
      });
    }
    premiumProfessional = json['premium_professional'] == true ||
        json['premium_professional'] == 1;
    hasReceivedLead =
        json['has_received_lead'] == true || json['has_received_lead'] == 1;
    agencyOwnerId = _parseInt(json['agency_owner_id']);
    isAgencyColleague = json['is_agency_colleague'] == true ||
        json['is_agency_colleague'] == 1;
    isIndependentColleague = json['is_independent_colleague'] == true ||
        json['is_independent_colleague'] == 1;
    canManageTeam =
        json['can_manage_team'] == true || json['can_manage_team'] == 1;
    if (json['content_access'] is Map<String, dynamic>) {
      contentAccess = TeamMemberContentAccess.fromJson(
        json['content_access'] as Map<String, dynamic>,
      );
    }
    sponsoringAgencyOwnerId = _parseInt(json['sponsoring_agency_owner_id']);
    subscriptionSponsoredByAgency =
        json['subscription_sponsored_by_agency'] == true ||
            json['subscription_sponsored_by_agency'] == 1;
    _applyColleagueRoleFallbacks();
  }

  static int? _parseInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    return int.tryParse(value.toString());
  }

  /// When the API omits `is_agency_colleague` / `is_independent_colleague` (e.g. only
  /// `role_names: ["user", "independent-colleague"]`), infer colleague type from roles.
  /// Does not override explicit `true` flags from the server.
  void _applyColleagueRoleFallbacks() {
    final names = roleNames ?? [];
    if (isAgencyColleague != true) {
      isAgencyColleague = names.any((r) => r.trim() == 'agency-colleague');
    }
    if (isIndependentColleague != true) {
      isIndependentColleague =
          names.any((r) => r.trim() == 'independent-colleague');
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
    data['subscription_type'] = subscriptionType;
    data['stripe_customer_id'] = stripeCustomerId;
    data['stripe_id'] = stripeId;
    data['pm_type'] = pmType;
    data['pm_last_four'] = pmLastFour;
    data['trial_ends_at'] = trialEndsAt;
    data['stripe_account_id'] = stripeAccountId;
    data['has_subscribed_once'] = hasSubscribedOnce;
    data['paid_start_at'] = paidStartAt;
    data['paid_end_at'] = paidEndAt;
    data['is_active'] = isActive;
    data['created_by_referal'] = createdByReferal;
    data['password_reset_otp'] = passwordResetOtp;
    data['email_verified_at'] = emailVerifiedAt;
    data['last_login_at'] = lastLoginAt;
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
    data['wallet_balance'] = walletBalance;
    data['referral_code_used_count'] = referralCodeUsedCount;
    data['is_profile_completed'] = isProfileCompleted;
    data['is_company_completed'] = isCompanyCompleted;
    data['is_finder_completed'] = isFinderCompleted;
    if (roleNames != null) {
      data['role_names'] = roleNames;
    }
    data['premium_professional'] = premiumProfessional;
    data['has_received_lead'] = hasReceivedLead;
    data['agency_owner_id'] = agencyOwnerId;
    data['is_agency_colleague'] = isAgencyColleague;
    data['is_independent_colleague'] = isIndependentColleague;
    data['can_manage_team'] = canManageTeam;
    if (contentAccess != null) {
      data['content_access'] = contentAccess!.toJson();
    }
    data['sponsoring_agency_owner_id'] = sponsoringAgencyOwnerId;
    data['subscription_sponsored_by_agency'] = subscriptionSponsoredByAgency;
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
