import 'package:synq/features/conversation/data/models/message_model.dart';

abstract class MessageState {}

class MessageStateInitial extends MessageState {}

class MessageStateLoading extends MessageState {}

class MessageStateLoaded extends MessageState {
  final List<MessageModel> messages;

  MessageStateLoaded({required this.messages});
}

class MessageStateNewMessage extends MessageState {
  final MessageModel message;

  MessageStateNewMessage({required this.message});
}

class MessageStateRemoved extends MessageState {
  final MessageModel message;

  MessageStateRemoved({required this.message});
}
