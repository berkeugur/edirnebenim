import 'package:edirnebenim/Authentication/reset_password.dart';
import 'package:edirnebenim/Authentication/sign_in_screen.dart';
import 'package:edirnebenim/Authentication/sign_up_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute<LoginPage>(
                  fullscreenDialog: true,
                  builder: (context) => const LoginPage(),
                ),
              );
            },
            child: const Text('Giriş Yap'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute<RegisterPage>(
                  fullscreenDialog: true,
                  builder: (context) => const RegisterPage(),
                ),
              );
            },
            child: const Text('Kayıt ol'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute<ResetPasswordPage>(
                  fullscreenDialog: true,
                  builder: (context) => const ResetPasswordPage(),
                ),
              );
            },
            child: const Text('Şifremi unuttum'),
          ),
        ],
      ),
    );
  }
}
