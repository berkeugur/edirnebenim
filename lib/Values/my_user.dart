import 'dart:math';

import 'package:edirnebenim/Authentication/user_model.dart';
import 'package:edirnebenim/config.dart';
import 'package:flutter/material.dart';

class MyUser extends ValueNotifier<UserModel?> {
  factory MyUser() => _shared;
  MyUser._sharedInstance() : super(null);
  static final MyUser _shared = MyUser._sharedInstance();

  void update(UserModel? user) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      value = user;
      notifyListeners();
    });
  }

  String? get photoURL => value?.photoURL;
  set photoURL(String? newPhotoURL) =>
      value?.photoURL = newPhotoURL ?? AppConfig.nullProfilePhotoURL;

  String? get userID => value?.userID;
  set userID(String? userID) => value?.userID = userID;

  String? get name => value?.name;
  set name(String? name) => value?.name = name;

  String? get surname => value?.surname;
  set surname(String? surname) => value?.surname = surname;

  String? get email => value?.email;
  set email(String? email) => value?.email = email;

  String? get phone => value?.phone;
  set phone(String? phone) => value?.phone = phone;

  String? get bio => value?.bio;
  set bio(String? bio) => value?.bio = bio;

  DateTime? get lastSeen => value?.lastSeen;
  set lastSeen(DateTime? lastSeen) => value?.lastSeen = lastSeen;

  bool? get isOnline => value?.isOnline;
  set isOnline(bool? isOnline) => value?.isOnline = isNull;

  bool get isNull {
    if (value == null) {
      return true;
    } else {
      return false;
    }
  }

  String? get profilePhoto {
    final myuser = value;
    if (myuser?.photoURL == '') {
      return null;
    }
    return myuser?.photoURL;
  }
}
