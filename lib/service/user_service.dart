import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:idcardku/config.dart';

import 'package:idcardku/model/response_model.dart';
import 'package:idcardku/model/user_model.dart';

Future<User> findUser(String username) async {
  final rawResponse = await http
      .get(
        Uri.parse("${AppConfig.apiUrl}/user/$username"),
      )
      .timeout(
        const Duration(seconds: 5),
      );

  final Map parseResponse = json.decode(rawResponse.body);
  final response = APIResponse.fromJson(parseResponse);

  if (response.code == 200) {
    final user = User.fromJson(response.data);
    return user;
  } else {
    throw Exception("Failed to fetch user");
  }
}
