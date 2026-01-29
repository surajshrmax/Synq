import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:synq/core/di/service_locator.dart';
import 'package:synq/core/storage/secure_storage.dart';
import 'package:synq/features/conversation/data/connections/message_connection.dart';
import 'package:synq/features/conversation/data/models/message_model.dart';
import 'package:synq/features/conversation/domain/usecases/get_all_messages_use_case.dart';
import 'package:synq/features/conversation/domain/usecases/send_message_use_case.dart';
import 'package:synq/features/conversation/presentation/bloc/message/message_event.dart';
import 'package:synq/features/conversation/presentation/bloc/message/message_state.dart';

class MessageBloc extends Bloc<MessageEvent, MessageState> {
  final GetAllMessagesUseCase getAllMessagesUseCase;
  final SendMessageUseCase sendMessageUseCase;
  final MessageConnection connection;
  late final StreamSubscription<MessageModel> _subscription;
  List<MessageModel> _messages = [];
  MessageBloc({
    required this.getAllMessagesUseCase,
    required this.sendMessageUseCase,
    required this.connection,
  }) : super(MessageStateInitial()) {
    _subscription = connection.messages.listen((message) {
      add(MessageRecievedEvent(message: message));
    });

    on<GetAllMessageEvent>(_onGetAllMessagesEvent);
    on<SendMessageEvent>(_sendMessageEvent);
    on<StartListeningMessageEvent>(_startMessageConnection);
    on<MessageRecievedEvent>(_onMessageRecieved);
  }

  Future<void> _onGetAllMessagesEvent(
    GetAllMessageEvent event,
    Emitter<MessageState> emit,
  ) async {
    emit(MessageStateLoading());
    var response = await getAllMessagesUseCase.call(event.conversationId);

    response.when(
      success: (data) {
        _messages = data;
        emit(MessageStateLoaded(messages: data));
      },
      failure: (error) {},
    );
  }

  Future<void> _sendMessageEvent(
    SendMessageEvent event,
    Emitter<MessageState> emit,
  ) async {
    emit(MessageStateSending());

    await connection.sendMessage(event.id, event.type, event.content);
  }

  Future<void> _onMessageRecieved(
    MessageRecievedEvent event,
    Emitter<MessageState> emit,
  ) async {
    _messages.add(event.message);
    emit(MessageStateLoaded(messages: List.from(_messages)));
  }

  Future<void> _startMessageConnection(
    StartListeningMessageEvent event,
    Emitter<MessageState> emit,
  ) async {
    var token = getIt<SecureStorage>();
    print("Access token: ${token.getAccessToken().toString()}");
    await connection.buildConnection(token.getAccessToken());
    await connection.startConnection();
  }
}
