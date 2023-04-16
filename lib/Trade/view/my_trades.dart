import 'dart:ui';

import 'package:edirnebenim/Packages/cache_network_images.dart';
import 'package:edirnebenim/Trade/models/trade_model.dart';
import 'package:edirnebenim/Trade/service/myTrades_pagination..dart';
import 'package:edirnebenim/Trade/values/my_trades.dart';
import 'package:edirnebenim/config.dart';
import 'package:edirnebenim/utilities/date_format.dart';
import 'package:edirnebenim/utilities/format_quantity.dart';
import 'package:flutter/material.dart';

import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class MyTradesView extends StatefulWidget {
  const MyTradesView({super.key});

  @override
  State<MyTradesView> createState() => _MyTradesViewState();
}

class _MyTradesViewState extends State<MyTradesView> {
  final MyTrades myTrades = MyTrades();
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
    var loading = false;
    return ValueListenableBuilder(
      valueListenable: myTrades,
      builder: (context, _, __) {
        print('MYTRADE: notifyListeners ${myTrades.length}');

        return SingleChildScrollView(
          child: NotificationListener(
            onNotification: (t) {
              final nextPageTrigger =
                  0.8 * _scrollController.positions.last.maxScrollExtent;

              if (_scrollController.positions.last.axisDirection ==
                      AxisDirection.down &&
                  _scrollController.positions.last.pixels >= nextPageTrigger) {
                if (loading == false) {
                  loading = true;
                  MyTradePaginationService().addMoreTradeData();
                  loading = false;
                }
              }
              return true;
            },
            child: MasonryGridView.count(
              padding: const EdgeInsets.only(
                bottom: 70,
                right: 18,
                left: 18,
                top: 18,
              ),
              shrinkWrap: true,
              controller: _scrollController,
              itemCount: myTrades.length,
              crossAxisCount: 1,
              itemBuilder: (context, index) {
                final trade = myTrades.getIndex(atIndex: index) ?? TradeModel();
                return Padding(
                  padding: const EdgeInsets.only(bottom: 18),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      InkWell(
                        onTap: () {
                          print(trade);
                        },
                        child: ClipRRect(
                          borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(8),
                            topLeft: Radius.circular(8),
                            bottomLeft: Radius.circular(8),
                            bottomRight: Radius.circular(8),
                          ),
                          child: Stack(
                            children: [
                              ImageFiltered(
                                imageFilter: ImageFilter.blur(
                                  sigmaX: 6,
                                  sigmaY: 6,
                                ),
                                child: AppCachedNetworkImage(
                                  imageUrl: trade.photos?[0],
                                  fit: BoxFit.fitWidth,
                                  height: 100,
                                  width:
                                      (MediaQuery.of(context).size.width - 58) /
                                          3,
                                ),
                              ),
                              Hero(
                                tag: trade.docID ?? 'null',
                                child: Material(
                                  color: Colors.transparent,
                                  child: AppCachedNetworkImage(
                                    imageUrl: trade.photos?[0],
                                    fit: BoxFit.contain,
                                    height: 100,
                                    width: (MediaQuery.of(context).size.width -
                                            58) /
                                        3,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 18),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              trade.title!,
                              style: TextStyle(
                                color: AppConfig.tradeTextColor,
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              '${formatQuantity(trade.price)}₺',
                              style: TextStyle(
                                color: AppConfig.tradeTextColor,
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            Text(
                              // ignore: lines_longer_than_80_chars
                              'Yayınlama Tarihi: ${AppDateFormat().dateFormatText(trade.createdAt?.toDate())}',
                              style: TextStyle(
                                color: AppConfig.tradeTextColor,
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            statusWidget(trade),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  Widget statusWidget(TradeModel trade) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 5,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: trade.status == TradeStatus.verified
            ? Colors.green
            : trade.status == TradeStatus.waiting
                ? Colors.amber[600]
                : trade.status == TradeStatus.unverified
                    ? Colors.redAccent
                    : Colors.grey[600],
      ),
      child: Text(
        '${trade.status.explanation}',
        style: AppConfig.font.copyWith(
          color: Colors.white,
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
