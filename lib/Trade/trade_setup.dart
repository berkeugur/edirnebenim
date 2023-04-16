import 'package:edirnebenim/Trade/service/constants_service.dart';
import 'package:edirnebenim/Trade/service/myTrades_pagination..dart';
import 'package:edirnebenim/Trade/service/savedTrades_pagination.dart';
import 'package:edirnebenim/Trade/service/trade_pagination.dart';
import 'package:edirnebenim/Trade/values/my_trades.dart';
import 'package:edirnebenim/Trade/values/saved_trades.dart';
import 'package:edirnebenim/locator.dart';
import 'package:flutter/foundation.dart';

Future<void> tradeSetuo() async {
  await ConstatntService().getTradeCategories();
  await ConstatntService().getTradeRegions();
  await TradePaginationService().getInitialTrades();
  await SavedTradePaginationService().getInitialTrades();
  await MyTradePaginationService().getInitialTrades();
}

Future<void> logoutTradeSetup() async {
  final savedtrades = locator<SavedTrades>();
  final myTrades = locator<MyTrades>();

  savedtrades.clear();
  myTrades.clear();
}

Future<void> loginTradeSetup() async {
  debugPrint('SIGN_IN_LOG: Login trade setup worked');
  SavedTradePaginationService.isLastPage = false;
  MyTradePaginationService.isLastPage = false;
  await SavedTradePaginationService().getInitialTrades();
  await MyTradePaginationService().getInitialTrades();
}
