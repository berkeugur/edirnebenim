import 'package:edirnebenim/Trade/models/trade_model.dart';
import 'package:edirnebenim/Trade/values/trade_categories.dart';
import 'package:edirnebenim/Trade/values/trade_regions.dart';
import 'package:edirnebenim/Trade/view/add/select_regions.dart';
import 'package:edirnebenim/Trade/view/subcategories.dart';
import 'package:edirnebenim/config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:iconsax/iconsax.dart';

class TradeCitiesView extends StatelessWidget {
  TradeCitiesView({
    required this.tradeModel,
    super.key,
  });
  final TradeModel tradeModel;
  final regions = TradeRegions();
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
          "Şehir seçin",
          style: AppConfig.font.copyWith(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: AnimationLimiter(
        child: ValueListenableBuilder(
          valueListenable: regions,
          builder: (context, value, _) {
            return ListView.builder(
              itemCount: regions.length,
              itemBuilder: (context, index) {
                return AnimationConfiguration.staggeredList(
                  position: index,
                  delay: Duration(milliseconds: 100),
                  child: SlideAnimation(
                    duration: Duration(milliseconds: 1500),
                    curve: Curves.fastLinearToSlowEaseIn,
                    horizontalOffset: 30,
                    verticalOffset: 300.0,
                    child: FlipAnimation(
                      duration: Duration(milliseconds: 2500),
                      curve: Curves.fastLinearToSlowEaseIn,
                      flipAxis: FlipAxis.y,
                      child: InkWell(
                        onTap: () {
                          tradeModel.city = regions.getTitles[index];
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => TradeRegionsView(
                              cityIndex: index,
                              tradeModel: tradeModel,
                            ),
                          ));
                        },
                        child: Column(
                          children: [
                            const Divider(),
                            ListTile(
                              title: Text(
                                regions.getTitles[index],
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
                      ),
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
}
