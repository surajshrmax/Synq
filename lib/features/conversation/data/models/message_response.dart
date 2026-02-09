import 'package:synq/features/conversation/data/models/message_model.dart';

class MessageResponse {
  final List<MessageModel> messages;
  final String cusror;

  MessageResponse({required this.messages, required this.cusror});

  factory MessageResponse.fromJson(Map<String, dynamic> json) =>
      MessageResponse(
        messages: (json['messages'] as List)
            .map((e) => MessageModel.fromJson(e))
            .toList(),
        cusror: json['lastCursorTime'],
      );
}
