class AddLeadWithReferrerRequest {
  final String dealId;
  final String firstName;
  final String lastName;
  final String email;
  final String phoneNumber;
  final String job;
  final String city;
  final String language;
  final LeadPayload lead;

  const AddLeadWithReferrerRequest({
    this.dealId = '',
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phoneNumber,
    this.job = '',
    this.city = '',
    this.language = '',
    required this.lead,
  });

  Map<String, dynamic> toJson() {
    return {
      'deal_id': dealId,
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'phone_number': phoneNumber,
      'job': job,
      'city': city,
      'language': language,
      'lead': lead.toJson(),
    };
  }
}

class LeadPayload {
  final String firstName;
  final String lastName;
  final String email;
  final String phoneNumber;
  final String note;

  const LeadPayload({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phoneNumber,
    required this.note,
  });

  Map<String, dynamic> toJson() {
    return {
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'phone_number': phoneNumber,
      'note': note,
    };
  }
}

