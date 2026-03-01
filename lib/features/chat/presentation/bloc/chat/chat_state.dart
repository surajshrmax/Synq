import 'package:synq/features/chat/data/models/chat_model.dart';

abstract class ChatState {}

class ChatStateLoading extends ChatState {}

class ChatStateLoaded extends ChatState {
  final List<ChatModel> conversations;

  ChatStateLoaded({required this.conversations});
}
