import 'package:synq/core/network/api_result.dart';
import 'package:synq/features/conversation/data/models/conversation_model.dart';

abstract class ConversationRepository {
  Future<ApiResult<List<ConversationModel>>> getAllConversation();
}
