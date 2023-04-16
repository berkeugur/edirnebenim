import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edirnebenim/Authentication/auth_service.dart';
import 'package:edirnebenim/Trade/models/trade_model.dart';
import 'package:edirnebenim/Trade/values/my_trades.dart';
import 'package:edirnebenim/Trade/values/saved_trades.dart';
import 'package:edirnebenim/Trade/view/savedandmyTradesScaffold.dart';
import 'package:edirnebenim/utilities/typedef.dart';

class SavedTradePaginationService {
  FirebaseFirestore db = FirebaseFirestore.instance;
  static DocumentSnapshot? lastDocument;
  static bool isLastPage = false;
  final pageSize = 10;
  final SavedTrades savedTrades = SavedTrades();

  Future<void> addData(TradeModel value) async {
    savedTrades.add(trade: value);
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
    if (AuthService.user != null) {
      if (savedTrades.length == 0) {
        if (!isLastPage) {
          await db
              .collection('trades')
              .where('saved_ids', arrayContains: AuthService.user!.uid)
              .orderBy('created_at', descending: true)
              .limit(pageSize)
              .get()
              .then(
            (value) async {
              print(value.docs.length);
              if (value.docs.isNotEmpty) {
                for (final doc in value.docs) {
                  final tradeDatum = TradeModel.fromJson(doc.data());

                  print(tradeDatum.savedIDs);
                  savedTrades.add(trade: tradeDatum);
                }

                if (value.docs.length < pageSize) {
                  isLastPage = true;
                }
                lastDocument = value.docs.last;
              }
            },
          );
        } else {
          print('is last page2 saved');
        }
      }
    }
  }

  Future<void> addMoreTradeData() async {
    if (!isLastPage) {
      if (lastDocument != null) {
        await db
            .collection('trades')
            .where('saved_ids', arrayContains: AuthService.user?.uid)
            .orderBy('created_at', descending: true)
            .startAfterDocument(lastDocument!)
            .limit(pageSize)
            .get()
            .then(
          (value) async {
            for (final doc in value.docs) {
              final tradeDatum = TradeModel.fromJson(doc.data());
              savedTrades.add(trade: tradeDatum);
            }
            if (value.docs.length < pageSize) {
              isLastPage = true;
            }
            lastDocument = value.docs.last;
          },
        );
      } else {
        print('last document null saved');
      }
    } else {
      print('is last page4 saved');
    }
  }
}
