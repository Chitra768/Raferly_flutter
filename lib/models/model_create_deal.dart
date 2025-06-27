class ModelCreateDeal {
  int? code;
  bool? status;
  String? message;
  // Data? data;
  // List<Null>? pagination;

  ModelCreateDeal(
      {this.code, this.status, this.message});

  ModelCreateDeal.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    status = json['status'];
    message = json['message'];
    // data = json['data'] != null ? Data.fromJson(json['data']) : null;
    // if (json['pagination'] != null) {
    //   pagination = [];
    //   json['pagination'].forEach((v) {
    //     pagination!.add(v);
    //   });
    // }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['code'] = code;
    data['status'] = status;
    data['message'] = message;
    // if (this.data != null) {
    //   data['data'] = this.data!.toJson();
    // }
    // if (pagination != null) {
    //   data['pagination'] = pagination!.map((v) => v).toList();
    // }
    return data;
  }
}

class Data {
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
