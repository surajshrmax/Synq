class UserProfile {
  final String name;
  final String imageUrl;
  final String bio;
  final DateTime lastSeen;

  UserProfile({
    required this.name,
    required this.imageUrl,
    required this.bio,
    required this.lastSeen,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) => UserProfile(
    name: json['name'],
    imageUrl: json['imageUrl'],
    bio: json['bio'],
    lastSeen: DateTime.parse(json['lastSeenAt']),
  );
}
