class GroupEvent {}

class CreateGroupEvent extends GroupEvent {
  final String name;
  final List<String> members;

  CreateGroupEvent({
    required this.name,
    required this.members,
  });
}

class GetGroupInfo extends GroupEvent {
  final String groupId;

  GetGroupInfo({required this.groupId});
}