import 'package:flutter/material.dart';
import 'package:myapp/database/database.dart';

import '../models/user.dart';

class UserProvider with ChangeNotifier {
  UserData? _userData;
  String? _email;
  String? _role;
  UserData? get userData => _userData;
  String? get email => _email;
  String? get role => _role;

  void setUser(String email, String role) {
    _email = email;
    _role = role;
    notifyListeners();
  }

  void setUserData(UserData userData) {
    _userData = userData;
    notifyListeners();
  }

  void updateUserData(UserData newUserData) {
    _userData = newUserData;
    final name = newUserData.name;
    final int? phone = int.tryParse(newUserData.phone);
    final birthday = newUserData.birthday;
    DatabaseConnection().updateUserData(
        newUserData.email,
        name,
        phone!,
        birthday,
        newUserData.gender,
        newUserData.career,
        newUserData.address,
        newUserData.description);
    notifyListeners();
  }

  void clearUser() {
    _userData = null;
    notifyListeners();
  }
}
// class UserProvider with ChangeNotifier {
//   String? _email;
//   String? _role;
//   String? _name;
//   String? _phone;
//   String? _birthday;
//   String? _career;
//   String? _gender;
//   String? _address;
//   String? _description;

//   String? get email => _email;
//   String? get role => _role;
//   String? get name => _name;
//   String? get phone => _phone;
//   String? get birthday => _birthday;
//   String? get career => _career;
//   String? get gender => _gender;
//   String? get address => _address;
//   String? get description => _description;

//   void setUser(
//     String email,
//     String name,
//     String career,
//   ) {
//     _email = email;
//     _name = name;
//     _career = career;
//     notifyListeners();
//   }

//   void setUserData(String email, String name, String phone, String birthday,
//       String career, String gender, String address, String description) {
//     _email = email;
//     _name = name;
//     _phone = phone;
//     _birthday = birthday;
//     _career = career;
//     _gender = gender;
//     _address = address;
//     _description = description;
//     notifyListeners();
//   }

//   void clearUser() {
//     _email = null;
//     _role = null;
//     _name = null;
//     _phone = null;
//     _birthday = null;
//     _gender = null;
//     _address = null;
//     _description = null;
//     notifyListeners();
//   }
// }
