import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edirnebenim/Authentication/auth_service.dart';
import 'package:edirnebenim/Message/channel_model.dart';
import 'package:edirnebenim/Message/chat_item_model.dart';
import 'package:firebase_storage/firebase_storage.dart';

class MessageService {
  final db = FirebaseFirestore.instance;
  final String messageCollectionPath = 'messages';
  final String chatCollectionPath = 'chat';

  Future<ChannelModel?> getChannel(String otherUserId) async {
    if (AuthService.user != null) {
      final snapshot = await FirebaseFirestore.instance
          .collection(messageCollectionPath)
          .where(
            'users',
            arrayContains: [AuthService.user?.uid, otherUserId],
          )
          .withConverter<ChannelModel>(
            fromFirestore: (snapshot, _) =>
                ChannelModel.fromJson(snapshot.data()!),
            toFirestore: (model, _) => model.toJson(),
          )
          .get();
      if (snapshot.docs.isEmpty) {
        return null;
      }
      for (final channel in snapshot.docs) {
        if (channel.data().users?.length == 2) {
          return channel.data();
        }
      }
    }
    return null;
  }

  Future<bool> createChannelAndChatItem({
    required ChannelModel channel,
    required ChatItemModel firstChatItem,
  }) async {
    try {
      await db
          .collection(messageCollectionPath)
          .doc(channel.id)
          .set(channel.toJson());
      await db
          .collection(messageCollectionPath)
          .doc(channel.id)
          .collection(chatCollectionPath)
          .doc(firstChatItem.createdAt?.millisecondsSinceEpoch.toString())
          .set(firstChatItem.toJson());
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<void> isReadTrue(ChannelModel channel, ChatItemModel chat) async {
    try {
      //kontrol edilen mesaj bizim değilse
      if (chat.idFrom != AuthService.user?.uid) {
        await db
            .collection(messageCollectionPath)
            .doc(channel.id)
            .collection(chatCollectionPath)
            .doc(chat.createdAt?.millisecondsSinceEpoch.toString() ?? '')
            .update({'is_read': true});
        if (channel.lastMessage?.createdAt == chat.createdAt) {
          await db.collection(messageCollectionPath).doc(channel.id).update(
            {'last_message.is_read': true, 'number_of_new_messages': 0},
          );
        }
      }
    } catch (e) {
      print(e);
    }
  }

  Future<bool> newChatItem({
    required ChatItemModel chatItem,
  }) async {
    try {
      final snap = await db
          .collection(messageCollectionPath)
          .doc(chatItem.channelId)
          .withConverter<ChannelModel>(
            fromFirestore: (snapshot, _) =>
                ChannelModel.fromJson(snapshot.data()!),
            toFirestore: (model, _) => model.toJson(),
          )
          .get();
      final channel = snap.data();

      if (channel?.lastMessage?.idFrom == AuthService.user?.uid) {
        await db
            .collection(messageCollectionPath)
            .doc(chatItem.channelId)
            .update({
          'last_message': chatItem.toJson(),
          'number_of_new_messages': (channel?.numberOfNewMessages ?? 0) + 1
        });
      } else {
        await db
            .collection(messageCollectionPath)
            .doc(chatItem.channelId)
            .update({
          'last_message': chatItem.toJson(),
          'number_of_new_messages': 1
        });
      }
      await db
          .collection(messageCollectionPath)
          .doc(chatItem.channelId)
          .collection(chatCollectionPath)
          .doc(chatItem.createdAt?.millisecondsSinceEpoch.toString())
          .set(chatItem.toJson());
      return true;
    } on FirebaseException catch (e) {
      print(e.code);
      if (e.code == 'not-found') {
        await createChannelAndChatItem(
          channel: ChannelModel(
            lastMessage: chatItem,
            users: chatItem.channelId.split('_'),
            numberOfNewMessages: 1,
            id: chatItem.channelId,
          ),
          firstChatItem: chatItem,
        );
      }
      return false;
    }
  }

  Future<bool> deleteChatItem({
    required ChatItemModel firstChatItem,
  }) async {
    try {
      await db
          .collection(messageCollectionPath)
          .doc(firstChatItem.channelId)
          .collection(chatCollectionPath)
          .doc(firstChatItem.createdAt?.millisecondsSinceEpoch.toString())
          .delete();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> clearMessages({
    required ChatItemModel firstChatItem,
  }) async {
    try {
      await db
          .collection(messageCollectionPath)
          .doc(firstChatItem.channelId)
          .delete();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<String?> uploadFile({
    required File file,
    required String channelId,
  }) async {
    final currentTime = DateTime.now();

    try {
      final ref = FirebaseStorage.instance
          .ref()
          .child(messageCollectionPath)
          .child(channelId)
          .child(currentTime.millisecondsSinceEpoch.toString());

      final uploadTask = ref.putFile(file);
      String? url;
      await uploadTask.whenComplete(() async {
        url = await ref.getDownloadURL();
      });

      return url;
    } catch (e) {
      return null;
    }
  }
}
