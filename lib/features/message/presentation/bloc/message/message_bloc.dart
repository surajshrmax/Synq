import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:synq/core/di/service_locator.dart';
import 'package:synq/core/storage/secure_storage.dart';
import 'package:synq/features/auth/data/models/user_model.dart';
import 'package:synq/features/auth/data/models/user_profile.dart';
import 'package:synq/features/message/data/connection/message_connection.dart';
import 'package:synq/features/message/data/models/message_model.dart';
import 'package:synq/features/message/domain/usecases/delete_message_use_case.dart';
import 'package:synq/features/message/domain/usecases/get_initial_messages_use_case.dart';
import 'package:synq/features/message/domain/usecases/get_messages_around_message_use_case.dart';
import 'package:synq/features/message/domain/usecases/get_newer_messages_use_case.dart';
import 'package:synq/features/message/domain/usecases/get_older_messages_use_case.dart';
import 'package:synq/features/message/domain/usecases/send_message_use_case.dart';
import 'package:synq/features/message/domain/usecases/update_message_status_use_case.dart';
import 'package:synq/features/message/domain/usecases/update_message_use_case.dart';
import 'package:synq/features/message/presentation/bloc/chat-session/chat_session_cubit.dart';
import 'package:synq/features/message/presentation/bloc/message/message_event.dart';
import 'package:synq/features/message/presentation/bloc/message/message_state.dart';

class MessageBloc extends Bloc<MessageEvent, MessageState> {
  final SendMessageUseCase sendMessageUseCase;
  final DeleteMessageUseCase deleteMessageUseCase;
  final UpdateMessageUseCase updateMessageUseCase;
  final UpdateMessageStatusUseCase updateMessageStatusUseCase;

  final GetInitialMessagesUseCase initialMessagesUseCase;
  final GetOlderMessagesUseCase olderMessagesUseCase;
  final GetMessagesAroundMessageUseCase messagesAroundMessageUseCase;
  final GetNewerMessagesUseCase newerMessagesUseCase;

  final MessageConnection messageConnection;
  final List<StreamSubscription> subs = [];

  final ChatSessionCubit chatSession;

  MessageBloc({
    required this.sendMessageUseCase,
    required this.deleteMessageUseCase,
    required this.updateMessageUseCase,
    required this.updateMessageStatusUseCase,
    required this.initialMessagesUseCase,
    required this.olderMessagesUseCase,
    required this.messagesAroundMessageUseCase,
    required this.newerMessagesUseCase,
    required this.messageConnection,
    required this.chatSession,
  }) : super(MessageInitial()) {
    _addAllListener();

    on<LoadInitialMessages>(_onLoadInitialMessageEvent);
    on<LoadOlderMessages>(_onLoadOlderMessagesEvent);
    on<LoadMessagesAroundMessage>(_onLoadMessagesAroundMessage);
    on<LoadNewerMessages>(_onLoadNewerMessages);

    on<SendMessage>(_onSendMessageEvent);
    on<UpdateMessage>(_onUpdateMessage);
    on<UpdateMessageStatus>(_onUpdateMessageStatus);
    on<DeleteMessage>(_onDeleteMessage);
    on<SentMessageUpdated>(_onSentMessageUpdatedEvent);

    on<NewMessageRecieved>(_onNewMessageEvent);
    on<MessageEditedEvent>(_onMessageEditedEvent);
    on<MessageDeletedEvent>(_onMessageDeletedEvent);
    on<StartConnection>(_onStartConnection);
    on<CloseConnection>(_onCloseConnection);
  }

  Future<void> _onLoadInitialMessageEvent(
    LoadInitialMessages event,
    Emitter<MessageState> emit,
  ) async {
    emit(MessageLoading());
    var response = await initialMessagesUseCase.call(
      GetInitialMessageParams(chatId: event.chatId, isChatId: event.isChatId),
    );

    response.when(
      success: (data) {
        chatSession.updateChatSession(
          chatId: data.chatId,
          hasMoreBefore: data.hasMoreBefore,
          beforeCursor: data.beforeCursor,
          messages: data.messages,
        );
        emit(
          MessageLoaded(
            type: LoadedMessagesType.initial,
            messages: data.messages,
            hasMoreBefore: data.hasMoreBefore,
            hasMoreAfter: data.hasMoreAfter,
          ),
        );

        
      },
      failure: (error) => emit(MessageError(error: error.message)),
    );
  }

  Future<void> _onLoadOlderMessagesEvent(
    LoadOlderMessages event,
    Emitter<MessageState> emit,
  ) async {
    if (!chatSession.state.hasMoreBefore) return;
    var response = await olderMessagesUseCase.call(
      GetOlderMessagesParams(
        chatId: chatSession.state.chatId!,
        cursor: chatSession.state.beforeCursor!,
      ),
    );

    response.when(
      success: (data) {
        chatSession.updateChatSession(
          beforeCursor: data.beforeCursor,
          hasMoreBefore: data.hasMoreBefore,
          messages: chatSession.state.messages..addAll(data.messages),
        );
        emit(
          MessageLoaded(
            type: LoadedMessagesType.old,
            messages: data.messages,
            hasMoreBefore: data.hasMoreBefore,
            hasMoreAfter: data.hasMoreAfter,
          ),
        );
      },
      failure: (error) => emit(MessageError(error: error.message)),
    );
  }

