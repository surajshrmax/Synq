abstract class SearchUserEvent {}

class StartSearchUserEvent extends SearchUserEvent {
  final String name;

  StartSearchUserEvent({required this.name});
}

class ExecuteSearchEvent extends SearchUserEvent {
  final String name;

  ExecuteSearchEvent({required this.name});
}
