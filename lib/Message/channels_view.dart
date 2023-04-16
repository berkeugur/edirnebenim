import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edirnebenim/Authentication/auth_service.dart';
import 'package:edirnebenim/Message/channel_model.dart';
import 'package:edirnebenim/Message/chat_view.dart';
import 'package:edirnebenim/Values/other_users.dart';
import 'package:edirnebenim/config.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';

class ChannelsView extends StatefulWidget {
  const ChannelsView({super.key});

  @override
  State<ChannelsView> createState() => _ChannelsViewState();
}

class _ChannelsViewState extends State<ChannelsView> {
  Stream<QuerySnapshot<ChannelModel>> getChannelsStream() {
    final snapshot = FirebaseFirestore.instance
        .collection('messages')
        .where(
          'users',
          arrayContains: AuthService.user?.uid,
        )
        .limit(15)
        .withConverter<ChannelModel>(
          fromFirestore: (snapshot, _) =>
              ChannelModel.fromJson(snapshot.data()!),
          toFirestore: (model, _) => model.toJson(),
        )
        .snapshots();

    return snapshot;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Padding(
        padding: EdgeInsets.only(
          top: MediaQuery.of(context).viewPadding.top,
          left: 18,
          right: 18,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 30,
                  child: Text(
                    'Mesajlar',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.rubik(
                      color: AppConfig.tradeTextColor,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            Expanded(
              child: StreamBuilder(
                stream: getChannelsStream(),
                builder: (context, snapshot) {
                  if (snapshot.hasData ||
                      snapshot.connectionState == ConnectionState.done) {
                    return ListView.builder(
                      padding: EdgeInsets.only(top: 0),
                      itemCount: snapshot.data?.docs.length ?? 0,
                      itemBuilder: (context, index) {
                        final channel = snapshot.data?.docs[index].data();
                        String? otheruserid;
                        if (channel?.users?.first == AuthService.user?.uid) {
                          otheruserid = channel?.users?[1];
                        } else {
                          otheruserid = channel?.users?[0];
                        }
                        final br = BorderRadius.circular(20);
                        return otheruserid == null
                            ? const SizedBox.shrink()
                            : FutureBuilder(
                                future: Users().getUserFromFirebaseWithUID(
                                  id: otheruserid,
                                  enableIsContain: true,
                                ),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                          ConnectionState.done ||
                                      snapshot.hasData) {
                                    final usermodel = snapshot.data!;
                                    return Container(
                                      margin: const EdgeInsets.only(
                                        bottom: 18,
                                      ),
                                      child: InkWell(
                                        borderRadius: br,
                                        onTap: () async {
                                          if (otheruserid != null) {
                                            if (usermodel != null) {
                                              await Navigator.of(context).push(
                                                MaterialPageRoute<ChatView>(
                                                  maintainState: false,
                                                  builder: (context) =>
                                                      ChatView(
                                                    user: usermodel,
                                                    channel: channel,
                                                  ),
                                                ),
                                              );
                                            }
                                          }
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 18,
                                            vertical: 9,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: br,
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black
                                                    .withOpacity(.03),
                                                offset: const Offset(0, 1),
                                                blurRadius: 3,
                                                spreadRadius: 1,
                                              )
                                            ],
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                  if (usermodel.photoURL !=
                                                      null)
                                                    CircleAvatar(
                                                      radius: 28,
                                                      backgroundImage:
                                                          NetworkImage(
                                                        usermodel.photoURL,
                                                      ),
                                                    ),
                                                  if (usermodel.photoURL ==
                                                      null)
                                                    const CircleAvatar(
                                                      radius: 28,
                                                      child: Icon(
                                                        Iconsax.user_octagon,
                                                      ),
                                                    ),
                                                  const SizedBox(width: 10),
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        '${usermodel.name} ${usermodel.surname}',
                                                        style: AppConfig.font
                                                            .copyWith(
                                                          fontSize: 18,
                                                        ),
                                                      ),
                                                      if (channel != null)
                                                        Text(
                                                          lastMessage(
                                                            channel,
                                                          ),
                                                        ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                              if (channel?.numberOfNewMessages !=
                                                      null &&
                                                  channel?.lastMessage
                                                          ?.idFrom !=
                                                      AuthService.user?.uid &&
                                                  channel?.numberOfNewMessages !=
                                                      0)
                                                Container(
                                                  padding:
                                                      const EdgeInsets.all(8),
                                                  decoration: BoxDecoration(
                                                    color: AppConfig
                                                        .tradePrimaryColor,
                                                    shape: BoxShape.circle,
                                                  ),
                                                  child: Text(
                                                    channel!.numberOfNewMessages
                                                        .toString(),
                                                    style:
                                                        AppConfig.font.copyWith(
                                                      fontSize: 12,
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                )
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  } else {
                                    return const SizedBox();
                                  }
                                },
                              );
                      },
                    );
                  } else {
                    return const CircularProgressIndicator();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  String lastMessage(ChannelModel channel) {
    //son mesajı gönderen kişi biz miyiz?
    if (channel.lastMessage?.idFrom == AuthService.user?.uid) {
      if (channel.lastMessage?.createdAt != null) {
        final minute = DateTime.now()
            .difference(channel.lastMessage!.createdAt!)
            .inMinutes;
        if (minute >= 60 && minute < 60 * 24) {
          return '${(minute / 60).toStringAsFixed(0)} saat önce gönderildi';
        } else if (minute >= 60 * 24 && minute < 1440 * 7) {
          return '${(minute / 1440).toStringAsFixed(0)} gün önce gönderildi';
        } else if (minute >= 1440 * 7) {
          return '${(minute / 1440 * 7).toStringAsFixed(0)} hafta önce gönderildi';
        } else {
          return 'Az önce gönderildi';
        }
      } else {
        return '';
      }
    } else {
      if (channel.lastMessage?.message != null) {
        if (channel.lastMessage?.createdAt != null) {
          final minute = DateTime.now()
              .difference(channel.lastMessage!.createdAt!)
              .inMinutes;
          if (minute < 60) {
            return '${channel.lastMessage!.message!} ☻ ${minute}d';
          } else if (minute >= 60 && minute < 60 * 24) {
            return '${channel.lastMessage!.message!} ☻ ${(minute / 60).toStringAsFixed(0)}s';
          } else if (minute >= 60 * 24 && minute < 1440 * 7) {
            return '${channel.lastMessage!.message!} ☻ ${(minute / 1440).toStringAsFixed(0)}g';
          } else {
            return channel.lastMessage!.message!;
          }
        } else {
          return channel.lastMessage!.message!;
        }
      } else {
        return '';
      }
    }
  }
}
