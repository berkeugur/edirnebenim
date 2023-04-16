// ignore_for_file: lines_longer_than_80_chars, avoid_print, inference_failure_on_instance_creation, cast_nullable_to_non_nullable

import 'dart:async';

import 'package:another_flushbar/flushbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edirnebenim/Authentication/my_profile.dart';
import 'package:edirnebenim/Authentication/ui/dialog.dart';
import 'package:edirnebenim/Authentication/ui/login.dart';
import 'package:edirnebenim/Authentication/user_model.dart';
import 'package:edirnebenim/Authentication/welcome_screen.dart';
import 'package:edirnebenim/Authentication/widgets/theme.dart';
import 'package:edirnebenim/Trade/service/myTrades_pagination..dart';
import 'package:edirnebenim/Trade/service/savedTrades_pagination.dart';
import 'package:edirnebenim/Trade/trade_setup.dart';
import 'package:edirnebenim/Trade/view/trade_scaffold.dart';
import 'package:edirnebenim/Values/my_user.dart';
import 'package:edirnebenim/locator.dart';
import 'package:edirnebenim/utilities/exceptions.dart';
import 'package:edirnebenim/utilities/mediaquery.dart';
import 'package:edirnebenim/utilities/snack_bar.dart';
import 'package:edirnebenim/utilities/typedef.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class AuthService {
  final FirebaseFirestore _firebase = FirebaseFirestore.instance;
  MyUser myUser = locator<MyUser>();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  static User? user;

  void Function()? authorizedControl(
    BuildContext context, {
    Function? function,
  }) {
    return () async {
      if (AuthService.user?.uid == null) {
        showCustomModelBottomSheet(context, LoginScreen());
      }
      if (AuthService.user?.uid != null) {
        if (function == null) {
          await Navigator.of(context).push(
            MaterialPageRoute<MyProfileScreen>(
              builder: (context) => const MyProfileScreen(),
            ),
          );
        } else {
          function.call();
        }
      }
    };
  }

  ///Firebase giriş veya kayıt işlemlerinden sonra kullanılmalı çünkü
  ///FirebaseAuth.instance.currentUser 'den email bilgisine ihtiyacı var.
  ///
  void setOnlineStatus({required bool isOnline}) {
    if (user != null) {
      if (isOnline) {
        _firebase.collection('users').doc(user!.uid).update(
          {
            'is_online': isOnline,
            'last_seen': Timestamp.now(),
          },
        );
      } else {
        _firebase.collection('users').doc(user!.uid).update(
          {
            'is_online': isOnline,
          },
        );
      }
    } else {
      print('user null');
    }
  }

  Future<UserModel?> get getUserData async {
    var customer = UserModel();
    //Firebase currentuser dan email bilgisini alacağı için login veya register
    //dan önce kullanmak gereklidir.

    if (user != null) {
      await _firebase
          .collection('users')
          .doc(user!.uid)
          .get()
          .then((DocumentSnapshot document) async {
        if (document.exists) {
          final data = document.data() as Json;
          customer = UserModel.fromJson(data);
        } else {
          throw AppExceptions.userDocumentIsNull;
        }
      });
    } else {
      throw AppExceptions.getUserDataException;
    }
    return customer;
  }

  // ignore: strict_raw_type
  StreamBuilder handleAuth() {
    return StreamBuilder<User?>(
      stream: _auth.authStateChanges(),
      builder: (context, snapshot) {
        user = snapshot.data;

        if (snapshot.hasData) {
          setOnlineStatus(isOnline: true);
          return FutureBuilder(
            future: getUserData,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                myUser.update(snapshot.data);
                return TradeScaffold();
              } else {
                return const Scaffold(
                  backgroundColor: Colors.white,
                  body: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }
            },
          );
        } else {
          return TradeScaffold(); //Login screen;
        }
      },
    );
  }

  Future<void> signOut(BuildContext context) async {
    await _auth.signOut().then((value) async {
      Navigator.of(context).pop();
      myUser.update(null);
      await logoutTradeSetup();
      //context.goNamed(APP_PAGE.initial.toName);
    });
  }

  Future<void> signIn({
    required BuildContext context,
    required String email,
    required String password,
  }) async {
    try {
      await _auth
          .signInWithEmailAndPassword(email: email, password: password)
          .then((value) async {
        print("SIGN_IN_LOG: ${AuthService.user}");
        user = value.user;
        print("SIGN_IN_LOG: ${AuthService.user}");

        await loginTradeSetup();
      });
    } on FirebaseAuthException catch (e) {
      print(e.code);
      print(e.message);
      if (e.code == 'user-not-found') {
        unawaited(
          Flushbar(
            duration: const Duration(seconds: 3),
            title: 'Hata Oluştu',
            message: 'E-posta adresi eksik veya hatalı',
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
      } else if (e.code == 'wrong-password') {
        unawaited(
          Flushbar(
            duration: const Duration(seconds: 3),
            title: 'Hata Oluştu',
            message: 'Girdiğiniz şifre eksik veya hatalı',
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
      } else if (e.code == 'invalid-email') {
        unawaited(
          Flushbar(
            duration: const Duration(seconds: 3),
            title: 'Hata Oluştu',
            message: 'E-posta adresi eksik veya hatalı',
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
    }
  }

  Future<void> createUser({
    required BuildContext context,
    required UserModel user,
    required String email,
    required String password,
  }) async {
    try {
      await _auth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((UserCredential value) async {
        //assert(user != null, 'User is null');

        final customerModel = UserModel(
          // ignore: avoid_redundant_argument_values

          userID: value.user != null ? value.user!.uid : 'user id null error',
          name: user.name,
          surname: user.surname,
          email: email,
          phone: user.phone,
        );
        await FirebaseFirestore.instance
            .collection('users')
            .doc(value.user!.uid)
            .set(customerModel.toJson())
            .then((x) async {
          print('create user and firebase firestore and navigator.');
          await getUserData.then((s) {
            print("SIGN_IN_LOG: ${AuthService.user}");
            AuthService.user = value.user;
            print("SIGN_IN_LOG: ${AuthService.user}");
            //context.go(context.namedLocation(APP_PAGE.home.toName));
          });
        });
      });
    } on FirebaseAuthException catch (e) {
      print('on firebaseauthexeption catch');
      if (e.code == 'weak-password') {
        context.snackbar('Daha güçlü bir şifre girin.');
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        context.snackbar(
          'Bu e posta zaten kullanılıyor. Farklı bir e posta ile deneyin.',
        );
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
  }

  Future<bool> sendPasswordResetEmail({required String email}) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }
}