  Future<void> _onLoadMessagesAroundMessage(
    LoadMessagesAroundMessage event,
    Emitter<MessageState> emit,
  ) async {
    final response = await messagesAroundMessageUseCase.call(
      GetMessagesAroundMessageParams(
        chatId: chatSession.state.chatId!,
        messageId: event.messageId,
        sentAt: event.sentAt,
      ),
    );

    response.when(
      success: (data) {
        chatSession.updateChatSession(
          beforeCursor: data.beforeCursor,
          hasMoreBefore: data.hasMoreBefore,
          afterCursor: data.afterCursor,
          hasMoreAfter: data.hasMoreAfter,
          messages: chatSession.state.messages
            ..clear()
            ..addAll(data.messages),
        );
        emit(
          MessageLoaded(
            type: LoadedMessagesType.around,
            messages: data.messages,
            hasMoreBefore: data.hasMoreBefore,
            hasMoreAfter: data.hasMoreAfter,
          ),
        );
      },
      failure: (error) => emit(MessageError(error: error.message)),
    );
  }

  Future<void> _onLoadNewerMessages(
    LoadNewerMessages event,
    Emitter<MessageState> emit,
  ) async {
    if (chatSession.state.afterCursor == null) return;
    final response = await newerMessagesUseCase.call(
      GetNewerMessagesParams(
        chatId: chatSession.state.chatId!,
        cursor: chatSession.state.afterCursor!,
      ),
    );

    response.when(
      success: (data) {
        chatSession.updateChatSession(
          hasMoreAfter: data.hasMoreAfter,
          afterCursor: data.afterCursor,
          messages: chatSession.state.messages..addAll(data.messages),
        );
        emit(
          MessageLoaded(
            type: LoadedMessagesType.newer,
            messages: data.messages,
            hasMoreBefore: data.hasMoreBefore,
            hasMoreAfter: data.hasMoreAfter,
          ),
        );
      },
      failure: (error) => emit(MessageError(error: error.message)),
    );
  }

  Future<void> _onSendMessageEvent(
    SendMessage event,
    Emitter<MessageState> emit,
  ) async {
    final String localId = DateTime.now().millisecondsSinceEpoch.toString();
    chatSession.state.messages.add(
      MessageModel(
        serverId: "id",
        localId: localId,
        content: event.content,
        isEdited: false,
        replyMessageId: event.replyToMessageId,
        reply: event.replyToMessageId == null
            ? null
            : chatSession.state.messages
                  .where((m) => m.serverId == event.replyToMessageId)
                  .map(
                    (m) => ReplyMessage(
                      id: m.serverId,
                      content: m.content,
                      serverTime: m.serverTime!,
                      sentAt: m.sendAt!,
                    ),
                  )
                  .first,
        sender: UserModel(
          id: "id",
          userName: "",
          profile: UserProfile(
            name: "Exception",
            imageUrl: "",
            bio: "",
            lastSeen: DateTime.now(),
          ),
        ),
        senderId: "",
        serverTime: "",
        status: "sending",
        sendAt: DateTime.now(),
      ),
    );
    emit(MessageSending());
    emit(MessageRecieved(message: chatSession.state.messages.last));
    await sendMessageUseCase.call(
      SendMessageParams(
        id: event.id,
        isChat: event.isChat,
        localId: localId,
        content: event.content,
        replyToMessageId: event.replyToMessageId,
      ),
    );
  }

  Future<void> _onSentMessageUpdatedEvent(SentMessageUpdated event, Emitter<MessageState> emit) async{
    emit(SentMessageUpdates(message: event.message));
  }

  Future<void> _onNewMessageEvent(
    NewMessageRecieved event,
    Emitter<MessageState> emit,
  ) async {
    emit(MessageRecieved(message: event.message));
  }

  Future<void> _onUpdateMessage(
    UpdateMessage event,
    Emitter<MessageState> emit,
  ) async {
    await updateMessageUseCase.call(event.id, event.content);
  }

  Future<void> _onUpdateMessageStatus(UpdateMessageStatus event, Emitter<MessageState> emit) async{
    await updateMessageStatusUseCase.call(UpdateMessageStatusParams(messageId: event.messageId, status: event.status));
  }

  Future<void> _onMessageEditedEvent(
    MessageEditedEvent event,
    Emitter<MessageState> emit,
  ) async {
    emit(MessageUpdated(id: event.id, message: event.message));
  }

  Future<void> _onDeleteMessage(
    DeleteMessage event,
    Emitter<MessageState> emit,
  ) async {
    await deleteMessageUseCase.call(event.id);
  }

  Future<void> _onMessageDeletedEvent(
    MessageDeletedEvent event,
    Emitter<MessageState> emit,
  ) async {
    emit(MessageRemoved(id: event.id));
  }

  Future<void> _onStartConnection(
    StartConnection event,
    Emitter<MessageState> emit,
  ) async {
    final secureStorage = getIt<SecureStorage>();
    await messageConnection.buildConnection(secureStorage.getAccessToken());
    await messageConnection.startConnection();
  }

  Future<void> _onCloseConnection(
    CloseConnection event,
    Emitter<MessageState> emit,
  ) async {
    await messageConnection.closeConnection();
    chatSession.clear();
  }

  void _addAllListener() {
    subs.add(messageConnection.sentMessages.listen((event){
      add(SentMessageUpdated(message: event));
    }));

    subs.add(
      messageConnection.messages.listen((event) {
        add(NewMessageRecieved(message: event));
      }),
    );

    subs.add(
      messageConnection.updates.listen(
        (event) => add(MessageEditedEvent(id: event.serverId, message: event)),
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
