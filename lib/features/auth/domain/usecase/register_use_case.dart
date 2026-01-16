import 'package:synq/core/network/api_error.dart';
import 'package:synq/core/network/api_result.dart';
import 'package:synq/features/auth/domain/repository/auth_repository.dart';
import 'package:synq/features/auth/domain/usecase/register_params.dart';

class RegisterUseCase {
  final AuthRepository authRepository;

  RegisterUseCase({required this.authRepository});

  Future<ApiResult> call(RegisterParams params) async {
    if (params.name.trim().isEmpty ||
        params.username.trim().isEmpty ||
        params.email.trim().isEmpty ||
        params.password.trim().isEmpty) {
      return ApiFailure(
        error: ApiError(
          message: "All fields are required.",
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

    return await authRepository.registerUser(params);
  }
}
