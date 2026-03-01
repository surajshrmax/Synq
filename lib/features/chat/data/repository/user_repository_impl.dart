import 'package:synq/core/network/api_result.dart';
import 'package:synq/features/auth/data/models/user_model.dart';
import 'package:synq/features/chat/data/data_source/remote/user_api_service.dart';
import 'package:synq/features/chat/domain/repository/user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  final UserApiService apiService;

  UserRepositoryImpl({required this.apiService});

  @override
  Future<ApiResult<UserModel>> getUserInfo(String userId) async {
    return await apiService.getUser(userId);
  }

  @override
  Future<ApiResult<Iterable<UserModel>>> searchUser(String name) async {
    return await apiService.searchUser(name);
  }
}
