class ModelNotificationControl {
  int? code;
  bool? status;
  String? message;
  NotificationControlData? data;
  List<dynamic>? pagination;

  ModelNotificationControl({
    this.code,
    this.status,
    this.message,
    this.data,
    this.pagination,
  });

  factory ModelNotificationControl.fromJson(Map<String, dynamic> json) {
    return ModelNotificationControl(
      code: json['code'],
      status: json['status'],
      message: json['message'],
      data: json['data'] != null
          ? NotificationControlData.fromJson(json['data'])
          : null,
      pagination: json['pagination'] ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['code'] = code;
    data['status'] = status;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    if (pagination != null) {
      data['pagination'] = pagination;
    }
    return data;
  }
}

class NotificationControlData {
  bool? emailNotification;

  NotificationControlData({this.emailNotification});

  factory NotificationControlData.fromJson(Map<String, dynamic> json) {
    return NotificationControlData(
      emailNotification: json['email_notification'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['email_notification'] = emailNotification;
    return data;
  }
}

