class ChatItemModel {
  ChatItemModel({
    required this.idFrom,
    required this.channelId,
    required this.createdAt,
    required this.isRead,
    this.message,
    this.image,
    this.video,
    this.audio,
    this.file,
  });
  ChatItemModel.fromJson(Map<String, dynamic> json) {
    idFrom = json['id_from'] as String;
    channelId = json['channel_id'] as String;
    message = json['message'] as String?;
    image = json['image'] as String?;
    video = json['video'] as String?;
    audio = json['audio'] as String?;
    file = json['file'] as String?;
    createdAt = DateTime.fromMillisecondsSinceEpoch(json['created_at'] as int);
    isRead = json['is_read'] as bool;
  }
  String? idFrom;
  late String channelId;
  String? message;
  String? image;
  String? video;
  String? audio;
  String? file;
  DateTime? createdAt;
  bool? isRead;

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id_from'] = idFrom;
    data['channel_id'] = channelId;
    data['message'] = message;
    data['image'] = image;
    data['video'] = video;
    data['audio'] = audio;
    data['file'] = file;
    data['created_at'] = createdAt?.millisecondsSinceEpoch;
    data['is_read'] = isRead;
    return data;
  }
}
