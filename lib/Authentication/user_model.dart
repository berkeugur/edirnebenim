// ignore_for_file: lines_longer_than_80_chars, must_be_immutable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edirnebenim/config.dart';
import 'package:edirnebenim/utilities/typedef.dart';
import 'package:equatable/equatable.dart';

class UserModel extends Equatable {
  UserModel({
    this.photoURL = AppConfig.nullProfilePhotoURL,
    this.userID,
    this.name,
    this.surname,
    this.email,
    this.phone,
    this.lastSeen,
    this.isOnline = false,
    this.bio,
  });

  UserModel.fromJson(Json json) {
    photoURL = (json['photoURL'] as String?) ?? AppConfig.nullProfilePhotoURL;
    userID = json['userID'] as String?;
    name = json['name'] as String?;
    surname = json['surname'] as String?;
    email = json['email'] as String?;
    phone = json['phone'] as String?;
    bio = json['bio'] as String?;
    lastSeen = (json['last_seen'] as Timestamp?)?.toDate();
    isOnline = (json['is_online'] as bool?) ?? false;
  }

  late String photoURL;
  String? userID;
  String? name;
  String? surname;
  String? email;
  String? phone;
  String? bio;
  DateTime? lastSeen;
  late bool isOnline;

  Json toJson() {
    final data = <String, dynamic>{};

    data['photoURL'] = photoURL;
    data['userID'] = userID;
    data['name'] = name;
    data['surname'] = surname;
    data['email'] = email;
    data['phone'] = phone;
    data['bio'] = bio;
    data['last_seen'] = lastSeen == null ? null : Timestamp.fromDate(lastSeen!);
    data['is_online'] = isOnline;
    return data;
  }

  @override
  List<Object?> get props => [
        userID,
        photoURL,
        name,
        surname,
        email,
        phone,
        bio,
      ];
}
