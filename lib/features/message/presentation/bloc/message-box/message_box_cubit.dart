import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:synq/features/message/presentation/bloc/message-box/message_box_cubit_state.dart';

class MessageBoxCubit extends Cubit<MessageBoxCubitState> {
  MessageBoxCubit()
    : super(MessageBoxCubitState(isEditing: false, content: "", messageId: ""));

  void startEditing(String messageId, String content) {
    emit(
      MessageBoxCubitState(
        isEditing: true,
        content: content,
        messageId: messageId,
      ),
    );
  }

  void clear() {
    emit(
      MessageBoxCubitState(
        messageId: "",
        isReplying: false,
        isEditing: false,
        content: "",
      ),
    );
  }

  void addReply(String messageId, String content) {
    emit(
      MessageBoxCubitState(
        isReplying: true,
        messageId: messageId,
        content: content,
      ),
    );
  }
}
