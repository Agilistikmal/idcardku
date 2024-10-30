class User {
  String username;
  String fullName;
  String phone;
  bool? verified;
  String lockedAt;
  String createdAt;
  String updatedAt;

  User({
    required this.username,
    required this.fullName,
    required this.phone,
    this.verified,
    required this.lockedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  User.fromJson(Map<String, dynamic> json)
      : username = json["username"],
        fullName = json["full_name"],
        phone = json["phone"],
        verified = json["verified"],
        lockedAt = json["locked_at"],
        createdAt = json["created_at"],
        updatedAt = json["updated_at"];
}
