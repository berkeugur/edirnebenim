// ignore_for_file: file_names, must_be_immutable

import 'package:edirnebenim/Authentication/auth_service.dart';
import 'package:edirnebenim/Trade/values/my_trades.dart';
import 'package:edirnebenim/Trade/values/trades.dart';
import 'package:edirnebenim/Trade/view/my_trades.dart';
import 'package:edirnebenim/Trade/view/saved_trades.dart';
import 'package:edirnebenim/config.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class SavedTradesScaffold extends StatelessWidget {
  SavedTradesScaffold({super.key});
  Trades trades = Trades();
  MyTrades myTrades = MyTrades();
  AuthService authService = AuthService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(
          top: MediaQuery.of(context).viewPadding.top,
        ),
        child: DefaultTabController(
          length: 2, // length of tabs
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TabBar(
                labelColor: AppConfig.tradePrimaryColor,
                unselectedLabelColor: AppConfig.tradeTextColor,
                labelStyle: AppConfig.font.copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
                tabs: const [
                  Tab(
                    text: 'İlanlarım',
                    icon: Icon(Iconsax.shop),
                  ),
                  Tab(
                    text: 'Favoriler',
                    icon: Icon(Iconsax.save_2),
                  ),
                ],
              ),
              Expanded(
                child: TabBarView(
                  children: <Widget>[
                    const MyTradesView(),
                    SavedTradesView(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
