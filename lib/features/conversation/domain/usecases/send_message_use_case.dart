import 'package:synq/features/conversation/domain/repository/message_repository.dart';

class SendMessageUseCase {
  final MessageRepository repository;

  SendMessageUseCase({required this.repository});

  Future<void> call(SendMessageParams params) async {
    await repository.sendMessage(params);
  }
}

class SendMessageParams {
  final String id;
  final bool isChat;
  final String content;
  final String? replyToMessageId;

  SendMessageParams({
    required this.id,
    required this.isChat,
    required this.content,
    this.replyToMessageId,
  });
}
