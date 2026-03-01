import 'package:synq/features/message/data/models/message_model.dart';

class MessageEvent {}

class LoadInitialMessages extends MessageEvent {
  final String chatId;
  final bool isChatId;

  LoadInitialMessages({required this.chatId, required this.isChatId});
}

class LoadOlderMessages extends MessageEvent {}

class LoadMessagesAroundMessage extends MessageEvent {
  final String messageId;
  final String sentAt;

  LoadMessagesAroundMessage({required this.messageId, required this.sentAt});
}

class LoadNewerMessages extends MessageEvent {}

class StartConnection extends MessageEvent {}

class SendMessage extends MessageEvent {
  final String id;
  final bool isChat;
  final String content;
  final String? replyToMessageId;

  SendMessage({
    required this.id,
    required this.isChat,
    required this.content,
    this.replyToMessageId,
  });
}

class UpdateMessage extends MessageEvent {
  final String id;
  final String content;

  UpdateMessage({required this.id, required this.content});
}

class DeleteMessage extends MessageEvent {
  final String id;

  DeleteMessage({required this.id});
}

class NewMessageRecieved extends MessageEvent {
  final MessageModel message;

  NewMessageRecieved({required this.message});
}

class MessageEditedEvent extends MessageEvent {
  final String id;
  final MessageModel message;

  MessageEditedEvent({required this.id, required this.message});
}

class MessageDeletedEvent extends MessageEvent {
  final String id;

  MessageDeletedEvent({required this.id});
}
