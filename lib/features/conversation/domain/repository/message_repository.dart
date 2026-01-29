import 'package:synq/core/network/api_result.dart';
import 'package:synq/features/conversation/data/data_source/remote/message_api_service.dart';
import 'package:synq/features/conversation/data/models/message_model.dart';

abstract class MessageRepository {
  Future<ApiResult<List<MessageModel>>> getMessages(String conversationId);
  Future<ApiResult<String>> sendMessage(String id, IdType type, String content);
}
