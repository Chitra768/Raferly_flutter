class ModelLogin {
  int? code;
  bool? status;
  String? message;
  Data? data;
  List<String>? pagination;

  ModelLogin({this.code, this.status, this.message, this.data, this.pagination});

  ModelLogin.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
    if (json['pagination'] != null) {
      pagination = List<String>.from(json['pagination']);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = {};
    json['code'] = code;
    json['status'] = status;
    json['message'] = message;
    if (data != null) json['data'] = data!.toJson();
    if (pagination != null) json['pagination'] = pagination;
    return json;
  }
}

class Data {
  String? accessToken;
  User? user;

  Data({this.accessToken, this.user});

  Data.fromJson(Map<String, dynamic> json) {
    accessToken = json['access_token'];
    user = json['user'] != null ? User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = {};
    json['access_token'] = accessToken;
    if (user != null) json['user'] = user!.toJson();
    return json;
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
  List<Roles>? roles;
  int? walletBalance;
  int? referralCodeUsedCount;

  User({
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
    this.roles,
    this.walletBalance,
    this.referralCodeUsedCount,
  });

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
    walletBalance = json['wallet_balance'];
    referralCodeUsedCount = json['referral_code_used_count'];

    if (json['roles'] != null) {
      roles = List<Roles>.from(json['roles'].map((v) => Roles.fromJson(v)));
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = {};
    json['id'] = id;
    json['first_name'] = firstName;
    json['last_name'] = lastName;
    json['email'] = email;
    json['phone_number'] = phoneNumber;
    json['avatar'] = avatar;
    json['social_type'] = socialType;
    json['social_id'] = socialId;
    json['company_type'] = companyType;
    json['company_name'] = companyName;
    json['company_id'] = companyId;
    json['company_logo'] = companyLogo;
    json['company_country_code'] = companyCountryCode;
    json['company_number'] = companyNumber;
    json['company_address'] = companyAddress;
    json['company_description'] = companyDescription;
    json['job_id'] = jobId;
    json['job'] = job;
    json['industry'] = industry;
    json['city'] = city;
    json['country_code'] = countryCode;
    json['country'] = country;
    json['referral_code'] = referralCode;
    json['is_paid'] = isPaid;
    json['has_subscribed_once'] = hasSubscribedOnce;
    json['paid_start_at'] = paidStartAt;
    json['paid_end_at'] = paidEndAt;
    json['is_active'] = isActive;
    json['password_reset_otp'] = passwordResetOtp;
    json['email_verified_at'] = emailVerifiedAt;
    json['lang'] = lang;
    json['send_lead_out'] = sendLeadOut;
    json['created_at'] = createdAt;
    json['updated_at'] = updatedAt;
    json['deleted_at'] = deletedAt;
    json['company_logo_url'] = companyLogoUrl;
    json['avatar_url'] = avatarUrl;
    json['product_id'] = productId;
    if (roles != null) {
      json['roles'] = roles!.map((v) => v.toJson()).toList();
    }
    json['wallet_balance'] = walletBalance;
    json['referral_code_used_count'] = referralCodeUsedCount;
    return json;
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
    final Map<String, dynamic> json = {};
    json['id'] = id;
    json['name'] = name;
    json['guard_name'] = guardName;
    json['created_at'] = createdAt;
    json['updated_at'] = updatedAt;
    if (pivot != null) json['pivot'] = pivot!.toJson();
    return json;
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
    final Map<String, dynamic> json = {};
    json['model_type'] = modelType;
    json['model_id'] = modelId;
    json['role_id'] = roleId;
    return json;
  }
}
