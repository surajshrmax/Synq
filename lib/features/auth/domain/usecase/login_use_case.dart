import 'package:synq/core/network/api_error.dart';
import 'package:synq/core/network/api_result.dart';
import 'package:synq/features/auth/domain/repository/auth_repository.dart';
import 'package:synq/features/auth/domain/usecase/login_params.dart';

class LoginUseCase {
  final AuthRepository authRepository;

  LoginUseCase({required this.authRepository});

  Future<ApiResult> call(LoginParams params) async {
    if (params.email.trim().isEmpty) {
      return ApiFailure(
        error: ApiError(
          message: "Email field is empty, can't go further without it.",
          errorType: ApiErrorType.user,
        ),
      );
    }
    if (params.password.trim().isEmpty) {
      return ApiFailure(
        error: ApiError(
          message: "Password field is empty, can't go further without it.",
          errorType: ApiErrorType.user,
        ),
      );
    }
    var emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(params.email)) {
      return ApiFailure(
        error: ApiError(
          message: "Enter a valid email address",
          errorType: ApiErrorType.user,
        ),
      );
    }
    return await authRepository.loginUser(params);
  }
}
