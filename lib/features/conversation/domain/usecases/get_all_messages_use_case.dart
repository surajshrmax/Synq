import 'package:synq/core/network/api_result.dart';
import 'package:synq/features/conversation/data/models/message_response.dart';
import 'package:synq/features/conversation/domain/repository/message_repository.dart';

class GetAllMessagesUseCase {
  final MessageRepository messageRepository;

  GetAllMessagesUseCase({required this.messageRepository});

  Future<ApiResult<MessageResponse>> call(
    String conversationId,
    bool isConversationId,
    String cursor,
  ) async {
    return await messageRepository.getMessages(conversationId, isConversationId,cursor);
  }
}
