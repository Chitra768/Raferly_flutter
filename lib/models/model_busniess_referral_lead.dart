class ModelBusinessReferralLead {
  int? code;
  bool? status;
  String? message;
  List<BusinessReferralLeadData>? data;
  Pagination? pagination;

  ModelBusinessReferralLead(
      {this.code, this.status, this.message, this.data, this.pagination});

  ModelBusinessReferralLead.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <BusinessReferralLeadData>[];
      json['data'].forEach((v) {
        data!.add(new BusinessReferralLeadData.fromJson(v));
      });
    }
    pagination = json['pagination'] != null
        ? new Pagination.fromJson(json['pagination'])
        : null;
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
      data['pagination'] = this.pagination!.toJson();
    }
    return data;
  }
}

class BusinessReferralLeadData {
  int? id;
  String? firstName;
  String? lastName;
  String? email;
  String? phoneNumber;
  String? avatar;
  String? createdAt;
  String? companyLogo;
  String? companyLogoUrl;
  String? companyName;
  String? companyAddress;
  String? companyCountryCode;
  String? companyNumber;
  int? dealId;
  String? lastAcceptedDealName;

  BusinessReferralLeadData(
      {this.id,
      this.firstName,
      this.lastName,
      this.email,
      this.phoneNumber,
      this.avatar,
      this.createdAt,
      this.companyLogo,
      this.companyLogoUrl,
      this.companyName,
      this.companyAddress,
      this.companyCountryCode,
      this.companyNumber,
      this.dealId,
      this.lastAcceptedDealName});

  BusinessReferralLeadData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    email = json['email'];
    phoneNumber = json['phone_number'];
    avatar = json['avatar'];
    createdAt = json['created_at'];
    companyLogo = json['company_logo'];
    companyLogoUrl = json['company_logo_url'];
    companyName = json['company_name'];
    companyAddress = json['company_address'];
    companyCountryCode = json['company_country_code'];
    companyNumber = json['company_number'];
    dealId = json['deal_id'];
    lastAcceptedDealName = json['last_accepted_deal_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['email'] = this.email;
    data['phone_number'] = this.phoneNumber;
    data['avatar'] = this.avatar;
    data['created_at'] = this.createdAt;
    data['company_logo'] = this.companyLogo;
    data['company_logo_url'] = this.companyLogoUrl;
    data['company_name'] = this.companyName;
    data['company_address'] = this.companyAddress;
    data['company_country_code'] = this.companyCountryCode;
    data['company_number'] = this.companyNumber;
    data['deal_id'] = this.dealId;
    data['last_accepted_deal_name'] = this.lastAcceptedDealName;
    return data;
  }
}

class Pagination {
  int? currentPage;
  int? lastPage;
  int? perPage;
  int? total;

  Pagination({this.currentPage, this.lastPage, this.perPage, this.total});

  Pagination.fromJson(Map<String, dynamic> json) {
    currentPage = json['current_page'];
    lastPage = json['last_page'];
    perPage = json['per_page'];
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['current_page'] = this.currentPage;
    data['last_page'] = this.lastPage;
    data['per_page'] = this.perPage;
    data['total'] = this.total;
    return data;
  }
}