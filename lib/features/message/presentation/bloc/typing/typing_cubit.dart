import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:synq/features/message/data/connection/message_connection.dart';
import 'package:synq/features/message/domain/usecases/update_typing_status_use_case.dart';
import 'package:synq/features/message/presentation/bloc/typing/typing_cubit_state.dart';

class TypingCubit extends Cubit<TypingCubitState> {
  final MessageConnection messageConnection;
  final UpdateTypingStatusUseCase updateTypingStatusUseCase;
  late StreamSubscription typingStreamSub;

  TypingCubit({
    required this.messageConnection,
    required this.updateTypingStatusUseCase,
  }) : super(TypingCubitState()) {
    typingStreamSub = messageConnection.typings.listen((event) {
      updateTypingState(event.isTyping);
    });
  }

  void updateTypingState(bool isTyping) {
    emit(TypingCubitState(isTyping: isTyping));
  }

  void setTypingStatus(String chatId, bool isTyping) async {
    await updateTypingStatusUseCase.call(
      UpdateTypingStatusParams(chatId: chatId, isTyping: isTyping),
    );
  }
}
