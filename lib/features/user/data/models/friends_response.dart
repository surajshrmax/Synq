import 'package:synq/features/auth/data/models/user_model.dart';

class FriendsResponse {
  final String? cursor;
  final bool hasMoreAfter;
  final List<UserModel> friends;

  FriendsResponse({
    required this.cursor,
    required this.hasMoreAfter,
    required this.friends,
  });

  factory FriendsResponse.fromJson(Map<String, dynamic> json) =>
      FriendsResponse(
        cursor: json['cursor'],
        hasMoreAfter: json['hasMoreAfter'],
        friends: (json['friends'] as List)
            .map((e) => UserModel.fromJson(e))
            .toList(),
      );
}
