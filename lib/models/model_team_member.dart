enum TeamMemberType { agency, independent, unknown }

/// GET `deal/teamMembers` — `data` holds `members` + `billing`.
class TeamMemberListModel {
  int? code;
  bool? status;
  String? message;
  TeamMemberListPayload? data;
  List<dynamic>? pagination;

  TeamMemberListModel({
    this.code,
    this.status,
    this.message,
    this.data,
    this.pagination,
  });

  /// Convenience accessor for member rows.
  List<TeamMemberData> get members => data?.members ?? [];

  TeamMemberBilling? get billing => data?.billing;

  TeamMemberListModel.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    status = json['status'];
    message = json['message'];
    pagination = json['pagination'] is List ? json['pagination'] as List : null;
    final rawData = json['data'];
    if (rawData is Map<String, dynamic>) {
      data = TeamMemberListPayload.fromJson(rawData);
    } else if (rawData is List) {
      // Legacy: `data` was a flat member array.
      data = TeamMemberListPayload(
        members: rawData
            .whereType<Map>()
            .map((v) => TeamMemberData.fromJson(Map<String, dynamic>.from(v)))
            .toList(),
      );
    }
  }
}

class TeamMemberListPayload {
  List<TeamMemberData> members;
  TeamMemberBilling? billing;

  TeamMemberListPayload({
    List<TeamMemberData>? members,
    this.billing,
  }) : members = members ?? [];

  factory TeamMemberListPayload.fromJson(Map<String, dynamic> json) {
    final membersRaw = json['members'];
    final members = <TeamMemberData>[];
    if (membersRaw is List) {
      for (final v in membersRaw) {
        if (v is Map<String, dynamic>) {
          members.add(TeamMemberData.fromJson(v));
        } else if (v is Map) {
          members.add(TeamMemberData.fromJson(Map<String, dynamic>.from(v)));
        }
      }
    }
    return TeamMemberListPayload(
      members: members,
      billing: json['billing'] is Map<String, dynamic>
          ? TeamMemberBilling.fromJson(json['billing'] as Map<String, dynamic>)
          : json['billing'] is Map
              ? TeamMemberBilling.fromJson(
                  Map<String, dynamic>.from(json['billing'] as Map),
                )
              : null,
    );
  }
}

/// Seat limits and independent billing state from list endpoint.
class TeamMemberBilling {
  int? maxAgencyColleagues;
  int? agencyColleaguesCount;
  int? agencyColleaguesRemaining;
  int? independentColleaguesCount;
  int? independentColleaguesSuspended;
  String? independentSeatsSubscriptionStatus;
  bool independentSeatsPaymentIssue;
  int? independentSeatPlanId;
  double? independentSeatAmount;
  String? independentSeatCurrency;
  double? independentMonthlyTotal;
  bool independentSeatRequiresWebCheckout;
  String? webCheckoutBaseUrl;

  TeamMemberBilling({
    this.maxAgencyColleagues,
    this.agencyColleaguesCount,
    this.agencyColleaguesRemaining,
    this.independentColleaguesCount,
    this.independentColleaguesSuspended,
    this.independentSeatsSubscriptionStatus,
    this.independentSeatsPaymentIssue = false,
    this.independentSeatPlanId,
    this.independentSeatAmount,
    this.independentSeatCurrency,
    this.independentMonthlyTotal,
    this.independentSeatRequiresWebCheckout = false,
    this.webCheckoutBaseUrl,
  });

  factory TeamMemberBilling.fromJson(Map<String, dynamic> json) {
    return TeamMemberBilling(
      maxAgencyColleagues:
          TeamMemberData._parseInt(json['max_agency_colleagues']),
      agencyColleaguesCount:
          TeamMemberData._parseInt(json['agency_colleagues_count']),
      agencyColleaguesRemaining:
          TeamMemberData._parseInt(json['agency_colleagues_remaining']),
      independentColleaguesCount:
          TeamMemberData._parseInt(json['independent_colleagues_count']),
      independentColleaguesSuspended:
          TeamMemberData._parseInt(json['independent_colleagues_suspended']),
      independentSeatsSubscriptionStatus: TeamMemberData._parseString(
        json['independent_seats_subscription_status'],
      ),
      independentSeatsPaymentIssue:
          json['independent_seats_payment_issue'] == true,
      independentSeatPlanId:
          TeamMemberData._parseInt(json['independent_seat_plan_id']),
      independentSeatAmount: _parseDouble(json['independent_seat_amount']),
      independentSeatCurrency: TeamMemberData._parseString(
        json['independent_seat_currency'],
      ),
      independentMonthlyTotal:
          _parseDouble(json['independent_monthly_total']),
      independentSeatRequiresWebCheckout:
          json['independent_seat_requires_web_checkout'] == true,
      webCheckoutBaseUrl:
          TeamMemberData._parseString(json['web_checkout_base_url']),
    );
  }

