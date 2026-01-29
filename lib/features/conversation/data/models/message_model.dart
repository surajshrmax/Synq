class MessageModel {
  final String id;
  final String content;
  final String senderId;
  final DateTime sendAt;

  MessageModel({
    required this.id,
    required this.content,
    required this.senderId,
    required this.sendAt,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) => MessageModel(
    id: json["id"],
    content: json['content'],
    senderId: json['senderId'],
    sendAt: DateTime.parse(json['sentAt']),
  );
}
