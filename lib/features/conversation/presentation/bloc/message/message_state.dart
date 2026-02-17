import 'package:synq/features/conversation/data/models/message_model.dart';

abstract class MessageState {}

class MessageStateInitial extends MessageState {}

class MessageStateLoading extends MessageState {}

class MessageStateLoaded extends MessageState {
  final List<MessageModel> messages;
  final String cursor;

  MessageStateLoaded({required this.messages, required this.cursor});
}

class MessageStateMoreItemsLoaded extends MessageState {
  final List<MessageModel> messages;

  MessageStateMoreItemsLoaded({required this.messages});
}

class MessageStateNewMessage extends MessageState {
  final MessageModel message;

  MessageStateNewMessage({required this.message});
}

class MessageStateRemoved extends MessageState {
  final MessageModel message;

  MessageStateRemoved({required this.message});
}

class MessageStateUpdated extends MessageState {
  final int index;
  final MessageModel message;

  MessageStateUpdated({required this.index, required this.message});
}
