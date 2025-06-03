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
  UserData? user;

  Data({this.accessToken, this.user});

  Data.fromJson(Map<String, dynamic> json) {
    accessToken = json['access_token'];
    user = json['user'] != null ? UserData.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = {};
    json['access_token'] = accessToken;
    if (user != null) json['user'] = user!.toJson();
    return json;
  }
}

class UserData {
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
  String? walletBalance;
  String? referralCodeUsedCount;

  UserData({
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

  UserData.fromJson(Map<String, dynamic> json) {
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
    walletBalance = json['wallet_balance'].toString();
    referralCodeUsedCount = json['referral_code_used_count'].toString();

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
  String? id;
  String? name;
  String? guardName;
  String? createdAt;
  String? updatedAt;
  Pivot? pivot;

  Roles({this.id, this.name, this.guardName, this.createdAt, this.updatedAt, this.pivot});

  Roles.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    name = json['name'].toString();
    guardName = json['guard_name'].toString();
    createdAt = json['created_at'].toString();
    updatedAt = json['updated_at'].toString();
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
  String? modelId;
  String? roleId;

  Pivot({this.modelType, this.modelId, this.roleId});

  Pivot.fromJson(Map<String, dynamic> json) {
    modelType = json['model_type'].toString();
    modelId = json['model_id'].toString();
    roleId = json['role_id'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = {};
    json['model_type'] = modelType;
    json['model_id'] = modelId;
    json['role_id'] = roleId;
    return json;
  }
}
