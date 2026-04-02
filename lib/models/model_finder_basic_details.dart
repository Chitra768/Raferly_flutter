import 'package:referaly/models/model_finder_suggestions.dart';

class ModelFinderBasicDetails {
  int? code;
  bool? status;
  String? message;
  FinderBasicDetailsData? data;
  List<dynamic>? pagination;

  ModelFinderBasicDetails({
    this.code,
    this.status,
    this.message,
    this.data,
    this.pagination,
  });

  ModelFinderBasicDetails.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    status = json['status'];
    message = json['message'];
    data = json['data'] != null
        ? FinderBasicDetailsData.fromJson(json['data'])
        : null;
    pagination = json['pagination'] != null ? json['pagination'] : [];
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

class FinderBasicDetailsData {
  int? id;
  String? userName;
  String? job;
  String? companyName;
  String? city;
  String? phoneNumber;
  String? email;
  String? avatarUrl;
  String? companyLogoUrl;
  String? companyAddress;
  String? companyDescription;
  FinderDetail? finderDetail;
  String? createdAt;
  String? updatedAt;

  FinderBasicDetailsData({
    this.id,
    this.userName,
    this.job,
    this.companyName,
    this.city,
    this.phoneNumber,
    this.email,
    this.avatarUrl,
    this.companyLogoUrl,
    this.companyAddress,
    this.companyDescription,
    this.finderDetail,
    this.createdAt,
    this.updatedAt,
  });

  FinderBasicDetailsData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userName = json['user_name'];
    job = json['job'];
    companyName = json['company_name'];
    city = json['city'];
    phoneNumber = json['phone_number'];
    email = json['email'];
    avatarUrl = json['avatar_url'];
    companyLogoUrl = json['company_logo_url'];
    companyAddress = json['company_address'];
    companyDescription = json['company_description'];
    finderDetail = json['finder_detail'] != null
        ? FinderDetail.fromJson(json['finder_detail'])
        : null;
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_name'] = userName;
    data['job'] = job;
    data['company_name'] = companyName;
    data['city'] = city;
    data['phone_number'] = phoneNumber;
    data['email'] = email;
    data['avatar_url'] = avatarUrl;
    data['company_logo_url'] = companyLogoUrl;
    data['company_address'] = companyAddress;
    data['company_description'] = companyDescription;
    if (finderDetail != null) {
      data['finder_detail'] = finderDetail!.toJson();
    }
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}

class FinderDetail {
  int? id;
  String? job;
  List<ProfessionalReferItem>? professionalIRefer;
  List<ProfessionalReferItem>? whoCanReferMe;
  int? shareCommissions;
  String? city;
  String? workPreferences;
  String? userName;
  String? companyName;
  String? userImage;
  int? userId;

  FinderDetail({
    this.id,
    this.job,
    this.professionalIRefer,
    this.whoCanReferMe,
    this.shareCommissions,
    this.city,
    this.workPreferences,
    this.userName,
    this.companyName,
    this.userImage,
    this.userId,
  });

  FinderDetail.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    job = json['job'];
    if (json['professional_i_refer'] != null) {
      professionalIRefer = <ProfessionalReferItem>[];
      for (final v in json['professional_i_refer'] as List) {
        professionalIRefer!.add(ProfessionalReferItem.fromJson(v as Map<String, dynamic>));
      }
    }
    if (json['who_can_refer_me'] != null) {
      whoCanReferMe = <ProfessionalReferItem>[];
      for (final v in json['who_can_refer_me'] as List) {
        whoCanReferMe!.add(ProfessionalReferItem.fromJson(v as Map<String, dynamic>));
      }
    }
    shareCommissions = json['share_commissions'];
    city = json['city'];
    workPreferences = json['work_preferences']?.toString();
    userName = json['user_name'];
    companyName = json['company_name'];
    userImage = json['user_image'];
    userId = json['user_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['job'] = job;
    if (professionalIRefer != null) {
      data['professional_i_refer'] = professionalIRefer!.map((v) => v.toJson()).toList();
    }
    if (whoCanReferMe != null) {
      data['who_can_refer_me'] = whoCanReferMe!.map((v) => v.toJson()).toList();
    }
    data['share_commissions'] = shareCommissions;
    data['city'] = city;
    data['work_preferences'] = workPreferences;
    data['user_name'] = userName;
    data['company_name'] = companyName;
    data['user_image'] = userImage;
    data['user_id'] = userId;
    return data;
  }
}
