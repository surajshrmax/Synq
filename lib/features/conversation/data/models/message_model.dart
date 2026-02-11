import 'package:synq/features/auth/data/models/user_model.dart';

class MessageModel {
  final String id;
  final String content;
  final bool isEdited;
  final UserModel sender;
  final String senderId;
  final DateTime sendAt;

  MessageModel({
    required this.id,
    required this.content,
    required this.isEdited,
    required this.sender,
    required this.senderId,
    required this.sendAt,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) => MessageModel(
    id: json["id"],
    content: json['content'],
    isEdited: json['isEdited'],
    sender: UserModel.fromJson(json['sender']),
    senderId: json['senderId'],
    sendAt: DateTime.parse(json['sentAt']),
  );
}
