class TeamMemberInviteRequest {
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final String jobTitle;
  final String city;
  final String memberType;
  final String? jobId;
  final String? successUrl;
  final String? cancelUrl;
  final bool? notifyOwnerByEmail;

  const TeamMemberInviteRequest({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.jobTitle,
    required this.city,
    required this.memberType,
    this.jobId,
    this.successUrl,
    this.cancelUrl,
    this.notifyOwnerByEmail,
  });

  Map<String, dynamic> toJson() {
    final payload = <String, dynamic>{
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'phone_number': phone,
      'city': city,
      'member_type': memberType,
    };
    if (jobTitle.trim().isNotEmpty) {
      payload['position'] = jobTitle.trim();
    }
    if (jobId != null && jobId!.trim().isNotEmpty) {
      payload['job_id'] = jobId;
    }
    if (successUrl != null && successUrl!.isNotEmpty) {
      payload['success_url'] = successUrl;
    }
    if (cancelUrl != null && cancelUrl!.isNotEmpty) {
      payload['cancel_url'] = cancelUrl;
    }
    if (notifyOwnerByEmail == true) {
      payload['notify_owner_by_email'] = true;
    }
    return payload;
  }
}
