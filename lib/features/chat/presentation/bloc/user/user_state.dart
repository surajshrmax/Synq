import 'package:synq/features/auth/data/models/user_model.dart';

abstract class UserState {}

class UserStateInitial extends UserState {}

class UserStateLoading extends UserState {}

class UserStateGetInfoLoading extends UserState {}

class UserStateInfoLoaded extends UserState {
  final UserModel user;

  UserStateInfoLoaded({required this.user});
}
