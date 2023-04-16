import 'package:edirnebenim/Authentication/auth_service.dart';
import 'package:edirnebenim/Trade/models/trade_model.dart';
import 'package:edirnebenim/Values/my_user.dart';
import 'package:flutter/material.dart';

class SavedTrades extends ValueNotifier<List<TradeModel>> {
  factory SavedTrades() => _shared;
  SavedTrades._sharedInstance() : super([]);
  static final SavedTrades _shared = SavedTrades._sharedInstance();

  int get length => value.length;
  void clear() {
    value.clear();
    notifyListeners();
  }

  void add({required TradeModel trade}) {
    final trades = value;
    // ignore: cascade_invocations
    trades.add(trade);
    notifyListeners();
  }

  void remove({required TradeModel trade}) {
    final trades = value;
    if (trades.contains(trade)) {
      trades.remove(trade);
      notifyListeners();
    } else {
      print("is not contain. remove failed");
    }
  }

  void sort() {
    final trades = value;
    // ignore: cascade_invocations
    trades.sort((a, b) {
      return b.createdAt.toString().compareTo(a.createdAt.toString());
    });
    notifyListeners();
  }

  void replaceWithId({required TradeModel newTradeData}) {
    final trades = value;
    final index =
        trades.indexWhere((element) => element.docID == newTradeData.docID);
    trades[index] = newTradeData;
    trades.sort((a, b) {
      return b.createdAt.toString().compareTo(a.createdAt.toString());
    });
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

  TradeModel? getIndex({required int atIndex}) {
    return value.length > atIndex ? value[atIndex] : null;
  }

  TradeModel? getWithID({required String id}) {
    final atIndex = value.indexWhere((element) => element.docID == id);
    return value.length > atIndex ? value[atIndex] : null;
  }
}
