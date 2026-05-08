class GroupModel {
  final String id;
  final String title;
  final String imageUrl;
  final int memeberCount;

  GroupModel({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.memeberCount,
  });

  factory GroupModel.fromJson(Map<String, dynamic> json) => GroupModel(
    id: json['id'],
    title: json['title'],
    imageUrl: json['imageUrl'],
    memeberCount: json['membersCount'],
  );
}
