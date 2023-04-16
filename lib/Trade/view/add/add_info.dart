import 'package:edirnebenim/Trade/models/trade_model.dart';
import 'package:edirnebenim/Trade/view/add/select_city_view.dart';
import 'package:edirnebenim/config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconsax/iconsax.dart';

class AddTradeInfoView extends StatefulWidget {
  const AddTradeInfoView({
    required this.tradeModel,
    super.key,
  });
  final TradeModel tradeModel;
  @override
  State<AddTradeInfoView> createState() => _AddTradeInfoViewState();
}

class _AddTradeInfoViewState extends State<AddTradeInfoView> {
  late TextEditingController titleController;
  late TextEditingController explanationController;
  late TextEditingController priceController;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController();
    explanationController = TextEditingController();
    priceController = TextEditingController();
  }

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool checkFields() {
    final form = formKey.currentState;
    if (form!.validate()) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Container(
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewPadding.bottom + 18,
          left: 18,
          right: 18,
        ),
        child: InkWell(
          onTap: () {
            if (checkFields()) {
              print(widget.tradeModel.toJson());
              widget.tradeModel
                ..title = titleController.text
                ..explanation = explanationController.text
                ..price = double.tryParse(priceController.text);
              print(widget.tradeModel.toJson());
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => TradeCitiesView(
                    tradeModel: widget.tradeModel,
                  ),
                ),
              );
            }
          },
          borderRadius: BorderRadius.circular(99),
          child: Container(
            height: 50,
            decoration: BoxDecoration(
              color: AppConfig.tradePrimaryColor,
              borderRadius: BorderRadius.circular(99),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Devam et',
                  style: AppConfig.font.copyWith(
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    fontSize: 16,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
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
          'Biraz bilgi ekle',
          style: AppConfig.font.copyWith(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          'İlan Başlığı*',
                          style: AppConfig.font.copyWith(
                            fontSize: 16,
                            color: AppConfig.tradeTextColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                  ],
                ),
                TextFormField(
                  controller: titleController,
                  keyboardType: TextInputType.text,
                  validator: (value) =>
                      value!.isEmpty ? 'Lütfen boş bırakmayınız.' : null,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 15),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey[400]!),
                      borderRadius: const BorderRadius.all(
                        Radius.circular(999),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: AppConfig.tradePrimaryColor,
                        width: 2,
                      ),
                      borderRadius: const BorderRadius.all(
                        Radius.circular(999),
                      ),
                    ),
                    hintText: 'Başlık',
                    hintStyle: AppConfig.font.copyWith(
                      color: Colors.grey[500],
                    ),
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(999),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  'Ürünün temel özelliklerinden kısaca bahset (ör. marka, model, yaş, tip)',
                  style: AppConfig.font.copyWith(
                    fontSize: 12,
                  ),
                ),

                ///////
                ///
                const SizedBox(height: 30),

                ///
                ///

                Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          'Ne Sattığını Açıkla*',
                          style: AppConfig.font.copyWith(
                            fontSize: 16,
                            color: AppConfig.tradeTextColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                  ],
                ),
                TextFormField(
                  controller: explanationController,
                  keyboardType: TextInputType.text,
                  validator: (value) =>
                      value!.isEmpty ? 'Lütfen boş bırakmayınız.' : null,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 15),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey[400]!),
                      borderRadius: const BorderRadius.all(
                        Radius.circular(999),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: AppConfig.tradePrimaryColor,
                        width: 2,
                      ),
                      borderRadius: const BorderRadius.all(
                        Radius.circular(999),
                      ),
                    ),
                    hintText: 'Açıklama',
                    hintStyle: AppConfig.font.copyWith(
                      color: Colors.grey[500],
                    ),
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(999),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  'Durum, özellik ve satma nedeni gibi bilgileri ekle',
                  style: AppConfig.font.copyWith(
                    fontSize: 12,
                  ),
                ),

                ///////
                ///
                const SizedBox(height: 30),

                ///
                ///

                Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          'Fiyat Belirle*',
                          style: AppConfig.font.copyWith(
                            fontSize: 16,
                            color: AppConfig.tradeTextColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                  ],
                ),
                TextFormField(
                  controller: priceController,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$'))
                  ],
                  validator: (value) =>
                      value!.isEmpty ? 'Lütfen boş bırakmayınız.' : null,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 15),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey[400]!),
                      borderRadius: const BorderRadius.all(
                        Radius.circular(999),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: AppConfig.tradePrimaryColor,
                        width: 2,
                      ),
                      borderRadius: const BorderRadius.all(
                        Radius.circular(999),
                      ),
                    ),
                    hintText: 'Fiyat',
                    hintStyle: AppConfig.font.copyWith(
                      color: Colors.grey[500],
                    ),
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(999),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  'Daha hızlı satılması için uygun fiyat belirle',
                  style: AppConfig.font.copyWith(
                    fontSize: 12,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
