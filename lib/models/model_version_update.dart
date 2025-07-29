class ModelVersionUpdate {
  int? code;
  bool? status;
  Message? message;

  ModelVersionUpdate({this.code, this.status, this.message});

  ModelVersionUpdate.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    status = json['status'];
    message =
        json['message'] != null ? new Message.fromJson(json['message']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['status'] = this.status;
    if (this.message != null) {
      data['message'] = this.message!.toJson();
    }
    return data;
  }
}

class Message {
  String? androidProductionVersion;
  String? androidBetaVersion;
  String? androidProductionVersionDate;
  String? androidBetaVersionDate;
  String? iosProductionVersion;
  String? iosBetaVersion;
  String? iosProductionVersionDate;
  String? iosBetaVersionDate;

  Message(
      {this.androidProductionVersion,
      this.androidBetaVersion,
      this.androidProductionVersionDate,
      this.androidBetaVersionDate,
      this.iosProductionVersion,
      this.iosBetaVersion,
      this.iosProductionVersionDate,
      this.iosBetaVersionDate});

  Message.fromJson(Map<String, dynamic> json) {
    androidProductionVersion = json['android_production_version'];
    androidBetaVersion = json['android_beta_version'];
    androidProductionVersionDate = json['android_production_version_date'];
    androidBetaVersionDate = json['android_beta_version_date'];
    iosProductionVersion = json['ios_production_version'];
    iosBetaVersion = json['ios_beta_version'];
    iosProductionVersionDate = json['ios_production_version_date'];
    iosBetaVersionDate = json['ios_beta_version_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['android_production_version'] = this.androidProductionVersion;
    data['android_beta_version'] = this.androidBetaVersion;
    data['android_production_version_date'] = this.androidProductionVersionDate;
    data['android_beta_version_date'] = this.androidBetaVersionDate;
    data['ios_production_version'] = this.iosProductionVersion;
    data['ios_beta_version'] = this.iosBetaVersion;
    data['ios_production_version_date'] = this.iosProductionVersionDate;
    data['ios_beta_version_date'] = this.iosBetaVersionDate;
    return data;
  }
}
