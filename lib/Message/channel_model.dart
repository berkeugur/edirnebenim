import 'package:edirnebenim/Message/chat_item_model.dart';
import 'package:edirnebenim/utilities/typedef.dart';

class ChannelModel {
  ChannelModel({
    required this.lastMessage,
    required this.users,
    required this.id,
    this.numberOfNewMessages,
  });
  ChannelModel.fromJson(Map<String, dynamic> json) {
    lastMessage = json['last_message'] != null
        ? ChatItemModel.fromJson(json['last_message'] as Json)
        : null;
    users = json['users'] != null
        ? (json['users'] as List).map((item) => item as String).toList()
        : null;
    id = json['id'] as String;
    numberOfNewMessages = json['number_of_new_messages'] as int?;
  }
  ChatItemModel? lastMessage;
  List<String>? users;
  String? id;
  int? numberOfNewMessages;

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    if (lastMessage != null) {
      data['last_message'] = lastMessage!.toJson();
    }
    data['users'] = users;
    data['id'] = id;
    data['number_of_new_messages'] = numberOfNewMessages;
    return data;
  }
}
