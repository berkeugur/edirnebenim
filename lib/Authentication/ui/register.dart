import 'dart:async';

import 'package:another_flushbar/flushbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edirnebenim/Authentication/auth_service.dart';
import 'package:edirnebenim/Authentication/ui/dialog.dart';
import 'package:edirnebenim/Authentication/ui/login.dart';
import 'package:edirnebenim/Authentication/user_model.dart';
import 'package:edirnebenim/Authentication/widgets/input_field.dart';
import 'package:edirnebenim/Values/my_user.dart';
import 'package:edirnebenim/locator.dart';
import 'package:edirnebenim/utilities/app_buttons.dart';
import 'package:edirnebenim/utilities/snack_bar.dart';
import 'package:flutter/material.dart';

import '../widgets/custom_checkbox.dart';
import '../widgets/primary_button.dart';
import '../widgets/theme.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController nameController = TextEditingController(text: '');
  final TextEditingController surnameController =
      TextEditingController(text: '');
  final TextEditingController emailController = TextEditingController(text: '');
  final TextEditingController passwordController =
      TextEditingController(text: '');
  final myUser = locator.get<MyUser>();
  bool passwordVisible = false;
  bool passwordConfrimationVisible = false;
  bool isChecked = false;
  bool isChecked2 = false;
  void togglePassword() {
    setState(() {
      passwordVisible = !passwordVisible;
    });
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
                '''Yeni hesap\noluştur''',
                style: heading2.copyWith(color: textBlack),
              ),
            ],
          ),
          const SizedBox(
            height: 28,
          ),
          Form(
            child: Column(
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Expanded(
                      flex: 1,
                      child: InputField(
                        hintText: 'Adınız',
                        controller: nameController,
                        suffixIcon: const SizedBox(),
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Expanded(
                      flex: 1,
                      child: InputField(
                        hintText: 'Soyadınız',
                        controller: surnameController,
                        suffixIcon: const SizedBox(),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 18,
                ),
                InputField(
                  hintText: 'E-postanız',
                  controller: emailController,
                  suffixIcon: const SizedBox(),
                ),
                const SizedBox(
                  height: 18,
                ),
                InputField(
                  hintText: 'Şifreniz',
                  controller: passwordController,
                  obscureText: !passwordVisible,
                  suffixIcon: IconButton(
                    color: textGrey,
                    splashRadius: 1,
                    icon: Icon(passwordVisible
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined),
                    onPressed: togglePassword,
                  ),
                ),
                const SizedBox(
                  height: 18,
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 18,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    isChecked = !isChecked;
                  });
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: isChecked ? primaryBlue : Colors.transparent,
                    borderRadius: BorderRadius.circular(4),
                    border: isChecked
                        ? null
                        : Border.all(color: textGrey, width: 1.5),
                  ),
                  width: 20,
                  height: 20,
                  child: isChecked
                      ? const Icon(
                          Icons.check,
                          size: 20,
                          color: Colors.white,
                        )
                      : null,
                ),
              ),
              const SizedBox(
                width: 12,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Gizlilik Sözleşmesi & Kullanım Koşullarını',
                    style: regular16pt.copyWith(color: primaryBlue),
                  ),
                  Text(
                    'kabul ediyorum.',
                    style: regular16pt.copyWith(color: textGrey),
                  ),
                ],
              ),
              const SizedBox(
                width: 12,
              ),
            ],
          ),
          const SizedBox(
            height: 18,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 20,
                width: 20,
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      isChecked2 = !isChecked2;
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: isChecked2 ? primaryBlue : Colors.transparent,
                      borderRadius: BorderRadius.circular(4),
                      border: isChecked2
                          ? null
                          : Border.all(color: textGrey, width: 1.5),
                    ),
                    width: 20,
                    height: 20,
                    child: isChecked2
                        ? const Icon(
                            Icons.check,
                            size: 20,
                            color: Colors.white,
                          )
                        : null,
                  ),
                ),
              ),
              const SizedBox(
                width: 12,
              ),
              Expanded(
                child: Text(
                  'İletişim bilgilerime kampanya, tanıtım ve reklam içerikli ticari elektronik ileti gönderilmesine izin veriyorum.',
                  style: regular16pt.copyWith(color: textGrey),
                  maxLines: 99,
                ),
              ),
              const SizedBox(
                width: 12,
              ),
            ],
          ),
          const SizedBox(
            height: 18,
          ),
          AppButtons.roundedButton(
              borderRadius: BorderRadius.circular(14),
              backgroundColor: primaryBlue,
              text: 'Kayıt Ol',
              function: () async {
                if (isChecked) {
                  if (nameController.text.isNotEmpty &&
                      surnameController.text.isNotEmpty &&
                      emailController.text.isNotEmpty &&
                      passwordController.text.isNotEmpty) {
                    await Future.delayed(const Duration(seconds: 3));
                    final now = Timestamp.now();
                    await AuthService()
                        .createUser(
                      context: context,
                      email: emailController.text.replaceAll(' ', ''),
                      password: passwordController.text,
                      user: UserModel(
                        name: nameController.text,
                        surname: surnameController.text,
                        phone: null,
                        isOnline: false,
                        lastSeen: now.toDate(),
                        userID: null,
                      ),
                    )
                        .then((value) {
                      if (AuthService.user != null) {
                        Navigator.of(context).pop();
                        Navigator.of(context).pop();
                      }
                    });
                  } else {
                    unawaited(
                      Flushbar(
                        duration: const Duration(seconds: 3),
                        title: 'Hata Oluştu',
                        message: 'Boşlukları doldurmalısınız',
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
                  }
                } else {
                  unawaited(
                    Flushbar(
                      duration: const Duration(seconds: 3),
                      title: 'Hata Oluştu',
                      message: 'Kullanıcı sözleşmesini kabul etmelisiniz.',
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
                }
              }),
          const SizedBox(
            height: 50,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Zaten hesabınız var mı? ",
                style: regular16pt.copyWith(color: textGrey),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  'Giriş Yapın',
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