  static double? _parseDouble(dynamic value) {
    if (value == null) return null;
    if (value is num) return value.toDouble();
    return double.tryParse(value.toString());
  }
}

class TeamMemberData {
  int? id;
  int? userId;
  String? fullName;
  String? email;
  String? phoneNumber;
  String? avatarUrl;
  String? memberType;
  String? status;
  String? createdAt;

  TeamMemberData({
    this.id,
    this.userId,
    this.fullName,
    this.email,
    this.phoneNumber,
    this.avatarUrl,
    this.memberType,
    this.status,
    this.createdAt,
  });

  TeamMemberData.fromJson(Map<String, dynamic> json) {
    id = _parseInt(json['id'] ?? json['collaborator_id']);
    userId = _parseInt(json['user_id'] ?? json['userId']);
    fullName = _parseString(
      json['full_name'] ?? json['fullName'] ?? json['name'],
    );
    email = _parseString(json['email']);
    phoneNumber = _parseString(json['phone_number'] ?? json['phoneNumber']);
    avatarUrl = _parseString(
      json['avatar_url'] ?? json['avatarUrl'] ?? json['company_logo_url'] ?? json['companyLogoUrl'],
    );
    memberType = _parseString(
      json['member_type'] ?? json['memberType'] ?? json['role_type'] ?? json['role'],
    );
    status = _parseString(json['status']);
    createdAt = _parseString(json['created_at'] ?? json['createdAt']);

    final user = json['user'];
    if (user is Map<String, dynamic>) {
      userId ??= _parseInt(user['id']);
      fullName ??= _parseString(user['full_name'] ?? user['fullName']);
      email ??= _parseString(user['email']);
      phoneNumber ??= _parseString(user['phone_number'] ?? user['phoneNumber']);
      avatarUrl ??= _parseString(
        user['avatar_url'] ?? user['company_logo_url'] ?? user['companyLogoUrl'],
      );
      memberType ??= _memberTypeFromRoles(user['roles']);
    }
  }

  TeamMemberType get type {
    final raw = (memberType ?? '').toLowerCase();
    if (raw.contains('independent') || raw == 'independent-user') {
      return TeamMemberType.independent;
    }
    if (raw.contains('agency') || raw == 'agency-user') {
      return TeamMemberType.agency;
    }
    return TeamMemberType.unknown;
  }

  static int? _parseInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    return int.tryParse(value.toString());
  }

  static String? _parseString(dynamic value) {
    if (value == null) return null;
    final s = value.toString();
    return s.isEmpty ? null : s;
  }

  static String? _memberTypeFromRoles(dynamic roles) {
    if (roles is! List) return null;
    for (final role in roles) {
      if (role is Map) {
        final name = role['name']?.toString().toLowerCase() ?? '';
        if (name.contains('independent')) return 'independent';
        if (name.contains('agency')) return 'agency';
      }
    }
    return null;
  }
}

/// Visibility + edition for a content module (agency co-user).
class ModulePermission {
  bool visibility;
  bool edition;

  ModulePermission({this.visibility = false, this.edition = false});

  ModulePermission copyWith({bool? visibility, bool? edition}) {
    return ModulePermission(
      visibility: visibility ?? this.visibility,
      edition: edition ?? this.edition,
    );
  }

  bool matches(ModulePermission other) => visibility == other.visibility && edition == other.edition;

  Map<String, dynamic> toJson() => {
        'visibility': visibility,
        'edition': edition,
      };

  factory ModulePermission.fromJson(dynamic json) {
    if (json is bool) {
      return ModulePermission(visibility: json, edition: false);
    }
    if (json is Map) {
      return ModulePermission(
        visibility: json['visibility'] == true,
        edition: json['edition'] == true,
      );
    }
    return ModulePermission();
  }
}

/// Agency co-user content + navigation restrictions (premium controls).
class TeamMemberContentAccess {
  ModulePermission businessReferrers;
  ModulePermission leadsSent;
  ModulePermission leadsReceived;
  ModulePermission referralContracts;
  // bool myNetworkVisible;
  bool iAmReferrerVisible;

