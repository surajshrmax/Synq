import 'package:synq/core/network/api_result.dart';
import 'package:synq/features/auth/domain/usecase/login_params.dart';
import 'package:synq/features/auth/domain/usecase/register_params.dart';

abstract class AuthRepository {
  Future<ApiResult> loginUser(LoginParams params);

  Future<ApiResult> registerUser(RegisterParams params);

  Future<ApiResult> logout();
}
