import 'package:synq/core/network/api_result.dart';
import 'package:synq/features/message/data/models/message_response.dart';
import 'package:synq/features/message/domain/repository/message_repository.dart';

class GetNewerMessagesUseCase {
  final MessageRepository messageRepository;

  GetNewerMessagesUseCase({required this.messageRepository});

  Future<ApiResult<MessageResponse>> call(GetNewerMessagesParams params) async {
    return await messageRepository.getNewerMessages(params);
  }
}

class GetNewerMessagesParams {
  final String chatId;
  final String cursor;

  GetNewerMessagesParams({required this.chatId, required this.cursor});
}
