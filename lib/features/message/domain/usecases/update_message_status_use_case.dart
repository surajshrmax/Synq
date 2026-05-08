import 'package:synq/features/message/domain/repository/message_repository.dart';

class UpdateMessageStatusUseCase {
  final MessageRepository repository;

  UpdateMessageStatusUseCase({required this.repository});

  Future<void> call(UpdateMessageStatusParams params) async {
    await repository.updateMessageStatus(params);
  }
}

class UpdateMessageStatusParams{
  final String messageId;
  final String status;

  UpdateMessageStatusParams({required this.messageId, required this.status});
}