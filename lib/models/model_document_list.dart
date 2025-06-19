class ModelDocumentList {
  int? code;
  bool? status;
  String? message;
  List<Data>? data;

  ModelDocumentList({this.code, this.status, this.message, this.data});

  ModelDocumentList.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
    String? document;
  String? name;
  String? id;
  String? dealId;
  String? createdAt;
  String? updatedAt;
  dynamic deletedAt;

    Data(
      {this.document,
      this.name,
      this.id,
      this.dealId,
      this.createdAt,
      this.updatedAt,
      this.deletedAt});

   Data.fromJson(Map<String, dynamic> json) {
    document = json['document'].toString();
    name = json['name'];
    id = json['id'].toString();
    dealId = json['deal_id'].toString();
    createdAt = json['created_at'].toString();
    updatedAt = json['updated_at'].toString();
    deletedAt = json['deleted_at'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['document'] = this.document;
    data['name'] = this.name;
    data['id'] = this.id;
    data['deal_id'] = this.dealId;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['deleted_at'] = this.deletedAt;
    return data;
  }
}
