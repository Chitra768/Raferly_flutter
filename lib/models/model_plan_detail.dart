class PlanDetailResponse {
  final int? code;
  final bool? status;
  final String? message;
  final PlanDetailData? data;

  PlanDetailResponse({
    this.code,
    this.status,
    this.message,
    this.data,
  });

  factory PlanDetailResponse.fromJson(Map<String, dynamic> json) {
    return PlanDetailResponse(
      code: json['code'] is int ? json['code'] as int : int.tryParse('${json['code']}'),
      status: json['status'] as bool?,
      message: json['message'] as String?,
      data: json['data'] is Map<String, dynamic>
          ? PlanDetailData.fromJson(json['data'] as Map<String, dynamic>)
          : null,
    );
  }
}

class PlanDetailData {
  final List<SubscriptionPlan> subscriptions;

  PlanDetailData({required this.subscriptions});

  factory PlanDetailData.fromJson(Map<String, dynamic> json) {
    final raw = json['subscriptions'];
    final list = (raw is List)
        ? raw.whereType<Map>().map((e) => Map<String, dynamic>.from(e)).toList()
        : const <Map<String, dynamic>>[];

    return PlanDetailData(
      subscriptions: list.map(SubscriptionPlan.fromJson).toList(),
    );
  }
}

class SubscriptionPlan {
  final int? id;
  final String? name;
  final String? label;
  final num? amount;
  final String? type;
  final String? subscriptionType;
  final int? isForAndroid;
  final int? isForWebApp;
  final int? isForIos;
  final String? androidPackageName;
  final String? iosPackageName;
  final String? description;
  final int? isActive;
  final String? createdAt;
  final String? updatedAt;
  final String? deletedAt;
  final num? monthlyAmount;

  SubscriptionPlan({
    this.id,
    this.name,
    this.label,
    this.amount,
    this.type,
    this.subscriptionType,
    this.isForAndroid,
    this.isForWebApp,
    this.isForIos,
    this.androidPackageName,
    this.iosPackageName,
    this.description,
    this.isActive,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.monthlyAmount,
  });

  factory SubscriptionPlan.fromJson(Map<String, dynamic> json) {
    num? _asNum(dynamic v) {
      if (v is num) return v;
      return num.tryParse('$v');
    }

    int? _asInt(dynamic v) {
      if (v is int) return v;
      return int.tryParse('$v');
    }

    return SubscriptionPlan(
      id: _asInt(json['id']),
      name: json['name'] as String?,
      label: json['label'] as String?,
      amount: _asNum(json['amount']),
      type: json['type'] as String?,
      subscriptionType: json['subscription_type'] as String?,
      isForAndroid: _asInt(json['is_for_android']),
      isForWebApp: _asInt(json['is_for_web_app']),
      isForIos: _asInt(json['is_for_ios']),
      androidPackageName: json['android_package_name'] as String?,
      iosPackageName: json['ios_package_name'] as String?,
      description: json['description'] as String?,
      isActive: _asInt(json['is_active']),
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
      deletedAt: json['deleted_at'] as String?,
      monthlyAmount: _asNum(json['monthly_amount']),
    );
  }
}

