class ModelCategories {
  int? code;
  bool? status;
  String? message;
  List<CategoryData>? data;
  List<dynamic>? pagination;

  ModelCategories({
    this.code,
    this.status,
    this.message,
    this.data,
    this.pagination,
  });

  ModelCategories.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <CategoryData>[];
      json['data'].forEach((v) {
        data!.add(CategoryData.fromJson(v));
      });
    }
    pagination = json['pagination'] != null ? json['pagination'] : [];
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
      data['pagination'] = pagination;
    }
    return data;
  }
}

class CategoryData {
  int? id;
  String? title;
  List<SubCategory>? subCategories;

  CategoryData({
    this.id,
    this.title,
    this.subCategories,
  });

  CategoryData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    if (json['sub_categories'] != null) {
      subCategories = <SubCategory>[];
      json['sub_categories'].forEach((v) {
        subCategories!.add(SubCategory.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    if (subCategories != null) {
      data['sub_categories'] = subCategories!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SubCategory {
  int? id;
  int? categoryId;
  String? title;

  SubCategory({
    this.id,
    this.categoryId,
    this.title,
  });

  SubCategory.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    categoryId = json['category_id'];
    title = json['title'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['category_id'] = categoryId;
    data['title'] = title;
    return data;
  }
}

