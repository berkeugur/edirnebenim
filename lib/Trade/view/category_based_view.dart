import 'package:edirnebenim/Trade/service/trade_pagination.dart';
import 'package:edirnebenim/Trade/values/trades.dart';
import 'package:edirnebenim/Trade/view/widgets/trade_item.dart';
import 'package:edirnebenim/locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class CategoryBasedScreen extends StatefulWidget {
  const CategoryBasedScreen({
    required this.subcategoryName,
    super.key,
  });

  final String subcategoryName;
  @override
  State<CategoryBasedScreen> createState() => _CategoryBasedScreenState();
}

class _CategoryBasedScreenState extends State<CategoryBasedScreen> {
  final trades = locator<Trades>();
  var loading = false;
  late ScrollController _scrollController;
  @override
  void initState() {
    _scrollController = ScrollController();
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.subcategoryName),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18),
          child: ValueListenableBuilder(
            valueListenable: trades,
            builder: (context, value, child) => NotificationListener(
              onNotification: (t) {
                final nextPageTrigger =
                    0.8 * _scrollController.positions.last.maxScrollExtent;

                if (_scrollController.positions.last.axisDirection ==
                        AxisDirection.down &&
                    _scrollController.positions.last.pixels >=
                        nextPageTrigger) {
                  if (loading == false) {
                    loading = true;
                    TradePaginationService()
                        .addMoreTradeData(categoryName: widget.subcategoryName);
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
                itemCount: trades.categoryBasedLength(widget.subcategoryName),
                crossAxisCount: 2,
                mainAxisSpacing: 2,
                crossAxisSpacing: 2,
                itemBuilder: (context, index) => TradeItem(
                  index: index,
                  isCategoryBasedTrades: true,
                  categoryName: widget.subcategoryName,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
