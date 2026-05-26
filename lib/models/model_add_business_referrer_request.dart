class AddBusinessReferrerRequest {
  final int dealId;
  final String firstName;
  final String lastName;
  final String? countryCode;
  final String phoneNumber;
  final String email;
  final String job;
  final String? jobId;
  final String companyType;
  final bool createdByParent;
  /// When true, API receives `is_sponsored: "1"` and `sponsor_user_id` when [sponsorUserId] is set.
  final bool isSponsored;
  final int? sponsorUserId;

  const AddBusinessReferrerRequest({
    required this.dealId,
    required this.firstName,
    required this.lastName,
    this.countryCode,
    required this.phoneNumber,
    required this.email,
    required this.job,
    this.jobId,
    required this.companyType,
    required this.createdByParent,
    this.isSponsored = false,
    this.sponsorUserId,
  });

  Map<String, dynamic> toJson() {
    final payload = <String, dynamic>{
      'deal_id': dealId,
      'first_name': firstName,
      'last_name': lastName,
      if (countryCode != null && countryCode!.trim().isNotEmpty) 'country_code': countryCode,
      'phone_number': phoneNumber,
      'email': email,
      'job': job,
      if (jobId != null && jobId!.trim().isNotEmpty) 'job_id': jobId,
      'company_type': companyType,
      'created_by_parent': createdByParent,
      'is_sponsored': isSponsored ? '1' : '0',
      if (isSponsored && sponsorUserId != null) 'sponsor_user_id': sponsorUserId,
    };
    return payload;
  }
}
