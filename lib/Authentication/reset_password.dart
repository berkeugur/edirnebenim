// ignore_for_file: lines_longer_than_80_chars

import 'package:edirnebenim/Authentication/auth_service.dart';
import 'package:edirnebenim/utilities/app_buttons.dart';
import 'package:edirnebenim/utilities/checkform.dart';
import 'package:edirnebenim/utilities/snack_bar.dart';
import 'package:edirnebenim/utilities/valitade.dart';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({super.key});

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

TextEditingController emailController = TextEditingController();

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  late String email;
  final formKey = GlobalKey<FormState>();
  ValueNotifier<bool> isLoading = ValueNotifier(false);
  Widget resetPasswordButton() {
    final isResetPasswordLoading = ValueNotifier<bool>(false);
    return ValueListenableBuilder(
      valueListenable: isResetPasswordLoading,
      builder: (context, value, y) {
        if (isResetPasswordLoading.value == true) {
          return AppButtons.roundedButton(isLoadingButton: true);
        } else {
          return AppButtons.roundedButton(
            function: () async {
              if (formCheck(formKey: formKey)) {
                isResetPasswordLoading.value = true;
                await AuthService()
                    .sendPasswordResetEmail(
                        email: email.trim().replaceAll(' ', ''))
                    .then(
                  (value) {
                    isLoading.value = true;

                    isResetPasswordLoading.value = false;
                    context.snackbar(
                        'Şifre Sıfırlama Bağlantısı E-Mail Adresinize gönderildi. E-posta kutunuzu kontrol edin.');
                  },
                ).catchError(
                  (dynamic e) {
                    if (e.code == 'user-not-found') {
                      context.snackbar(
                          'Bu tanımlayıcıya karşılık gelen kullanıcı kaydı yok. Kullanıcı silinmiş olabilir.');
                    } else {
                      context.snackbar('Hata oluştu $e');
                    }
                    isResetPasswordLoading.value = false;
                  },
                );
              }
            },
            text: 'Bağlantı Gönder',
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Şifre Sıfırlama')),
      body: ValueListenableBuilder(
        valueListenable: isLoading,
        builder: (context, value, x) {
          return Center(
            child: SingleChildScrollView(
              child: SizedBox(
                width: 300,
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (value == true)
                        const Text(
                            'Şifre Sıfırlama Bağlantısı E-Mail Adresinize gönderildi. E-posta kutunuzu kontrol edin.')
                      else
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Form(
                              key: formKey,
                              autovalidateMode: AutovalidateMode.always,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  const Text(
                                    'Şifrenizi Sıfrılayın',
                                    style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  TextFormField(
                                    keyboardType: TextInputType.emailAddress,
                                    decoration: const InputDecoration(
                                      prefixIcon: Icon(Icons.mail),
                                      hintText: 'E-posta',
                                      border: OutlineInputBorder(),
                                    ),
                                    validator: Validate.email,
                                    onChanged: (value) {
                                      email = value;
                                    },
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  resetPasswordButton(),
                                  const SizedBox(
                                    height: 50,
                                  ),
                                ],
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                context.pop();
                              },
                              child: const Text(
                                'Giriş Yapın',
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
