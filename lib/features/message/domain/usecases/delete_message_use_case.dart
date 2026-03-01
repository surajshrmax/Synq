import 'package:synq/features/message/domain/repository/message_repository.dart';

class DeleteMessageUseCase {
  final MessageRepository messageRepository;

  DeleteMessageUseCase({required this.messageRepository});

  Future<void> call(String messageId) async {
    await messageRepository.deleteMessage(messageId);
  }
}
