class LoginResponse {
  final String userId;
  final AuthToken token;

  LoginResponse({required this.userId, required this.token});

  factory LoginResponse.fromJson(Map<String, dynamic> json) => LoginResponse(
    userId: json['userId'],
    token: AuthToken(
      accessToken: json['accessToken'],
      refreshTokne: json['refreshToken'],
    ),
  );
}

class AuthToken {
  final String accessToken;
  final String refreshTokne;

  AuthToken({required this.accessToken, required this.refreshTokne});
}
