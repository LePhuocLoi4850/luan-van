import 'package:flutter/material.dart';
import '../../ui/screens.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen>
    with TickerProviderStateMixin {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  late TabController _tabController;
  final _formKey = GlobalKey<FormState>();
  late String _role;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _handleSignUp() async {
    if (_formKey.currentState!.validate()) {
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          });

      String role;
      final email = _emailController.text;
      final password = _passwordController.text;
      final isEmailAvailable =
          await DatabaseConnection().checkForExistingEmail(email);

      if (_tabController.index == 0) {
        role = 'user';
      } else {
        role = 'company';
      }

      if (!mounted) return;
      if (isEmailAvailable!) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Tài khoản đã tồn tại, hãy nhập email khác'),
            backgroundColor: Colors.red,
            duration: Duration(milliseconds: 1500),
          ),
        );
        return Navigator.of(context).pop();
      }

      try {
        await DatabaseConnection().signUp(context, email, password, role);
        if (role == 'user') {
          if (!mounted) return;
          final userProvider =
              Provider.of<UserProvider>(context, listen: false);
          userProvider.setUser(email, role);
          await DatabaseConnection().addUserData(email, role);
          if (!mounted) return;
          Navigator.pop(context);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const UpdateUser()),
          );
        } else {
          if (!mounted) return;
          final companyProvider =
              Provider.of<CompanyProvider>(context, listen: false);

          companyProvider.setCompany(email, role);

          await DatabaseConnection().addCompanyData(email, role);
          if (!mounted) return;
          Navigator.pop(context);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const UpdateCompany()),
          );
        }
        return;
      } catch (e) {
        return;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 0, right: 0, top: 200),
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
                  'SignUp',
                  style: TextStyle(
                      fontSize: 34,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 30, right: 30.0),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: TabBar(
                    indicatorSize: TabBarIndicatorSize.tab,
                    indicator: BoxDecoration(
                      color: const Color.fromARGB(255, 173, 211, 242),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    controller: _tabController,
                    tabs: const [
                      Tab(text: 'Tài khoản ứng viên'),
                      Tab(text: 'Tài khoản tuyển dụng')
                    ],
                    onTap: (index) {
                      setState(() {
                        if (_tabController.index == 0) {
                          _role = 'user';
                          print(_role);
                        } else if (_tabController.index == 1) {
                          _role = 'company';
                          print(_role);
                        }
                      });
                    },
                  ),
                ),
              ),
              Padding(
                  padding: const EdgeInsets.only(
                      left: 40, right: 40, top: 20, bottom: 10),
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
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 40.0, right: 40, top: 10, bottom: 10),
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText: 'ConfirmPassword',
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
                  keyboardType: TextInputType.visiblePassword,
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value != _passwordController.text) {
                      return 'mật khẩu không khớp';
                    }
                    return null;
                  },
                ),
              ),
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
                      await _handleSignUp();
                    },
                    child: const Text(
                      'SIGNUP',
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
                    const Text('Already have an Account?'),
                    TextButton(
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 0.0, vertical: 3),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        textStyle: const TextStyle(
                          color: Colors.amber,
                        ),
                      ),
                      onPressed: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const AuthScreen()));
                      },
                      child: const Text(
                        'LOGIN',
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
