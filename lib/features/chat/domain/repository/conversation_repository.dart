import 'package:synq/core/network/api_result.dart';
import 'package:synq/features/chat/data/models/chat_model.dart';

abstract class ConversationRepository {
  Future<ApiResult<List<ChatModel>>> getAllConversation();
}
