import 'package:synq/core/network/api_result.dart';
import 'package:synq/features/chat/data/models/chat_model.dart';
import 'package:synq/features/chat/domain/repository/conversation_repository.dart';

class GetAllConversationUseCase {
  final ConversationRepository conversationRepository;

  GetAllConversationUseCase({required this.conversationRepository});

  Future<ApiResult<List<ChatModel>>> call() {
    return conversationRepository.getAllConversation();
  }
}
