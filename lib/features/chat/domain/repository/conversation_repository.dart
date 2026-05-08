import 'package:synq/core/network/api_result.dart';
import 'package:synq/features/chat/data/models/chat_model.dart';
import 'package:synq/features/chat/data/models/group_model.dart';

abstract class ConversationRepository {
  Future<ApiResult<List<ChatModel>>> getAllConversation();
  Future<ApiResult> createGroupConversation(String name, List<String> members);
  Future<ApiResult<GroupModel>> getGroupInfo(String groupId);
}
