import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:synq/core/di/service_locator.dart';
import 'package:synq/core/storage/secure_storage.dart';
import 'package:synq/features/conversation/data/connections/message_connection.dart';
import 'package:synq/features/conversation/domain/usecases/delete_message_use_case.dart';
import 'package:synq/features/conversation/domain/usecases/get_initial_messages_use_case.dart';
import 'package:synq/features/conversation/domain/usecases/get_messages_around_message_use_case.dart';
import 'package:synq/features/conversation/domain/usecases/get_newer_messages_use_case.dart';
import 'package:synq/features/conversation/domain/usecases/get_older_messages_use_case.dart';
import 'package:synq/features/conversation/domain/usecases/send_message_use_case.dart';
import 'package:synq/features/conversation/domain/usecases/update_message_use_case.dart';
import 'package:synq/features/conversation/presentation/bloc/message-re-write/message_re_write_event.dart';
import 'package:synq/features/conversation/presentation/bloc/message-re-write/message_re_write_state.dart';

class MessageReWriteBloc
    extends Bloc<MessageReWriteEvent, MessageReWriteState> {
  final SendMessageUseCase sendMessageUseCase;
  final DeleteMessageUseCase deleteMessageUseCase;
  final UpdateMessageUseCase updateMessageUseCase;

  final GetInitialMessagesUseCase initialMessagesUseCase;
  final GetOlderMessagesUseCase olderMessagesUseCase;
  final GetMessagesAroundMessageUseCase messagesAroundMessageUseCase;
  final GetNewerMessagesUseCase newerMessagesUseCase;

  final MessageConnection messageConnection;
  final List<StreamSubscription> subs = [];

  String chatId = "";
  String? beforeCursor;
  String? afterCursor;
  bool hasMoreBefore = false;
  bool hasMoreAfter = false;

  MessageReWriteBloc({
    required this.sendMessageUseCase,
    required this.deleteMessageUseCase,
    required this.updateMessageUseCase,
    required this.initialMessagesUseCase,
    required this.olderMessagesUseCase,
    required this.messagesAroundMessageUseCase,
    required this.newerMessagesUseCase,
    required this.messageConnection,
  }) : super(MessageInitial()) {
    _addAllListener();

    on<LoadInitialMessages>(_onLoadInitialMessageEvent);
    on<LoadOlderMessages>(_onLoadOlderMessagesEvent);
    on<LoadMessagesAroundMessage>(_onLoadMessagesAroundMessage);
    on<LoadNewerMessages>(_onLoadNewerMessages);

    on<SendMessage>(_onSendMessageEvent);
    on<UpdateMessage>(_onUpdateMessage);
    on<DeleteMessage>(_onDeleteMessage);

    on<NewMessageRecieved>(_onNewMessageEvent);
    on<MessageEditedEvent>(_onMessageEditedEvent);
    on<MessageDeletedEvent>(_onMessageDeletedEvent);
    on<StartConnection>(_onStartConnection);
  }

  Future<void> _onLoadInitialMessageEvent(
    LoadInitialMessages event,
    Emitter<MessageReWriteState> emit,
  ) async {
    emit(MessageLoading());
    var response = await initialMessagesUseCase.call(
      GetInitialMessageParams(chatId: event.chatId, isChatId: event.isChatId),
    );

    response.when(
      success: (data) {
        chatId = data.conversationId;
        beforeCursor = data.beforeCursor;
        hasMoreBefore = data.hasMoreBefore;
        hasMoreAfter = data.hasMoreAfter;
        emit(
          MessageLoaded(
            type: LoadedMessagesType.initial,
            messages: data.messages,
          ),
        );
      },
      failure: (error) => emit(MessageError(error: error.message)),
    );
  }

  Future<void> _onLoadOlderMessagesEvent(
    LoadOlderMessages event,
    Emitter<MessageReWriteState> emit,
  ) async {
    if (!hasMoreBefore) return;
    var response = await olderMessagesUseCase.call(
      GetOlderMessagesParams(chatId: chatId, cursor: beforeCursor!),
    );

    response.when(
      success: (data) {
        beforeCursor = data.beforeCursor;
        hasMoreBefore = data.hasMoreBefore;
        hasMoreAfter = data.hasMoreAfter;
        emit(
          MessageLoaded(type: LoadedMessagesType.old, messages: data.messages),
        );
      },
      failure: (error) => emit(MessageError(error: error.message)),
    );
  }

  Future<void> _onLoadMessagesAroundMessage(
    LoadMessagesAroundMessage event,
    Emitter<MessageReWriteState> emit,
  ) async {
    final response = await messagesAroundMessageUseCase.call(
      GetMessagesAroundMessageParams(
        chatId: chatId,
        messageId: event.messageId,
        sentAt: event.sentAt,
      ),
    );

    response.when(
      success: (data) {
        hasMoreAfter = data.hasMoreAfter;
        hasMoreBefore = data.hasMoreBefore;
        afterCursor = data.afterCursor;
        beforeCursor = data.beforeCursor;

        emit(
          MessageLoaded(
            type: LoadedMessagesType.around,
            messages: data.messages,
          ),
        );
      },
      failure: (error) => emit(MessageError(error: error.message)),
    );
  }

  Future<void> _onLoadNewerMessages(
    LoadNewerMessages event,
    Emitter<MessageReWriteState> emit,
  ) async {
    if (afterCursor == null) return;
    final response = await newerMessagesUseCase.call(
      GetNewerMessagesParams(chatId: chatId, cursor: afterCursor!),
    );

    response.when(
      success: (data) {
        hasMoreAfter = data.hasMoreAfter;
        afterCursor = data.afterCursor;
        emit(
          MessageLoaded(
            type: LoadedMessagesType.newer,
            messages: data.messages,
          ),
        );
      },
      failure: (error) => emit(MessageError(error: error.message)),
    );
  }

  Future<void> _onSendMessageEvent(
    SendMessage event,
    Emitter<MessageReWriteState> emit,
  ) async {
    emit(MessageSending());
    await sendMessageUseCase.call(
      SendMessageParams(
        id: event.id,
        isChat: event.isChat,
        content: event.content,
        replyToMessageId: event.replyToMessageId,
      ),
    );
  }

  Future<void> _onNewMessageEvent(
    NewMessageRecieved event,
    Emitter<MessageReWriteState> emit,
  ) async {
    emit(MessageRecieved(message: event.message));
  }

  Future<void> _onUpdateMessage(
    UpdateMessage event,
    Emitter<MessageReWriteState> emit,
  ) async {
    await updateMessageUseCase.call(event.id, event.content);
  }

  Future<void> _onMessageEditedEvent(
    MessageEditedEvent event,
    Emitter<MessageReWriteState> emit,
  ) async {
    emit(MessageUpdated(id: event.id, message: event.message));
  }

  Future<void> _onDeleteMessage(
    DeleteMessage event,
    Emitter<MessageReWriteState> emit,
  ) async {
    await deleteMessageUseCase.call(event.id);
  }

  Future<void> _onMessageDeletedEvent(
    MessageDeletedEvent event,
    Emitter<MessageReWriteState> emit,
  ) async {
    emit(MessageRemoved(id: event.id));
  }

  Future<void> _onStartConnection(
    StartConnection event,
    Emitter<MessageReWriteState> emit,
  ) async {
    final secureStorage = getIt<SecureStorage>();
    await messageConnection.buildConnection(secureStorage.getAccessToken());
    await messageConnection.startConnection();
  }

  void _addAllListener() {
    subs.add(
      messageConnection.messages.listen((event) {
        add(NewMessageRecieved(message: event));
      }),
    );

    subs.add(
      messageConnection.updates.listen(
        (event) => add(MessageEditedEvent(id: event.id, message: event)),
      ),
    );

    subs.add(
      messageConnection.deletes.listen(
        (event) => add(MessageDeletedEvent(id: event)),
      ),
    );
  }

  @override
  Future<void> close() {
    for (final sub in subs) {
      sub.cancel();
    }
    return super.close();
  }
}
