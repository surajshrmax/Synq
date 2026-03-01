import 'package:synq/features/message/data/models/message_model.dart';

class MessageState {}

enum LoadedMessagesType { initial, old, newer, around }

class MessageInitial extends MessageState {}

class MessageLoading extends MessageState {}

class MessageLoaded extends MessageState {
  final LoadedMessagesType type;
  final List<MessageModel> messages;
  final bool hasMoreAfter;
  final bool hasMoreBefore;

  MessageLoaded({
    required this.type,
    required this.messages,
    required this.hasMoreAfter,
    required this.hasMoreBefore,
  });
}

class MessageRecieved extends MessageState {
  final MessageModel message;

  MessageRecieved({required this.message});
}

class MessageUpdated extends MessageState {
  final String id;
  final MessageModel message;

  MessageUpdated({required this.id, required this.message});
}

class MessageRemoved extends MessageState {
  final String id;

  MessageRemoved({required this.id});
}

class MessageSending extends MessageState {}

class MessageSent extends MessageState {
  final String id;

  MessageSent({required this.id});
}

class MessageError extends MessageState {
  final String error;

  MessageError({required this.error});
}
