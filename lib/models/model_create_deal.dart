class ModelCreateDeal {
  int? code;
  bool? status;
  String? message;
  Data? data;
  List<Null>? pagination;

  ModelCreateDeal(
      {this.code, this.status, this.message, this.data, this.pagination});

  ModelCreateDeal.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
    if (json['pagination'] != null) {
      pagination = [];
      json['pagination'].forEach((v) {
        pagination!.add(v);
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['code'] = code;
    data['status'] = status;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    if (pagination != null) {
      data['pagination'] = pagination!.map((v) => v).toList();
    }
    return data;
  }
}

class Data {
  int? id;
  int? createdBy;
  String? dealName;
  int? dealCommissionType;
  String? commissionType;
  Null? commissionValue;
  Null? description;
  String? document;
  int? documentUploadedManually;
  int? suggestion;
  int? isDelete;
  String? deepLink;
  Null? sharingTempLink;
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

  Data(
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

  Data.fromJson(Map<String, dynamic> json) {
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
        dealSteps!.add(DealSteps.fromJson(v));
      });
    }
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
    data['invite_qr_code'] = inviteQrCode;
    data['document_url'] = documentUrl;
    data['commission_trans_type'] = commissionTransType;
    data['invite_link'] = inviteLink;
    if (dealSteps != null) {
      data['deal_steps'] = dealSteps!.map((v) => v.toJson()).toList();
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
