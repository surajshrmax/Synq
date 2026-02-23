import 'package:synq/features/auth/data/models/user_model.dart';

class MessageModel {
  final String id;
  final String content;
  final bool? isEdited;
  final String? replyMessageId;
  final ReplyMessage? reply;
  final UserModel? sender;
  final String? senderId;
  final String? serverTime;
  final DateTime? sendAt;

  MessageModel({
    required this.id,
    required this.content,
    required this.isEdited,
    required this.replyMessageId,
    required this.reply,
    required this.sender,
    required this.senderId,
    required this.serverTime,
    required this.sendAt,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      id: json["id"],
      content: json['content'],
      isEdited: json['isEdited'],
      replyMessageId: json['replyMessageId'],
      reply: json['reply'] != null
          ? ReplyMessage.fromJson(json['reply'])
          : null,
      sender: UserModel.fromJson(json['sender']),
      senderId: json['senderId'],
      serverTime: json['sentAt'],
      sendAt: DateTime.parse(json['sentAt']),
    );
  }
}

class ReplyMessage {
  final String id;
  final String content;
  final String serverTime;
  final DateTime sentAt;

  ReplyMessage({
    required this.id,
    required this.content,
    required this.serverTime,
    required this.sentAt,
  });

  factory ReplyMessage.fromJson(Map<String, dynamic> json) => ReplyMessage(
    id: json['id'],
    serverTime: json['sentAt'],
    content: json['content'],
    sentAt: DateTime.parse(json['sentAt']),
  );
}
