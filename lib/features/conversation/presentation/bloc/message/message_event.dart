import 'package:synq/features/conversation/data/data_source/remote/message_api_service.dart';
import 'package:synq/features/conversation/data/models/message_model.dart';

abstract class MessageEvent {}

class GetAllMessageEvent extends MessageEvent {
  final String conversationId;
  final bool isConversationId;

  GetAllMessageEvent({
    required this.conversationId,
    required this.isConversationId,
  });
}

class SendMessageEvent extends MessageEvent {
  final String id;
  final IdType type;
  final String content;

  SendMessageEvent({
    required this.id,
    required this.type,
    required this.content,
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

class StartListeningMessageEvent extends MessageEvent {}
