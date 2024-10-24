import 'package:flutter/material.dart';

class MyBase64 extends ChangeNotifier {
  String _base64 = '';
  String get base64 => _base64;
  void updateBase64(String newBase64) {
    _base64 = newBase64;
    notifyListeners();
  }
}
