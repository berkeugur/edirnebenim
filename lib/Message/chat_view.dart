import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edirnebenim/Authentication/auth_service.dart';
import 'package:edirnebenim/Authentication/user_model.dart';
import 'package:edirnebenim/Message/channel_model.dart';
import 'package:edirnebenim/Message/chat_item_model.dart';
import 'package:edirnebenim/Message/message_service.dart';
import 'package:edirnebenim/Trade/view/details_view.dart';
import 'package:edirnebenim/Trade/view/widgets/last_seen_text.dart';
import 'package:edirnebenim/config.dart';
import 'package:edirnebenim/utilities/date_format.dart';
import 'package:edirnebenim/utilities/snack_bar.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class ChatView extends StatefulWidget {
  const ChatView({
    required this.user,
    this.channel,
    super.key,
  });
  final ChannelModel? channel;
  final UserModel user;

  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late TextEditingController textEditingController;
  late ScrollController scrollController;

  String? channelId;
  Future<void> getChannelId() async {
    await MessageService()
        .getChannel(user!.userID!)
        .then((value) => channelId = value?.id);
  }

  @override
  void initState() {
    super.initState();
    textEditingController = TextEditingController();
    scrollController = ScrollController();

    if (widget.channel == null) {
      getChannelId();
    } else {
      channelId = widget.channel!.id;
    }
  }

  @override
  void dispose() {
    textEditingController.dispose();
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ChannelModel? channel = widget.channel;
    final user = widget.user;
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        centerTitle: false,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.report_outlined),
            iconSize: 32,
          )
        ],
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
        title: Row(
          children: [
            CircleAvatar(
              radius: 24,
              backgroundImage: NetworkImage(user.photoURL),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.name ?? 'Hata oluştu',
                  style: AppConfig.font.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  lastSeenText(
                    date: user.lastSeen!,
                    isOnline: user.isOnline,
                  ),
                  style: AppConfig.font
                      .copyWith(fontWeight: FontWeight.w400, fontSize: 14),
                ),
              ],
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('messages')
                  .doc(channelId ?? '${AuthService.user!.uid}_${user.userID}')
                  .collection('chat')
                  .orderBy('created_at', descending: true)
                  .limit(30)
                  .withConverter<ChatItemModel>(
                    fromFirestore: (snapshot, _) =>
                        ChatItemModel.fromJson(snapshot.data()!),
                    toFirestore: (model, _) => model.toJson(),
                  )
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData ||
                    snapshot.connectionState == ConnectionState.done) {
                  return SingleChildScrollView(
                    reverse: true,
                    controller: scrollController,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ListView.builder(
                            shrinkWrap: true,
                            reverse: true,
                            physics: const NeverScrollableScrollPhysics(),
                            padding: const EdgeInsets.all(20),
                            itemCount: snapshot.data?.docs.length ?? 0,
                            itemBuilder: (context, index) {
                              final chatItem =
                                  snapshot.data?.docs[index].data();
                              final isHost =
                                  chatItem?.idFrom == AuthService.user?.uid;
                              if (channel != null && chatItem != null) {
                                MessageService().isReadTrue(channel!, chatItem);
                              }

                              return Row(
                                mainAxisAlignment: isHost
                                    ? MainAxisAlignment.end
                                    : MainAxisAlignment.start,
                                children: [
                                  Container(
                                    margin: const EdgeInsets.all(10),
                                    padding: const EdgeInsets.all(10),
                                    color: Colors.white,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          chatItem?.message ?? 'no message',
                                        ),
                                        Text(AppDateFormat().dateFormatText(
                                            chatItem?.createdAt)),
                                        Icon(
                                          Icons.verified,
                                          color: chatItem?.isRead ?? false
                                              ? Colors.green
                                              : Colors.grey,
                                        ),
                                        Text((chatItem?.createdAt
                                                ?.millisecondsSinceEpoch)
                                            .toString()),
                                      ],
                                    ),
                                  ),
                                ],
                              );
                            }),
                      ],
                    ),
                  );
                } else {
                  return const SizedBox();
                }
              },
            ),
          ),
          Row(
            children: [
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewPadding.bottom,
                    left: 5,
                  ),
                  height: 55,
                  decoration: BoxDecoration(
                    color: AppConfig.tradePrimaryColor,
                    borderRadius: BorderRadius.circular(99),
                  ),
                  child: Form(
                    key: _formKey,
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.emoji_emotions_outlined,
                            color: Colors.white,
                            size: 32,
                          ),
                        ),
                        Expanded(
                          child: TextFormField(
                            cursorColor: Colors.white,
                            controller: textEditingController,
                            keyboardType: TextInputType.text,
                            style: const TextStyle(color: Colors.white),
                            decoration: InputDecoration.collapsed(
                              floatingLabelAlignment:
                                  FloatingLabelAlignment.center,
                              hintStyle: AppConfig.font.copyWith(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w400,
                              ),
                              hintText: 'Mesaj',
                            ),
                            onFieldSubmitted: (value) async {
                              if (textEditingController.text.isNotEmpty &&
                                  _formKey.currentState!.validate()) {
                                _formKey.currentState!.save();
                                final now = Timestamp.now();
                                final chatitem = ChatItemModel(
                                  idFrom: AuthService.user!.uid,
                                  channelId: channelId ??
                                      '${AuthService.user!.uid}_${user.userID}',
                                  createdAt: now.toDate(),
                                  isRead: false,
                                  message: textEditingController.text,
                                );
                                channel = ChannelModel(
                                  lastMessage: chatitem,
                                  users: widget.channel?.users,
                                  id: widget.channel?.id,
                                );
                                await MessageService()
                                    .newChatItem(
                                  chatItem: chatitem,
                                )
                                    .then((value) async {
                                  textEditingController.clear();
                                });
                              } else {
                                context.snackbar('mesajınızı yazınız.');
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: () async {
                  if (textEditingController.text.isNotEmpty &&
                      _formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    final now = Timestamp.now();
                    final chatitem = ChatItemModel(
                      idFrom: AuthService.user!.uid,
                      channelId: channelId ??
                          '${AuthService.user!.uid}_${user.userID}',
                      createdAt: now.toDate(),
                      isRead: false,
                      message: textEditingController.text,
                    );
                    channel = ChannelModel(
                      lastMessage: chatitem,
                      users: widget.channel?.users,
                      id: widget.channel?.id,
                    );
                    await MessageService()
                        .newChatItem(
                      chatItem: chatitem,
                    )
                        .then((value) async {
                      textEditingController.clear();
                    });
                  } else {
                    context.snackbar('mesajınızı yazınız.');
                  }
                },
                child: Container(
                  margin: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewPadding.bottom,
                    left: 5,
                    right: 5,
                  ),
                  width: 55,
                  height: 55,
                  decoration: BoxDecoration(
                    color: AppConfig.tradeSecondaryColor,
                    borderRadius: BorderRadius.circular(99),
                  ),
                  child: const Icon(
                    Icons.send,
                    color: Colors.white,
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
