import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edirnebenim/Authentication/auth_service.dart';
import 'package:edirnebenim/Authentication/widgets/input_field.dart';
import 'package:edirnebenim/Values/my_user.dart';
import 'package:edirnebenim/config.dart';
import 'package:edirnebenim/locator.dart';
import 'package:edirnebenim/utilities/app_buttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:iconsax/iconsax.dart';

class NameChangeScreen extends StatefulWidget {
  const NameChangeScreen({super.key});

  @override
  State<NameChangeScreen> createState() => _NameChangeScreenState();
}

class _NameChangeScreenState extends State<NameChangeScreen> {
  late TextEditingController nameController;
  MyUser myUser = locator<MyUser>();
  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: myUser.name);
  }

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        shadowColor: Colors.transparent,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).maybePop();
          },
          icon: Icon(
            Iconsax.arrow_left_2,
            color: AppConfig.tradeTextColor,
            size: 25,
          ),
        ),
        title: Text(
          'Adını Düzenle',
          style: AppConfig.font.copyWith(
            color: AppConfig.tradeTextColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18),
        child: Column(
          children: [
            InputField(
              hintText: 'Adınız',
              suffixIcon: const SizedBox(),
              controller: nameController,
              onChanged: (p0) {
                setState(() {});
              },
            ),
            const SizedBox(height: 18),
            AppButtons.roundedButton(
              borderRadius: BorderRadius.circular(12),
              backgroundColor: nameController.text == myUser.name
                  ? Colors.grey[300]
                  : AppConfig.tradePrimaryColor,
              function: () async {
                //await FirebaseFirestore.instance.collection("users").doc(F)
              },
              text: 'Güncelle',
            ),
          ],
        ),
      ),
    );
  }
}
