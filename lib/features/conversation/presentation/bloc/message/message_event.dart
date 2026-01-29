import 'package:synq/features/conversation/data/data_source/remote/message_api_service.dart';
import 'package:synq/features/conversation/data/models/message_model.dart';

abstract class MessageEvent {}

class GetAllMessageEvent extends MessageEvent {
  final String conversationId;

  GetAllMessageEvent({required this.conversationId});
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

class StartListeningMessageEvent extends MessageEvent {}
