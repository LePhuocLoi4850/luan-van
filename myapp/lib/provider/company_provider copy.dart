// ignore_for_file: file_name, file_names
import 'package:flutter/material.dart';
import '../models/company.dart';

class CompanyProvider with ChangeNotifier {
  CompanyData? _companyData;
  String? _email;
  String? _role;

  CompanyData? get companyData => _companyData;
  String? get email => _email;
  String? get role => _role;

  void setCompany(String email, String role) {
    _email = email;
    _role = role;
    notifyListeners();
  }

  void setCompanyData(CompanyData companyData) {
    _companyData = companyData;
    notifyListeners();
  }

  void clearCompany() {
    _companyData = null;
    notifyListeners();
  }
}
