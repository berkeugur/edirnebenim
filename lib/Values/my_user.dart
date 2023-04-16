import 'package:edirnebenim/Authentication/user_model.dart';
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
