import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:synq/features/chat/domain/usecases/get_all_conversation_use_case.dart';
import 'package:synq/features/chat/presentation/bloc/chat/chat_event.dart';
import 'package:synq/features/chat/presentation/bloc/chat/chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final GetAllConversationUseCase useCase;
  ChatBloc({required this.useCase}) : super(ChatStateLoading()) {
    on<LoadAllChatEvent>(_onLoadAllChats);
  }

  Future<void> _onLoadAllChats(
    LoadAllChatEvent event,
    Emitter<ChatState> emit,
  ) async {
    var response = await useCase.call();

    response.when(
      success: (data) {
        emit(ChatStateLoaded(conversations: data));
      },
      failure: (error) {},
    );
  }
}
