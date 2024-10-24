class CompanyData {
  final String email;
  final String name;
  final int phone;
  final String tax;
  final String career;
  final String address;
  final String description;

  CompanyData({
    required this.email,
    required this.name,
    required this.phone,
    required this.tax,
    required this.career,
    required this.address,
    required this.description,
  });

  factory CompanyData.fromMap(Map<String, dynamic> map) {
    return CompanyData(
      email: map['email'],
      name: map['name'],
      phone: map['phone'],
      tax: map['tax'],
      career: map['career'],
      address: map['address'],
      description: map['description'],
    );
  }
}
