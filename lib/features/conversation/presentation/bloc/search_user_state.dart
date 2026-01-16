import 'package:synq/features/auth/domain/entities/user.dart';

abstract class SearchUserState {}

class SearchUserInitialState extends SearchUserState {}

class SearchUserFoundState extends SearchUserState {
  final Iterable<User> users;

  SearchUserFoundState({required this.users});
}

class SearchUserNotFoundState extends SearchUserState {}
