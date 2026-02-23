import 'package:synq/core/network/api_result.dart';
import 'package:synq/features/conversation/data/models/message_response.dart';
import 'package:synq/features/conversation/domain/usecases/get_initial_messages_use_case.dart';
import 'package:synq/features/conversation/domain/usecases/get_messages_around_message_use_case.dart';
import 'package:synq/features/conversation/domain/usecases/get_newer_messages_use_case.dart';
import 'package:synq/features/conversation/domain/usecases/get_older_messages_use_case.dart';

abstract class MessageRepository {
  Future<ApiResult<MessageResponse>> getMessages(
    String conversationId,
    bool isConversationId,
    bool isAfter,
    String cursor,
  );

  Future<ApiResult<MessageResponse>> getInitialMessages(
    GetInitialMessageParams params,
  );

  Future<ApiResult<MessageResponse>> getOlderMessages(
    GetOlderMessagesParams params,
  );

  Future<ApiResult<MessageResponse>> getMessagesAroundMessage(
    GetMessagesAroundMessageParams params,
  );

  Future<ApiResult<MessageResponse>> getNewerMessages(
    GetNewerMessagesParams params,
  );
}
