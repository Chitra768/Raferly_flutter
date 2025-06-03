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
  String? id;
  String? createdBy;
  String? dealName;
  String? dealCommissionType;
  String? commissionType;
  String? commissionValue;
  String? description;
  String? document;
  String? documentUploadedManually;
  String? suggestion;
  String? isDelete;
  String? deepLink;
  String? sharingTempLink;
  String? sendLeadOut;
  String? isActive;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;
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
    id = json['id'].toString();
    createdBy = json['created_by'].toString();
    dealName = json['deal_name'].toString();
    dealCommissionType = json['deal_commission_type'].toString();
    commissionType = json['commission_type'].toString();
    commissionValue = json['commission_value'].toString();
    description = json['description'].toString();
    document = json['document'].toString();
    documentUploadedManually = json['document_uploaded_manually'].toString();
    suggestion = json['suggestion'].toString();
    isDelete = json['is_delete'].toString();
    deepLink = json['deep_link'].toString();
    sharingTempLink = json['sharing_temp_link'].toString();
    sendLeadOut = json['send_lead_out'].toString();
    isActive = json['is_active'].toString();
    createdAt = json['created_at'].toString();
    updatedAt = json['updated_at'].toString();
    deletedAt = json['deleted_at'].toString();
    inviteQrCode = json['invite_qr_code'].toString();
    documentUrl = json['document_url'].toString();
    commissionTransType = json['commission_trans_type'].toString();
    inviteLink = json['invite_link'].toString();
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
  String? id;
  String? dealId;
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
    id = json['id'].toString();
    dealId = json['deal_id'].toString();
    name = json['name'].toString();
    createdAt = json['created_at'].toString();
    updatedAt = json['updated_at'].toString();
    deletedAt = json['deleted_at'].toString();
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
  String? id;
  String? firstName;
  String? lastName;
  String? email;
  String? phoneNumber;
  String? dealId;
  String? description;
  String? leadAssignType;
  String? businessReferralId;
  String? createdBy;
  String? isLost;
  String? lostReason;
  String? isActive;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;
  String? companyLogoUrl;
  List<LeadTrack>? leadTrack;
  String? user;

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
    id = json['id'].toString();
    firstName = json['first_name'].toString();
    lastName = json['last_name'].toString();
    email = json['email'].toString();
    phoneNumber = json['phone_number'].toString();
    dealId = json['deal_id'].toString();
    description = json['description'].toString();
    leadAssignType = json['lead_assign_type'].toString();
    businessReferralId = json['business_referral_id'].toString();
    createdBy = json['created_by'].toString();
    isLost = json['is_lost'].toString();
    lostReason = json['lost_reason'].toString();
    isActive = json['is_active'].toString();
    createdAt = json['created_at'].toString();
    updatedAt = json['updated_at'].toString();
    deletedAt = json['deleted_at'].toString();
    companyLogoUrl = json['company_logo_url'].toString();
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
  String? id;
  String? leadId;
  String? dealStepId;
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
    id = json['id'].toString();
    leadId = json['lead_id'].toString();
    dealStepId = json['deal_step_id'].toString();
    name = json['name'].toString();
    esName = json['es_name'].toString();
    frName = json['fr_name'].toString();
    completedAt = json['completed_at'].toString();
    comment = json['comment'].toString();
    commisionValue = json['commision_value'].toString();
    createdAt = json['created_at'].toString();
    updatedAt = json['updated_at'].toString();
    deletedAt = json['deleted_at'].toString();
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
