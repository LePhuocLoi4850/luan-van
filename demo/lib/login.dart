import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'controller.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  void _login() async {
    if (_formKey.currentState!.validate()) {
      String email = _emailController.text;
      String password = _passwordController.text;

      if (email == 'e@.com' && password == '123456') {
        final authController = Get.find<AuthController>(); // Get the controller
        authController.login();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Email hoặc mật khẩu không đúng')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: SizedBox(
          width: 412,
          height: 400,
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Text(
                  'Đăng nhập',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue[800],
                  ),
                ),
                const SizedBox(height: 30),
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.email_outlined,
                      color: Colors.grey[400],
                    ),
                    hintText: 'Email',
                    hintStyle: TextStyle(color: Colors.grey[400]),
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50),
                      borderSide: BorderSide.none,
                    ),
                    errorBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.red, width: 2.0),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.red, width: 2),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    filled: true,
                    fillColor: Colors.blue[50],
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Hãy cho tôi biết email của bạn';
                    } else if (!value.contains('@')) {
                      return 'Email không hợp lệ';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  keyboardType: TextInputType.visiblePassword,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.lock_outline_rounded,
                      color: Colors.grey[400],
                    ),
                    hintText: 'Nhập mật khẩu',
                    hintStyle: TextStyle(color: Colors.grey[400]),
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50),
                      borderSide: BorderSide.none,
                    ),
                    errorBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.red, width: 2.0),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.red, width: 2),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    filled: true,
                    fillColor: Colors.blue[50],
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Mật khẩu không được để trống';
                    } else if (value.length < 6 || value.length > 25) {
                      return 'Mật khẩu hợp lệ từ 6 - 25 ký tự';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 50),
                Container(
                  width: 412,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: TextButton(
                    onPressed: _login,
                    child: const Text(
                      'Đăng nhập',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
