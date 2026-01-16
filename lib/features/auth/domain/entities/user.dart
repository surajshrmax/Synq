import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String id;
  final String name;
  final String userName;
  final String? email;
  final String imageUrl;
  final bool isVerified;

  const User({
    required this.id,
    required this.name,
    required this.userName,
    required this.email,
    required this.imageUrl,
    required this.isVerified,
  });

  @override
  List<Object?> get props => [id, name, userName, email, imageUrl, isVerified];
}
