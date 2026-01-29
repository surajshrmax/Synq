import 'package:synq/core/network/api_result.dart';
import 'package:synq/features/conversation/data/data_source/remote/message_api_service.dart';
import 'package:synq/features/conversation/data/models/message_model.dart';
import 'package:synq/features/conversation/domain/repository/message_repository.dart';

class MessageRepositoryImpl extends MessageRepository {
  final MessageApiService apiService;

  MessageRepositoryImpl({required this.apiService});

  @override
  Future<ApiResult<List<MessageModel>>> getMessages(
    String conversationId,
  ) async {
    return await apiService.getAllMessages(conversationId);
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
