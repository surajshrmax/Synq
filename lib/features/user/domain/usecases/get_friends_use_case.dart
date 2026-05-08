import 'package:synq/core/network/api_result.dart';
import 'package:synq/features/user/data/models/friends_response.dart';
import 'package:synq/features/user/domain/repository/user_repository.dart';

class GetFriendsUseCase {
  final UserRepository userRepository;

  GetFriendsUseCase({required this.userRepository});

  Future<ApiResult<FriendsResponse>> call(String? keyword) async {
    return await userRepository.getFriends(keyword);
  }
}
