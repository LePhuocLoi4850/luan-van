class UserData {
  final String email;
  final String name;
  final String phone;
  final String birthday;
  final String gender;
  final String career;
  final String address;
  final String description;

  UserData({
    required this.email,
    required this.name,
    required this.phone,
    required this.birthday,
    required this.gender,
    required this.career,
    required this.address,
    required this.description,
  });

  factory UserData.fromMap(Map<String, dynamic> map) {
    return UserData(
      email: map['email'],
      name: map['name'],
      phone: map['phone'].toString(),
      birthday: map['birthday'],
      gender: map['gender'],
      career: map['career'],
      address: map['address'],
      description: map['description'],
    );
  }
  UserData copyWith({
    String? email,
    String? name,
    String? phone,
    String? birthday,
    String? gender,
    String? career,
    String? address,
    String? description,
  }) {
    return UserData(
      email: email ?? this.email,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      birthday: birthday ?? this.birthday,
      gender: gender ?? this.gender,
      career: career ?? this.career,
      address: address ?? this.address,
      description: description ?? this.description,
    );
  }
}
