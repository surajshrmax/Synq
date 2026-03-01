import 'package:synq/features/message/domain/repository/message_repository.dart';

class UpdateMessageUseCase {
  final MessageRepository messageRepository;

  UpdateMessageUseCase({required this.messageRepository});

  Future<void> call(String messageId, String content) async {
    await messageRepository.updateMessage(messageId, content);
  }
}
