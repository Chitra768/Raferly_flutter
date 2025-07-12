class ModelSendLead {
  int? code;
  bool? status;
  String? message;
  List<SendLeadData>? data;
  Pagination? pagination;
    Notifications? notifications;

  ModelSendLead(
      {this.code, this.status, this.message, this.data, this.pagination, this.notifications});

  ModelSendLead.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <SendLeadData>[];
      json['data'].forEach((v) {
        data!.add(new SendLeadData.fromJson(v));
      });
    }
    pagination = json['pagination'] != null
        ? new Pagination.fromJson(json['pagination'])
        : null;
          notifications = json['notifications'] != null
        ? new Notifications.fromJson(json['notifications'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    if (this.pagination != null) {
      data['pagination'] = this.pagination!.toJson();
    }
     if (this.notifications != null) {
      data['notifications'] = this.notifications!.toJson();
    }
    return data;
  }
}

class SendLeadData {
  int? id;
  String? firstName;
  String? lastName;
  String? email;
  String? phoneNumber;
  int? dealId;
  String? description;
  String? leadAssignType;
  String? businessReferralId;
  int? createdBy;
  int? isLost;
  String? lostReason;
  int? isActive;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;
  int? totalTrack;
  String? completedTrack;
  String? companyName;
  String? companyLogoUrl;
  List<LeadTrack>? leadTrack;
  Deal? deal;
  User? user;

