import 'dart:ui';

import 'package:edirnebenim/Authentication/auth_service.dart';
import 'package:edirnebenim/Packages/cache_network_images.dart';
import 'package:edirnebenim/Trade/models/trade_model.dart';
import 'package:edirnebenim/Trade/service/firebase_service.dart';
import 'package:edirnebenim/Trade/values/saved_trades.dart';
import 'package:edirnebenim/Trade/values/trades.dart';
import 'package:edirnebenim/Trade/view/details_view.dart';
import 'package:edirnebenim/Values/my_user.dart';
import 'package:edirnebenim/config.dart';
import 'package:edirnebenim/locator.dart';
import 'package:edirnebenim/utilities/format_quantity.dart';
import 'package:flutter/material.dart';

class TradeItem extends StatelessWidget {
  TradeItem({
    required this.index,
    this.customTrade,
    this.isSavedTrades = false,
    this.isCategoryBasedTrades = false,
    this.categoryName,
    super.key,
  });
  bool loading = false;
  final int index;
  final bool isSavedTrades;
  final bool isCategoryBasedTrades;
  final String? categoryName;
  final trades = Trades();
  final myUser = locator<MyUser>();
  final savedTrades = SavedTrades();
  final authService = AuthService();
  final TradeModel? customTrade;

  @override
  Widget build(BuildContext context) {
    final TradeModel? trade;
    if (isSavedTrades) {
      trade = savedTrades.getIndex(atIndex: index);
    } else if (isCategoryBasedTrades) {
      trade = trades.getCategoryBasedIndex(
        atIndex: index,
        subcategoryName: categoryName!,
      );
    } else if (customTrade != null) {
      trade = customTrade;
    } else {
      trade = trades.getIndex(atIndex: index);
    }

    return Container(
      margin: const EdgeInsets.all(3),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute<TradeDetailScreen>(
              maintainState: false,
              builder: (context) => TradeDetailScreen(
                tradeModel: trade ?? TradeModel(),
              ),
            ),
          );
        },
        child: Container(
          width: (MediaQuery.of(context).size.width - 58) / 3,
          decoration: BoxDecoration(
            border: Border.all(
              width: 2,
              color: const Color.fromARGB(255, 233, 236, 237),
            ),
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(8),
                  topLeft: Radius.circular(8),
                ),
                child: Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    Stack(
                      children: [
                        ImageFiltered(
                          imageFilter: ImageFilter.blur(
                            sigmaX: 6,
                            sigmaY: 6,
                          ),
                          child: AppCachedNetworkImage(
                            imageUrl: trade?.photos?[0],
                            fit: BoxFit.fitWidth,
                            height: 100,
                            width: (MediaQuery.of(context).size.width - 58) / 2,
                          ),
                        ),
                        Hero(
                          tag: trade?.docID ?? 'null',
                          child: Material(
                            color: Colors.transparent,
                            child: AppCachedNetworkImage(
                              imageUrl: trade?.photos?[0],
                              fit: BoxFit.contain,
                              height: 100,
                              width:
                                  (MediaQuery.of(context).size.width - 58) / 2,
                            ),
                          ),
                        ),
                      ],
                    ),
                    ValueListenableBuilder(
                      valueListenable: SavedTrades(),
                      builder: (context, value, _) {
                        final isSaved =
                            SavedTrades().containID(id: trade?.docID ?? '');

                        return InkWell(
                          onTap: authService.authorizedControl(
                            context,
                            function: () async {
                              await TradeFirebaseService().setSavedTrade(
                                trade: trade!,
                              );
                            },
                          ),
                          borderRadius: BorderRadius.circular(999),
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            margin: const EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              color: isSaved
                                  ? AppConfig.tradePrimaryColor
                                  : Colors.white.withOpacity(.3),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              isSaved ? Icons.bookmark : Icons.bookmark_outline,
                              size: 22,
                              color: isSaved ? Colors.white : Colors.grey[800],
                            ),
                          ),
                        );
                      },
                    )
                  ],
                ),
              ),
              const SizedBox(height: 5),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      (trade?.title).toString(),
                      overflow: TextOverflow.fade,
                      maxLines: 2,
                      textAlign: TextAlign.start,
                      style: AppConfig.font.copyWith(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: trade?.category ?? 'null',
                            style: AppConfig.font.copyWith(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: AppConfig.tradePrimaryColor,
                            ),
                          ),
                          TextSpan(
                            text: ' - ',
                            style: AppConfig.font.copyWith(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: AppConfig.tradeTextColor,
                            ),
                          ),
                          TextSpan(
                            text: trade?.subcategory ?? 'null',
                            style: AppConfig.font.copyWith(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: AppConfig.tradeSecondaryColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          trade?.region ?? 'null',
                          overflow: TextOverflow.fade,
                          maxLines: 1,
                          textAlign: TextAlign.start,
                          style: AppConfig.font.copyWith(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: Colors.yellow[800],
                          ),
                        ),
                        Text(
                          '${formatQuantity(trade?.price)}₺',
                          overflow: TextOverflow.fade,
                          maxLines: 1,
                          textAlign: TextAlign.end,
                          style: AppConfig.font.copyWith(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
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
