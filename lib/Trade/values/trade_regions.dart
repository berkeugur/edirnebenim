import 'package:edirnebenim/utilities/typedef.dart';
import 'package:flutter/material.dart';

class TradeRegions extends ValueNotifier<TradeRegionsType> {
  TradeRegions._sharedInstance() : super({});
  static final TradeRegions _shared = TradeRegions._sharedInstance();
  factory TradeRegions() => _shared;

  int get length => value.length;

  void add({required TradeRegionsType newregion}) {
    final regions = value;
    regions.addAll(newregion);
    notifyListeners();
  }

  void remove({required String regionKey}) {
    final regions = value;
    if (regions.containsKey(regionKey)) {
      regions.removeWhere(
        (key, value) => key == regionKey,
      );
      notifyListeners();
    }
  }

  List<String> get getTitles {
    final regions = value;
    return regions.keys.toList();
  }

  List<List<String>> get getSubRegions {
    final regions = value;
    return regions.values.toList();
  }
}
