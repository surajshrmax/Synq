import 'package:synq/core/network/api_result.dart';
import 'package:synq/features/conversation/data/models/message_response.dart';
import 'package:synq/features/conversation/domain/repository/message_repository.dart';

class GetMessagesAroundMessageUseCase {
  final MessageRepository messageRepository;

  GetMessagesAroundMessageUseCase({required this.messageRepository});

  Future<ApiResult<MessageResponse>> call(
    GetMessagesAroundMessageParams params,
  ) async {
    return await messageRepository.getMessagesAroundMessage(params);
  }
}

class GetMessagesAroundMessageParams {
  final String chatId;
  final String messageId;
  final String sentAt;

  GetMessagesAroundMessageParams({
    required this.chatId,
    required this.messageId,
    required this.sentAt,
  });
}
