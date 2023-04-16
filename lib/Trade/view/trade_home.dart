import 'package:edirnebenim/Authentication/auth_service.dart';
import 'package:edirnebenim/Trade/service/trade_pagination.dart';
import 'package:edirnebenim/Trade/values/trade_categories.dart';
import 'package:edirnebenim/Trade/values/trade_location.dart';
import 'package:edirnebenim/Trade/values/trades.dart';
import 'package:edirnebenim/Trade/view/all_recents.dart';
import 'package:edirnebenim/Trade/view/categories.dart';
import 'package:edirnebenim/Trade/view/subcategories.dart';
import 'package:edirnebenim/Trade/view/widgets/trade_item.dart';
import 'package:edirnebenim/Values/my_user.dart';
import 'package:edirnebenim/config.dart';
import 'package:edirnebenim/locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:iconsax/iconsax.dart';

class TradeHome extends StatefulWidget {
  const TradeHome({super.key});

  @override
  State<TradeHome> createState() => _TradeHomeState();
}

class _TradeHomeState extends State<TradeHome> {
  final tradeCategories = TradeCategories();
  late ScrollController _scrollController;
  AuthService authService = AuthService();
  MyUser myUser = locator<MyUser>();
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
    return Padding(
      padding: EdgeInsets.only(top: MediaQuery.of(context).viewPadding.top),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              //color: Colors.orange,
              height: 50,
              child: _appbar(context),
            ),
            SizedBox(
              //color: Colors.red,
              height: 60,
              child: _categoriesTitle(context),
            ),
            SizedBox(
              //color: Colors.brown,
              height: (MediaQuery.of(context).size.width - 58) / 3 * 2 + 12,
              child: _categories(),
            ),
            SizedBox(
              //color: Colors.blueAccent,
              height: 60,
              child: _lastTradesTitle(context),
            ),
            Container(
              //color: Colors.amber,
              child: _lastTrades(),
            ),
          ],
        ),
      ),
    );
  }

  Padding _lastTradesTitle(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 18, right: 18, top: 18),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'En son paylaşılanlar',
            style: AppConfig.font.copyWith(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppConfig.tradeTextColor,
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute<Widget>(
                  builder: (context) => const AllRecentsScreen(),
                ),
              );
            },
            child: Text(
              'Tümünü gör',
              style: AppConfig.font.copyWith(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: const Color.fromARGB(255, 169, 178, 186),
              ),
            ),
          )
        ],
      ),
    );
  }

  Padding _categories() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: ValueListenableBuilder(
        valueListenable: tradeCategories,
        builder: (context, value, child) => Wrap(
          spacing: 2,
          children: List.generate(
            tradeCategories.length > 6 ? 6 : tradeCategories.length,
            (index) => Container(
              margin: const EdgeInsets.all(3),
              child: InkWell(
                borderRadius: BorderRadius.circular(10),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute<Widget>(
                      builder: (context) => TradeSubCategoriesView(
                        categoryIndex: index,
                        isForAddNewTrade: false,
                      ),
                    ),
                  );
                },
                child: Container(
                  width: (MediaQuery.of(context).size.width - 58) / 3,
                  height: (MediaQuery.of(context).size.width - 58) / 3,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
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
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        tradeCategories.getCategoryIconPath[index] ??
                            'assets/categories/default.png',
                        height: 32,
                        width: 32,
                      ),
                      const SizedBox(height: 5),
                      Text(
                        tradeCategories.getTitles[index],
                        overflow: TextOverflow.fade,
                        maxLines: 2,
                        textAlign: TextAlign.center,
                        style: AppConfig.font.copyWith(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Padding _categoriesTitle(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 18, right: 18, top: 18),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Ne arıyorsun?',
            style: AppConfig.font.copyWith(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppConfig.tradeTextColor,
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute<TradeCategoriesView>(
                  builder: (context) => TradeCategoriesView(
                    isForAddNewTrade: false,
                  ),
                ),
              );
            },
            child: Text(
              'Tümünü gör',
              style: AppConfig.font.copyWith(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: const Color.fromARGB(255, 169, 178, 186),
              ),
            ),
          )
        ],
      ),
    );
  }

  Padding _appbar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        right: 18,
        left: 18,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () {},
            icon: Icon(
              Iconsax.setting_2,
              color: AppConfig.tradeTextColor,
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 5,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(99),
              border: Border.all(
                color: AppConfig.tradeTextColor,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Iconsax.location,
                  color: AppConfig.tradeTextColor,
                ),
                const SizedBox(width: 5),
                Text(
                  TradeLocation().getCity,
                  style: AppConfig.font.copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: AppConfig.tradeTextColor,
                  ),
                ),
                if (TradeLocation().getRegions != null)
                  Text(
                    ", ${TradeLocation().getRegions ?? "Tümü"}",
                    style: AppConfig.font.copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: AppConfig.tradeTextColor,
                    ),
                  ),
              ],
            ),
          ),
          ValueListenableBuilder(
            valueListenable: myUser,
            builder: (context, value, _) {
              return InkWell(
                onTap: AuthService().authorizedControl(
                  context,
                ),
                child: myUser.profilePhoto == null
                    ? Icon(
                        Iconsax.user,
                        color: AppConfig.tradeTextColor,
                      )
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(99),
                        child: Image.network(myUser.profilePhoto!),
                      ),
              );
            },
          )
        ],
      ),
    );
  }

  Padding _lastTrades() {
    var loading = false;
    final trades = Trades();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: ValueListenableBuilder(
        valueListenable: trades,
        builder: (context, value, child) => NotificationListener(
          onNotification: (t) {
            final nextPageTrigger =
                0.8 * _scrollController.positions.last.maxScrollExtent;

            if (_scrollController.positions.last.axisDirection ==
                    AxisDirection.down &&
                _scrollController.positions.last.pixels >= nextPageTrigger) {
              if (loading == false) {
                loading = true;
                TradePaginationService().addMoreTradeData();

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
            itemCount: trades.length,
            crossAxisCount: 2,
            mainAxisSpacing: 2,
            crossAxisSpacing: 2,
            itemBuilder: (context, index) => TradeItem(index: index),
          ),
        ),
      ),
    );
  }
}
