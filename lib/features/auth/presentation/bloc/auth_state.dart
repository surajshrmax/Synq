abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthSuccess extends AuthState {}

class AuthError extends AuthState {
  final String errorMessage;
  final ErrorSource source;

  AuthError({required this.errorMessage, required this.source});
}

enum ErrorSource { login, register }
