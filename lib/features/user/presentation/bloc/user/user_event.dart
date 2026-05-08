abstract class UserEvent {}

class GetUserInfoEvent extends UserEvent {
  final String userId;

  GetUserInfoEvent({required this.userId});
}

class GetFriends extends UserEvent {
  final String? keyword;

  GetFriends({required this.keyword});
}
