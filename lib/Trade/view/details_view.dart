import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edirnebenim/Authentication/auth_service.dart';
import 'package:edirnebenim/Authentication/my_profile.dart';
import 'package:edirnebenim/Authentication/other_profile.dart';
import 'package:edirnebenim/Authentication/user_model.dart';
import 'package:edirnebenim/Message/chat_view.dart';
import 'package:edirnebenim/Packages/cache_network_images.dart';
import 'package:edirnebenim/Trade/models/trade_model.dart';
import 'package:edirnebenim/Trade/view/widgets/last_seen_text.dart';
import 'package:edirnebenim/Values/other_users.dart';
import 'package:edirnebenim/config.dart';
import 'package:edirnebenim/utilities/format_quantity.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class TradeDetailScreen extends StatelessWidget {
  const TradeDetailScreen({
    required this.tradeModel,
    super.key,
  });
  final TradeModel tradeModel;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Container(
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewPadding.bottom + 18,
          left: 18,
          right: 18,
        ),
        child: Row(
          children: [
            Expanded(
              child: InkWell(
                onTap: AuthService().authorizedControl(
                  context,
                  function: () async {
                    if (user != null) {
                      await Navigator.of(context).push(
                        MaterialPageRoute<ChatView>(
                          maintainState: false,
                          builder: (context) => ChatView(user: user!),
                        ),
                      );
                    }
                  },
                ),
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
                      const Icon(
                        Iconsax.message,
                        color: Colors.white,
                        size: 24,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        'Sohbet',
                        overflow: TextOverflow.fade,
                        maxLines: 1,
                        textAlign: TextAlign.end,
                        style: AppConfig.font.copyWith(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: Text(
                '${formatQuantity(tradeModel.price)}₺',
                overflow: TextOverflow.fade,
                maxLines: 1,
                textAlign: TextAlign.end,
                style: AppConfig.font.copyWith(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            PhotosWidget(tradeModel: tradeModel),
            Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    tradeModel.title ?? '',
                    style: AppConfig.font.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: AppConfig.tradeTextColor,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: tradeModel.category ?? 'null',
                          style: AppConfig.font.copyWith(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppConfig.tradePrimaryColor,
                          ),
                        ),
                        TextSpan(
                          text: ' - ',
                          style: AppConfig.font.copyWith(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppConfig.tradeTextColor,
                          ),
                        ),
                        TextSpan(
                          text: tradeModel.subcategory ?? 'null',
                          style: AppConfig.font.copyWith(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppConfig.tradeSecondaryColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Icon(Iconsax.location),
                      const SizedBox(width: 5),
                      Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: tradeModel.region ?? 'null',
                              style: AppConfig.font.copyWith(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: AppConfig.tradeTextColor,
                              ),
                            ),
                            TextSpan(
                              text: ', ',
                              style: AppConfig.font.copyWith(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: AppConfig.tradeTextColor,
                              ),
                            ),
                            TextSpan(
                              text: tradeModel.city ?? 'null',
                              style: AppConfig.font.copyWith(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: AppConfig.tradeTextColor,
                              ),
                            ),
                            TextSpan(
                              text: ', ',
                              style: AppConfig.font.copyWith(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: AppConfig.tradeTextColor,
                              ),
                            ),
                            TextSpan(
                              text: tradeModel.country ?? 'null',
                              style: AppConfig.font.copyWith(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: AppConfig.tradeTextColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    tradeModel.explanation ?? '',
                    style: AppConfig.font.copyWith(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                      color: AppConfig.tradeTextColor,
                    ),
                  ),
                  const SizedBox(height: 10),
                  UserCard(tradeModel: tradeModel),
                  const SizedBox(height: 10),
                  ReportTradeButton(tradeModel: tradeModel),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

UserModel? user;

class UserCard extends StatelessWidget {
  UserCard({
    required this.tradeModel,
    super.key,
  });

  final TradeModel tradeModel;
  final Users users = Users();
  @override
  Widget build(BuildContext context) {
    users.getUserFromFirebaseWithUID(
      id: tradeModel.uid!,
      enableIsContain: true,
    );
    return InkWell(
      onTap: () {
        if (tradeModel.uid == AuthService.user?.uid) {
          Navigator.of(context).push(
            MaterialPageRoute<Widget>(
              builder: (context) => const MyProfileScreen(),
            ),
          );
        } else {
          if (tradeModel.uid != null) {
            final otherUser = users.searchID(id: tradeModel.uid!);
            if (otherUser != null) {
              Navigator.of(context).push(
                MaterialPageRoute<Widget>(
                  builder: (context) => OtherProfileScreen(
                    otherUser: otherUser,
                  ),
                ),
              );
            }
          }
        }
      },
      child: ValueListenableBuilder(
        valueListenable: users,
        builder: (context, _, __) {
          user = users.searchID(id: tradeModel.uid!);
          if (user == null) {
            return const SizedBox.shrink();
          }
          return Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              border: Border.all(
                color: const Color.fromARGB(255, 233, 236, 237),
              ),
              borderRadius: BorderRadius.circular(5),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    if (user?.photoURL != null)
                      CircleAvatar(
                        radius: 28,
                        backgroundImage: NetworkImage(user!.photoURL),
                      ),
                    if (user?.photoURL == null)
                      const CircleAvatar(
                        radius: 28,
                        child: Icon(Iconsax.user_octagon),
                      ),
                    if (user?.photoURL != null) const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user?.name ?? '',
                          style: AppConfig.font.copyWith(fontSize: 18),
                        ),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(3),
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.green,
                              ),
                            ),
                            const SizedBox(width: 5),
                            if (user?.lastSeen != null)
                              Text(
                                lastSeenText(
                                  date: user!.lastSeen!,
                                  isOnline: user!.isOnline,
                                ),
                                style: AppConfig.font.copyWith(fontSize: 14),
                              ),
                          ],
                        )
                      ],
                    ),
                  ],
                ),
                const Icon(
                  Iconsax.arrow_right_3,
                  size: 26,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class ReportTradeButton extends StatelessWidget {
  const ReportTradeButton({
    required this.tradeModel,
    super.key,
  });

  final TradeModel tradeModel;

  @override
  Widget build(BuildContext context) {
    final isLoading = ValueNotifier<bool>(false);
    final counter = ValueNotifier<int>(0);

    return OutlinedButton(
      onPressed: () async {
        if (isLoading.value == false && counter.value == 0) {
          isLoading.value = true;
          await Future.delayed(const Duration(seconds: 3), () async {
            await FirebaseFirestore.instance.collection('reports').doc().set({
              'trade': tradeModel.toJson(),
              'from_uid': 'asdasdsa',
              'created_at': Timestamp.now()
            }).then((x) {
              isLoading.value = false;
              counter.value++;
            });
          });
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(9),
        child: ValueListenableBuilder(
          valueListenable: isLoading,
          builder: (context, value, widget) {
            if (value == false) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (counter.value == 0)
                    Icon(
                      Icons.report,
                      size: 32,
                      color: AppConfig.tradePrimaryColor,
                    ),
                  if (counter.value == 0) const SizedBox(width: 5),
                  if (counter.value == 0)
                    Text(
                      'İLANI ŞİKAYET ET',
                      style: AppConfig.font.copyWith(
                        fontWeight: FontWeight.w500,
                        fontSize: 18,
                        color: AppConfig.tradeTextColor,
                      ),
                    ),
                  if (counter.value != 0)
                    Text(
                      'Şikayetiniz Alındı',
                      style: AppConfig.font.copyWith(
                        fontWeight: FontWeight.w500,
                        fontSize: 18,
                        color: AppConfig.tradeTextColor,
                      ),
                    ),
                ],
              );
            } else {
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 36,
                    width: 36,
                    child: Row(
                      children: [
                        Column(
                          children: [
                            const CircularProgressIndicator(),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}

class PhotosWidget extends StatelessWidget {
  const PhotosWidget({
    required this.tradeModel,
    super.key,
  });

  final TradeModel tradeModel;

  @override
  Widget build(BuildContext context) {
    ValueNotifier<int> pageIndex = ValueNotifier(0);
    final height = ValueNotifier<double?>(0);
    Future.delayed(const Duration(milliseconds: 100), () {
      height.value = null;
    });
    return Stack(
      children: [
        Stack(
          alignment: Alignment.topRight,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height / 3,
              child: Stack(
                children: [
                  PageView(
                    onPageChanged: (value) {
                      pageIndex.value = value;
                    },
                    children:
                        List.generate(tradeModel.photos?.length ?? 0, (index) {
                      return Stack(
                        children: [
                          ImageFiltered(
                            imageFilter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
                            child: AppCachedNetworkImage(
                              imageUrl: tradeModel.photos?[index],
                              fit: BoxFit.fitWidth,
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.height / 3,
                            ),
                          ),
                          Hero(
                            tag: tradeModel.docID ?? 'null',
                            child: Material(
                              color: Colors.transparent,
                              child: AppCachedNetworkImage(
                                imageUrl: tradeModel.photos?[index],
                                height:
                                    MediaQuery.of(context).size.height / 3 + 18,
                                fit: BoxFit.fitHeight,
                                width: MediaQuery.of(context).size.width,
                              ),
                            ),
                          ),
                        ],
                      );
                    }),
                  ),
                  if ((tradeModel.photos?.length ?? 0) > 1)
                    Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                            tradeModel.photos?.length ?? 0,
                            (i) => ValueListenableBuilder(
                              valueListenable: pageIndex,
                              builder: (context, _, __) {
                                return Container(
                                  margin: const EdgeInsets.all(4),
                                  padding: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: i == pageIndex.value
                                        ? AppConfig.tradePrimaryColor
                                        : Colors.white,
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    )
                ],
              ),
            ),
            ValueListenableBuilder(
              valueListenable: height,
              builder: (context, _, __) {
                return AnimatedContainer(
                  duration: const Duration(seconds: 2),
                  height: height.value,
                  decoration: BoxDecoration(
                    boxShadow: [
                      const BoxShadow(),
                      BoxShadow(
                        color: height.value == 0
                            ? Colors.transparent
                            : Colors.black.withOpacity(.4),
                        spreadRadius: 120,
                        blurRadius: 10000,
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            InkWell(
              onTap: () => Navigator.of(context).pop(),
              borderRadius: BorderRadius.circular(999),
              child: Container(
                padding: const EdgeInsets.all(4),
                margin: EdgeInsets.only(
                  top: MediaQuery.of(context).viewPadding.top,
                  left: 9,
                ),
                child: const Icon(
                  Iconsax.arrow_left_2,
                  size: 32,
                  color: Colors.white,
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                InkWell(
                  onTap: () {},
                  borderRadius: BorderRadius.circular(999),
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    margin: EdgeInsets.only(
                      top: MediaQuery.of(context).viewPadding.top,
                      right: 9,
                    ),
                    child: const Icon(
                      Icons.share,
                      size: 28,
                      color: Colors.white,
                    ),
                  ),
                ),
                InkWell(
                  onTap: AuthService().authorizedControl(
                    context,
                    function: () async {
                      print('deneme');
                      await Future.delayed(
                        const Duration(seconds: 1),
                        () {
                          print('denem2');
                        },
                      );
                    },
                  ),
                  borderRadius: BorderRadius.circular(999),
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    margin: EdgeInsets.only(
                      top: MediaQuery.of(context).viewPadding.top,
                      right: 9,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(.9),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.bookmark_outline,
                      size: 28,
                      color: Colors.grey[800],
                    ),
                  ),
                ),
              ],
            ),
          ],
        )
      ],
    );
  }
}
