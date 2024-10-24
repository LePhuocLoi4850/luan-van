import 'package:flutter/material.dart';
import 'package:jobapp/models/user_data.dart';

class UserProvider extends ChangeNotifier {
  UserModel? _userModel;

  UserModel? get userModel => _userModel;

  void setUserModel(UserModel userModel) {
    _userModel = userModel;
    notifyListeners();
  }
}
