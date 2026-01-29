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
import 'package:synq/features/conversation/data/connections/message_connection.dart';
import 'package:synq/features/conversation/data/data_source/remote/conversation_api_service.dart';
import 'package:synq/features/conversation/data/data_source/remote/message_api_service.dart';
import 'package:synq/features/conversation/data/data_source/remote/user_api_service.dart';
import 'package:synq/features/conversation/data/repository/conversation_repository_impl.dart';
import 'package:synq/features/conversation/data/repository/message_repository_impl.dart';
import 'package:synq/features/conversation/data/repository/user_repository_impl.dart';
import 'package:synq/features/conversation/domain/repository/conversation_repository.dart';
import 'package:synq/features/conversation/domain/repository/message_repository.dart';
import 'package:synq/features/conversation/domain/repository/user_repository.dart';
import 'package:synq/features/conversation/domain/usecases/get_all_conversation_use_case.dart';
import 'package:synq/features/conversation/domain/usecases/get_all_messages_use_case.dart';
import 'package:synq/features/conversation/domain/usecases/get_user_info_use_case.dart';
import 'package:synq/features/conversation/domain/usecases/search_user_use_case.dart';
import 'package:synq/features/conversation/domain/usecases/send_message_use_case.dart';
import 'package:synq/features/conversation/presentation/bloc/conversation/conversation_bloc.dart';
import 'package:synq/features/conversation/presentation/bloc/message/message_bloc.dart';
import 'package:synq/features/conversation/presentation/bloc/search/search_user_bloc.dart';
import 'package:synq/features/conversation/presentation/bloc/user/user_bloc.dart';

final getIt = GetIt.instance;

void setUpDI() {
  // dependencies for auth
  getIt.registerLazySingleton<SecureStorage>(
    () => SecureStorage(FlutterSecureStorage()),
  );
  getIt.registerSingleton<ApiClient>(
    DioApiClient(dio: DioFactory.create("http://192.168.135.74:5213")),
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

  //dependencies for user
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

  getIt.registerLazySingleton<GetUserInfoUseCase>(
    () => GetUserInfoUseCase(userRepository: getIt<UserRepository>()),
  );

  getIt.registerFactory<UserBloc>(
    () => UserBloc(useCase: getIt<GetUserInfoUseCase>()),
  );

  //dependencies for conversation
  getIt.registerLazySingleton<ConversationApiService>(
    () => ConversationApiService(apiClient: getIt<ApiClient>()),
  );

  getIt.registerLazySingleton<ConversationRepository>(
    () =>
        ConversationRepositoryImpl(apiService: getIt<ConversationApiService>()),
  );

  getIt.registerLazySingleton<GetAllConversationUseCase>(
    () => GetAllConversationUseCase(
      conversationRepository: getIt<ConversationRepository>(),
    ),
  );

  getIt.registerFactory<ConversationBloc>(
    () => ConversationBloc(useCase: getIt<GetAllConversationUseCase>()),
  );

  //dependencies for message
  getIt.registerLazySingleton<MessageApiService>(
    () => MessageApiService(apiClient: getIt<ApiClient>()),
  );
  getIt.registerLazySingleton<MessageRepository>(
    () => MessageRepositoryImpl(apiService: getIt<MessageApiService>()),
  );
  getIt.registerLazySingleton<GetAllMessagesUseCase>(
    () => GetAllMessagesUseCase(messageRepository: getIt<MessageRepository>()),
  );
  getIt.registerLazySingleton<SendMessageUseCase>(
    () => SendMessageUseCase(repository: getIt<MessageRepository>()),
  );
  getIt.registerLazySingleton(() => MessageConnection());
  getIt.registerFactory<MessageBloc>(
    () => MessageBloc(
      getAllMessagesUseCase: getIt<GetAllMessagesUseCase>(),
      sendMessageUseCase: getIt<SendMessageUseCase>(),
      connection: MessageConnection()
    ),
  );
}
