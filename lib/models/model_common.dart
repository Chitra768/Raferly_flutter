class ModelCommon {
  int? code;
  bool? status;
  String? message;

  ModelCommon({this.code, this.status, this.message});

  ModelCommon.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    status = json['status'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['code'] = code;
    data['status'] = status;
    data['message'] = message;
    return data;
  }
}
