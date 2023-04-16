import 'dart:async';

import 'package:another_flushbar/flushbar.dart';
import 'package:edirnebenim/Authentication/auth_service.dart';
import 'package:edirnebenim/Authentication/ui/dialog.dart';
import 'package:edirnebenim/Authentication/ui/register.dart';
import 'package:edirnebenim/Authentication/ui/reset.dart';
import 'package:edirnebenim/Authentication/widgets/input_field.dart';
import 'package:edirnebenim/Authentication/widgets/primary_button.dart';
import 'package:edirnebenim/Authentication/widgets/theme.dart';
import 'package:edirnebenim/Values/my_user.dart';
import 'package:edirnebenim/locator.dart';
import 'package:edirnebenim/utilities/app_buttons.dart';
import 'package:edirnebenim/utilities/checkform.dart';
import 'package:edirnebenim/utilities/snack_bar.dart';
import 'package:edirnebenim/utilities/valitade.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController(text: '');
  final TextEditingController passwordController =
      TextEditingController(text: '');

  bool passwordVisible = false;
  void togglePassword() {
    setState(() {
      passwordVisible = !passwordVisible;
    });
  }

  final myUser = locator.get<MyUser>();
  @override
  void initState() {
    super.initState();
  }

  final formKey = GlobalKey<FormState>();

  Widget loginButton() {
    return AppButtons.roundedButton(
      borderRadius: BorderRadius.circular(14),
      backgroundColor: primaryBlue,
      text: 'Giriş Yap',
      function: () async {
        if (passwordController.text.isEmpty && emailController.text.isEmpty) {
          unawaited(
            Flushbar(
              duration: const Duration(seconds: 3),
              title: 'Hata Oluştu',
              message: 'Bilgilerinizi giriniz.',
              backgroundColor: Colors.red,
              boxShadows: [
                BoxShadow(
                  color: Colors.red[800]!,
                  offset: const Offset(0, 2),
                  blurRadius: 3,
                )
              ],
            ).show(context),
          );
        } else if (emailController.text.isEmpty) {
          unawaited(
            Flushbar(
              duration: const Duration(seconds: 3),
              title: 'Hata Oluştu',
              message: 'E-postanızı girmelisiniz.',
              backgroundColor: Colors.red,
              boxShadows: [
                BoxShadow(
                  color: Colors.red[800]!,
                  offset: const Offset(0, 2),
                  blurRadius: 3,
                )
              ],
            ).show(context),
          );
        } else if (passwordController.text.isEmpty) {
          unawaited(
            Flushbar(
              duration: const Duration(seconds: 3),
              title: 'Hata Oluştu',
              message: 'Şifrenizi girmelisiniz.',
              backgroundColor: Colors.red,
              boxShadows: [
                BoxShadow(
                  color: Colors.red[800]!,
                  offset: const Offset(0, 2),
                  blurRadius: 3,
                )
              ],
            ).show(context),
          );
        } else {
          if (formCheck(formKey: formKey)) {
            await Future.delayed(const Duration(seconds: 3));
            await AuthService()
                .signIn(
              context: context,
              email: emailController.text.replaceAll(' ', ''),
              password: passwordController.text,
            )
                .then((value) {
              if (AuthService.user != null) {
                Navigator.of(context).pop();
              }
            });
          }
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 40, 24, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Hesabınıza\ngiriş yapın',
                style: heading2.copyWith(color: textBlack),
              ),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
          const SizedBox(
            height: 48,
          ),
          Form(
            key: formKey,
            child: Column(
              children: [
                InputField(
                  hintText: 'E-postanız',
                  suffixIcon: const SizedBox(),
                  controller: emailController,
                ),
                const SizedBox(
                  height: 32,
                ),
                InputField(
                  hintText: 'Şifreniz',
                  controller: passwordController,
                  obscureText: !passwordVisible,
                  suffixIcon: IconButton(
                    color: textGrey,
                    splashRadius: 1,
                    icon: Icon(
                      passwordVisible
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                    ),
                    onPressed: togglePassword,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 32,
          ),
          GestureDetector(
            onTap: () {
              showCustomModelBottomSheet(context, ResetPasswordScreen());
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  'Şifremi Unuttum',
                  textAlign: TextAlign.right,
                  style: regular16pt.copyWith(color: primaryBlue),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 32,
          ),
          loginButton(),
          const SizedBox(
            height: 50,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Hesabınız yok mu? ',
                style: regular16pt.copyWith(color: textGrey),
              ),
              GestureDetector(
                onTap: () {
                  showCustomModelBottomSheet(context, RegisterScreen());
                },
                child: Text(
                  'Kayıt Olun',
                  style: regular16pt.copyWith(color: primaryBlue),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
