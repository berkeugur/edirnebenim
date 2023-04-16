import 'package:edirnebenim/Trade/models/trade_model.dart';
import 'package:edirnebenim/Trade/values/trade_categories.dart';
import 'package:edirnebenim/Trade/view/add/add_info.dart';
import 'package:edirnebenim/Trade/view/category_based_view.dart';
import 'package:edirnebenim/config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:iconsax/iconsax.dart';

class TradeSubCategoriesView extends StatelessWidget {
  TradeSubCategoriesView({
    required this.categoryIndex,
    required this.isForAddNewTrade,
    super.key,
  });
  final int categoryIndex;
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
          tradeCategories.getTitles[categoryIndex],
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
              itemCount: tradeCategories.getSubCategories[categoryIndex].length,
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
        if (isForAddNewTrade) {
          Navigator.of(context).push(
            MaterialPageRoute<Widget>(
              builder: (context) => AddTradeInfoView(
                tradeModel: TradeModel(
                  category: tradeCategories.getTitles[categoryIndex],
                  subcategory: tradeCategories.getSubCategories[categoryIndex]
                      [index],
                ),
              ),
            ),
          );
        } else {
          Navigator.of(context).push(
            MaterialPageRoute<Widget>(
              builder: (context) => CategoryBasedScreen(
                subcategoryName: tradeCategories.getSubCategories[categoryIndex]
                    [index],
              ),
            ),
          );
        }
      },
      child: Column(
        children: [
          const Divider(),
          ListTile(
            title: Text(
              tradeCategories.getSubCategories[categoryIndex][index],
              style: AppConfig.font.copyWith(
                color: AppConfig.tradeTextColor,
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            //subtitle:Text(tradeCategories.getSubCategories[index].toString()),
            trailing: Icon(
              Iconsax.arrow_right_3,
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
