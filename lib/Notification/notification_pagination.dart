import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edirnebenim/Authentication/auth_service.dart';
import 'package:edirnebenim/Notification/notification_model.dart';
import 'package:edirnebenim/Notification/notification_value.dart';
import 'package:edirnebenim/Service/pagination_service.dart';

import 'package:edirnebenim/utilities/typedef.dart';
import 'package:flutter/foundation.dart';

class NotificationPaginationService extends PaginationService {
  FirebaseFirestore db = FirebaseFirestore.instance;
  static DocumentSnapshot? lastDocument;
  static bool isLastPage = false;
  final pageSize = 10;
  final Notifications notifications = Notifications();

  bool checkLastPage(List<FirebaseDocument> list) {
    if (list.length < pageSize) {
      isLastPage = true;
      return true;
    }
    if (list.isEmpty) {
      isLastPage = true;
      return true;
    }
    isLastPage = false;
    return false;
  }

  @override
  Future<void> getInitialTrades() async {
    if (notifications.length == 0) {
      if (!isLastPage) {
        await db
            .collection('notifications')
            .where('uid', isEqualTo: AuthService.user?.uid)
            .orderBy('created_at', descending: true)
            .limit(pageSize)
            .get()
            .then(
          (value) async {
            if (value.docs.isNotEmpty) {
              debugPrint('Notification: fetching length:${value.docs.length}');
              for (final doc in value.docs) {
                final n = NotificationModel.fromJson(doc.data());
                notifications.add(notification: n);
              }

              if (value.docs.length < pageSize) {
                isLastPage = true;
              }
              lastDocument = value.docs.last;
            } else {
              isLastPage = true;
            }
          },
        );
      }
    }
  }

  @override
  Future<void> addMoreTradeData() async {
    if (!isLastPage) {
      if (lastDocument != null) {
        await db
            .collection('notifications')
            .where('uid', isEqualTo: AuthService.user?.uid)
            .orderBy('created_at', descending: true)
            .startAfterDocument(lastDocument!)
            .limit(pageSize)
            .get()
            .then(
          (value) async {
            debugPrint('Notification: fetching length:${value.docs.length}');
            for (final doc in value.docs) {
              final n = NotificationModel.fromJson(doc.data());
              notifications.add(notification: n);
            }
            if (value.docs.length < pageSize) {
              isLastPage = true;
            }
            lastDocument = value.docs.last;
          },
        );
      }
    }
  }
}
