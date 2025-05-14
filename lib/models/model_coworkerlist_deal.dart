class ModelCoworkerlistDeal {
  int? code;
  bool? status;
  String? message;
  List<CoworkerlistDealData>? data;

  ModelCoworkerlistDeal({this.code, this.status, this.message, this.data});

  ModelCoworkerlistDeal.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <CoworkerlistDealData>[];
      json['data'].forEach((v) {
        data!.add(CoworkerlistDealData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['code'] = code;
    data['status'] = status;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CoworkerlistDealData {
  int? id;
  String? dealName;
  String? inviteQrCode;
  String? inviteLink;

  CoworkerlistDealData({this.id, this.dealName, this.inviteQrCode, this.inviteLink});

  CoworkerlistDealData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    dealName = json['deal_name'];
    inviteQrCode = json['invite_qr_code'];
    inviteLink = json['invite_link'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = id;
    data['deal_name'] = dealName;
    data['invite_qr_code'] = inviteQrCode;
    data['invite_link'] = inviteLink;
    return data;
  }
}