  TeamMemberContentAccess({
    ModulePermission? businessReferrers,
    ModulePermission? leadsSent,
    ModulePermission? leadsReceived,
    ModulePermission? referralContracts,
    // this.myNetworkVisible = true,
    this.iAmReferrerVisible = true,
  })  : businessReferrers = businessReferrers ?? ModulePermission(),
        leadsSent = leadsSent ?? ModulePermission(),
        leadsReceived = leadsReceived ?? ModulePermission(),
        referralContracts = referralContracts ?? ModulePermission();

  TeamMemberContentAccess copy() {
    return TeamMemberContentAccess(
      businessReferrers: businessReferrers.copyWith(),
      leadsSent: leadsSent.copyWith(),
      leadsReceived: leadsReceived.copyWith(),
      referralContracts: referralContracts.copyWith(),
      // myNetworkVisible: myNetworkVisible,
      iAmReferrerVisible: iAmReferrerVisible,
    );
  }

  bool matches(TeamMemberContentAccess other) {
    return businessReferrers.matches(other.businessReferrers) &&
        leadsSent.matches(other.leadsSent) &&
        leadsReceived.matches(other.leadsReceived) &&
        referralContracts.matches(other.referralContracts) &&
        // myNetworkVisible == other.myNetworkVisible &&
        iAmReferrerVisible == other.iAmReferrerVisible;
  }

  Map<String, dynamic> toJson() => {
        'business_referrers': businessReferrers.toJson(),
        'leads_sent': leadsSent.toJson(),
        'leads_received': leadsReceived.toJson(),
        'referral_contracts': referralContracts.toJson(),
        // 'my_network': myNetworkVisible,
        'i_am_referrer': iAmReferrerVisible,
      };

  factory TeamMemberContentAccess.fromJson(Map<String, dynamic>? json) {
    if (json == null) return TeamMemberContentAccess();
    final leads = json['leads'];
    ModulePermission? sent;
    ModulePermission? received;
    if (leads is Map) {
      sent = ModulePermission.fromJson(leads['sent'] ?? leads['send']);
      received = ModulePermission.fromJson(leads['received']);
    }
    return TeamMemberContentAccess(
      businessReferrers: ModulePermission.fromJson(
        json['business_referrers'] ?? json['businessReferrers'],
      ),
      leadsSent: sent ?? ModulePermission.fromJson(json['leads_sent'] ?? json['leadsSent']),
      leadsReceived: received ?? ModulePermission.fromJson(json['leads_received'] ?? json['leadsReceived']),
      referralContracts: ModulePermission.fromJson(
        json['referral_contracts'] ?? json['referralContracts'],
      ),
      // myNetworkVisible: json['my_network'] != false && json['myNetwork'] != false,
      iAmReferrerVisible: json['i_am_referrer'] != false && json['iAmReferrer'] != false,
    );
  }
}

class TeamMemberSettingsModel {
  int? id;
  int? userId;
  String? fullName;
  String? email;
  String? avatarUrl;
  String? memberType;
  String? collaborationLabel;
  TeamMemberContentAccess contentAccess;
  bool canSwitchToIndependent;

  TeamMemberSettingsModel({
    this.id,
    this.userId,
    this.fullName,
    this.email,
    this.avatarUrl,
    this.memberType,
    this.collaborationLabel,
    TeamMemberContentAccess? contentAccess,
    this.canSwitchToIndependent = false,
  }) : contentAccess = contentAccess ?? TeamMemberContentAccess();

  factory TeamMemberSettingsModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] is Map<String, dynamic> ? json['data'] as Map<String, dynamic> : json;
    return TeamMemberSettingsModel(
      id: TeamMemberData._parseInt(data['id']),
      userId: TeamMemberData._parseInt(data['user_id'] ?? data['userId']),
      fullName: TeamMemberData._parseString(data['full_name'] ?? data['fullName']),
      email: TeamMemberData._parseString(data['email']),
      avatarUrl: TeamMemberData._parseString(data['avatar_url'] ?? data['avatarUrl']),
      memberType: TeamMemberData._parseString(data['member_type'] ?? data['memberType']),
      collaborationLabel: TeamMemberData._parseString(
        data['collaboration_label'] ?? data['collaborationLabel'],
      ),
      contentAccess: TeamMemberContentAccess.fromJson(
        data['content_access'] is Map<String, dynamic>
            ? data['content_access'] as Map<String, dynamic>
            : null,
      ),
      canSwitchToIndependent:
          data['can_switch_to_independent'] == true || data['canSwitchToIndependent'] == true,
    );
  }
}

class TeamMemberSettingsResponse {
  bool? status;
  String? message;
  TeamMemberSettingsModel? data;

  TeamMemberSettingsResponse({this.status, this.message, this.data});

