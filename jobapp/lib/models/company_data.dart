class CompanyModel {
  final int? id;
  final String? name;
  final String? email;
  final String? career;
  final String? phone;
  final String? address;
  final String? scale;
  final String? description;
  final String? image;
  final DateTime? createdAt;

  CompanyModel({
    this.id,
    this.name,
    this.email,
    this.career,
    this.phone,
    this.address,
    this.scale,
    this.description,
    this.image,
    this.createdAt,
  });

  // Chuyển đổi đối tượng thành JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'career': career,
      'phone': phone,
      'address': address,
      'scale': scale,
      'description': description,
      'image': image,
      'created_at': createdAt?.toIso8601String(),
    };
  }

  // Tạo đối tượng từ JSON
  factory CompanyModel.fromJson(Map<String, dynamic> json) {
    return CompanyModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      career: json['career'],
      phone: json['phone'],
      address: json['address'],
      scale: json['scale'],
      description: json['description'],
      image: json['image'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }
  @override
  String toString() {
    return 'CompanyModel{id: $id, name: $name, email: $email, career: $career, phone: $phone, address: $address, scale: $scale, description: $description, image: $image, createdAt: $createdAt}';
  }

  // Copy method để tạo đối tượng mới với các giá trị có thể thay đổi
  CompanyModel copyWith({
    int? id,
    String? name,
    String? email,
    String? career,
    String? phone,
    String? address,
    String? scale,
    String? description,
    String? image,
    DateTime? createdAt,
  }) {
    return CompanyModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      career: career ?? this.career,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      scale: scale ?? this.scale,
      description: description ?? this.description,
      image: image ?? this.image,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
