import 'package:synq/core/network/api_client.dart';
import 'package:synq/core/network/api_result.dart';
import 'package:synq/features/conversation/data/models/message_model.dart';

class MessageApiService {
  final ApiClient apiClient;

  MessageApiService({required this.apiClient});

  Future<ApiResult<List<MessageModel>>> getAllMessages(
    String conversationId,
  ) async {
    var response = await apiClient.get<List<dynamic>>(
      "/messages/$conversationId",
    );

    return response.when(
      success: (data) {
        List<MessageModel> messages = data
            .map((e) => MessageModel.fromJson(e))
            .toList();
        return ApiSuccess(data: messages);
      },
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
