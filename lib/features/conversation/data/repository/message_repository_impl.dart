import 'package:synq/core/network/api_result.dart';
import 'package:synq/features/conversation/data/data_source/remote/message_api_service.dart';
import 'package:synq/features/conversation/data/models/message_response.dart';
import 'package:synq/features/conversation/domain/repository/message_repository.dart';

class MessageRepositoryImpl extends MessageRepository {
  final MessageApiService apiService;

  MessageRepositoryImpl({required this.apiService});

  @override
  Future<ApiResult<MessageResponse>> getMessages(
    String conversationId,
    bool isConversationId,
    String cursor,
  ) async {
    return await apiService.getAllMessages(conversationId, isConversationId, cursor);
  }

  @override
  Future<ApiResult<String>> sendMessage(
    String id,
    IdType type,
    String content,
  ) async {
    return await apiService.sendMessage(id, type, content);
  }
}
