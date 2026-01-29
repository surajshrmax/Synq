import 'package:synq/core/network/api_result.dart';
import 'package:synq/features/conversation/data/data_source/remote/conversation_api_service.dart';
import 'package:synq/features/conversation/data/models/conversation_model.dart';
import 'package:synq/features/conversation/domain/repository/conversation_repository.dart';

class ConversationRepositoryImpl implements ConversationRepository {
  final ConversationApiService apiService;

  ConversationRepositoryImpl({required this.apiService});

  @override
  Future<ApiResult<List<ConversationModel>>> getAllConversation() async {
    return await apiService.getAllConversation();
  }
}
