abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoginLoading extends AuthState {}

class AuthRegisterLoading extends AuthState {}

class AuthSuccess extends AuthState {}

class AuthError extends AuthState {
  final String errorMessage;
  final Source source;

  AuthError({required this.errorMessage, required this.source});
}

enum Source { login, register }
