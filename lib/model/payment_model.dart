class Payment {
  String id;
  String referenceId;
  String username;
  String qrString;
  String status;
  int amount;
  String createdAt;
  String updatedAt;

  Payment({
    required this.id,
    required this.referenceId,
    required this.username,
    required this.qrString,
    required this.status,
    required this.amount,
    required this.createdAt,
    required this.updatedAt,
  });

  Payment.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        referenceId = json["reference_id"],
        username = json["username"],
        qrString = json["qr_string"],
        status = json["status"],
        amount = json["Amount"],
        createdAt = json["created_at"],
        updatedAt = json["updated_at"];
}
