class ModelOutofraferaly {
  int? code;
  bool? status;
  String? message;
  Data? data;

  ModelOutofraferaly({this.code, this.status, this.message, this.data});

  ModelOutofraferaly.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  DealDetail? dealDetail;
  LeadDetail? leadDetail;

  Data({this.dealDetail, this.leadDetail});

  Data.fromJson(Map<String, dynamic> json) {
    dealDetail = json['dealDetail'] != null
        ? new DealDetail.fromJson(json['dealDetail'])
        : null;
    leadDetail = json['leadDetail'] != null
        ? new LeadDetail.fromJson(json['leadDetail'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.dealDetail != null) {
      data['dealDetail'] = this.dealDetail!.toJson();
    }
    if (this.leadDetail != null) {
      data['leadDetail'] = this.leadDetail!.toJson();
    }
    return data;
  }
}

class DealDetail {
  int? id;
  Null? createdBy;
  String? dealName;
  int? dealCommissionType;
  String? commissionType;
  String? commissionValue;
  Null? description;
  Null? document;
  int? documentUploadedManually;
  int? suggestion;
  int? isDelete;
  String? deepLink;
  String? sharingTempLink;
  int? sendLeadOut;
  int? isActive;
  String? createdAt;
  String? updatedAt;
  Null? deletedAt;
  String? inviteQrCode;
  String? documentUrl;
  String? commissionTransType;
  String? inviteLink;
  List<DealSteps>? dealSteps;

  DealDetail(
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
      this.dealSteps});

  DealDetail.fromJson(Map<String, dynamic> json) {
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
    inviteQrCode = json['invite_qr_code'];
    documentUrl = json['document_url'];
    commissionTransType = json['commission_trans_type'];
    inviteLink = json['invite_link'];
    if (json['deal_steps'] != null) {
      dealSteps = <DealSteps>[];
      json['deal_steps'].forEach((v) {
        dealSteps!.add(new DealSteps.fromJson(v));
      });
    }
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
    if (this.dealSteps != null) {
      data['deal_steps'] = this.dealSteps!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class DealSteps {
  int? id;
  int? dealId;
  String? name;
  String? createdAt;
  String? updatedAt;
  Null? deletedAt;

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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['deal_id'] = this.dealId;
    data['name'] = this.name;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['deleted_at'] = this.deletedAt;
    return data;
  }
}

class LeadDetail {
  int? id;
  String? firstName;
  String? lastName;
  String? email;
  String? phoneNumber;
  int? dealId;
  String? description;
  String? leadAssignType;
  Null? businessReferralId;
  Null? createdBy;
  int? isLost;
  Null? lostReason;
  int? isActive;
  String? createdAt;
  String? updatedAt;
  Null? deletedAt;
  String? companyLogoUrl;
  List<LeadTrack>? leadTrack;
  Null? user;

  LeadDetail(
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
      this.companyLogoUrl,
      this.leadTrack,
      this.user});

  LeadDetail.fromJson(Map<String, dynamic> json) {
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
    lostReason = json['lost_reason'];
    isActive = json['is_active'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
    companyLogoUrl = json['company_logo_url'];
    if (json['lead_track'] != null) {
      leadTrack = <LeadTrack>[];
      json['lead_track'].forEach((v) {
        leadTrack!.add(new LeadTrack.fromJson(v));
      });
    }
    user = json['user'];
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
    data['company_logo_url'] = this.companyLogoUrl;
    if (this.leadTrack != null) {
      data['lead_track'] = this.leadTrack!.map((v) => v.toJson()).toList();
    }
    data['user'] = this.user;
    return data;
  }
}

class LeadTrack {
  int? id;
  int? leadId;
  int? dealStepId;
  String? name;
  Null? esName;
  Null? frName;
  Null? completedAt;
  Null? comment;
  Null? commisionValue;
  String? createdAt;
  String? updatedAt;
  Null? deletedAt;

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
    esName = json['es_name'];
    frName = json['fr_name'];
    completedAt = json['completed_at'];
    comment = json['comment'];
    commisionValue = json['commision_value'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
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

