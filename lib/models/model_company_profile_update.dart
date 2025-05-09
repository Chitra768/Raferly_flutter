import 'package:referaly/models/model_role.dart';

class ModelCompanyProfileUpdate {
  final int code;
  final bool status;
  final String message;
  final CompanyProfileData data;
  final List<dynamic> pagination;

  ModelCompanyProfileUpdate({
    required this.code,
    required this.status,
    required this.message,
    required this.data,
    required this.pagination,
  });

  factory ModelCompanyProfileUpdate.fromJson(Map<String, dynamic> json) {
    return ModelCompanyProfileUpdate(
      code: json['code'] ?? 0,
      status: json['status'] ?? false,
      message: json['message'] ?? '',
      data: CompanyProfileData.fromJson(json['data'] ?? {}),
      pagination: json['pagination'] ?? [],
    );
  }
}

class CompanyProfileData {
  final int id;
  final String firstName;
  final String lastName;
  final String email;
  final String phoneNumber;
  final String avatar;
  final String socialType;
  final String? socialId;
  final String companyType;
  final String companyName;
  final String? companyId;
  final String companyLogo;
  final String companyCountryCode;
  final String companyNumber;
  final String companyAddress;
  final String? companyDescription;
  final String? jobId;
  final String job;
  final String? industry;
  final String city;
  final String countryCode;
  final String? country;
  final String referralCode;
  final int isPaid;
  final int hasSubscribedOnce;
  final String? paidStartAt;
  final String? paidEndAt;
  final int isActive;
  final String? passwordResetOtp;
  final String? emailVerifiedAt;
  final String lang;
  final int sendLeadOut;
  final String createdAt;
  final String updatedAt;
  final String? deletedAt;
  final String companyLogoUrl;
  final String avatarUrl;
  final String? productId;
  final List<ModelRole> roles;
  final int walletBalance;
  final int referralCodeUsedCount;

  CompanyProfileData({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phoneNumber,
    required this.avatar,
    required this.socialType,
    this.socialId,
    required this.companyType,
    required this.companyName,
    this.companyId,
    required this.companyLogo,
    required this.companyCountryCode,
    required this.companyNumber,
    required this.companyAddress,
    this.companyDescription,
    this.jobId,
    required this.job,
    this.industry,
    required this.city,
    required this.countryCode,
    this.country,
    required this.referralCode,
    required this.isPaid,
    required this.hasSubscribedOnce,
    this.paidStartAt,
    this.paidEndAt,
    required this.isActive,
    this.passwordResetOtp,
    this.emailVerifiedAt,
    required this.lang,
    required this.sendLeadOut,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    required this.companyLogoUrl,
    required this.avatarUrl,
    this.productId,
    required this.roles,
    required this.walletBalance,
    required this.referralCodeUsedCount,
  });

  factory CompanyProfileData.fromJson(Map<String, dynamic> json) {
    return CompanyProfileData(
      id: json['id'] ?? 0,
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
      email: json['email'] ?? '',
      phoneNumber: json['phone_number'] ?? '',
      avatar: json['avatar'] ?? '',
      socialType: json['social_type'] ?? '',
      socialId: json['social_id'],
      companyType: json['company_type'] ?? '',
      companyName: json['company_name'] ?? '',
      companyId: json['company_id'],
      companyLogo: json['company_logo'] ?? '',
      companyCountryCode: json['company_country_code'] ?? '',
      companyNumber: json['company_number'] ?? '',
      companyAddress: json['company_address'] ?? '',
      companyDescription: json['company_description'],
      jobId: json['job_id'],
      job: json['job'] ?? '',
      industry: json['industry'],
      city: json['city'] ?? '',
      countryCode: json['country_code'] ?? '',
      country: json['country'],
      referralCode: json['referral_code'] ?? '',
      isPaid: json['is_paid'] ?? 0,
      hasSubscribedOnce: json['has_subscribed_once'] ?? 0,
      paidStartAt: json['paid_start_at'],
      paidEndAt: json['paid_end_at'],
      isActive: json['is_active'] ?? 0,
      passwordResetOtp: json['password_reset_otp'],
      emailVerifiedAt: json['email_verified_at'],
      lang: json['lang'] ?? '',
      sendLeadOut: json['send_lead_out'] ?? 0,
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
      deletedAt: json['deleted_at'],
      companyLogoUrl: json['company_logo_url'] ?? '',
      avatarUrl: json['avatar_url'] ?? '',
      productId: json['product_id'],
      roles: (json['roles'] as List<dynamic>?)
              ?.map((role) => ModelRole.fromJson(role))
              .toList() ??
          [],
      walletBalance: json['wallet_balance'] ?? 0,
      referralCodeUsedCount: json['referral_code_used_count'] ?? 0,
    );
  }
}
