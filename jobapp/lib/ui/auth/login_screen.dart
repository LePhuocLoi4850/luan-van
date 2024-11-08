import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:jobapp/ui/auth/auth_controller.dart';
import 'package:provider/provider.dart';

import '../../server/database.dart';

// ignore: must_be_immutable
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthController controller = Get.find<AuthController>();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void _login() async {
    if (_formKey.currentState!.validate()) {
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          });

      String email = _emailController.text;
      String pass = _passwordController.text;
      print('qua1');
      try {
        bool isValid = await controller.validateEmailAndPassword(email, pass);
        if (!isValid) {
          Navigator.pop(context);
          return;
        }
        print('qua2');

        final role = await Database().checkForExistingRole(email);

        if (role != 'null') {
          final authLogin = await controller.login(email, pass, role);
          if (authLogin == null) {
            print('Đăng nhập thất bại do chưa cập nhật thông tin');
            if (role == 'user') {
              final name = await Database().selectNameEmail(email);

              if (!mounted) return;
              Navigator.pop(context);
              controller.email = email;
              controller.name = name;
              Get.offAllNamed('updateUser');
            } else if (role == 'company') {
              if (!mounted) return;
              Navigator.pop(context);
              controller.email = email;
              Get.offAllNamed('updateCompany');
            }
          } else {
            if (!mounted) return;
            if (role == 'user') {
              Get.offAllNamed('/homeScreen');
            } else if (role == 'company') {
              Get.offAllNamed('/companyScreen');
            }
          }
        } else {
          print('User chưa chọn role');
          final name = await controller.checkForExistingName(email);

          controller.name = name;
          controller.email = email;
          if (!mounted) return;
          Navigator.pop(context);
          Get.offAllNamed('/chooseRole');
        }
      } catch (e) {
        // Catch any errors and handle them
        print("Error during login: $e");
        Fluttertoast.showToast(
          msg: "An error occurred: ${e.toString()}",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
        if (!mounted) return;
        Navigator.pop(context); // Ensure the dialog is closed
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: FocusScope.of(context).unfocus,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/images/logo.jpg'),
                      fit: BoxFit.fill)),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 220.0, left: 20, right: 20),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    const Text(
                      'Đăng nhập',
                      style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.email_outlined,
                          color: Colors.grey[800],
                        ),
                        hintText: 'Email',
                        hintStyle: TextStyle(
                          color: Colors.grey[600],
                        ),
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide.none,
                        ),
                        errorBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Colors.red, width: 3),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Colors.red, width: 3),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        errorStyle: const TextStyle(
                            fontSize: 16,
                            color: Colors.red,
                            fontWeight: FontWeight.w500),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'hãy cho tôi biết email của bạn';
                        } else if (!value.contains('@')) {
                          return 'email không hợp lệ';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.lock_outline_rounded,
                          color: Colors.grey[800],
                        ),
                        suffixIcon: GestureDetector(
                          onTap: () {
                            context.read<LoginState>().toggleObscureText();
                          },
                          child: Icon(
                            context.watch<LoginState>()._obscureText
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            color: Colors.grey[800],
                          ),
                        ),
                        hintText: 'Nhập mật khẩu',
                        hintStyle: TextStyle(
                          color: Colors.grey[600],
                        ),
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide.none,
                        ),
                        errorBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Colors.red, width: 3),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Colors.red, width: 3),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        errorStyle: const TextStyle(
                            fontSize: 16,
                            color: Colors.red,
                            fontWeight: FontWeight.w500),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      controller: _passwordController,
                      obscureText: context.watch<LoginState>()._obscureText,
                      keyboardType: TextInputType.visiblePassword,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Mật khẩu không được để trống';
                        } else if (value.length < 6 || value.length > 25) {
                          return 'Mật khẩu hợp lệ từ 6 - 25 ký tự';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                      width: 412,
                      height: 50,
                      decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 8, 125, 220),
                          borderRadius: BorderRadius.circular(15)),
                      child: TextButton(
                        onPressed: () {
                          _login();
                        },
                        child: const Text(
                          'Đăng nhập',
                          style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Bạn chưa có tài khoản?  ',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w500),
                        ),
                        TextButton(
                          style: ButtonStyle(
                              backgroundColor: WidgetStateProperty.all<Color>(
                                  const Color.fromARGB(255, 8, 109, 192)),
                              shape: WidgetStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                              )),
                          onPressed: () {
                            Get.toNamed('/register');
                          },
                          child: const Text(
                            'Đăng ký ngay',
                            style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LoginState extends ChangeNotifier {
  bool _obscureText = true;

  bool get obscureText => _obscureText;

  void toggleObscureText() {
    _obscureText = !_obscureText;
    notifyListeners();
  }
}
 // void _login() async {
  //   if (_formKey.currentState!.validate()) {
  //     showDialog(
  //         context: context,
  //         barrierDismissible: false,
  //         builder: (context) {
  //           return const Center(
  //             child: CircularProgressIndicator(),
  //           );
  //         });
  //     String email = _emailController.text;
  //     String pass = _passwordController.text;
  //     final role = await Database().checkForExistingRole(email);
  //     // String roleText = role.first.first.toString();
  //     String roleText = role.isNotEmpty && role.first.isNotEmpty
  //         ? role.first.first.toString()
  //         : '';
  //     print(roleText);

  //     try {
  //       if (roleText.isNotEmpty) {
  //         final authLogin = await controller.login(email, pass, roleText);
  //         if (authLogin == null) {
  //           if (!mounted) return;
  //           Navigator.pop(context);
  //         } else {
  //           if (!mounted) return;
  //           if (roleText == 'user') {
  //             Get.offAllNamed('/homeUV');
  //           } else if (roleText == 'company') {
  //             Get.offAllNamed('/homeNTD');
  //           }
  //         }
  //       } else {
  //         if (!mounted) return;
  //         Navigator.pop(context);
  //         Get.offAllNamed('/chooseRole');
  //       }
  //     } catch (e) {
  //       print(e);
  //     }
  //   }
  // }