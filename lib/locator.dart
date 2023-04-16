import 'package:edirnebenim/Trade/values/my_trades.dart';
import 'package:edirnebenim/Trade/values/saved_trades.dart';
import 'package:edirnebenim/Trade/values/trades.dart';
import 'package:edirnebenim/Values/my_user.dart';
import 'package:get_it/get_it.dart';

GetIt locator = GetIt.instance;

void setupLocator() {
  locator
    ..registerSingleton<MyUser>(MyUser())
    ..registerSingleton<Trades>(Trades())
    ..registerSingleton<SavedTrades>(SavedTrades())
    ..registerSingleton<MyTrades>(MyTrades());
}
