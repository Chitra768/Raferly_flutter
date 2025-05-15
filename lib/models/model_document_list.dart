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

  Data({this.document, this.name});

  Data.fromJson(Map<String, dynamic> json) {
    document = json['document'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['document'] = this.document;
    data['name'] = this.name;
    return data;
  }
}
