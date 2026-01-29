import 'package:synq/core/network/api_result.dart';
import 'package:synq/features/conversation/data/models/conversation_model.dart';
import 'package:synq/features/conversation/domain/repository/conversation_repository.dart';

class GetAllConversationUseCase {
  final ConversationRepository conversationRepository;

  GetAllConversationUseCase({required this.conversationRepository});

  Future<ApiResult<List<ConversationModel>>> call() {
    return conversationRepository.getAllConversation();
  }
}
