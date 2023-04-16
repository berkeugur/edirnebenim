// ignore_for_file: lines_longer_than_80_chars

import 'package:edirnebenim/Authentication/auth_service.dart';
import 'package:edirnebenim/Authentication/user_model.dart';
import 'package:edirnebenim/utilities/app_buttons.dart';
import 'package:edirnebenim/utilities/checkform.dart';
import 'package:edirnebenim/utilities/valitade.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

TextEditingController emailController = TextEditingController();

class _RegisterPageState extends State<RegisterPage> {
  late String email;
  late String password;
  late String name;
  late String surname;
  PhoneNumber phone = PhoneNumber(isoCode: 'TR');
  final formKey = GlobalKey<FormState>();

  ValueNotifier<bool> isSignInLoading = ValueNotifier(false);
  Widget registerButton() {
    if (isSignInLoading.value == true) {
      return AppButtons.roundedButton(isLoadingButton: true);
    } else {
      return AppButtons.roundedButton(
        function: () async {
          if (formCheck(formKey: formKey)) {
            isSignInLoading.value = true;
            await AuthService().createUser(
              user: UserModel(
                name: name,
                surname: surname,
                phone: phone.phoneNumber,
                email: email,
              ),
              context: context,
              email: email.replaceAll(' ', ''),
              password: password,
            );
            isSignInLoading.value = false;
          }
        },
        text: 'Kayıt Ol',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kayıt Ekranı'),
      ),
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
                          'Kayıt Olun',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          keyboardType: TextInputType.name,
                          decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.person),
                            hintText: 'Adınız',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) =>
                              value!.isEmpty ? 'Doldurmak zorunludur.' : null,
                          onChanged: (value) {
                            name = value;
                          },
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          keyboardType: TextInputType.name,
                          decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.person),
                            hintText: 'Soyadınız',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) =>
                              value!.isEmpty ? 'Doldurmak zorunludur.' : null,
                          onChanged: (value) {
                            surname = value;
                          },
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        InternationalPhoneNumberInput(
                          onInputChanged: (PhoneNumber number) {
                            phone = number;
                          },
                          onInputValidated: (bool value) {},
                          validator: (value) =>
                              value!.isEmpty ? 'Doldurmak zorunludur.' : null,
                          errorMessage: 'Hatalı Format',
                          selectorConfig: const SelectorConfig(
                            selectorType: PhoneInputSelectorType.DIALOG,
                            setSelectorButtonAsPrefixIcon: true,
                            leadingPadding: 25,
                          ),
                          autoValidateMode: AutovalidateMode.disabled,
                          selectorTextStyle: const TextStyle(
                            color: Colors.black,
                          ),
                          initialValue: phone,
                          inputDecoration: const InputDecoration(
                            prefixIcon: Icon(Icons.phone),
                            hintText: 'Telefon Numaranız',
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: const TextInputType.numberWithOptions(
                            signed: true,
                            decimal: true,
                          ),
                          inputBorder: const OutlineInputBorder(),
                          onSaved: (PhoneNumber number) {
                            print('On Saved: $number');
                          },
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
                            return registerButton();
                          },
                        )
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
