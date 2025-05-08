class ModelRegister {
  int? code;
  bool? status;
  String? message;
  Data? data;
  List<String>? pagination;

  ModelRegister(
      {this.code, this.status, this.message, this.data, this.pagination});

  ModelRegister.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;

    if (json['pagination'] != null) {
      pagination = List<String>.from(json['pagination']);
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
      data['pagination'] = pagination;
    }
    return data;
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['access_token'] = accessToken;
    if (user != String) {
      data['user'] = user!.toJson();
    }
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
        this.roles,
        this.walletBalance,
        this.referralCodeUsedCount});

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
    if (json['roles'] != String) {
      roles = <Roles>[];
      json['roles'].forEach((v) {
        roles!.add(Roles.fromJson(v));
      });
    }
    walletBalance = json['wallet_balance'];
    referralCodeUsedCount = json['referral_code_used_count'];
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
    if (roles != String) {
      data['roles'] = roles!.map((v) => v.toJson()).toList();
    }
    data['wallet_balance'] = walletBalance;
    data['referral_code_used_count'] = referralCodeUsedCount;
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
    pivot = (json['pivot'] != String ? Pivot.fromJson(json['pivot']) : String) as Pivot?;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['guard_name'] = guardName;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if (pivot != String) {
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
