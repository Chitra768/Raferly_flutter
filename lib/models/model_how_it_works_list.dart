class ModelHowItWorksList {
  bool? status;
  List<HowItWorksList>? activity;

  ModelHowItWorksList({this.status, this.activity});

  ModelHowItWorksList.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['activity'] != null) {
      activity = <HowItWorksList>[];
      json['activity'].forEach((v) {
        activity!.add(new HowItWorksList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.activity != null) {
      data['activity'] = this.activity!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class HowItWorksList {
  int? id;
  String? types;
  int? priority;
  int? status;
  String? videoLink;
  String? icon;
  String? title;
  String? subtitle;
  String? text;
  List<String>? guidelines;

  HowItWorksList(
      {this.id,
        this.types,
        this.priority,
        this.status,
        this.videoLink,
        this.icon,
        this.title,
        this.subtitle,
        this.text,
        this.guidelines});

  HowItWorksList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    types = json['types'];
    priority = json['priority'];
    status = json['status'];
    videoLink = json['video_link'];
    icon = json['icon'];
    title = json['title'];
    subtitle = json['subtitle'];
    text = json['text'];
     // Safely parse guidelines, removing nulls
    if (json['guidelines'] != null && json['guidelines'] is List) {
      guidelines = List<String>.from(
        json['guidelines'].where((item) => item != null),
      );
    } else {
      guidelines = [];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['types'] = this.types;
    data['priority'] = this.priority;
    data['status'] = this.status;
    data['video_link'] = this.videoLink;
    data['icon'] = this.icon;
    data['title'] = this.title;
    data['subtitle'] = this.subtitle;
    data['text'] = this.text;
    data['guidelines'] = this.guidelines;
    return data;
  }
}
