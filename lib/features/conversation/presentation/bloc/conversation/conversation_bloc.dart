import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:synq/features/conversation/domain/usecases/get_all_conversation_use_case.dart';
import 'package:synq/features/conversation/presentation/bloc/conversation/conversation_event.dart';
import 'package:synq/features/conversation/presentation/bloc/conversation/conversation_state.dart';

class ConversationBloc extends Bloc<ConversationEvent, ConversationState> {
  final GetAllConversationUseCase useCase;
  ConversationBloc({required this.useCase})
    : super(ConversationStateLoading()) {
    on<LoadAllConversationEvent>(_onLoadAllConversation);
  }

  Future<void> _onLoadAllConversation(
    LoadAllConversationEvent event,
    Emitter<ConversationState> emit,
  ) async {
    var response = await useCase.call();

    response.when(
      success: (data) {
        emit(ConversationStateLoaded(conversations: data));
      },
      failure: (error) {},
    );
  }
}
