import 'package:synq/core/network/api_result.dart';
import 'package:synq/features/auth/data/models/user_model.dart';
import 'package:synq/features/user/data/models/friends_response.dart';

abstract class UserRepository {
  Future<ApiResult<UserModel>> getUserInfo(String userId);
  Future<ApiResult<Iterable<UserModel>>> searchUser(String name);
  Future<ApiResult<FriendsResponse>> getFriends(String? keyword);
}
