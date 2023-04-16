import 'package:edirnebenim/Trade/values/trade_categories.dart';
import 'package:edirnebenim/Trade/view/subcategories.dart';
import 'package:edirnebenim/config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:iconsax/iconsax.dart';

class TradeCategoriesView extends StatelessWidget {
  TradeCategoriesView({
    required this.isForAddNewTrade,
    super.key,
  });
  final bool isForAddNewTrade;

  final tradeCategories = TradeCategories();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppConfig.tradePrimaryColor,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).maybePop();
          },
          icon: const Icon(
            Iconsax.arrow_left_2,
            color: Colors.white,
            size: 25,
          ),
        ),
        title: Text(
          isForAddNewTrade ? 'Ne satıyorsunuz?' : AppConfig.categories,
          style: AppConfig.font.copyWith(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: AnimationLimiter(
        child: ValueListenableBuilder(
          valueListenable: tradeCategories,
          builder: (context, value, _) {
            return ListView.builder(
              itemCount: tradeCategories.length,
              itemBuilder: (context, index) {
                return AnimationConfiguration.staggeredList(
                  position: index,
                  delay: const Duration(milliseconds: 100),
                  child: SlideAnimation(
                    duration: const Duration(milliseconds: 1500),
                    curve: Curves.fastLinearToSlowEaseIn,
                    horizontalOffset: 30,
                    verticalOffset: 300,
                    child: FlipAnimation(
                      duration: const Duration(milliseconds: 2500),
                      curve: Curves.fastLinearToSlowEaseIn,
                      flipAxis: FlipAxis.y,
                      child: listItem(context, index),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  InkWell listItem(BuildContext context, int index) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute<TradeSubCategoriesView>(
            builder: (context) => TradeSubCategoriesView(
              categoryIndex: index,
              isForAddNewTrade: isForAddNewTrade,
            ),
          ),
        );
      },
      child: Column(
        children: [
          const Divider(),
          ListTile(
            title: Text(
              tradeCategories.getTitles[index],
              style: AppConfig.font.copyWith(
                color: AppConfig.tradeTextColor,
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            //subtitle:Text(tradeCategories.getSubCategories[index].toString()),
            trailing: Icon(
              Icons.arrow_forward_ios,
              weight: 2.5,
              color: AppConfig.tradeTextColor,
            ),
          ),
          const Divider(),
        ],
      ),
    );
  }
}
