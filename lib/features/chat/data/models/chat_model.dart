import 'package:synq/features/auth/data/models/user_model.dart';
import 'package:synq/features/message/data/models/message_model.dart';

class ChatModel {
  final String id;
  final String? title;
  final bool isGroup;
  final UserModel? user;
  final MessageModel? lastMessage;

  ChatModel({
    required this.id,
    required this.title,
    required this.isGroup,
    required this.user,
    required this.lastMessage,
  });

  factory ChatModel.fromJson(Map<String, dynamic> json) => ChatModel(
    id: json['id'],
    title: json['title'],
    isGroup: json['isGroup'],
    user: UserModel.fromJson(json['user']),
    lastMessage: json['lastMessage'] == null
        ? null
        : MessageModel.fromJson(json["lastMessage"]),
  );
}
