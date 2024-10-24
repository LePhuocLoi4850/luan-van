// user_model.dart
class UserModel {
  String name;
  String email;
  int age;

  UserModel(
      {this.name = 'John Doe',
      this.email = 'john.doe@example.com',
      this.age = 25});

  Map<String, dynamic> toJson() => {
        'name': name,
        'email': email,
        'age': age,
      };

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      name: json['name'],
      email: json['email'],
      age: json['age'],
    );
  }
}
