import 'package:synq/core/network/api_client.dart';
import 'package:synq/core/network/api_result.dart';
import 'package:synq/features/conversation/data/models/message_response.dart';

class MessageApiService {
  final ApiClient apiClient;

  MessageApiService({required this.apiClient});

  Future<ApiResult<MessageResponse>> getAllMessages(
    String conversationId,
    bool isConversationId,
    String cursor,
  ) async {
    var response = await apiClient.get<MessageResponse>(
      "/messages?chatId=$conversationId&isChatId=$isConversationId&lastCursorTime=$cursor&lastMessageId=0",
      mapper: (json) => MessageResponse.fromJson(json),
    );

    return response.when(
      success: (data) => ApiSuccess(data: data),
      failure: (error) => ApiFailure(error: error),
    );
  }

  Future<ApiResult<String>> sendMessage(
    String id,
    IdType type,
    String content,
  ) async {
    var response = await apiClient.post(
      "/messages",
      data: {"id": id, "type": type.index, "content": content},
    );

    return response.when(
      success: (data) => ApiSuccess(data: data),
      failure: (error) => ApiFailure(error: error),
    );
  }
}

enum IdType { conversation, user }
