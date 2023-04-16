import 'package:edirnebenim/Trade/models/trade_model.dart';
import 'package:edirnebenim/Trade/values/trade_regions.dart';
import 'package:edirnebenim/Trade/view/add/add_info.dart';
import 'package:edirnebenim/Trade/view/add/add_photos.dart';
import 'package:edirnebenim/config.dart';
import 'package:edirnebenim/Trade/values/trade_categories.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:iconsax/iconsax.dart';

class TradeRegionsView extends StatelessWidget {
  TradeRegionsView({
    required this.cityIndex,
    required this.tradeModel,
    super.key,
  });
  final int cityIndex;
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
          regions.getTitles[cityIndex],
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
              itemCount: regions.getSubRegions[cityIndex].length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    tradeModel
                      ..city = regions.getTitles[cityIndex]
                      ..region = regions.getSubRegions[cityIndex][index]
                      ..country = 'Turkiye';
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => AddPhotos(
                          tradeModel: tradeModel,
                        ),
                      ),
                    );
                  },
                  child: AnimationConfiguration.staggeredList(
                    position: index,
                    delay: const Duration(milliseconds: 100),
                    child: SlideAnimation(
                      duration: const Duration(milliseconds: 1500),
                      curve: Curves.fastLinearToSlowEaseIn,
                      horizontalOffset: 30,
                      verticalOffset: 300.0,
                      child: FlipAnimation(
                        duration: const Duration(milliseconds: 2500),
                        curve: Curves.fastLinearToSlowEaseIn,
                        flipAxis: FlipAxis.y,
                        child: Column(
                          children: [
                            const Divider(),
                            ListTile(
                              title: Text(
                                regions.getSubRegions[cityIndex][index],
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
