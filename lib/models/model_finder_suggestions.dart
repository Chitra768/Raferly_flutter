class ModelFinderSuggestions {
  int? code;
  bool? status;
  String? message;
  List<FinderSuggestionData>? data;
  Pagination? pagination;

  ModelFinderSuggestions({
    this.code,
    this.status,
    this.message,
    this.data,
    this.pagination,
  });

  ModelFinderSuggestions.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <FinderSuggestionData>[];
      json['data'].forEach((v) {
        data!.add(FinderSuggestionData.fromJson(v));
      });
    }
    pagination = json['pagination'] != null
        ? Pagination.fromJson(json['pagination'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['code'] = code;
    data['status'] = status;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    if (pagination != null) {
      data['pagination'] = pagination!.toJson();
    }
    return data;
  }
}

class FinderSuggestionData {
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
  bool? hasFinderDetail;

  FinderSuggestionData({
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
    this.hasFinderDetail,
  });

  FinderSuggestionData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    job = json['job'];
    if (json['professional_i_refer'] != null) {
      professionalIRefer = <ProfessionalReferItem>[];
      json['professional_i_refer'].forEach((v) {
        professionalIRefer!.add(ProfessionalReferItem.fromJson(v));
      });
    }
    if (json['who_can_refer_me'] != null) {
      whoCanReferMe = <ProfessionalReferItem>[];
      json['who_can_refer_me'].forEach((v) {
        whoCanReferMe!.add(ProfessionalReferItem.fromJson(v));
      });
    }
    shareCommissions = json['share_commissions'];
    city = json['city'];
    workPreferences = json['work_preferences'];
    userName = json['user_name'];
    companyName = json['company_name'];
    userImage = json['user_image'];
    userId = json['user_id'];
    hasFinderDetail = json['has_finder_detail'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['job'] = job;
    if (professionalIRefer != null) {
      data['professional_i_refer'] =
          professionalIRefer!.map((v) => v.toJson()).toList();
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
    data['has_finder_detail'] = hasFinderDetail;
    return data;
  }
}

class ProfessionalReferItem {
  int? id;
  String? name;

  ProfessionalReferItem({
    this.id,
    this.name,
  });

  ProfessionalReferItem.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    return data;
  }
}

class Pagination {
  int? currentPage;
  int? lastPage;
  int? perPage;
  int? total;
  int? totalCredit;
  int? availableCredit;
  int? usedCredit;

  Pagination({
    this.currentPage,
    this.lastPage,
    this.perPage,
    this.total,
    this.totalCredit,
    this.availableCredit,
    this.usedCredit,
  });

  Pagination.fromJson(Map<String, dynamic> json) {
    currentPage = json['current_page'];
    lastPage = json['last_page'];
    perPage = json['per_page'];
    total = json['total'];
    totalCredit = json['total_credit'];
    availableCredit = json['available_credit'];
    usedCredit = json['used_credit'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['current_page'] = currentPage;
    data['last_page'] = lastPage;
    data['per_page'] = perPage;
    data['total'] = total;
    data['total_credit'] = totalCredit;
    data['available_credit'] = availableCredit;
    data['used_credit'] = usedCredit;
    return data;
  }
}
