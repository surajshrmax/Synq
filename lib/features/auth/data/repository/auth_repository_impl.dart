import 'package:synq/core/network/api_client.dart';
import 'package:synq/core/network/api_result.dart';
import 'package:synq/core/storage/secure_storage.dart';
import 'package:synq/features/auth/data/models/login_response.dart';
import 'package:synq/features/auth/domain/repository/auth_repository.dart';
import 'package:synq/features/auth/domain/usecase/login_params.dart';
import 'package:synq/features/auth/domain/usecase/register_params.dart';

class AuthRepositoryImpl implements AuthRepository {
  final ApiClient client;
  final SecureStorage secureStorage;

  AuthRepositoryImpl({required this.client, required this.secureStorage});

  @override
  Future<ApiResult> loginUser(LoginParams params) async {
    var response = await client.post<LoginResponse>(
      "/auth/login",
      data: {"email": params.email, "password": params.password},
      mapper: (json) => LoginResponse.fromJson(json),
    );

    return response.when(
      success: (data) async {
        await secureStorage.saveToken(data.token!);
        return ApiSuccess(data: data);
      },
      failure: (error) => ApiFailure(error: error),
    );
  }

  @override
  Future<ApiResult> registerUser(RegisterParams params) async {
    var response = await client.post<LoginResponse>(
      "/auth/register",
      data: {
        "name": params.name,
        "username": params.username,
        "email": params.email,
        "password": params.password,
      },
      mapper: (json) => LoginResponse.fromJson(json),
    );

    return response.when(
      success: (data) async {
        await secureStorage.saveToken(data.token!);
        return ApiSuccess(data: data);
      },
      failure: (error) => ApiFailure(error: error),
    );
  }

  @override
  Future<ApiResult> logout() async {
    var response = await client.post("/auth/logout");
    return response.when(
      success: (data) async {
        await secureStorage.deleteAllTokens();
        return ApiSuccess(data: data);
      },
      failure: (error) => ApiFailure(error: error),
    );
  }
}
