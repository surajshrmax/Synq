import 'package:synq/features/message/data/models/message_model.dart';

class MessageResponse {
  final String chatId;
  final bool hasMoreAfter;
  final bool hasMoreBefore;
  final String? beforeCursor;
  final String? afterCursor;
  final List<MessageModel> messages;

  MessageResponse({
    required this.chatId,
    required this.hasMoreAfter,
    required this.hasMoreBefore,
    required this.messages,
    required this.beforeCursor,
    required this.afterCursor,
  });

  factory MessageResponse.fromJson(Map<String, dynamic> json) =>
      MessageResponse(
        chatId: json['chatId'],
        hasMoreAfter: json['hasMoreAfter'],
        hasMoreBefore: json['hasMoreBefore'],
        beforeCursor: json['beforeCursor'],
        afterCursor: json['afterCursor'],
        messages: json['messages'] != null
            ? (json['messages'] as List)
                  .map((e) => MessageModel.fromJson(e))
                  .toList()
            : [],
      );
}
