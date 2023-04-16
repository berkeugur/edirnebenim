import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edirnebenim/Authentication/user_model.dart';
import 'package:flutter/material.dart';

typedef ValueModel = UserModel;

class Users extends ValueNotifier<List<ValueModel>> {
  factory Users() => _shared;
  Users._sharedInstance() : super([]);
  static final Users _shared = Users._sharedInstance();

  int get length => value.length;

  ///check before is not contain uid
  Future<ValueModel?> getUserFromFirebaseWithUID({
    required String id,
    required bool enableIsContain,
  }) async {
    ValueModel? valueModel;
    if (enableIsContain) {
      if (!containID(id: id)) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(id)
            .get()
            .then((value) {
          if (value.data() != null) {
            valueModel = ValueModel.fromJson(value.data()!);
            if (valueModel != null) {
              add(user: valueModel!);
            }
          }
        });
      } else {
        return value.where((element) => element.userID == id).first;
      }
    } else {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(id)
          .get()
          .then((value) {
        if (value.data() != null) {
          valueModel = ValueModel.fromJson(value.data()!);
          if (valueModel != null) {
            add(user: valueModel!);
          }
        }
      });
    }
    return valueModel;
  }

  void add({required ValueModel user}) {
    value.add(user);
    notifyListeners();
  }

  void remove({required ValueModel user}) {
    final users = value;
    if (users.contains(user)) {
      users.remove(user);
      notifyListeners();
    }
  }

  void removeAt({required int index}) {
    final users = value;
    if (length > index) {
      users.removeAt(index);
      notifyListeners();
    }
  }

  //is this uid contain in users
  bool containID({required String id}) {
    final users = value;
    for (final user in users) {
      if (user.userID == id) {
        return true;
      }
    }
    return false;
  }

  ValueModel? searchID({required String id}) {
    final users = value;
    for (final user in users) {
      if (user.userID == id) {
        return user;
      }
    }
    return null;
  }

  ValueModel? getIndex({required int atIndex}) {
    return value.length > atIndex ? value[atIndex] : null;
  }
}
