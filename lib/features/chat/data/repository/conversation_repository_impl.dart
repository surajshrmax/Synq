import 'package:synq/core/network/api_result.dart';
import 'package:synq/features/chat/data/data_source/remote/conversation_api_service.dart';
import 'package:synq/features/chat/data/models/chat_model.dart';
import 'package:synq/features/chat/domain/repository/conversation_repository.dart';

class ConversationRepositoryImpl implements ConversationRepository {
  final ConversationApiService apiService;

  ConversationRepositoryImpl({required this.apiService});

  @override
  Future<ApiResult<List<ChatModel>>> getAllConversation() async {
    return await apiService.getAllConversation();
  }
}
