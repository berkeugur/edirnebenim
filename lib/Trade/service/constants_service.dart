import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edirnebenim/Trade/values/trade_categories.dart';
import 'package:edirnebenim/Trade/values/trade_location.dart';
import 'package:edirnebenim/Trade/values/trade_regions.dart';

class ConstatntService {
  final tradeCategories = TradeCategories();
  final tradeRegions = TradeRegions();

  Future<void> getTradeCategories() async {
    await FirebaseFirestore.instance
        .collection('constants')
        .doc('trade')
        .collection('turkish')
        .doc('categories')
        .get()
        .then((value) {
      value.data()?.forEach((key, value) {
        tradeCategories.add(
          newCategory: {
            key: (value as List).map((item) => item as String).toList()
          },
        );
      });
    });
  }

  Future<void> getTradeRegions() async {
    await FirebaseFirestore.instance
        .collection('constants')
        .doc('trade')
        .collection('turkish')
        .doc('regions')
        .get()
        .then((value) {
      value.data()?.forEach((key, value) {
        tradeRegions.add(
          newregion: {
            key: (value as List).map((item) => item as String).toList()
          },
        );
      });
      TradeLocation().update(
        update: {
          tradeRegions.getTitles.first:
              null, //tradeRegions.getSubRegions.first.first,
        },
      );
    });
  }
}
