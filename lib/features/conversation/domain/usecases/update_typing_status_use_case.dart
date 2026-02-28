import 'package:synq/features/conversation/domain/repository/message_repository.dart';

class UpdateTypingStatusUseCase {
  final MessageRepository messageRepository;

  UpdateTypingStatusUseCase({required this.messageRepository});

  Future<void> call(UpdateTypingStatusParams params) async {
    await messageRepository.updateTypingStatus(params);
  }
}

class UpdateTypingStatusParams {
  final String chatId;
  final bool isTyping;

  UpdateTypingStatusParams({required this.chatId, required this.isTyping});
}
