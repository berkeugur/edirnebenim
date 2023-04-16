import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edirnebenim/Authentication/auth_service.dart';
import 'package:edirnebenim/Trade/models/trade_model.dart';
import 'package:edirnebenim/Trade/values/my_trades.dart';
import 'package:edirnebenim/utilities/typedef.dart';
import 'package:flutter/foundation.dart';

class MyTradePaginationService {
  FirebaseFirestore db = FirebaseFirestore.instance;
  static DocumentSnapshot? lastDocument;
  static bool isLastPage = false;
  final pageSize = 10;
  final MyTrades trades = MyTrades();

  Future<void> addData(TradeModel value) async {
    trades.add(trade: value);
  }

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

  Future<void> getInitialTrades() async {
    if (trades.length == 0) {
      if (!isLastPage) {
        await db
            .collection('trades')
            .where('uid', isEqualTo: AuthService.user?.uid)
            .orderBy('created_at', descending: true)
            .limit(pageSize)
            .get()
            .then(
          (value) async {
            debugPrint('MYTRADE: fetching length:${value.docs.length}');
            if (value.docs.isNotEmpty) {
              for (final doc in value.docs) {
                final tradeDatum = TradeModel.fromJson(doc.data());
                trades.add(trade: tradeDatum);
              }

              if (value.docs.length < pageSize) {
                isLastPage = true;
              }
              lastDocument = value.docs.last;
            }
          },
        );
      } else {
        print('is last page2');
      }
    }
  }

  Future<void> addMoreTradeData() async {
    if (!isLastPage) {
      if (lastDocument != null) {
        await db
            .collection('trades')
            .where('uid', isEqualTo: AuthService.user?.uid)
            .orderBy('created_at', descending: true)
            .startAfterDocument(lastDocument!)
            .limit(pageSize)
            .get()
            .then(
          (value) async {
            debugPrint('MYTRADE: fetching length:${value.docs.length}');
            if (value.docs.isNotEmpty) {
              for (final doc in value.docs) {
                final tradeDatum = TradeModel.fromJson(doc.data());
                trades.add(trade: tradeDatum);
              }
              if (value.docs.length < pageSize) {
                isLastPage = true;
              }
              lastDocument = value.docs.last;
            }
          },
        );
      } else {
        print('last document null');
      }
    } else {
      print('is last page4');
    }
  }
}