  factory TeamMemberSettingsResponse.fromJson(Map<String, dynamic> json) {
    return TeamMemberSettingsResponse(
      status: json['status'] == true,
      message: TeamMemberData._parseString(json['message']),
      data: json['data'] is Map<String, dynamic> ? TeamMemberSettingsModel.fromJson(json) : null,
    );
  }
}

class TeamMemberPerformance {
  int totalLeads;
  int activeLeads;
  int pendingLeads;
  int successfulLeads;
  int lostLeads;
  int businessReferrers;
  int referralContracts;
  double conversionRate;
  num totalTurnover;
  num totalCommissionPaid;
  num totalNetIncome;
  String currency;

  TeamMemberPerformance({
    this.totalLeads = 0,
    this.activeLeads = 0,
    this.pendingLeads = 0,
    this.successfulLeads = 0,
    this.lostLeads = 0,
    this.businessReferrers = 0,
    this.referralContracts = 0,
    this.conversionRate = 0,
    this.totalTurnover = 0,
    this.totalCommissionPaid = 0,
    this.totalNetIncome = 0,
    this.currency = '',
  });

  int get displayPendingLeads => pendingLeads > 0 ? pendingLeads : activeLeads;

  factory TeamMemberPerformance.fromJson(Map<String, dynamic>? json) {
    if (json == null) return TeamMemberPerformance();
    final active = TeamMemberData._parseInt(json['active_leads']) ?? 0;
    final pending = TeamMemberData._parseInt(json['pending_leads']) ?? active;
    return TeamMemberPerformance(
      totalLeads: TeamMemberData._parseInt(json['total_leads']) ?? 0,
      activeLeads: active,
      pendingLeads: pending,
      successfulLeads: TeamMemberData._parseInt(json['successful_leads']) ?? 0,
      lostLeads: TeamMemberData._parseInt(json['lost_leads']) ?? 0,
      businessReferrers: TeamMemberData._parseInt(json['business_referrers']) ?? 0,
      referralContracts: TeamMemberData._parseInt(json['referral_contracts']) ?? 0,
      conversionRate: (json['conversion_rate'] is num) ? (json['conversion_rate'] as num).toDouble() : 0,
      totalTurnover: json['total_turnover_generated'] ?? json['total_turnover'] ?? 0,
      totalCommissionPaid: json['total_commission_paid'] ?? 0,
      totalNetIncome: json['total_net_income'] ?? 0,
      currency: TeamMemberData._parseString(json['currency']) ?? '',
    );
  }
}

class TeamMemberProfileModel {
  int? id;
  int? userId;
  String? fullName;
  String? email;
  String? avatarUrl;
  String? memberType;
  String? collaborationLabel;
  String? aboutIndependent;
  TeamMemberPerformance performance;
  bool canSwitchToAgency;

  TeamMemberProfileModel({
    this.id,
    this.userId,
    this.fullName,
    this.email,
    this.avatarUrl,
    this.memberType,
    this.collaborationLabel,
    this.aboutIndependent,
    TeamMemberPerformance? performance,
    this.canSwitchToAgency = false,
  }) : performance = performance ?? TeamMemberPerformance();

  factory TeamMemberProfileModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] is Map<String, dynamic> ? json['data'] as Map<String, dynamic> : json;
    return TeamMemberProfileModel(
      id: TeamMemberData._parseInt(data['id']),
      userId: TeamMemberData._parseInt(data['user_id'] ?? data['userId']),
      fullName: TeamMemberData._parseString(data['full_name'] ?? data['fullName']),
      email: TeamMemberData._parseString(data['email']),
      avatarUrl: TeamMemberData._parseString(data['avatar_url'] ?? data['avatarUrl']),
      memberType: TeamMemberData._parseString(data['member_type'] ?? data['memberType']),
      collaborationLabel: TeamMemberData._parseString(
        data['collaboration_label'] ?? data['collaborationLabel'],
      ),
      aboutIndependent: TeamMemberData._parseString(
        data['about'] ?? data['about_independent'] ?? data['aboutIndependent'],
      ),
      performance: TeamMemberPerformance.fromJson(
        data['performance'] is Map<String, dynamic> ? data['performance'] as Map<String, dynamic> : null,
      ),
      canSwitchToAgency: data['can_switch_to_agency'] == true || data['canSwitchToAgency'] == true,
    );
  }
}

class TeamMemberProfileResponse {
  bool? status;
  String? message;
  TeamMemberProfileModel? data;

  TeamMemberProfileResponse({this.status, this.message, this.data});

  factory TeamMemberProfileResponse.fromJson(Map<String, dynamic> json) {
    return TeamMemberProfileResponse(
      status: json['status'] == true,
      message: TeamMemberData._parseString(json['message']),
      data: json['data'] is Map<String, dynamic> ? TeamMemberProfileModel.fromJson(json) : null,
    );
  }
}

