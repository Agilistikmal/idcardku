import 'package:idcardku/model/user_model.dart';

class Post {
  String id;
  String title;
  String content;
  String authorUsername;
  User? author;
  String createdAt;
  String updatedAt;

  Post({
    required this.id,
    required this.title,
    required this.content,
    required this.authorUsername,
    this.author,
    required this.createdAt,
    required this.updatedAt,
  });

  Post.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        title = json["title"],
        content = json["content"],
        authorUsername = json["author_username"],
        author = User.fromJson(json["author"]),
        createdAt = json["created_at"],
        updatedAt = json["updated_at"];
}
