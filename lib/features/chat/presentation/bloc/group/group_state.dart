import 'package:synq/features/chat/data/models/group_model.dart';

class GroupState {}

class GroupInitialState extends GroupState {}
class GroupCreatingState extends GroupState {}
class GroupCreatedState extends GroupState {}

class GroupInfoLoadingState extends GroupState{}
class GroupInfoLoadedState extends GroupState{
  final GroupModel group;

  GroupInfoLoadedState({required this.group});
}

class GroupErrorState extends GroupState {
  final String error;

  GroupErrorState({required this.error});
}