import 'package:synq/features/conversation/data/models/message_model.dart';

class MessageReWriteEvent {}

class LoadInitialMessages extends MessageReWriteEvent {
  final String chatId;
  final bool isChatId;

  LoadInitialMessages({required this.chatId, required this.isChatId});
}

class LoadOlderMessages extends MessageReWriteEvent {}

class LoadMessagesAroundMessage extends MessageReWriteEvent {
  final String messageId;
  final String sentAt;

  LoadMessagesAroundMessage({required this.messageId, required this.sentAt});
}

class LoadNewerMessages extends MessageReWriteEvent {}

class StartConnection extends MessageReWriteEvent {}

class SendMessage extends MessageReWriteEvent {
  final String content;
  final String? replyToMessageId;

  SendMessage({required this.content, this.replyToMessageId});
}

class UpdateMessage extends MessageReWriteEvent {
  final String id;
  final String content;

  UpdateMessage({required this.id, required this.content});
}

class DeleteMessage extends MessageReWriteEvent {
  final String id;

  DeleteMessage({required this.id});
}

class NewMessageRecieved extends MessageReWriteEvent {
  final MessageModel message;

  NewMessageRecieved({required this.message});
}

class MessageEditedEvent extends MessageReWriteEvent {
  final String id;
  final MessageModel message;

  MessageEditedEvent({required this.id, required this.message});
}

class MessageDeletedEvent extends MessageReWriteEvent {
  final String id;

  MessageDeletedEvent({required this.id});
}
