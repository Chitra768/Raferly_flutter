class ModelUploadDocument {
  int? code;
  bool? status;
  String? message;
  List<Data>? data;
  List<dynamic>? pagination;

  ModelUploadDocument(
      {this.code, this.status, this.message, this.data, this.pagination});

  ModelUploadDocument.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
    if (json['pagination'] != null) {
      pagination = <dynamic>[];
      json['pagination'].forEach((v) {
        pagination!.add(v);
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
    if (this.pagination != null) {
      data['pagination'] = this.pagination!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  String? id;
  String? document;
  String? name;

  Data({this.id, this.document, this.name});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    document = json['document'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['document'] = this.document;
    data['name'] = this.name;
    return data;
  }
}