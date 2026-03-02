class ChatSessionState {
  final String? chatId;
  final bool hasMoreAfter;
  final bool hasMoreBefore;
  final String? beforeCursor;
  final String? afterCursor;

  const ChatSessionState({
    required this.chatId,
    this.hasMoreAfter = false,
    this.hasMoreBefore = false,
    this.beforeCursor,
    this.afterCursor,
  });

  ChatSessionState copyWith({
    String? chatId,
    bool? hasMoreBefore,
    bool? hasMoreAfter,
    String? beforeCursor,
    String? afterCursor,
  }) {
    return ChatSessionState(
      chatId: chatId,
      hasMoreBefore: hasMoreBefore ?? this.hasMoreBefore,
      hasMoreAfter: hasMoreAfter ?? this.hasMoreAfter,
      beforeCursor: beforeCursor,
      afterCursor: afterCursor,
    );
  }
}
