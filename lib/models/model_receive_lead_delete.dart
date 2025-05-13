class ModelReceiveLeadDelete {
  int? code;
  bool? status;
  String? message;

  ModelReceiveLeadDelete({this.code, this.status, this.message});

  ModelReceiveLeadDelete.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    status = json['status'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['code'] = code;
    data['status'] = status;
    data['message'] = message;
    return data;
  }
}