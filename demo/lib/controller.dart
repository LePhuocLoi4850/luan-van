import 'dart:convert';

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'auth_server.dart';
import './model.dart';

class AuthController extends GetxController {
  var isLoggedIn = false.obs; // Use an observable boolean for isLoggedIn
  var userModel = UserModel().obs; // Sử dụng constructor mặc định

  // Hàm update userModel với thông tin mới
  void updateUser(UserModel newUser) {
    userModel.value = newUser; // Thay thế model hiện tại bằng model mới
    saveUserToLocal(); // Lưu thông tin vào máy
  }

  // Lưu thông tin user vào SharedPreferences
  Future<void> saveUserToLocal() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('user', jsonEncode(userModel.value.toJson()));
  }

  // Tải thông tin user từ SharedPreferences
  Future<void> loadUserFromLocal() async {
    final prefs = await SharedPreferences.getInstance();
    String? userData = prefs.getString('user');
    if (userData != null) {
      userModel.value = UserModel.fromJson(jsonDecode(userData));
    }
  }

  Future<void> checkLoginStatus() async {
    final isLoggedIn = await AuthService.isUserLoggedIn();
    this.isLoggedIn.value = isLoggedIn; // Update the observable
  }

  void login() async {
    await AuthService.login();
    isLoggedIn.value = true; // Update login status and trigger navigation
  }

  void logout() async {
    await AuthService.logout();
    isLoggedIn.value = false; // Update login status and trigger navigation
  }

  @override
  void onInit() {
    loadUserFromLocal(); // Tải dữ liệu khi khởi động controller
    super.onInit();
  }
}
