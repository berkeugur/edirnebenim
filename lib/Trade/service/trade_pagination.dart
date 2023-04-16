import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edirnebenim/Authentication/auth_service.dart';
import 'package:edirnebenim/Trade/models/trade_model.dart';
import 'package:edirnebenim/Trade/values/trades.dart';
import 'package:edirnebenim/Values/my_user.dart';
import 'package:edirnebenim/utilities/typedef.dart';

class TradePaginationService {
  FirebaseFirestore db = FirebaseFirestore.instance;
  static DocumentSnapshot? lastDocument;
  static bool isLastPage = false;
  final pageSize = 10;
  final Trades trades = Trades();

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
            .orderBy('created_at', descending: true)
            .limit(pageSize)
            .get()
            .then(
          (value) async {
            for (final doc in value.docs) {
              final tradeDatum = TradeModel.fromJson(doc.data());
              trades.add(trade: tradeDatum);
            }

            if (value.docs.length < pageSize) {
              isLastPage = true;
            }
            lastDocument = value.docs.last;
          },
        );
      } else {
        print('is last page2');
      }
    }
  }

  Future<void> addMoreTradeData({String? categoryName}) async {
    if (!isLastPage) {
      if (lastDocument != null) {
        if (categoryName != null) {
          await db
              .collection('trades')
              .orderBy('created_at', descending: true)
              .where('subcategory', isEqualTo: categoryName)
              .startAfterDocument(lastDocument!)
              .limit(pageSize)
              .get()
              .then(
            (value) async {
              print(value.docs.length);

              for (final doc in value.docs) {
                final tradeDatum = TradeModel.fromJson(doc.data());
                trades.add(trade: tradeDatum);
              }
              if (value.docs.length < pageSize) {
                isLastPage = true;
              }
              lastDocument = value.docs.last;
            },
          );
        } else {
          await db
              .collection('trades')
              .orderBy('created_at', descending: true)
              .startAfterDocument(lastDocument!)
              .limit(pageSize)
              .get()
              .then(
            (value) async {
              print(value.docs.length);

              for (final doc in value.docs) {
                final tradeDatum = TradeModel.fromJson(doc.data());
                trades.add(trade: tradeDatum);
              }
              if (value.docs.length < pageSize) {
                isLastPage = true;
              }
              lastDocument = value.docs.last;
            },
          );
        }
      } else {
        print('last document null');
      }
    } else {
      print('is last page4');
    }
  }
}
