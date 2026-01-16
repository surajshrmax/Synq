import 'package:synq/core/network/api_result.dart';
import 'package:synq/features/auth/data/models/user_model.dart';

abstract class UserRepository {
  Future<ApiResult<Iterable<UserModel>>> searchUser(String name);
}
