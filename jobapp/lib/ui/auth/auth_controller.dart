import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:jobapp/server/database.dart';
import 'package:postgres/postgres.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import '../../models/auth_token.dart';
import '../../models/user_data.dart';
import '../../models/company_data.dart';
import '../../server/database_connection.dart';

class AuthController extends GetxController {
  var isLoggedIn = false.obs;
  var isLoading = false.obs;
  String? email;
  String? name;
  String? role;
  String? base64;
  var userModel = UserModel().obs;
  var companyModel = CompanyModel().obs;
  var showError = false.obs;
  final _authTokenKey = 'authToken';

  Future<void> _saveLoginStatus(bool isLoggedIn) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('loginStatus', isLoggedIn);
  }

  Future<void> saveAdminLoginStatus(bool isLoggedIn) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('loginStatus', isLoggedIn);
  }

  Future<void> loadSaveLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final loginStatus = prefs.getBool('loginStatus') ?? false;
    isLoggedIn.value = loginStatus;

    if (loginStatus) {
      role = prefs.getString('userRole');

      if (role == 'user') {
        final userJson = prefs.getString('userData');
        if (userJson != null) {
          final userMap = jsonDecode(userJson);
          userModel.value = UserModel.fromJson(userMap);
        }
      } else if (role == 'company') {
        final companyJson = prefs.getString('companyData');
        if (companyJson != null) {
          final companyMap = jsonDecode(companyJson);
          companyModel.value = CompanyModel.fromJson(companyMap);
        }
      } else if (role == 'admin') {
        print('admin');
      }
    }
    isLoading.value = false;
  }

  Future<void> saveUserData(UserModel user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('userData');
    final userJson = user.toJson();
    await prefs.setString('userData', jsonEncode(userJson));
  }

  Future<void> saveCompanyData(CompanyModel company) async {
    final prefs = await SharedPreferences.getInstance();

    // Xóa dữ liệu 'companyData' cũ
    await prefs.remove('companyData');

    final companyJson = company.toJson();

    await prefs.setString('companyData', jsonEncode(companyJson));
  }

  Future<AuthToken?> login(String email, String pass, String roleText) async {
    final conn = DatabaseConnection().connection;
    try {
      if (roleText == 'user') {
        final results = await conn!.execute(Sql.named('''
      SELECT * FROM users WHERE email = @email
'''), parameters: {
          'email': email,
        });
        if (results.isEmpty) {
          print('select user thất bại');
          return null;
        }
        final userData = results.single;
        final userId = int.parse(userData.first.toString());
        final authToken = _createAuthToken(userId.toString());
        print('qua 5');

        userModel.value = UserModel(
          id: userId,
          name: userData[2].toString(),
          email: userData[1].toString(),
          career: userData[3].toString(),
          phone: userData[4].toString(),
          gender: userData[5].toString(),
          birthday: DateTime.parse(userData[6].toString()),
          address: userData[7].toString(),
          description: userData[8].toString(),
          salaryFrom: int.parse(userData[9].toString()),
          salaryTo: int.parse(userData[10].toString()),
          image: userData[11].toString(),
          experience: userData[12].toString(),
          createdAt: DateTime.parse(userData[13].toString()),
        );

        print('qua 6');

        _saveAuthToken(authToken);
        saveUserData(userModel.value);
        _saveRole('user');
        _saveLoginStatus(true);
        isLoggedIn.value = true;
        return authToken;
      } else {
        final results = await conn!.execute(Sql.named('''
      SELECT * FROM company WHERE email = @email
'''), parameters: {
          'email': email,
        });
        print('Company query results: $results');
        if (results.isEmpty) {
          print('company chưa cập nhật thông tin');
          return null;
        }
        final companyData = results.single;
        final companyId = int.parse(companyData.first.toString());
        final authToken = _createAuthToken(companyId.toString());

        companyModel.value = CompanyModel(
          id: companyId,
          name: companyData[1].toString(),
          email: companyData[2].toString(),
          career: companyData[3].toString(),
          phone: companyData[4].toString(),
          address: companyData[5].toString(),
          scale: companyData[6].toString(),
          description: companyData[7].toString(),
          image: companyData[8].toString(),
          createdAt: DateTime.parse(companyData[9].toString()),
        );

        _saveAuthToken(authToken);
        saveCompanyData(companyModel.value);
        _saveRole('company');
        _saveLoginStatus(true);
        isLoggedIn.value = true;
        return authToken;
      }
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<bool> validateEmailAndPassword(String email, String pass) async {
    final conn = DatabaseConnection().connection;

    try {
      final result = await conn?.execute(Sql.named('''
      SELECT pass FROM auth WHERE email = @email
    '''), parameters: {
        'email': email,
      });

      if (result == null || result.isEmpty) {
        Fluttertoast.showToast(
          msg: "Địa chỉ email không tồn tại",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
        return false;
      }

      final storedPass = result.single.single as String;

      if (pass != storedPass) {
        Fluttertoast.showToast(
          msg: "Mật khẩu không đúng",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
        return false;
      }

      return true;
    } catch (e) {
      print("Lỗi khi xác thực email và mật khẩu: $e");
      Fluttertoast.showToast(
        msg: "Đã xảy ra lỗi: ${e.toString()}",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      return false;
    }
  }

  Future<AuthToken?> register(String name, String email, String pass) async {
    final conn = DatabaseConnection().connection;
    try {
      final results = await conn?.execute(Sql.named('''
      SELECT * FROM auth WHERE email = @email
'''), parameters: {
        'email': email,
      });
      if (results!.isNotEmpty) {
        Fluttertoast.showToast(
          msg: "email người dùng đã tồn tại",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
        return null;
      }

      await conn?.execute(Sql.named('''
      INSERT INTO auth (name, email, pass) VALUES (@name, @email, @pass);
'''), parameters: {
        'name': name,
        'email': email,
        'pass': pass,
      });

      final userIdResults = await conn?.execute(Sql.named('''
      SELECT auth_id FROM auth WHERE email = @email
'''), parameters: {
        'email': email,
      });

      final userId = userIdResults?.single.single as int;
      final authToken = _createAuthToken(userId.toString());
      _saveAuthToken(authToken);
      this.email = email;
      this.name = name;
      _saveLoginStatus(true);
      isLoggedIn.value = true;
      return authToken;
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<void> chooseRole(String role, String email) async {
    final conn = DatabaseConnection().connection;
    try {
      await conn?.execute(Sql.named('''
      UPDATE auth SET role = @role WHERE email = @email;
    '''), parameters: {
        'role': role,
        'email': email,
      });
      print('Role updated successfully');
      _saveRole(role);
      Get.offAllNamed(role == 'user' ? '/updateUser' : '/updateCompany');
    } catch (e) {
      print(e);
      return;
    }
  }

  Future<dynamic> checkForExistingName(String email) async {
    final conn = DatabaseConnection().connection;
    try {
      final result = await conn?.execute(Sql.named('''
        SELECT name FROM auth WHERE email = @email
      '''), parameters: {'email': email});
      return result?.first[0].toString();
    } catch (e) {
      print('Error checking for existing email: $e');
      return;
    }
  }

  Future<dynamic> checkForExistingRole(String email) async {
    final conn = DatabaseConnection().connection;
    try {
      final result = await conn?.execute(Sql.named('''
        SELECT role FROM auth WHERE email = @email
      '''), parameters: {'email': email});
      return result!.first[0].toString();
    } catch (e) {
      print('Error checking for existing email: $e');
      return;
    }
  }

  Future<void> updateUserData(
    String email,
    String name,
    String career,
    int phone,
    DateTime birthday,
    String gender,
    String address,
    String description,
    String image,
    DateTime createdAt,
  ) async {
    final conn = DatabaseConnection().connection;
    try {
      await conn?.execute(
        Sql.named(
            'INSERT INTO users (email, name, career, phone, birthday, gender, address, description, image, created_at) '
            'VALUES (@email, @name, @career, @phone, @birthday, @gender, @address, @description, @image, @created_at)'),
        parameters: {
          'email': email,
          'name': name,
          'created_at': createdAt,
          'career': career,
          'phone': phone,
          'birthday': birthday,
          'gender': gender,
          'address': address,
          'description': description,
          'image': image,
        },
      );

      print('Thêm thông tin user thành công');
      int id = await Database().selectIdUserForEmail(email);
      await conn!.execute(Sql.named('''
      INSERT INTO mycv (uid,namecv,time) VALUES (@uid,@namecv,@time)
'''), parameters: {'uid': id, 'namecv': name, 'time': DateTime.now()});
      userModel.value = UserModel(
        id: id,
        name: name,
        email: email,
        career: career,
        phone: phone.toString(),
        gender: gender,
        birthday: birthday,
        address: address,
        description: description,
        salaryFrom: 0,
        salaryTo: 0,
        image: image,
        experience: 'update',
        createdAt: createdAt,
      );

      saveUserData(userModel.value);

      Get.offAllNamed('/homeScreen');
    } catch (e) {
      print('Lỗi khi thêm dữ liệu: $e');
      Get.snackbar(
        'Lỗi cập nhật',
        'Không thể cập nhật thông tin. Vui lòng thử lại sau.',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> updateCompanyData(
      String name,
      String email,
      String career,
      int phone,
      String address,
      String scale,
      String description,
      String image) async {
    final conn = DatabaseConnection().connection;
    try {
      await conn?.execute(
        Sql.named(
            'INSERT INTO company (name, email, career, phone, address, scale, description, image) '
            'VALUES (@name, @email, @career, @phone, @address, @scale, @description, @image)'),
        parameters: {
          'name': name,
          'email': email,
          'career': career,
          'phone': phone,
          'address': address,
          'scale': scale,
          'description': description,
          'image': image,
        },
      );

      print('Thêm thông tin company thành công');
      int id = await Database().selectIdCompanyForEmail(email);
      companyModel.value = CompanyModel(
          id: id,
          name: name,
          email: email,
          career: career,
          phone: phone.toString(),
          address: address,
          scale: scale,
          description: description,
          image: image,
          createdAt: DateTime.now());

      saveCompanyData(companyModel.value);

      Get.offAllNamed('/companyScreen');
    } catch (e) {
      print('Lỗi khi thêm dữ liệu: $e');
      Get.snackbar(
        'Lỗi cập nhật',
        'Không thể cập nhật thông tin. Vui lòng thử lại sau.',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  AuthToken _createAuthToken(String userId) {
    final tokenId = const Uuid().v4();
    final expiryDate = DateTime.now().add(const Duration(hours: 1));
    return AuthToken(token: tokenId, userId: userId, expiryDate: expiryDate);
  }

  Future<void> _saveAuthToken(AuthToken authToken) async {
    final prefs = await SharedPreferences.getInstance();
    final authTokenJson = json.encode(authToken.toJson());
    await prefs.setString(_authTokenKey, authTokenJson);
  }

  Future<void> _saveRole(String role) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userRole', role);
  }

  Future<void> saveRoleAdmin(String role) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userRole', role);
  }

  Future<void> clearSavedAuthToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_authTokenKey);
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('userRole');
    await prefs.remove('userData');
    await prefs.remove('companyData');
    await clearSavedAuthToken();
    _saveLoginStatus(false);

    isLoggedIn.value = false;
    email = null;
    name = null;
    role = null;

    update();
    Get.offAllNamed('/login');
  }
}
  // Future<void> saveEmail(String email, String name, String role) async {
  //   final prefs = await SharedPreferences.getInstance();
  //   await prefs.setString('userEmail', email);
  //   await prefs.setString('userName', name);
  //   await prefs.setString('userRole', role);
  // }

  // Future<void> _saveData(String base64) async {
  //   final prefs = await SharedPreferences.getInstance();
  //   await prefs.setString('user', base64);
  // }