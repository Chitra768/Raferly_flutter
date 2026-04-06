class ModelContactResponse {
  int? code;
  bool? status;
  String? message;
  List<ContractData>? data;
  Pagination? pagination;

  ModelContactResponse({
    this.code,
    this.status,
    this.message,
    this.data,
    this.pagination,
  });

  ModelContactResponse.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    status = json['status'];
    message = json['message'];

    final rawData = json['data'];
    if (rawData == null) {
      data = [];
    } else if (rawData is List) {
      data = rawData.map((v) => ContractData.fromJson(v)).toList();
    } else if (rawData is Map<String, dynamic>) {
      data = [ContractData.fromJson(rawData)];
    } else {
      data = [];
    }

    pagination = json['pagination'] != null
        ? Pagination.fromJson(json['pagination'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = <String, dynamic>{};
    map['code'] = code;
    map['status'] = status;
    map['message'] = message;
    if (data != null) {
      map['data'] = data!.map((v) => v.toJson()).toList();
    }
    if (pagination != null) {
      map['pagination'] = pagination!.toJson();
    }
    return map;
  }

  /// Helper to check if contact list has entries
  bool get hasContacts => data != null && data!.isNotEmpty;
}

class ContractData {
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
  bool? isCollaborator;
  String? companyName;
  String? leadCount;
  String? referalFormUrl;
  String? inviteQrCode;
  String? documentUrl;
  String? commissionTransType;
  String? inviteLink;
  CreatedDetail? createdDetail;
    List<Documents>? documents;
  List<DealSteps>? dealSteps;
  List<DealCases>? dealCases;

  ContractData({
    this.id,
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
    this.isCollaborator,
    this.companyName,
    this.leadCount,
    this.referalFormUrl,
    this.inviteQrCode,
    this.documentUrl,
    this.commissionTransType,
    this.inviteLink,
    this.createdDetail,
    this.documents,
    this.dealSteps,
    this.dealCases,
  });

  ContractData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdBy = json['created_by'];
    dealName = json['deal_name']?.toString();
    dealCommissionType = json['deal_commission_type'];
    commissionType = json['commission_type']?.toString();
    commissionValue = json['commission_value']?.toString();
    description = json['description']?.toString();
    document = json['document']?.toString();
    documentUploadedManually = json['document_uploaded_manually'];
    suggestion = json['suggestion'];
    isDelete = json['is_delete'];
    deepLink = json['deep_link']?.toString();
    sharingTempLink = json['sharing_temp_link']?.toString();
    sendLeadOut = json['send_lead_out'];
    isActive = json['is_active'];
    createdAt = json['created_at']?.toString();
    updatedAt = json['updated_at']?.toString();
    deletedAt = json['deleted_at']?.toString();
    isCollaborator = json['is_collaborator'];
    companyName = json['company_name']?.toString();
    leadCount = json['leads_count']?.toString();
    referalFormUrl = json['referal_form_url']?.toString();
    inviteQrCode = json['invite_qr_code']?.toString();
    documentUrl = json['document_url']?.toString();
    commissionTransType = json['commission_trans_type']?.toString();
    inviteLink = json['invite_link']?.toString();
    createdDetail = json['created_detail'] != null
        ? CreatedDetail.fromJson(json['created_detail'])
        : null;
         if (json['documents'] != null) {
      documents = <Documents>[];
      json['documents'].forEach((v) {
        documents!.add(new Documents.fromJson(v));
      });
    }
    if (json['deal_steps'] != null) {
      dealSteps = <DealSteps>[];
      json['deal_steps'].forEach((v) {
        dealSteps!.add(DealSteps.fromJson(v));
      });
    }
    if (json['deal_cases'] != null) {
      dealCases = <DealCases>[];
      json['deal_cases'].forEach((v) {
        dealCases!.add(new DealCases.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
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
    data['is_collaborator'] = isCollaborator;
    data['company_name'] = companyName;
    data['leads_count'] = leadCount;
    data['referal_form_url'] = referalFormUrl;
    data['invite_qr_code'] = inviteQrCode;
    data['document_url'] = documentUrl;
    data['commission_trans_type'] = commissionTransType;
    data['invite_link'] = inviteLink;
    if (createdDetail != null) {
      data['created_detail'] = createdDetail!.toJson();
    }
    if (documents != null) {
      data['documents'] = documents!.map((v) => v.toJson()).toList();
    }
    if (dealSteps != null) {
      data['deal_steps'] = dealSteps!.map((v) => v.toJson()).toList();
    }
    if (this.dealCases != null) {
      data['deal_cases'] = this.dealCases!.map((v) => v.toJson()).toList();
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
    this.roles,
  });

  CreatedDetail.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['first_name']?.toString();
    lastName = json['last_name']?.toString();
    email = json['email']?.toString();
    phoneNumber = json['phone_number']?.toString();
    avatar = json['avatar']?.toString();
    socialType = json['social_type']?.toString();
    socialId = json['social_id']?.toString();
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
    hasSubscribedOnce = json['has_subscribed_once'];
    paidStartAt = json['paid_start_at']?.toString();
    paidEndAt = json['paid_end_at']?.toString();
    isActive = json['is_active'];
    passwordResetOtp = json['password_reset_otp']?.toString();
    emailVerifiedAt = json['email_verified_at']?.toString();
    lang = json['lang']?.toString();
    sendLeadOut = json['send_lead_out'];
    createdAt = json['created_at']?.toString();
    updatedAt = json['updated_at']?.toString();
    deletedAt = json['deleted_at']?.toString();
    companyLogoUrl = json['company_logo_url']?.toString();
    avatarUrl = json['avatar_url']?.toString();
    productId = json['product_id']?.toString();
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
    if (roles != null) {
      data['roles'] = roles!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
class Documents {
  int? id;
  int? dealId;
  String? name;
  String? createdAt;
  String? updatedAt;
  String? documentUrl;

  Documents(
      {this.id,
      this.dealId,
      this.name,
      this.createdAt,
      this.updatedAt,
      this.documentUrl});

  Documents.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    dealId = json['deal_id'];
    name = json['name'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    documentUrl = json['document_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['deal_id'] = this.dealId;
    data['name'] = this.name;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['document_url'] = this.documentUrl;
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
    pivot = json['pivot'] != null ? Pivot.fromJson(json['pivot']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
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
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['model_type'] = this.modelType;
    data['model_id'] = this.modelId;
    data['role_id'] = this.roleId;
    return data;
  }
}

class DealSteps {
  int? id;
  int? dealId;
  String? name;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;

  DealSteps(
      {this.id,
      this.dealId,
      this.name,
      this.createdAt,
      this.updatedAt,
      this.deletedAt});

  DealSteps.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    dealId = json['deal_id'];
    name = json['name'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this.id;
    data['deal_id'] = this.dealId;
    data['name'] = this.name;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['deleted_at'] = this.deletedAt;
    return data;
  }
}
class DealCases {
  int? id;
  int? dealId;
  String? leadType;
  String? commissionType;
  int? commissionValue;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;

  DealCases(
      {this.id,
        this.dealId,
        this.leadType,
        this.commissionType,
        this.commissionValue,
        this.createdAt,
        this.updatedAt,
        this.deletedAt});

  DealCases.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    dealId = json['deal_id'];
    leadType = json['lead_type'];
    commissionType = json['commission_type'];
    commissionValue = json['commission_value'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['deal_id'] = this.dealId;
    data['lead_type'] = this.leadType;
    data['commission_type'] = this.commissionType;
    data['commission_value'] = this.commissionValue;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['deleted_at'] = this.deletedAt;
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
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['current_page'] = this.currentPage;
    data['last_page'] = this.lastPage;
    data['per_page'] = this.perPage;
    data['total'] = this.total;
    return data;
  }
}
