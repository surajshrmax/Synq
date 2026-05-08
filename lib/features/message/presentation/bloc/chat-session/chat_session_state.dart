import 'package:synq/features/message/data/models/message_model.dart';

class ChatSessionState {
  final String? chatId;
  final bool hasMoreAfter;
  final bool hasMoreBefore;
  final String? beforeCursor;
  final String? afterCursor;
  final List<MessageModel> messages;

  const ChatSessionState({
    required this.chatId,
    this.hasMoreAfter = false,
    this.hasMoreBefore = false,
    this.beforeCursor,
    this.afterCursor,
    required this.messages,
  });

  ChatSessionState copyWith({
    String? chatId,
    bool? hasMoreBefore,
    bool? hasMoreAfter,
    String? beforeCursor,
    String? afterCursor,
    required List<MessageModel> messages,
  }) {
    return ChatSessionState(
      chatId: chatId,
      hasMoreBefore: hasMoreBefore ?? this.hasMoreBefore,
      hasMoreAfter: hasMoreAfter ?? this.hasMoreAfter,
      beforeCursor: beforeCursor,
      afterCursor: afterCursor,
      messages: messages,
    );
  }
}
