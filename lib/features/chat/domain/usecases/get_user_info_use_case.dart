import 'package:synq/core/network/api_result.dart';
import 'package:synq/features/auth/data/models/user_model.dart';
import 'package:synq/features/chat/domain/repository/user_repository.dart';

class GetUserInfoUseCase {
  final UserRepository userRepository;

  GetUserInfoUseCase({required this.userRepository});

  Future<ApiResult<UserModel>> call(String userId) async {
    return await userRepository.getUserInfo(userId);
  }
}
