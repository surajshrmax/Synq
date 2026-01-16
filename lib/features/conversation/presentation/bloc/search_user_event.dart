abstract class SearchUserEvent {}

class StartSearchUserEvent extends SearchUserEvent {
  final String name;

  StartSearchUserEvent({required this.name});
}
