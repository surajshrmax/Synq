import 'package:synq/core/network/api_result.dart';
import 'package:synq/features/chat/domain/repository/conversation_repository.dart';

class CreateGroupUseCase {
  final ConversationRepository repository;

  CreateGroupUseCase({required this.repository});

  Future<ApiResult> call(String name, List<String> members)async{
    return await repository.createGroupConversation(name, members);
  }
}