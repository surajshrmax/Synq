class TypingStatusModel {
  final String userId;
  final bool isTyping;

  TypingStatusModel({required this.userId, required this.isTyping});

  factory TypingStatusModel.fromJson(Map<String, dynamic> json) =>
      TypingStatusModel(userId: json["userId"], isTyping: json["isTyping"]);
}
