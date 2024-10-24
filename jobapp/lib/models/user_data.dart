class UserModel {
  final int? id;
  final String? name;
  final String? email;
  final String? career;
  final String? phone;
  final String? gender;
  final DateTime? birthday;
  final String? address;
  final String? description;
  final int? salaryFrom;
  final int? salaryTo;
  final String? image;
  final String? experience;
  final DateTime? createdAt;

  UserModel({
    this.id,
    this.name,
    this.email,
    this.career,
    this.phone,
    this.gender,
    this.birthday,
    this.address,
    this.description,
    this.salaryFrom,
    this.salaryTo,
    this.image,
    this.experience,
    this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'career': career,
      'phone': phone,
      'gender': gender,
      'birthday': birthday!.toIso8601String(),
      'address': address,
      'description': description,
      'salary_from': salaryFrom,
      'salary_to': salaryTo,
      'image': image,
      'experiences': experience,
      'created_at': createdAt!.toIso8601String(),
    };
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      career: json['career'],
      phone: json['phone'],
      gender: json['gender'],
      birthday: DateTime.parse(json['birthday']),
      address: json['address'],
      description: json['description'],
      salaryFrom: json['salary_from'],
      salaryTo: json['salary_to'],
      image: json['image'],
      experience: json['experiences'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  UserModel copyWith({
    int? id,
    String? name,
    String? email,
    String? career,
    String? phone,
    String? gender,
    DateTime? birthday,
    String? address,
    String? description,
    int? salaryFrom,
    int? salaryTo,
    String? image,
    String? experience,
    DateTime? createdAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      career: career ?? this.career,
      phone: phone ?? this.phone,
      gender: gender ?? this.gender,
      birthday: birthday ?? this.birthday,
      address: address ?? this.address,
      description: description ?? this.description,
      salaryFrom: salaryFrom ?? this.salaryFrom,
      salaryTo: salaryTo ?? this.salaryTo,
      image: image ?? this.image,
      experience: experience ?? this.experience,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  String toString() {
    return 'UserModel{id: $id, name: $name, email: $email, career: $career, phone: $phone, gender: $gender, birthday: $birthday, address: $address, description: $description, salaryFrom: $salaryFrom, salaryTo: $salaryTo, image: $image, experience: $experience, createdAt: $createdAt}';
  }
}
