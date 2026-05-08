import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:synq/features/message/data/models/message_model.dart';
import 'package:synq/features/message/presentation/bloc/chat-session/chat_session_state.dart';

class ChatSessionCubit extends Cubit<ChatSessionState> {
  ChatSessionCubit() : super(ChatSessionState(chatId: null, messages: []));

  void updateChatSession({
    String? chatId,
    bool? hasMoreBefore,
    bool? hasMoreAfter,
    String? beforeCursor,
    String? afterCursor,
    required List<MessageModel> messages
  }) {
    emit(
      state.copyWith(
        chatId: chatId,
        hasMoreBefore: hasMoreBefore,
        hasMoreAfter: hasMoreAfter,
        beforeCursor: beforeCursor,
        afterCursor: afterCursor,
        messages: messages
      ),
    );
  }

  void clear() {
    emit(ChatSessionState(chatId: null, messages: []));
  }
}
