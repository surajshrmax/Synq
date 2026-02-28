import 'package:synq/features/conversation/data/models/message_model.dart';
import 'package:synq/features/conversation/data/models/message_response.dart';

class MessageReWriteState {}

enum LoadedMessagesType { initial, old, newer, around }

class MessageInitial extends MessageReWriteState {}

class MessageLoading extends MessageReWriteState {}

class MessageLoaded extends MessageReWriteState {
  final LoadedMessagesType type;
  final List<MessageModel> messages;

  MessageLoaded({required this.type, required this.messages});
}

class MessageRecieved extends MessageReWriteState {
  final MessageModel message;

  MessageRecieved({required this.message});
}

class MessageUpdated extends MessageReWriteState {
  final String id;
  final MessageModel message;

  MessageUpdated({required this.id, required this.message});
}

class MessageRemoved extends MessageReWriteState {
  final String id;

  MessageRemoved({required this.id});
}

class MessageSending extends MessageReWriteState {}

class MessageSent extends MessageReWriteState {
  final String id;

  MessageSent({required this.id});
}

class MessageError extends MessageReWriteState {
  final String error;

  MessageError({required this.error});
}
