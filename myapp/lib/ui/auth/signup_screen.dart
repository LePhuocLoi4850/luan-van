import 'package:flutter/material.dart';
import '../../ui/screens.dart';

class AuthScreen1 extends StatelessWidget {
  const AuthScreen1({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/background.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SignUpScreen(),
        ],
      ),
    );
  }
}
