import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edirnebenim/Authentication/auth_service.dart';
import 'package:edirnebenim/Authentication/user_model.dart';
import 'package:edirnebenim/Message/chat_view.dart';
import 'package:edirnebenim/Trade/models/trade_model.dart';
import 'package:edirnebenim/Trade/view/widgets/trade_item.dart';
import 'package:edirnebenim/Values/my_user.dart';
import 'package:edirnebenim/config.dart';
import 'package:edirnebenim/locator.dart';
import 'package:edirnebenim/utilities/app_buttons.dart';
import 'package:edirnebenim/utilities/mediaquery.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:iconsax/iconsax.dart';

class OtherProfileScreen extends StatefulWidget {
  const OtherProfileScreen({
    required this.otherUser,
    super.key,
  });
  final UserModel otherUser;
  @override
  State<OtherProfileScreen> createState() => _OtherProfileScreenState();
}

class _OtherProfileScreenState extends State<OtherProfileScreen> {
  MyUser myUser = locator<MyUser>();

  //Widget Config
  final Color profileBackground = const Color.fromARGB(255, 8, 62, 253);
  final TextStyle _textStyle = AppConfig.font;

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
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: FutureBuilder(
              future: FirebaseFirestore.instance
                  .collection('trades')
                  .where('uid', isEqualTo: widget.otherUser.userID)
                  .withConverter<TradeModel>(
                    fromFirestore: (snapshot, _) =>
                        TradeModel.fromJson(snapshot.data()!),
                    toFirestore: (model, _) => model.toJson(),
                  )
                  .get(),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                    return const Text('none');
                  case ConnectionState.waiting:
                    return const CircularProgressIndicator();
                  case ConnectionState.active:
                    return const Text('active');
                  case ConnectionState.done:
                    return MasonryGridView.count(
                      padding: const EdgeInsets.only(bottom: 70),
                      shrinkWrap: true,
                      itemCount: snapshot.data?.docs.length ?? 0,
                      crossAxisCount: 2,
                      mainAxisSpacing: 2,
                      crossAxisSpacing: 2,
                      itemBuilder: (context, index) => TradeItem(
                        index: index,
                        customTrade: snapshot.data?.docs[index].data(),
                      ),
                    );
                }
              },
            ),
          ),
        ),
        const SizedBox(height: 18),
      ],
    );
  }

  Container _header(BuildContext context) {
    final displayName = '${widget.otherUser.name} ${widget.otherUser.surname}';
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
              backgroundImage: NetworkImage(widget.otherUser.photoURL),
            ),
          ),
          //if (MyUser().value?.photoURL == null)

          const SizedBox(height: 18),
          Text(
            displayName,
            style: _textStyle.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          const SizedBox(height: 18),
          SizedBox(
            child: AppButtons(context).futureButton(
              border: Border.all(
                color: Colors.white,
              ),
              indicator: CircularProgressIndicator(
                color: profileBackground,
              ),
              backgroundColor: profileBackground,
              textColor: Colors.white,
              text: 'Mesaj Gönder',
              function: () async {
                AuthService().authorizedControl(
                  context,
                  function: () async {
                    await Navigator.of(context).push(
                      MaterialPageRoute<ChatView>(
                        maintainState: false,
                        builder: (context) => ChatView(user: widget.otherUser),
                      ),
                    );
                  },
                )?.call();
              },
            ),
          ),
        ],
      ),
    );
  }

  AppBar _appbar(BuildContext context) {
    final displayName = '${widget.otherUser.name} ${widget.otherUser.surname}';
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
        displayName,
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
