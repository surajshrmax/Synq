import 'package:synq/core/network/api_client.dart';
import 'package:synq/core/network/api_result.dart';
import 'package:synq/features/chat/data/models/chat_model.dart';

class ConversationApiService {
  final ApiClient apiClient;

  ConversationApiService({required this.apiClient});

  Future<ApiResult<List<ChatModel>>> getAllConversation() async {
    var response = await apiClient.get<List<dynamic>>("/chats");
    return response.when(
      success: (data) {
        List<ChatModel> conversations = data
            .map((e) => ChatModel.fromJson(e))
            .toList();
        return ApiSuccess(data: conversations);
      },
      failure: (error) => ApiFailure(error: error),
    );
  }

  Future<ApiResult> createGroup(String name, List<String> members) async {
    var response = await apiClient.post("/chats", data: {
      "name": name,
      "imageUrl": "",
      "members": members
    });

    return response.when(success: (data) => ApiSuccess(data: data), failure: (error) => ApiFailure(error: error),);
  }
}
