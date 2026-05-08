import 'package:synq/core/network/api_result.dart';
import 'package:synq/features/chat/data/models/group_model.dart';
import 'package:synq/features/chat/domain/repository/conversation_repository.dart';

class GetGroupInfoUseCase {
  final ConversationRepository repository;

  GetGroupInfoUseCase({required this.repository});

  Future<ApiResult<GroupModel>> call(String groupId) async {
    return await repository.getGroupInfo(groupId);
  }
}