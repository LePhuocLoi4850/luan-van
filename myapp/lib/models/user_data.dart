class User {
  final String name;
  final String phone;
  final DateTime birthday;
  final String gender;
  final String career;
  final String address;
  final String description;

  User({
    required this.name,
    required this.phone,
    required this.birthday,
    required this.gender,
    required this.career,
    required this.address,
    required this.description,
  });

  // Constructor from Map (từ kết quả truy vấn database)
  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      name: map['name'] ?? '',
      phone: map['phone'] ?? '',
      birthday: map['birthday'] is DateTime
          ? map['birthday']
          : DateTime.now(), // Xử lý trường hợp birthday null
      gender: map['gender'] ?? '',
      career: map['career'] ?? '',
      address: map['address'] ?? '',
      description: map['description'] ?? '',
    );
  }
}
