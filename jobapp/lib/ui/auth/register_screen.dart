import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobapp/ui/auth/auth_controller.dart';
import 'package:provider/provider.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  AuthController controller = Get.find<AuthController>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void _register() async {
    if (_formKey.currentState!.validate()) {
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          });
      String name = _nameController.text;
      String email = _emailController.text;
      String pass = _passwordController.text;
      try {
        final authRegister = await controller.register(name, email, pass);
        if (authRegister != null) {
          if (!mounted) return;
          Navigator.pop(context);
          Get.offAllNamed('/chooseRole');
        } else {
          if (!mounted) return;
          Navigator.pop(context);
        }
      } catch (e) {
        print(e);
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
                      'Đăng ký',
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
                          Icons.perm_identity_outlined,
                          color: Colors.grey[800],
                        ),
                        hintText: 'Họ và tên',
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
                      controller: _nameController,
                      keyboardType: TextInputType.name,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Hãy cho tôi biết họ và tên của bạn';
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
                            context.read<RegisterState>().toggleObscureText();
                          },
                          child: Icon(
                            context.watch<RegisterState>()._obscureText
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            color: Colors.grey[800],
                          ),
                        ),
                        hintText: 'Mật khẩu',
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
                      obscureText: context.watch<RegisterState>()._obscureText,
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
                    TextFormField(
                      decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.lock_outline_rounded,
                          color: Colors.grey[800],
                        ),
                        suffixIcon: GestureDetector(
                          onTap: () {
                            context
                                .read<RegisterState>()
                                .toggleObscureTextConfirm();
                          },
                          child: Icon(
                            context.watch<RegisterState>()._obscureTextConfirm
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            color: Colors.grey[800],
                          ),
                        ),
                        hintText: 'Nhập lại mật khẩu',
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
                      obscureText:
                          context.watch<RegisterState>()._obscureTextConfirm,
                      keyboardType: TextInputType.visiblePassword,
                      validator: (value) {
                        if (value!.isEmpty ||
                            value != _passwordController.text) {
                          return 'mật khẩu không trùng khớp';
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
                          _register();
                        },
                        child: const Text(
                          'Đăng ký',
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
                          'Bạn đã có tài khoản?  ',
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
                            Get.back();
                          },
                          child: const Text(
                            'Đăng nhập ngay',
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

class RegisterState extends ChangeNotifier {
  bool _obscureText = true;
  bool _obscureTextConfirm = true;

  bool get obscureText => _obscureText;
  bool get obscureTextConfirm => _obscureTextConfirm;

  void toggleObscureText() {
    _obscureText = !_obscureText;
    notifyListeners();
  }

  void toggleObscureTextConfirm() {
    _obscureTextConfirm = !_obscureTextConfirm;
    notifyListeners();
  }
}
