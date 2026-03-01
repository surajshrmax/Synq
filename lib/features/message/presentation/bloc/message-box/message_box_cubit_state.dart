class MessageBoxCubitState {
  final bool isEditing;
  final bool isReplying;
  final String content;
  final String messageId;

  MessageBoxCubitState({
    this.isEditing = false,
    this.content = "",
    required this.messageId,
    this.isReplying = false,
  });
}
