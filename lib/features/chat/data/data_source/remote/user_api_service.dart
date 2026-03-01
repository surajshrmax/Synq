import 'package:synq/core/network/api_client.dart';
import 'package:synq/core/network/api_result.dart';
import 'package:synq/features/auth/data/models/user_model.dart';

class UserApiService {
  final ApiClient client;

  UserApiService({required this.client});

  Future<ApiResult<UserModel>> getUser(String userId) async {
    var response = await client.get(
      "/users/$userId",
      mapper: (json) => UserModel.fromJson(json),
    );

    return response.when(
      success: (data) => ApiSuccess(data: data),
      failure: (error) => ApiFailure(error: error),
    );
  }

  Future<ApiResult<Iterable<UserModel>>> searchUser(String name) async {
    var response = await client.get<List<dynamic>>("/users/search/$name");

    return response.when(
      success: (data) {
        Iterable<UserModel> users = data.map((e) => UserModel.fromJson(e));
        return ApiSuccess<Iterable<UserModel>>(data: users);
      },
      failure: (error) => ApiFailure(error: error),
    );
  }
}
