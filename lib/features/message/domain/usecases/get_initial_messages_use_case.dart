import 'package:synq/core/network/api_result.dart';
import 'package:synq/features/message/data/models/message_response.dart';
import 'package:synq/features/message/domain/repository/message_repository.dart';

class GetInitialMessagesUseCase {
  final MessageRepository messageRepository;

  GetInitialMessagesUseCase({required this.messageRepository});

  Future<ApiResult<MessageResponse>> call(
    GetInitialMessageParams params,
  ) async {
    return await messageRepository.getInitialMessages(params);
  }
}

class GetInitialMessageParams {
  final String chatId;
  final bool isChatId;

  GetInitialMessageParams({required this.chatId, required this.isChatId});
}
