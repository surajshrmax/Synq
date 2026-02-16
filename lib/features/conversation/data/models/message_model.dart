import 'package:synq/features/auth/data/models/user_model.dart';

class MessageModel {
  final String id;
  final String content;
  final bool? isEdited;
  final String? replyMessageId;
  final ReplyMessage? reply;
  final UserModel? sender;
  final String? senderId;
  final DateTime? sendAt;

  MessageModel({
    required this.id,
    required this.content,
    required this.isEdited,
    required this.replyMessageId,
    required this.reply,
    required this.sender,
    required this.senderId,
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
      sendAt: DateTime.parse(json['sentAt']),
    );
  }
}

class ReplyMessage {
  final String id;
  final String content;

  ReplyMessage({required this.id, required this.content});

  factory ReplyMessage.fromJson(Map<String, dynamic> json) =>
      ReplyMessage(id: json['id'], content: json['content']);
}
