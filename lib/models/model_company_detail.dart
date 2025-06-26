class ModelDealDetail {
  int? code;
  bool? status;
  String? message;
  DealDetailData? data;
  // List<String>? pagination;

  ModelDealDetail({
    this.code,
    this.status,
    this.message,
    this.data,
    // this.pagination,
  });

  ModelDealDetail.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    status = json['status'];
    message = json['message'];
    if (json['data'] != null && json['data'] is Map<String, dynamic>) {
      data = DealDetailData.fromJson(json['data']);
    }
    // if (json['pagination'] != null) {
    //   pagination = List<String>.from(json['pagination']);
    // }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = {};
    json['code'] = code;
    json['status'] = status;
    json['message'] = message;
    if (data != null) {
      json['data'] = data!.toJson();
    }
    // if (pagination != null) {
    //   json['pagination'] = pagination;
    // }
    return json;
  }
}

class DealDetailData {
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
  String? referrerName;
  String? documentName;
  String? companyName;
  String? companyLogoUrl;
  int? referrers;
  int? collaborators;
  int? totalLead;
  String? inviteQrCode;
  String? documentUrl;
  String? commissionTransType;
  String? inviteLink;
  List<DealSteps>? dealSteps;
  List<String>? dealCases;
  List<Users>? users;
  List<String>? leads;

  DealDetailData(
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
      this.referrerName,
      this.documentName,
      this.companyName,
      this.companyLogoUrl,
      this.referrers,
      this.collaborators,
      this.totalLead,
      this.inviteQrCode,
      this.documentUrl,
      this.commissionTransType,
      this.inviteLink,
      this.dealSteps,
      this.dealCases,
      this.users,
      this.leads});

  DealDetailData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
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
    referrerName = json['referrer_name'];
    documentName = json['document_name'];
    companyName = json['company_name'];
    companyLogoUrl = json['company_logo_url'];
    referrers = json['referrers'];
    collaborators = json['collaborators'];
    totalLead = json['total_lead'];
    inviteQrCode = json['invite_qr_code'];
    documentUrl = json['document_url'];
    commissionTransType = json['commission_trans_type'];
    inviteLink = json['invite_link'];
    if (json['deal_steps'] != null) {
      dealSteps = <DealSteps>[];
      json['deal_steps'].forEach((v) {
        dealSteps!.add(DealSteps.fromJson(v));
      });
    }
    // if (json['deal_cases'] != String) {
    //   dealCases = <String>[];
    //   json['deal_cases'].forEach((v) {
    //     dealCases!.add(new Null.fromJson(v));
    //   });
    // }
    if (json['users'] != null) {
      users = <Users>[];
      json['users'].forEach((v) {
        users!.add(Users.fromJson(v));
      });
    }
    // if (json['leads'] != null) {
    //   leads = <String>[];
    //   json['leads'].forEach((v) {
    //     leads!.add(new String.fromJson(v));
    //   });
    // }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
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
    data['referrer_name'] = referrerName;
    data['document_name'] = documentName;
    data['company_name'] = companyName;
    data['company_logo_url'] = companyLogoUrl;
    data['referrers'] = referrers;
    data['collaborators'] = collaborators;
    data['total_lead'] = totalLead;
    data['invite_qr_code'] = inviteQrCode;
    data['document_url'] = documentUrl;
    data['commission_trans_type'] = commissionTransType;
    data['invite_link'] = inviteLink;
    if (dealSteps != null) {
      data['deal_steps'] = dealSteps!.map((v) => v.toJson()).toList();
    }
    // if (this.dealCases != null) {
    //   data['deal_cases'] = this.dealCases!.map((v) => v.toJson()).toList();
    // }
    if (users != null) {
      data['users'] = users!.map((v) => v.toJson()).toList();
    }
    // if (this.leads != null) {
    //   data['leads'] = this.leads!.map((v) => v.toJson()).toList();
    // }
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
    data['id'] = id;
    data['deal_id'] = dealId;
    data['name'] = name;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['deleted_at'] = deletedAt;
    return data;
  }
}

class Users {
  String? firstName;
  String? lastName;
  String? email;
  String? countryCode;
  String? phoneNumber;
  String? createdAt;
  String? companyLogoUrl;
  String? avatarUrl;
  String? productId;
  Pivot? pivot;
  List<String>? roles;

  Users(
      {this.firstName,
      this.lastName,
      this.email,
      this.countryCode,
      this.phoneNumber,
      this.createdAt,
      this.companyLogoUrl,
      this.avatarUrl,
      this.productId,
      this.pivot,
      this.roles});

  Users.fromJson(Map<String, dynamic> json) {
    firstName = json['first_name'];
    lastName = json['last_name'];
    email = json['email'];
    countryCode = json['country_code'];
    phoneNumber = json['phone_number'];
    createdAt = json['created_at'];
    companyLogoUrl = json['company_logo_url'];
    avatarUrl = json['avatar_url'];
    productId = json['product_id'];
    pivot = json['pivot'] != String ? Pivot.fromJson(json['pivot']) : null;
    if (json['roles'] != null) {
      roles = <String>[];
      // json['roles'].forEach((v) {
      //   roles!.add(new String.fromJson(v));
      // });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['email'] = email;
    data['country_code'] = countryCode;
    data['phone_number'] = phoneNumber;
    data['created_at'] = createdAt;
    data['company_logo_url'] = companyLogoUrl;
    data['avatar_url'] = avatarUrl;
    data['product_id'] = productId;
    if (pivot != null) {
      data['pivot'] = pivot!.toJson();
    }
    // if (this.roles != null) {
    //   data['roles'] = this.roles!.map((v) => v.toJson()).toList();
    // }
    return data;
  }
}

class Pivot {
  int? dealId;
  int? userId;
  String? deletedAt;

  Pivot({this.dealId, this.userId, this.deletedAt});

  Pivot.fromJson(Map<String, dynamic> json) {
    dealId = json['deal_id'];
    userId = json['user_id'];
    deletedAt = json['deleted_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['deal_id'] = dealId;
    data['user_id'] = userId;
    data['deleted_at'] = deletedAt;
    return data;
  }
}
