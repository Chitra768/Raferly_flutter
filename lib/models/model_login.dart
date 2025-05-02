class ModelLogin {
  bool? status;
  String? message;
  int? userId;

  ModelLogin({this.status, this.message, this.userId});

  ModelLogin.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    userId = json['user_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    data['user_id'] = userId;
    return data;
  }
}
