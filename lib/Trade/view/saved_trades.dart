import 'package:edirnebenim/Trade/service/savedTrades_pagination.dart';
import 'package:edirnebenim/Trade/values/saved_trades.dart';
import 'package:edirnebenim/Trade/view/widgets/trade_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class SavedTradesView extends StatefulWidget {
  SavedTradesView({super.key});

  @override
  State<SavedTradesView> createState() => _SavedTradesViewState();
}

class _SavedTradesViewState extends State<SavedTradesView> {
  SavedTrades savedTrades = SavedTrades();

  late ScrollController _scrollController;
  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18),
        child: ValueListenableBuilder(
          valueListenable: savedTrades,
          builder: (context, value, child) => NotificationListener(
            onNotification: (t) {
              final nextPageTrigger =
                  0.8 * _scrollController.positions.last.maxScrollExtent;

              if (_scrollController.positions.last.axisDirection ==
                      AxisDirection.down &&
                  _scrollController.positions.last.pixels >= nextPageTrigger) {
                if (loading == false) {
                  loading = true;
                  SavedTradePaginationService().addMoreTradeData();

                  //print('getirildi');
                  loading = false;
                }
              }
              return true;
            },
            child: MasonryGridView.count(
              controller: _scrollController,
              padding: const EdgeInsets.only(bottom: 70),
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: savedTrades.length,
              crossAxisCount: 2,
              mainAxisSpacing: 2,
              crossAxisSpacing: 2,
              itemBuilder: (context, index) => TradeItem(
                index: index,
                isSavedTrades: true,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
