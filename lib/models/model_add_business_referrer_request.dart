class AddBusinessReferrerRequest {
  final int dealId;
  final String firstName;
  final String lastName;
  final String phoneNumber;
  final String email;
  final String job;
  final String companyType;
  final bool createdByParent;

  const AddBusinessReferrerRequest({
    required this.dealId,
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
    required this.email,
    required this.job,
    required this.companyType,
    required this.createdByParent,
  });

  Map<String, dynamic> toJson() {
    return {
      'deal_id': dealId,
      'first_name': firstName,
      'last_name': lastName,
      'phone_number': phoneNumber,
      'email': email,
      'job': job,
      'company_type': companyType,
      'created_by_parent': createdByParent,
    };
  }
}
