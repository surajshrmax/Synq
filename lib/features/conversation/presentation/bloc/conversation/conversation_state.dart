import 'package:synq/features/conversation/data/models/conversation_model.dart';

abstract class ConversationState {}

class ConversationStateLoading extends ConversationState {}

class ConversationStateLoaded extends ConversationState {
  final List<ConversationModel> conversations;

  ConversationStateLoaded({required this.conversations});
}
