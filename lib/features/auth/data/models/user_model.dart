class UserModel {
  final String id;
  final String name;
  final String userName;
  final String? email;
  final String imageUrl;
  final bool isVerified;

  const UserModel({
    required this.id,
    required this.name,
    required this.userName,
    this.email,
    required this.imageUrl,
    required this.isVerified,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    id: json['id'],
    userName: json['username'],
    name: json['name'],
    email: json['email'],
    imageUrl: json['imageUrl'],
    isVerified: json['isVerified'],
  );
}
