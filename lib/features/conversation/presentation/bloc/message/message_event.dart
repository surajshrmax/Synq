import 'package:synq/features/conversation/data/data_source/remote/message_api_service.dart';
import 'package:synq/features/conversation/data/models/message_model.dart';

abstract class MessageEvent {}

class GetAllMessageEvent extends MessageEvent {
  final String conversationId;
  final bool isConversationId;
  final String cursor;

  GetAllMessageEvent({
    required this.conversationId,
    required this.isConversationId,
    required this.cursor,
  });
}

class LoadMoreMessageEvent extends MessageEvent {
  final String conversationId;

  LoadMoreMessageEvent({required this.conversationId});
}

class SendMessageEvent extends MessageEvent {
  final String id;
  final IdType type;
  final String content;
  final String? replyMessageId;

  SendMessageEvent({
    required this.id,
    required this.type,
    required this.content,
    required this.replyMessageId,
  });
}

class MessageRecievedEvent extends MessageEvent {
  final MessageModel message;

  MessageRecievedEvent({required this.message});
}

class MessageDeleteEvent extends MessageEvent {
  final String id;

  MessageDeleteEvent({required this.id});
}

class DeleteMessage extends MessageEvent {
  final String id;

  DeleteMessage({required this.id});
}

class UpdateMessage extends MessageEvent {
  final String id;
  final String content;

  UpdateMessage({required this.id, required this.content});
}

class MessageUpdateEvent extends MessageEvent {
  final MessageModel message;

  MessageUpdateEvent({required this.message});
}

class StartListeningMessageEvent extends MessageEvent {}
