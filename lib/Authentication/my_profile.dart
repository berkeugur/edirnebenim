import 'package:edirnebenim/Authentication/EditProfile/profile_edit.dart';
import 'package:edirnebenim/Authentication/auth_service.dart';
import 'package:edirnebenim/Authentication/user_model.dart';
import 'package:edirnebenim/Values/my_user.dart';
import 'package:edirnebenim/config.dart';
import 'package:edirnebenim/locator.dart';
import 'package:edirnebenim/utilities/app_buttons.dart';
import 'package:edirnebenim/utilities/mediaquery.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class MyProfileScreen extends StatefulWidget {
  const MyProfileScreen({super.key});

  @override
  State<MyProfileScreen> createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends State<MyProfileScreen> {
  MyUser myUser = locator<MyUser>();

  //Widget Config
  final Color profileBackground = const Color.fromARGB(255, 8, 62, 253);
  final String _appBarTitle = 'Profilim';
  final TextStyle _textStyle = AppConfig.font;
  final String _listtileTitle1 = '2. El veya Sıfır Ürün Paylaşımlarım';
  final String _listtileTitle2 = 'İş İlanları Paylaşımları';
  final String _logoutText = 'Çıkış Yap';
  final String _editProfileText = 'Profili Düzenle';
  final String _comingSoonText = 'Yakında';
  final String _displayName =
      '${MyUser().value?.name} ${MyUser().value?.surname}';

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: myUser,
      builder: (context, value, child) {
        return Scaffold(
          appBar: _appbar(context),
          body: _body(context),
        );
      },
    );
  }

  Column _body(BuildContext context) {
    return Column(
      children: [
        _header(context),
        const SizedBox(height: 18),
        Column(
          children: [
            if (false)
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 18, vertical: 9),
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey),
                ),
                child: ListTile(
                  title: Text(_listtileTitle1),
                  trailing: const Icon(
                    Iconsax.arrow_right_3,
                    size: 24,
                  ),
                ),
              ),
            if (false)
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 18, vertical: 9),
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey),
                ),
                child: ListTile(
                  title: Text(_listtileTitle2),
                  subtitle: Text(
                    _comingSoonText,
                    style: _textStyle.copyWith(
                      color: AppConfig.tradePrimaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  trailing: const Icon(
                    Iconsax.arrow_right_3,
                    size: 24,
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 18),
        AppButtons(context).futureButton(
          backgroundColor: profileBackground,
          textColor: Colors.white,
          indicator: const CircularProgressIndicator(
            color: Colors.white,
          ),
          text: _logoutText,
          function: () async {
            await AuthService().signOut(context);
          },
        ),
        const SizedBox(height: 18),
        SizedBox(
          child: AppButtons(context).futureButton(
            border: Border.all(
              color: profileBackground,
            ),
            indicator: CircularProgressIndicator(
              color: profileBackground,
            ),
            backgroundColor: Colors.white,
            textColor: profileBackground,
            text: _editProfileText,
            function: () async {
              await Navigator.of(context).push(
                MaterialPageRoute<Widget>(
                  builder: (context) => const ProfileEditScreen(),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Container _header(BuildContext context) {
    return Container(
      width: context.width,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: profileBackground,
        /*  borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ), */
      ),
      child: Column(
        children: [
          //if (MyUser().value?.photoURL != null)
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
                MyUser().value?.photoURL ?? UserModel().photoURL,
              ),
            ),
          ),
          //if (MyUser().value?.photoURL == null)

          const SizedBox(height: 18),
          Text(
            _displayName,
            style: _textStyle.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
        ],
      ),
    );
  }

  AppBar _appbar(BuildContext context) {
    return AppBar(
      backgroundColor: profileBackground,
      shadowColor: Colors.transparent,
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
        _appBarTitle,
        style: _textStyle.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      actions: [
        IconButton(
          onPressed: () {
            Navigator.of(context).maybePop();
          },
          icon: const Icon(
            Iconsax.setting_2,
            color: Colors.white,
            size: 25,
          ),
        ),
      ],
    );
  }
}
