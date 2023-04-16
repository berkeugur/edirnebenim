import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edirnebenim/Authentication/auth_service.dart';
import 'package:edirnebenim/Trade/models/trade_model.dart';
import 'package:edirnebenim/Trade/values/saved_trades.dart';
import 'package:edirnebenim/Trade/values/trades.dart';
import 'package:edirnebenim/Values/my_user.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TradeFirebaseService {
  final db = FirebaseFirestore.instance;
  TradeModel myUser = TradeModel();
  SavedTrades savedTrades = SavedTrades();
  Trades trades = Trades();
  Future<void> setSavedTrade({required TradeModel trade}) async {
    print(savedTrades.length);
    if (trade.savedIDs?.contains(AuthService.user?.uid) ?? false) {
      try {
        await db.collection('trades').doc(trade.docID).update({
          'saved_ids': FieldValue.arrayRemove([AuthService.user?.uid]),
        }).then((value) {
          savedTrades.remove(trade: trade);
          trade.savedIDs?.remove(AuthService.user?.uid);
          trades.replaceWithId(newTradeData: trade);
        });
      } catch (e) {
        print(e);
      }
    } else {
      try {
        await db.collection('trades').doc(trade.docID).update({
          'saved_ids': FieldValue.arrayUnion([AuthService.user?.uid]),
        }).then((value) {
          savedTrades.add(trade: trade);
          trade.savedIDs?.add(AuthService.user?.uid);
          trades.replaceWithId(newTradeData: trade);
        });
      } catch (e) {
        print(e);
      }
    }
    print(savedTrades.length);
  }
}
