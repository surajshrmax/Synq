import 'package:synq/core/network/api_result.dart';
import 'package:synq/features/auth/data/models/user_model.dart';
import 'package:synq/features/conversation/domain/repository/user_repository.dart';

class SearchUserUseCase {
  final UserRepository repository;

  SearchUserUseCase({required this.repository});

  Future<ApiResult<Iterable<UserModel>>> call(String name) async {
    var response = await repository.searchUser(name);
    return response;
  }
}
