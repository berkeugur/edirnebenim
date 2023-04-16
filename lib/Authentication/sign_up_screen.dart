import 'package:edirnebenim/Authentication/auth_service.dart';
import 'package:edirnebenim/utilities/app_buttons.dart';
import 'package:edirnebenim/utilities/checkform.dart';
import 'package:edirnebenim/utilities/valitade.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

TextEditingController emailController = TextEditingController();

class _LoginPageState extends State<LoginPage> {
  late String email;
  late String password;
  final formKey = GlobalKey<FormState>();
  ValueNotifier<bool> isSignInLoading = ValueNotifier(false);
  Widget loginButton() {
    if (isSignInLoading.value == true) {
      return AppButtons.roundedButton(isLoadingButton: true);
    } else {
      return AppButtons.roundedButton(
        text: 'Giriş Yap',
        function: () async {
          if (formCheck(formKey: formKey)) {
            await AuthService()
                .signIn(
                  context: context,
                  email: email.replaceAll(' ', ''),
                  password: password,
                )
                .then(
                  (value) => Navigator.of(context).pop(),
                );
          }
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('BETOKONT RANDEVU')),
      body: Center(
        child: SingleChildScrollView(
          child: SizedBox(
            width: 300,
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Form(
                    key: formKey,
                    autovalidateMode: AutovalidateMode.always,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        const Text(
                          'Giriş Yapın',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
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
                        TextFormField(
                          obscureText: true,
                          keyboardType: TextInputType.visiblePassword,
                          autocorrect: false,
                          decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.lock),
                            hintText: 'Şifre',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) =>
                              value!.isEmpty ? 'Şifre girmek zorunludur' : null,
                          onChanged: (value) {
                            password = value;
                          },
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        ValueListenableBuilder(
                          valueListenable: isSignInLoading,
                          builder: (context, value, y) {
                            return loginButton();
                          },
                        ),
                        const SizedBox(
                          height: 40,
                        ),
                        AppButtons.roundedButton(
                          text: 'E-posta ile üye olun',
                          function: () async {
                            //context.goNamed(APP_PAGE.register.toName);
                          },
                        ),
                        const SizedBox(
                          height: 40,
                        ),
                        TextButton(
                          onPressed: () {
                            //context.goNamed(APP_PAGE.resetPassword.toName);
                          },
                          child: const Text(
                            'Parolanızı mı unuttunuz?',
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
