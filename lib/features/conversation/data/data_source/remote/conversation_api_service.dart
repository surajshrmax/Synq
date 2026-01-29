import 'package:synq/core/network/api_client.dart';
import 'package:synq/core/network/api_result.dart';
import 'package:synq/features/conversation/data/models/conversation_model.dart';

class ConversationApiService {
  final ApiClient apiClient;

  ConversationApiService({required this.apiClient});

  Future<ApiResult<List<ConversationModel>>> getAllConversation() async {
    var response = await apiClient.get<List<dynamic>>("/chats");
    return response.when(
      success: (data) {
        List<ConversationModel> conversations = data
            .map((e) => ConversationModel.fromJson(e))
            .toList();
        return ApiSuccess(data: conversations);
      },
      failure: (error) => ApiFailure(error: error),
    );
  }
}
