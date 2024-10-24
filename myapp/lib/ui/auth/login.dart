import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/company.dart';
import '../../provider/company_provider copy.dart';
import '../../ui/screens.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  Future<void> _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          });
      final email = _emailController.text;
      final password = _passwordController.text;

      final isEmailAvailable =
          await DatabaseConnection().checkForExistingEmail(email);
      final isPasswordAvailable =
          await DatabaseConnection().checkForExistingPassword(email);
      final isRoleAvailable =
          await DatabaseConnection().checkForExistingRole(email);
      if (!mounted) return;
      if (!isEmailAvailable!) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Tài khoản không tồn tại'),
            backgroundColor: Colors.red,
          ),
        );
        return Navigator.of(context).pop();
      }

      String passwordText = isPasswordAvailable.first.first.toString();
      String roleText = isRoleAvailable.first.first.toString();

      if (passwordText != password) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Mật khẩu không đúng'),
            backgroundColor: Colors.red,
          ),
        );
        return Navigator.of(context).pop();
      }

      try {
        await DatabaseConnection().login(email, password);
        print('login thành công');
        print(roleText);
        if (roleText == 'user') {
          final userDataList =
              await DatabaseConnection().getUserDataByEmail(email);
          print(userDataList);
          String formattedBirthday =
              DateFormat('yyyy-MM-dd').format(userDataList[0][2]);
          final userDataMap = {
            'email': email,
            'name': userDataList[0][0],
            'phone': int.parse(userDataList[0][1]),
            'birthday': formattedBirthday,
            'career': userDataList[0][4],
            'gender': userDataList[0][3],
            'address': userDataList[0][5],
            'description': userDataList[0][6],
          };
          final userData = UserData.fromMap(userDataMap);
          if (!mounted) return;
          final userProvider =
              Provider.of<UserProvider>(context, listen: false);
          userProvider.setUserData(userData);
          userProvider.setUser(email, roleText);
          Navigator.pop(context);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const UserScreen()),
          );
        } else if (roleText == 'company') {
          final companyDataList =
              await DatabaseConnection().getCompanyDataByEmail(email);
          print(companyDataList);
          final companyDataMap = companyDataList[0][0] != null
              ? {
                  'email': email,
                  'name': companyDataList[0][0],
                  'phone': int.parse(companyDataList[0][1]),
                  'tax': companyDataList[0][2],
                  'career': companyDataList[0][3],
                  'address': companyDataList[0][4],
                  'description': companyDataList[0][5],
                }
              : {
                  'email': email,
                  'name': '',
                  'phone': 0,
                  'tax': '',
                  'career': '',
                  'address': '',
                  'description': '',
                };
          final companyData = CompanyData.fromMap(companyDataMap);
          if (!mounted) return;
          final companyProvider =
              Provider.of<CompanyProvider>(context, listen: false);
          companyProvider.setCompanyData(companyData);
          companyProvider.setCompany(email, roleText);
          Navigator.pop(context);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const CompanyScreen()),
          );
        } else {
          print('lỗi đăng nhập xin thử lại');
        }
      } catch (e) {
        return;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 00, right: 00, top: 200),
      height: 800,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey, width: 1),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(50),
          topRight: Radius.circular(50),
        ),
      ),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              const Padding(
                padding: EdgeInsets.all(30.0),
                child: Text(
                  'Login',
                  style: TextStyle(
                      fontSize: 34,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue),
                ),
              ),
              Padding(
                  padding: const EdgeInsets.only(
                      left: 40.0, right: 40, top: 10, bottom: 10),
                  child: TextFormField(
                    decoration: InputDecoration(
                      labelText: 'E-Mail',
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 20, horizontal: 30),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: const BorderSide(
                          color: Colors.grey,
                          width: 2,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: const BorderSide(
                          color: Colors.blue,
                          width: 2,
                        ),
                      ),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    controller: _emailController,
                    validator: (value) {
                      if (value!.isEmpty || !value.contains('@')) {
                        return 'Invalid email!';
                      }
                      return null;
                    },
                  )),
              Padding(
                  padding: const EdgeInsets.only(
                      left: 40.0, right: 40, top: 10, bottom: 10),
                  child: TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Password',
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 20, horizontal: 30),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: const BorderSide(
                          color: Colors.grey,
                          width: 2,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: const BorderSide(
                          color: Colors.blue,
                          width: 2,
                        ),
                      ),
                    ),
                    obscureText: true,
                    keyboardType: TextInputType.visiblePassword,
                    controller: _passwordController,
                    validator: (value) {
                      if (value == null || value.length < 6) {
                        return 'mật khẩu ít nhất 6 chữ số';
                      }
                      return null;
                    },
                  )),
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: SizedBox(
                  width: 330,
                  height: 55,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      backgroundColor: Colors.blue,
                      textStyle: TextStyle(
                        color: Theme.of(context)
                            .primaryTextTheme
                            .titleLarge
                            ?.color,
                      ),
                    ),
                    onPressed: () async {
                      await _handleLogin();
                    },
                    child: const Text(
                      'LOGIN',
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 18),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Don\'t have an Account?'),
                    TextButton(
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 0.0, vertical: 3),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        textStyle: const TextStyle(
                          color: Colors.amber,
                        ),
                      ),
                      onPressed: () async {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const AuthScreen1()));
                      },
                      child: const Text(
                        'SIGNUP',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                            fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
