class ModelOngoingRequests {
  int? code;
  bool? status;
  String? message;
  List<OngoingRequestData>? data;
  List<dynamic>? pagination;

  ModelOngoingRequests({
    this.code,
    this.status,
    this.message,
    this.data,
    this.pagination,
  });

  ModelOngoingRequests.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <OngoingRequestData>[];
      json['data'].forEach((v) {
        data!.add(OngoingRequestData.fromJson(v));
      });
    }
    pagination = json['pagination'] ?? [];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['code'] = code;
    data['status'] = status;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['pagination'] = pagination;
    return data;
  }
}

class OngoingRequestData {
  int? id;
  UserData? userData;
  String? status;
  bool? needToRespond;

  OngoingRequestData({
    this.id,
    this.userData,
    this.status,
    this.needToRespond,
  });

  OngoingRequestData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userData =
        json['user_data'] != null ? UserData.fromJson(json['user_data']) : null;
    status = json['status'];
    needToRespond = json['need_to_respond'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    if (userData != null) {
      data['user_data'] = userData!.toJson();
    }
    data['status'] = status;
    data['need_to_respond'] = needToRespond;
    return data;
  }
}

class UserData {
  int? userId;
  String? userName;
  String? job;
  String? companyName;
  String? companyType;
  String? companyDescription;
  String? city;
  String? phoneNumber;
  String? email;
  String? avatarUrl;
  String? companyLogoUrl;

  UserData({
    this.userId,
    this.userName,
    this.job,
    this.companyName,
    this.companyType,
    this.companyDescription,
    this.city,
    this.phoneNumber,
    this.email,
    this.avatarUrl,
    this.companyLogoUrl,
  });

  UserData.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'] != null ? int.tryParse(json['user_id'].toString()) : null;
    userName = json['user_name'];
    job = json['job'];
    companyName = json['company_name'];
    companyType = json['company_type'];
    companyDescription = json['company_description'];
    city = json['city'];
    phoneNumber = json['phone_number'];
    email = json['email'];
    avatarUrl = json['avatar_url'];
    companyLogoUrl = json['company_logo_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (userId != null) data['user_id'] = userId;
    data['user_name'] = userName;
    data['job'] = job;
    data['company_name'] = companyName;
    if (companyType != null) data['company_type'] = companyType;
    if (companyDescription != null) data['company_description'] = companyDescription;
    data['city'] = city;
    data['phone_number'] = phoneNumber;
    data['email'] = email;
    data['avatar_url'] = avatarUrl;
    data['company_logo_url'] = companyLogoUrl;
    return data;
  }
}
