import 'package:edirnebenim/Authentication/EditProfile/item.dart';
import 'package:edirnebenim/Authentication/user_model.dart';
import 'package:edirnebenim/Values/my_user.dart';
import 'package:edirnebenim/config.dart';
import 'package:edirnebenim/locator.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class ProfileEditScreen extends StatefulWidget {
  const ProfileEditScreen({super.key});

  @override
  State<ProfileEditScreen> createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends State<ProfileEditScreen> {
  final TextStyle _textStyle = AppConfig.font;
  final myUser = locator<MyUser>();
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
          'Profil Düzenle',
          style: _textStyle.copyWith(
            color: AppConfig.tradeTextColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 18),
          DecoratedBox(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                width: 4,
                color: Colors.white,
              ),
            ),
            child: CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage(
                myUser.value?.photoURL ?? UserModel().photoURL,
              ),
            ),
          ),
          const SizedBox(height: 18),
          HomeItem(
            context: context,
            title: myUser.value?.name,
            subtitle: 'Adınız',
            emptyText: 'Adınız',
            /*  targetPage: SizedBox(), */
          ),
          HomeItem(
            context: context,
            title: myUser.value?.surname,
            subtitle: 'Soyadınız',
            emptyText: 'Soyadınız',
            /*  targetPage: SizedBox(), */
          ),
          HomeItem(
            context: context,
            title: myUser.value?.bio,
            subtitle: 'Kendiniz hakkında birkaç kelime ekleyin',
            emptyText: 'Kendinizi Tanıtın',
            /* targetPage: const ProfileEditBiographyChangeScreen(), */
          ),
          HomeItem(
            context: context,
            title: myUser.value?.phone,
            subtitle: 'Telefon Numaranız',
            emptyText: 'Telefon Numaranızı Ekleyebilirsiniz.',
            /* targetPage: const ProfileEditBiographyChangeScreen(), */
          ),
        ],
      ),
    );
  }
}
