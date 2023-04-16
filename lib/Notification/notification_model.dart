import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class NotificationModel extends Equatable {
  NotificationModel({
    required this.title,
    required this.userid,
    required this.docID,
    this.subtitle,
    this.createdAt,
  });

  NotificationModel.fromJson(Map<String, dynamic> json) {
    title = json['title'] as String;
    subtitle = json['subtitle'] as String?;
    createdAt = DateTime.fromMillisecondsSinceEpoch(json['created_at'] as int);
    userid = json['uid'] as String;
    docID = json['doc_id'] as String;
  }
  late String title;
  String? subtitle;
  DateTime? createdAt;
  late String userid;
  late String docID;

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['title'] = title;
    data['subtitle'] = subtitle;
    data['created_at'] = createdAt?.millisecondsSinceEpoch;
    data['uid'] = userid;
    data['doc_id'] = docID;
    return data;
  }

  static final notificationCollection = FirebaseFirestore.instance
      .collection('notifications')
      .withConverter<NotificationModel>(
        fromFirestore: (snapshot, _) =>
            NotificationModel.fromJson(snapshot.data()!),
        toFirestore: (movie, _) => movie.toJson(),
      );

  @override
  List<Object?> get props => [title, createdAt, subtitle, userid, docID];
}
