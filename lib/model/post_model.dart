class Post {
  String id;
  String title;
  String content;
  String authorUsername;
  String createdAt;
  String updatedAt;

  Post({
    required this.id,
    required this.title,
    required this.content,
    required this.authorUsername,
    required this.createdAt,
    required this.updatedAt,
  });

  Post.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        title = json["title"],
        content = json["content"],
        authorUsername = json["author_username"],
        createdAt = json["created_at"],
        updatedAt = json["updated_at"];
}