enum TeamMemberContentTab { leads, contracts, referrers }

extension TeamMemberContentTabX on TeamMemberContentTab {
  String get apiValue {
    switch (this) {
      case TeamMemberContentTab.leads:
        return 'leads';
      case TeamMemberContentTab.contracts:
        return 'contracts';
      case TeamMemberContentTab.referrers:
        return 'referrers';
    }
  }

  static TeamMemberContentTab fromString(String? value) {
    switch (value?.toLowerCase()) {
      case 'contracts':
        return TeamMemberContentTab.contracts;
      case 'referrers':
        return TeamMemberContentTab.referrers;
      default:
        return TeamMemberContentTab.leads;
    }
  }
}

class TeamMemberContentItem {
  int? id;
  String? type;
  String? title;
  String? subtitle;
  String? status;
  String? logoUrl;
  int? dealId;

  TeamMemberContentItem({
    this.id,
    this.type,
    this.title,
    this.subtitle,
    this.status,
    this.logoUrl,
    this.dealId,
  });

  factory TeamMemberContentItem.fromJson(Map<String, dynamic> json) {
    return TeamMemberContentItem(
      id: TeamMemberData._parseInt(json['id']),
      type: TeamMemberData._parseString(json['type']),
      title: TeamMemberData._parseString(json['title']),
      subtitle: TeamMemberData._parseString(json['subtitle']),
      status: TeamMemberData._parseString(json['status']),
      logoUrl: TeamMemberData._parseString(json['logo_url'] ?? json['logoUrl']),
      dealId: TeamMemberData._parseInt(json['deal_id'] ?? json['dealId']),
    );
  }
}

class TeamMemberContentSummary {
  int leadsCount;
  int contractsCount;
  int referrersCount;

  TeamMemberContentSummary({
    this.leadsCount = 0,
    this.contractsCount = 0,
    this.referrersCount = 0,
  });

  factory TeamMemberContentSummary.fromJson(Map<String, dynamic>? json) {
    if (json == null) return TeamMemberContentSummary();
    return TeamMemberContentSummary(
      leadsCount: TeamMemberData._parseInt(json['leads_count']) ?? 0,
      contractsCount: TeamMemberData._parseInt(json['contracts_count']) ?? 0,
      referrersCount: TeamMemberData._parseInt(json['referrers_count']) ?? 0,
    );
  }
}

class TeamMemberContentModel {
  TeamMemberContentSummary summary;
  TeamMemberContentTab tab;
  List<TeamMemberContentItem> items;
  String? memberName;
  String? memberEmail;
  String? avatarUrl;

  TeamMemberContentModel({
    TeamMemberContentSummary? summary,
    this.tab = TeamMemberContentTab.leads,
    List<TeamMemberContentItem>? items,
    this.memberName,
    this.memberEmail,
    this.avatarUrl,
  })  : summary = summary ?? TeamMemberContentSummary(),
        items = items ?? [];

  factory TeamMemberContentModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] is Map<String, dynamic> ? json['data'] as Map<String, dynamic> : json;
    final itemsRaw = data['items'];
    final items = <TeamMemberContentItem>[];
    if (itemsRaw is List) {
      for (final item in itemsRaw) {
        if (item is Map<String, dynamic>) {
          items.add(TeamMemberContentItem.fromJson(item));
        }
      }
    }
    return TeamMemberContentModel(
      summary: TeamMemberContentSummary.fromJson(
        data['summary'] is Map<String, dynamic> ? data['summary'] as Map<String, dynamic> : null,
      ),
      tab: TeamMemberContentTabX.fromString(
        TeamMemberData._parseString(data['tab']),
      ),
      items: items,
      memberName: TeamMemberData._parseString(data['member_name'] ?? data['memberName']),
      memberEmail: TeamMemberData._parseString(data['member_email'] ?? data['memberEmail']),
      avatarUrl: TeamMemberData._parseString(data['avatar_url'] ?? data['avatarUrl']),
    );
  }
}

class TeamMemberContentResponse {
  bool? status;
  String? message;
  TeamMemberContentModel? data;

  TeamMemberContentResponse({this.status, this.message, this.data});

  factory TeamMemberContentResponse.fromJson(Map<String, dynamic> json) {
    return TeamMemberContentResponse(
      status: json['status'] == true,
      message: TeamMemberData._parseString(json['message']),
      data: json['data'] is Map<String, dynamic> ? TeamMemberContentModel.fromJson(json) : null,
    );
  }
}
