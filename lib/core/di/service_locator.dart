import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:synq/config/constants.dart';
import 'package:synq/core/network/api_client.dart';
import 'package:synq/core/network/dio_api_client.dart';
import 'package:synq/core/network/dio_factory.dart';
import 'package:synq/core/storage/secure_storage.dart';
import 'package:synq/features/auth/data/repository/auth_repository_impl.dart';
import 'package:synq/features/auth/domain/repository/auth_repository.dart';
import 'package:synq/features/auth/domain/usecase/login_use_case.dart';
import 'package:synq/features/auth/domain/usecase/register_use_case.dart';
import 'package:synq/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:synq/features/message/data/connection/message_connection.dart';
import 'package:synq/features/chat/data/data_source/remote/conversation_api_service.dart';
import 'package:synq/features/message/data/data_source/remote/message_api_service.dart';
import 'package:synq/features/chat/data/data_source/remote/user_api_service.dart';
import 'package:synq/features/chat/data/repository/conversation_repository_impl.dart';
import 'package:synq/features/message/data/repository/message_repository_impl.dart';
import 'package:synq/features/chat/data/repository/user_repository_impl.dart';
import 'package:synq/features/chat/domain/repository/conversation_repository.dart';
import 'package:synq/features/message/domain/repository/message_repository.dart';
import 'package:synq/features/chat/domain/repository/user_repository.dart';
import 'package:synq/features/message/domain/usecases/delete_message_use_case.dart';
import 'package:synq/features/chat/domain/usecases/get_all_conversation_use_case.dart';
import 'package:synq/features/message/domain/usecases/get_initial_messages_use_case.dart';
import 'package:synq/features/message/domain/usecases/get_messages_around_message_use_case.dart';
import 'package:synq/features/message/domain/usecases/get_newer_messages_use_case.dart';
import 'package:synq/features/message/domain/usecases/get_older_messages_use_case.dart';
import 'package:synq/features/chat/domain/usecases/get_user_info_use_case.dart';
import 'package:synq/features/chat/domain/usecases/search_user_use_case.dart';
import 'package:synq/features/message/domain/usecases/send_message_use_case.dart';
import 'package:synq/features/message/domain/usecases/update_message_use_case.dart';
import 'package:synq/features/message/domain/usecases/update_typing_status_use_case.dart';
import 'package:synq/features/chat/presentation/bloc/chat/chat_bloc.dart';
import 'package:synq/features/message/presentation/bloc/message/message_bloc.dart';
import 'package:synq/features/chat/presentation/bloc/search/search_user_bloc.dart';
import 'package:synq/features/message/presentation/bloc/typing/typing_cubit.dart';
import 'package:synq/features/chat/presentation/bloc/user/user_bloc.dart';

final getIt = GetIt.instance;

void setUpDI() {
  // dependencies for auth
  getIt.registerLazySingleton<SecureStorage>(
    () => SecureStorage(FlutterSecureStorage()),
  );
  getIt.registerSingleton<ApiClient>(
    DioApiClient(dio: DioFactory.create(serverUrl)),
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

  getIt.registerFactory<ChatBloc>(
    () => ChatBloc(useCase: getIt<GetAllConversationUseCase>()),
  );

  //dependencies for message
  getIt.registerLazySingleton<MessageApiService>(
    () => MessageApiService(apiClient: getIt<ApiClient>()),
  );
  getIt.registerLazySingleton<MessageRepository>(
    () => MessageRepositoryImpl(apiService: getIt<MessageApiService>()),
  );

  getIt.registerLazySingleton<MessageConnection>(() => MessageConnection());

  getIt.registerLazySingleton<SendMessageUseCase>(
    () => SendMessageUseCase(repository: getIt<MessageRepository>()),
  );

  getIt.registerLazySingleton<GetInitialMessagesUseCase>(
    () => GetInitialMessagesUseCase(
      messageRepository: getIt<MessageRepository>(),
    ),
  );

  getIt.registerLazySingleton<GetOlderMessagesUseCase>(
    () =>
        GetOlderMessagesUseCase(messageRepository: getIt<MessageRepository>()),
  );

  getIt.registerLazySingleton<GetMessagesAroundMessageUseCase>(
    () => GetMessagesAroundMessageUseCase(
      messageRepository: getIt<MessageRepository>(),
    ),
  );

  getIt.registerLazySingleton<GetNewerMessagesUseCase>(
    () =>
        GetNewerMessagesUseCase(messageRepository: getIt<MessageRepository>()),
  );

  getIt.registerLazySingleton<DeleteMessageUseCase>(
    () => DeleteMessageUseCase(messageRepository: getIt<MessageRepository>()),
  );

  getIt.registerLazySingleton<UpdateMessageUseCase>(
    () => UpdateMessageUseCase(messageRepository: getIt<MessageRepository>()),
  );

  getIt.registerFactory<MessageBloc>(
    () => MessageBloc(
      sendMessageUseCase: getIt<SendMessageUseCase>(),
      deleteMessageUseCase: getIt<DeleteMessageUseCase>(),
      updateMessageUseCase: getIt<UpdateMessageUseCase>(),
      initialMessagesUseCase: getIt<GetInitialMessagesUseCase>(),
      olderMessagesUseCase: getIt<GetOlderMessagesUseCase>(),
      messagesAroundMessageUseCase: getIt<GetMessagesAroundMessageUseCase>(),
      newerMessagesUseCase: getIt<GetNewerMessagesUseCase>(),
      messageConnection: getIt<MessageConnection>(),
    ),
  );

  getIt.registerLazySingleton<UpdateTypingStatusUseCase>(
    () => UpdateTypingStatusUseCase(
      messageRepository: getIt<MessageRepository>(),
    ),
  );
  getIt.registerFactory<TypingCubit>(
    () => TypingCubit(
      messageConnection: getIt<MessageConnection>(),
      updateTypingStatusUseCase: getIt<UpdateTypingStatusUseCase>(),
    ),
  );
}
