import 'package:synq/core/network/api_result.dart';
import 'package:synq/features/conversation/data/models/message_model.dart';
import 'package:synq/features/conversation/domain/repository/message_repository.dart';

class GetAllMessagesUseCase {
  final MessageRepository messageRepository;

  GetAllMessagesUseCase({required this.messageRepository});

  Future<ApiResult<List<MessageModel>>> call(String conversationId) async {
    return await messageRepository.getMessages(conversationId);
  }
}