  SendLeadData(
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
      this.totalTrack,
      this.completedTrack,
      this.companyName,
      this.companyLogoUrl,
      this.leadTrack,
      this.deal,
      this.user});

  SendLeadData.fromJson(Map<String, dynamic> json) {
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
    lostReason = json['lost_reason'] as String?;
    isActive = json['is_active'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'] as String?;
    totalTrack = json['total_track'];
    completedTrack = json['completed_track'];
    companyName = json['company_name'];
    companyLogoUrl = json['company_logo_url'];
    if (json['lead_track'] != null) {
      leadTrack = <LeadTrack>[];
      json['lead_track'].forEach((v) {
        leadTrack!.add(new LeadTrack.fromJson(v));
      });
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
    data['total_track'] = this.totalTrack;
    data['completed_track'] = this.completedTrack;
    data['company_name'] = this.companyName;
    data['company_logo_url'] = this.companyLogoUrl;
    if (this.leadTrack != null) {
      data['lead_track'] = this.leadTrack!.map((v) => v.toJson()).toList();
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

class LeadTrack {
  int? id;
  int? leadId;
  int? dealStepId;
  String? name;
  String? esName;
  String? frName;
  String? completedAt;
  String? comment;
  String? commisionValue;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;

  LeadTrack(
      {this.id,
      this.leadId,
      this.dealStepId,
      this.name,
      this.esName,
      this.frName,
      this.completedAt,
      this.comment,
      this.commisionValue,
      this.createdAt,
      this.updatedAt,
      this.deletedAt});

  LeadTrack.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    leadId = json['lead_id'];
    dealStepId = json['deal_step_id'];
    name = json['name'];
    esName = json['es_name'] as String?;
    frName = json['fr_name'] as String?;
    completedAt = json['completed_at'] as String?;
    comment = json['comment'] as String?;
    commisionValue = json['commision_value'] as String?;
    createdAt = json['created_at'] as String?;
    updatedAt = json['updated_at'] as String?;
    deletedAt = json['deleted_at'] as String?;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['lead_id'] = this.leadId;
    data['deal_step_id'] = this.dealStepId;
    data['name'] = this.name;
    data['es_name'] = this.esName;
    data['fr_name'] = this.frName;
    data['completed_at'] = this.completedAt;
    data['comment'] = this.comment;
    data['commision_value'] = this.commisionValue;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['deleted_at'] = this.deletedAt;
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
      this.createdDetail});

  Deal.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdBy = json['created_by'];
    dealName = json['deal_name'];
    dealCommissionType = json['deal_commission_type'];
    commissionType = json['commission_type'];
    commissionValue = json['commission_value'];
    description = json['description'] as String?;
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
    deletedAt = json['deleted_at'] as String?;
    inviteQrCode = json['invite_qr_code'];
    documentUrl = json['document_url'];
    commissionTransType = json['commission_trans_type'];
    inviteLink = json['invite_link'];
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
    data['invite_qr_code'] = this.inviteQrCode;
    data['document_url'] = this.documentUrl;
    data['commission_trans_type'] = this.commissionTransType;
    data['invite_link'] = this.inviteLink;
    if (this.createdDetail != null) {
      data['created_detail'] = this.createdDetail!.toJson();
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
      this.companyLogoUrl,
      this.avatarUrl,
      this.productId,
      this.roles});

  CreatedDetail.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    email = json['email'];
    phoneNumber = json['phone_number'];
    avatar = json['avatar'];
    socialType = json['social_type'];
    socialId = json['social_id'] as String?;
    companyType = json['company_type'];
    companyName = json['company_name'];
    companyId = json['company_id'] as String?;
    companyLogo = json['company_logo'];
    companyCountryCode = json['company_country_code'];
    companyNumber = json['company_number'];
    companyAddress = json['company_address'];
    companyDescription = json['company_description'];
    jobId = json['job_id'] as String?;
    job = json['job'];
    industry = json['industry'] as String?;
    city = json['city'];
    countryCode = json['country_code'];
    country = json['country'] as String?;
    referralCode = json['referral_code'];
    isPaid = json['is_paid'];
    hasSubscribedOnce = json['has_subscribed_once'];
    paidStartAt = json['paid_start_at'];
    paidEndAt = json['paid_end_at'];
    isActive = json['is_active'];
    passwordResetOtp = json['password_reset_otp'] as String?;
    emailVerifiedAt = json['email_verified_at'] as String?;
    lang = json['lang'] as String?;
    sendLeadOut = json['send_lead_out'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'] as String?;
    companyLogoUrl = json['company_logo_url'];
    avatarUrl = json['avatar_url'];
    productId = json['product_id'] as String?;
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
    socialId = json['social_id'] as String?;
    companyType = json['company_type'];
    companyName = json['company_name'];
    companyId = json['company_id'] as String?;
    companyLogo = json['company_logo'];
    companyCountryCode = json['company_country_code'];
    companyNumber = json['company_number'];
    companyAddress = json['company_address'];
    companyDescription = json['company_description'];
    jobId = json['job_id'] as String?;
    job = json['job'];
    industry = json['industry'] as String?;
    city = json['city'];
    countryCode = json['country_code'];
    country = json['country'] as String?;
    referralCode = json['referral_code'];
    isPaid = json['is_paid'];
    hasSubscribedOnce = json['has_subscribed_once'];
    paidStartAt = json['paid_start_at'];
    paidEndAt = json['paid_end_at'];
    isActive = json['is_active'];
    passwordResetOtp = json['password_reset_otp'] as String?;
    emailVerifiedAt = json['email_verified_at'] as String?;
    lang = json['lang'] as String?;
    sendLeadOut = json['send_lead_out'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'] as String?;
    companyLogoUrl = json['company_logo_url'];
    avatarUrl = json['avatar_url'];
    productId = json['product_id'] as String?;
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

class Pagination {
  int? currentPage;
  int? lastPage;
  int? perPage;
  int? total;

  Pagination({this.currentPage, this.lastPage, this.perPage, this.total});

  Pagination.fromJson(Map<String, dynamic> json) {
    currentPage = json['current_page'];
    lastPage = json['last_page'];
    perPage = json['per_page'];
    total = json['total'];
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
class Notifications {
  Archived? archived;
  Archived? leadSent;

  Notifications({this.archived, this.leadSent});

  Notifications.fromJson(Map<String, dynamic> json) {
    archived = json['archived'] != null
        ? new Archived.fromJson(json['archived'])
        : null;
    leadSent = json['lead_sent'] != null
        ? new Archived.fromJson(json['lead_sent'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.archived != null) {
      data['archived'] = this.archived!.toJson();
    }
    if (this.leadSent != null) {
      data['lead_sent'] = this.leadSent!.toJson();
    }
    return data;
  }
}

class Archived {
  int? count;

  Archived({this.count});

  Archived.fromJson(Map<String, dynamic> json) {
    count = json['count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['count'] = this.count;
    return data;
  }
}