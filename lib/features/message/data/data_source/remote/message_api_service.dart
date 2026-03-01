import 'package:synq/core/network/api_client.dart';
import 'package:synq/core/network/api_result.dart';
import 'package:synq/features/message/data/models/message_response.dart';
import 'package:synq/features/message/domain/usecases/get_initial_messages_use_case.dart';
import 'package:synq/features/message/domain/usecases/get_messages_around_message_use_case.dart';
import 'package:synq/features/message/domain/usecases/get_newer_messages_use_case.dart';
import 'package:synq/features/message/domain/usecases/get_older_messages_use_case.dart';
import 'package:synq/features/message/domain/usecases/send_message_use_case.dart';
import 'package:synq/features/message/domain/usecases/update_typing_status_use_case.dart';

class MessageApiService {
  final ApiClient apiClient;

  MessageApiService({required this.apiClient});

  Future<void> sendMessage(SendMessageParams params) async {
    await apiClient.post(
      "/messages",
      data: {
        "id": params.id,
        "isChat": params.isChat,
        "content": params.content,
        "replyToMessageId": params.replyToMessageId,
      },
    );
  }

  Future<void> deleteMessage(String messageId) async {
    await apiClient.delete("/messages", data: {"messageId": messageId});
  }

  Future<void> updateMessage(String messageId, String content) async {
    await apiClient.patch("/messages", {
      "messageId": messageId,
      "content": content,
    });
  }

  Future<void> updateTypingStatus(UpdateTypingStatusParams params) async {
    await apiClient.post(
      "/messages/typing",
      data: {"chatId": params.chatId, "isTyping": params.isTyping},
    );
  }

  Future<ApiResult<MessageResponse>> getAllMessages(
    String conversationId,
    bool isConversationId,
    bool isAfter,
    String cursor,
  ) async {
    var response = await apiClient.get<MessageResponse>(
      "/messages?chatId=$conversationId&isChatId=$isConversationId&isAfter=$isAfter&lastCursorTime=$cursor&lastMessageId=0",
      mapper: (json) => MessageResponse.fromJson(json),
    );

    return response.when(
      success: (data) => ApiSuccess(data: data),
      failure: (error) => ApiFailure(error: error),
    );
  }

  Future<ApiResult<MessageResponse>> getInitialMessages(
    GetInitialMessageParams params,
  ) async {
    var response = await apiClient.get(
      "/messages/initial?chatId=${params.chatId}&isChatId=${params.isChatId}",
      mapper: (json) => MessageResponse.fromJson(json),
    );

    return response.when(
      success: (data) => ApiSuccess(data: data),
      failure: (error) => ApiFailure(error: error),
    );
  }

  Future<ApiResult<MessageResponse>> getOlderMessages(
    GetOlderMessagesParams params,
  ) async {
    var response = await apiClient.get(
      "/messages/older?chatId=${params.chatId}&cursor=${params.cursor}",
      mapper: (json) => MessageResponse.fromJson(json),
    );

    return response.when(
      success: (data) => ApiSuccess(data: data),
      failure: (error) => ApiFailure(error: error),
    );
  }

  Future<ApiResult<MessageResponse>> getMessagesAroundMessage(
    GetMessagesAroundMessageParams params,
  ) async {
    var response = await apiClient.get(
      "/messages/around?chatId=${params.chatId}&messageId=${params.messageId}&sentAt=${params.sentAt}",
      mapper: (json) => MessageResponse.fromJson(json),
    );

    return response.when(
      success: (data) => ApiSuccess(data: data),
      failure: (error) => ApiFailure(error: error),
    );
  }

  Future<ApiResult<MessageResponse>> getNewerMessages(
    GetNewerMessagesParams params,
  ) async {
    final response = await apiClient.get(
      "/messages/newer?chatId=${params.chatId}&cursor=${params.cursor}",
      mapper: (json) => MessageResponse.fromJson(json),
    );

    return response.when(
      success: (data) => ApiSuccess(data: data),
      failure: (error) => ApiFailure(error: error),
    );
  }
}

enum IdType { conversation, user }
