enum FeedbackType {
  feedback,
  bug,
  featureIdea;

  String toJson() {
    if (this == FeedbackType.featureIdea) return 'feature_idea';
    return name;
  }

  static FeedbackType fromJson(String json) {
    if (json == 'feature_idea') return FeedbackType.featureIdea;
    return FeedbackType.values.firstWhere(
      (type) => type.name == json,
      orElse: () => throw FormatException('Invalid feedback type: $json'),
    );
  }
}

class FeedbackModel {
  int? code;
  bool? status;
  String? message;
  List<Data>? data;

  FeedbackModel({this.code, this.status, this.message, this.data});

  FeedbackModel.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  String? email;
  String? description;
  FeedbackType? type;
  int? userId;

  Data({this.email, this.description, this.type, this.userId});

  Data.fromJson(Map<String, dynamic> json) {
    email = json['email'];
    description = json['description'];
    type = json['type'] != null ? FeedbackType.fromJson(json['type']) : null;
    userId = json['user_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['email'] = this.email;
    data['description'] = this.description;
    data['type'] = this.type?.toJson();
    data['user_id'] = this.userId;
    return data;
  }
}
