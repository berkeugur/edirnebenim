import 'package:edirnebenim/Notification/notification_model.dart';
import 'package:flutter/material.dart';

class Notifications extends ValueNotifier<List<NotificationModel>> {
  factory Notifications() => _shared;
  Notifications._sharedInstance() : super([]);
  static final Notifications _shared = Notifications._sharedInstance();

  int get length => value.length;

  void add({required NotificationModel notification}) {
    final notifications = value;
    // ignore: cascade_invocations
    notifications.add(notification);
    debugPrint('Notification: add:${notification.toJson()}');
    notifyListeners();
  }

  void remove({required NotificationModel notification}) {
    final notifications = value;
    if (notifications.contains(notification)) {
      notifications.remove(notification);
      debugPrint('Notification: remove:${notification.toJson()}');
      notifyListeners();
    }
  }

  void sort() {
    final notifications = value;
    // ignore: cascade_invocations
    notifications.sort((a, b) {
      return b.createdAt.toString().compareTo(a.createdAt.toString());
    });
    notifyListeners();
  }

  void replaceWithId({required NotificationModel newNotification}) {
    final notifications = value;
    final index = notifications
        .indexWhere((element) => element.docID == newNotification.docID);
    notifications[index] = newNotification;
    notifications.sort((a, b) {
      return b.createdAt.toString().compareTo(a.createdAt.toString());
    });
    debugPrint('Notification: replacedWithID:${newNotification.toJson()}');
    notifyListeners();
  }

  //is this uid contain in users
  bool containID({required String id}) {
    final trades = value;
    for (final trade in trades) {
      if (trade.docID == id) {
        return true;
      }
    }
    return false;
  }

  NotificationModel? getIndex({required int atIndex}) {
    return value.length > atIndex ? value[atIndex] : null;
  }

  NotificationModel? getWithID({required String id}) {
    final atIndex = value.indexWhere((element) => element.docID == id);
    return value.length > atIndex ? value[atIndex] : null;
  }
}
