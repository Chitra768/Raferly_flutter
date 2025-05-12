class SubscriptionModel {
  int? code;
  bool? status;
  String? message;
  String? data;

  SubscriptionModel({this.code, this.status, this.message, this.data});

  SubscriptionModel.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    status = json['status'];
    message = json['message'];
    data = json['data'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['status'] = this.status;
    data['message'] = this.message;
    data['data'] = this.data;
    return data;
  }
}