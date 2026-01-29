abstract class UserEvent {}

class GetUserInfoEvent extends UserEvent {
  final String userId;

  GetUserInfoEvent({required this.userId});
}
