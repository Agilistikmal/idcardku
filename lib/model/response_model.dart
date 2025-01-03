class APIResponse {
  int code;
  String message;
  dynamic data;

  APIResponse({required this.code, required this.message, this.data});

  APIResponse.fromJson(Map<dynamic, dynamic> json)
      : code = json["code"] as int,
        message = json["message"] as String,
        data = json["data"];
}

class APIResponses {
  int code;
  String message;
  List data;

  APIResponses({required this.code, required this.message, required this.data});

  APIResponses.fromJson(Map<dynamic, dynamic> json)
      : code = json["code"] as int,
        message = json["message"] as String,
        data = json["data"];
}
