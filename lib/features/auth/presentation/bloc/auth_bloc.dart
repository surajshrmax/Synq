import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:synq/core/network/api_result.dart';
import 'package:synq/features/auth/domain/usecase/login_params.dart';
import 'package:synq/features/auth/domain/usecase/login_use_case.dart';
import 'package:synq/features/auth/domain/usecase/register_params.dart';
import 'package:synq/features/auth/domain/usecase/register_use_case.dart';
import 'package:synq/features/auth/presentation/bloc/auth_event.dart';
import 'package:synq/features/auth/presentation/bloc/auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUseCase loginUseCase;
  final RegisterUseCase registerUseCase;
  AuthBloc({required this.loginUseCase, required this.registerUseCase})
    : super(AuthInitial()) {
    on<LoginEvent>(_onLoginEvent);
    on<RegisterEvent>(_onRegisterEvent);
  }

  Future<void> _onLoginEvent(LoginEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    var response = await loginUseCase.call(
      LoginParams(email: event.email, password: event.password),
    );
    switch (response) {
      case ApiSuccess():
        emit(AuthSuccess());
        break;
      case ApiFailure():
        emit(
          AuthError(
            errorMessage: response.error.message,
            source: ErrorSource.login,
          ),
        );
        break;
    }
  }

  Future<void> _onRegisterEvent(
    RegisterEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    var response = await registerUseCase.call(
      RegisterParams(
        name: event.name,
        username: event.username,
        email: event.email,
        password: event.password,
      ),
    );

    response.when(
      success: (data) => emit(AuthSuccess()),
      failure: (error) => emit(
        AuthError(errorMessage: error.message, source: ErrorSource.register),
      ),
    );
  }
}
