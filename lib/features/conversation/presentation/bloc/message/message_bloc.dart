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

  final List<StreamSubscription> _subs = [];

  List<MessageModel> _messages = [];
  MessageBloc({
    required this.getAllMessagesUseCase,
    required this.sendMessageUseCase,
    required this.connection,
  }) : super(MessageStateInitial()) {
    _subs.add(connection.messages.listen((msg) => onNewMessage(msg)));
    _subs.add(connection.deletes.listen((id) => onMessageDeletes(id)));
    _subs.add(connection.updates.listen((msg) => onMessageUpdate(msg)));

    on<GetAllMessageEvent>(_onGetAllMessagesEvent);
    on<SendMessageEvent>(_sendMessageEvent);
    on<StartListeningMessageEvent>(_startMessageConnection);
    on<MessageRecievedEvent>(_onMessageRecieved);
    on<DeleteMessage>(_onDeleteMessage);
    on<MessageDeleteEvent>(_onMessageDeleteEvent);
    on<UpdateMessage>(_onUpdateMessage);
    on<MessageUpdateEvent>(_onMessageUpdateEvent);
  }

  Future<void> _onGetAllMessagesEvent(
    GetAllMessageEvent event,
    Emitter<MessageState> emit,
  ) async {
    print("LOADED MESSAGES");
    emit(MessageStateLoading());
    var response = await getAllMessagesUseCase.call(
      event.conversationId,
      event.isConversationId,
      "null",
    );

    response.when(
      success: (data) {
        _messages = data.messages;
        emit(MessageStateLoaded(messages: data.messages));
      },
      failure: (error) {},
    );
  }

  Future<void> _sendMessageEvent(
    SendMessageEvent event,
    Emitter<MessageState> emit,
  ) async {
    print("SENT MESSAGE TO CONNECTION");
    await connection.sendMessage(
      event.id,
      event.type,
      event.content,
      event.replyMessageId,
    );
  }

  Future<void> _onDeleteMessage(
    DeleteMessage event,
    Emitter<MessageState> state,
  ) async {
    print("DELETING MESSAGE ${event.id}");
    await connection.deleteMessage(event.id);
  }

  Future<void> _onMessageDeleteEvent(
    MessageDeleteEvent event,
    Emitter<MessageState> emit,
  ) async {
    print("INSIDE BLOC DELETING MESSAGE");
    final message = _messages.where((m) => m.id == event.id).firstOrNull;
    // emit(MessageStateLoaded(messages: _messages));
    emit(MessageStateRemoved(message: message!));
    _messages.removeWhere((m) => m.id == event.id);
  }

  Future<void> _onMessageRecieved(
    MessageRecievedEvent event,
    Emitter<MessageState> emit,
  ) async {
    print("INSIDE BLOC HITTING ON_MESSAGE_RECIEVED");
    emit(MessageStateNewMessage(message: event.message));
    _messages.add(event.message);
  }

  Future<void> _startMessageConnection(
    StartListeningMessageEvent event,
    Emitter<MessageState> emit,
  ) async {
    print("STARTING NEW SIGNAL_R CONNECTION");
    var token = getIt<SecureStorage>();
    print("Access token: ${token.getAccessToken().toString()}");
    await connection.buildConnection(token.getAccessToken());
    await connection.startConnection();
  }

  Future<void> _onUpdateMessage(
    UpdateMessage event,
    Emitter<MessageState> emit,
  ) async {
    await connection.updateMessage(event.id, event.content);
  }

  Future<void> _onMessageUpdateEvent(
    MessageUpdateEvent event,
    Emitter<MessageState> emit,
  ) async {
    var msg = _messages.where((m) => m.id == event.message.id).first;
    final index = _messages.indexOf(msg);
    _messages[index] = event.message;
    emit(MessageStateUpdated(index: index, message: event.message));
  }

  void onNewMessage(MessageModel message) =>
      add(MessageRecievedEvent(message: message));

  void onMessageDeletes(String id) => add(MessageDeleteEvent(id: id));

  void onMessageUpdate(MessageModel message) =>
      add(MessageUpdateEvent(message: message));

  @override
  Future<void> close() {
    print("CLOSING SUBSCRIPTION");
    for (final sub in _subs) {
      sub.cancel();
    }
    return super.close();
  }
}
