class UserProfile {
  String firstName;
  String lastName;
  String email;
  String phone;
  String userType; // 'Professional' or 'Individual'
  String job;
  String city;
  String language;

  UserProfile({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.userType,
    required this.job,
    required this.city,
    required this.language,
  });
}
