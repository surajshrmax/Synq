import 'package:synq/features/auth/data/models/user_model.dart';

class SearchUserResponse {
  final List<UserModel> data;

  SearchUserResponse({required this.data});

  factory SearchUserResponse.fromJson(Map<String, dynamic> json) =>
      SearchUserResponse(
        data: (json['data'] as List).map((e) => UserModel.fromJson(e)).toList(),
      );
}
