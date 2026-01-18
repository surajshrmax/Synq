import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:synq/core/network/api_client.dart';
import 'package:synq/core/network/dio_api_client.dart';
import 'package:synq/core/network/dio_factory.dart';
import 'package:synq/core/storage/secure_storage.dart';
import 'package:synq/features/auth/data/repository/auth_repository_impl.dart';
import 'package:synq/features/auth/domain/repository/auth_repository.dart';
import 'package:synq/features/auth/domain/usecase/login_use_case.dart';
import 'package:synq/features/auth/domain/usecase/register_use_case.dart';
import 'package:synq/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:synq/features/conversation/data/data_source/remote/user_api_service.dart';
import 'package:synq/features/conversation/data/repository/user_repository_impl.dart';
import 'package:synq/features/conversation/domain/repository/user_repository.dart';
import 'package:synq/features/conversation/domain/usecases/search_user_use_case.dart';
import 'package:synq/features/conversation/presentation/bloc/search/search_user_bloc.dart';

final getIt = GetIt.instance;

void setUpDI() {
  // dependencies for auth
  getIt.registerLazySingleton<SecureStorage>(
    () => SecureStorage(FlutterSecureStorage()),
  );
  getIt.registerSingleton<ApiClient>(
    DioApiClient(dio: DioFactory.create("http://192.168.238.74:5213")),
  );
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      client: getIt<ApiClient>(),
      secureStorage: getIt<SecureStorage>(),
    ),
  );
  getIt.registerLazySingleton<LoginUseCase>(
    () => LoginUseCase(authRepository: getIt<AuthRepository>()),
  );
  getIt.registerLazySingleton<RegisterUseCase>(
    () => RegisterUseCase(authRepository: getIt<AuthRepository>()),
  );
  getIt.registerFactory<AuthBloc>(
    () => AuthBloc(
      loginUseCase: getIt<LoginUseCase>(),
      registerUseCase: getIt<RegisterUseCase>(),
    ),
  );

  //dependencies for user service
  getIt.registerLazySingleton<UserApiService>(
    () => UserApiService(client: getIt<ApiClient>()),
  );

  getIt.registerLazySingleton<UserRepository>(
    () => UserRepositoryImpl(apiService: getIt<UserApiService>()),
  );

  getIt.registerLazySingleton<SearchUserUseCase>(
    () => SearchUserUseCase(repository: getIt<UserRepository>()),
  );

  getIt.registerFactory<SearchUserBloc>(
    () => SearchUserBloc(useCase: getIt<SearchUserUseCase>()),
  );
}
