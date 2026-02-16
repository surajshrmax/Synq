import 'package:synq/features/auth/data/models/user_profile.dart';

class UserModel {
  final String id;
  final String? userName;
  final String? email;
  final UserProfile? profile;

  const UserModel({
    required this.id,
    required this.userName,
    this.email,
    this.profile,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    id: json['id'],
    userName: json['username'],
    email: json['email'],
    profile: UserProfile.fromJson(json['userProfile']),
  );
}
