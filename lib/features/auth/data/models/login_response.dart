import 'package:synq/features/auth/data/models/user_model.dart';

class LoginResponse {
  final UserModel? user;
  final AuthToken? token;

  LoginResponse({required this.user, required this.token});

  factory LoginResponse.fromJson(Map<String, dynamic> json) => LoginResponse(
    user: UserModel.fromJson(json['user']),
    token: AuthToken.fromJson(json['token']),
  );
}

class AuthToken {
  final String? id;
  final String? accessToken;
  final String? refreshTokne;

  AuthToken({
    required this.id,
    required this.accessToken,
    required this.refreshTokne,
  });

  factory AuthToken.fromJson(Map<String, dynamic> json) => AuthToken(
    id: json['id'],
    accessToken: json['accessToken'],
    refreshTokne: json['refreshToken'],
  );
}
