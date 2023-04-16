import 'dart:async';

import 'package:another_flushbar/flushbar.dart';
import 'package:edirnebenim/Authentication/auth_service.dart';
import 'package:edirnebenim/Authentication/ui/dialog.dart';
import 'package:edirnebenim/Authentication/ui/register.dart';
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

class ResetPasswordScreen extends StatefulWidget {
  @override
  _ResetPasswordScreenState createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final TextEditingController emailController = TextEditingController(text: '');

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
      text: 'Şifremi Sıfırla',
      function: () async {
        if (emailController.text.isEmpty) {
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
        } else {
          if (formCheck(formKey: formKey)) {
            await Future.delayed(const Duration(seconds: 3));
            await AuthService()
                .sendPasswordResetEmail(
              email: emailController.text.replaceAll(' ', ''),
            )
                .then((value) {
              if (value == true) {
                Navigator.of(context).pop();
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Sıfırlama Bağlantısı Gönderildi'),
                    content: const Text(
                      'Şifrenizi sıfırlamanız için e-posta adresinize bir bağlantı gönderdik. Bağlantıya tıklayarak şifrenizi sıfırlayabilirsiniz.',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text('tamam'),
                      )
                    ],
                  ),
                );
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
                'Şifrenizi\nsıfırlayın',
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
              GestureDetector(
                onTap: () {
                  showCustomModelBottomSheet(context, RegisterScreen());
                },
                child: Text(
                  'Giriş Yap',
                  style: regular16pt.copyWith(color: primaryBlue),
                ),
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
