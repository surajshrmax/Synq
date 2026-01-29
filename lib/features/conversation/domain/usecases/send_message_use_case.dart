import 'package:synq/core/network/api_result.dart';
import 'package:synq/features/conversation/data/data_source/remote/message_api_service.dart';
import 'package:synq/features/conversation/domain/repository/message_repository.dart';

class SendMessageUseCase {
  final MessageRepository repository;

  SendMessageUseCase({required this.repository});

  Future<ApiResult<String>> call(String id, IdType type, String content) async {
    return repository.sendMessage(id, type, content);
  }
}
