class CompanyProfile {
  final String name;
  final String description;
  final String address;
  final String businessCode;
  final String? imagePath;

  CompanyProfile({
    required this.name,
    required this.description,
    required this.address,
    required this.businessCode,
    this.imagePath,
  });

  factory CompanyProfile.fromJson(Map<String, dynamic> json) {
    return CompanyProfile(
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      address: json['address'] ?? '',
      businessCode: json['businessCode'] ?? '',
      imagePath: json['imagePath'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'address': address,
      'businessCode': businessCode,
      'imagePath': imagePath,
    };
  }
} 