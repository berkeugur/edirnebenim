import 'package:flutter/material.dart';

class TradeLocation extends ValueNotifier<Map<String, String?>> {
  TradeLocation._sharedInstance() : super({});
  static final TradeLocation _shared = TradeLocation._sharedInstance();
  factory TradeLocation() => _shared;

  void update({required Map<String, String?> update}) {
    final location = value;
    location.clear();
    if (location.isEmpty) {
      location.addAll({
        update.keys.toList().first: update.values.toList().first,
      });
    }

    notifyListeners();
  }

  String get getCity {
    final location = value;
    return location.keys.first;
  }

  String? get getRegions {
    final location = value;
    return location.values.first;
  }
}
