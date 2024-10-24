import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:jobapp/models/auth_token.dart';
import 'package:postgres/postgres.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import '../../server/database_connection.dart';

class AuthService {
  static const _authTokenKey = 'authToken';
  static const _isLoggedKey = 'isLoggedIn';
  static final expirationTime =
      DateTime.now().add(const Duration(hours: 1)).millisecondsSinceEpoch;
  static var isLoggedIn = false.obs;

  static Future<bool> isUserLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    print('Trạng thái đăng nhập hiện tại: $isLoggedIn');
    return isLoggedIn;
  }

  static Future<void> _updateLoginStatus(bool newStatus) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isLoggedKey, newStatus);
    isLoggedIn.value = newStatus;
    print('Trạng thái đăng nhập đã được cập nhật: ${isLoggedIn.value}');
  }

  static Future<AuthToken?> register(
      String name, String email, String pass, DateTime creationDate) async {
    final conn = DatabaseConnection().connection;
    try {
      final results = await conn?.execute(Sql.named('''
      SELECT * FROM users WHERE email = @email
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
      INSERT INTO users(name, email, pass, creationDate) VALUES (@name, @email, @pass, @creationDate);
'''), parameters: {
        'name': name,
        'email': email,
        'pass': pass,
        'creationDate': creationDate,
      });

      final userIdResults = await conn?.execute(Sql.named('''
      SELECT id FROM users WHERE email = @email
'''), parameters: {
        'email': email,
      });

      final userId = userIdResults?.single.single as int;
      final authToken = _createAuthToken(userId.toString());
      _saveAuthToken(authToken);
      _updateLoginStatus(true);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('userEmail', email);
      return authToken;
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  static Future<AuthToken?> login(
      String email, String pass, DateTime creationDate) async {
    final conn = DatabaseConnection().connection;
    try {
      final emailResults = await conn?.execute(Sql.named('''
      SELECT email FROM users WHERE email = @email
'''), parameters: {
        'email': email,
      });
      print(emailResults);
      if (emailResults!.isEmpty) {
        Fluttertoast.showToast(
          msg: "địa chỉ email không tồn tại",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
        return null;
      }
      final passResults = await conn?.execute(Sql.named('''
      SELECT pass FROM users WHERE email = @email
'''), parameters: {
        'email': email,
      });
      print(passResults);
      if (pass != passResults?.single.single as String) {
        Fluttertoast.showToast(
          msg: "Mật khẩu không đúng",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
        return null;
      }
      final results = await conn!.execute(Sql.named('''
      SELECT * FROM users WHERE email = @email
'''), parameters: {
        'email': email,
      });
      if (results.isEmpty) {
        return null;
      }
      final userData = results.single;

      final userId = userData.first;
      final authToken = _createAuthToken(userId.toString());
      _saveAuthToken(authToken);
      _updateLoginStatus(true);

      return authToken;
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  static AuthToken _createAuthToken(String userId) {
    final tokenId = const Uuid().v4();
    final expiryDate = DateTime.now().add(const Duration(hours: 1));
    return AuthToken(token: tokenId, userId: userId, expiryDate: expiryDate);
  }

  static Future<void> _saveAuthToken(AuthToken authToken) async {
    final prefs = await SharedPreferences.getInstance();
    final authTokenJson = json.encode(authToken.toJson());
    await prefs.setString(_authTokenKey, authTokenJson);
  }

  static Future<String?> getUserEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('userEmail');
  }

  static Future<void> clearSavedAuthToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_authTokenKey);
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    _updateLoginStatus(false);
    await prefs.remove('userEmail');
    await prefs.remove('userName');
    await clearSavedAuthToken();
    Get.offAllNamed('/login');
  }
}
