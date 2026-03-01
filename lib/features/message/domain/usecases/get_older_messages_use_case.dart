import 'package:synq/core/network/api_result.dart';
import 'package:synq/features/message/data/models/message_response.dart';
import 'package:synq/features/message/domain/repository/message_repository.dart';

class GetOlderMessagesUseCase {
  final MessageRepository messageRepository;

  GetOlderMessagesUseCase({required this.messageRepository});

  Future<ApiResult<MessageResponse>> call(GetOlderMessagesParams params) async {
    return await messageRepository.getOlderMessages(params);
  }
}

class GetOlderMessagesParams {
  final String chatId;
  final String cursor;

  GetOlderMessagesParams({required this.chatId, required this.cursor});
}
