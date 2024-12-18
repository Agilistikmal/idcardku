import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:idcardku/config.dart';
import 'package:idcardku/model/post_model.dart';

import 'package:idcardku/model/response_model.dart';

Future<List<Post>> findPosts() async {
  final rawResponse = await http
      .get(
        Uri.parse("${AppConfig.apiUrl}/post"),
      )
      .timeout(
        const Duration(seconds: 5),
      );

  final Map parseResponse = json.decode(rawResponse.body);
  final response = APIResponses.fromJson(parseResponse);

  if (response.code == 200) {
    return response.data.map((e) => Post.fromJson(e)).toList();
  } else {
    throw Exception("Failed to fetch posts");
  }
}

Future<Post> findPost(String id) async {
  final rawResponse = await http
      .get(
        Uri.parse("${AppConfig.apiUrl}/post/$id"),
      )
      .timeout(
        const Duration(seconds: 5),
      );

  final Map parseResponse = json.decode(rawResponse.body);
  final response = APIResponse.fromJson(parseResponse);

  if (response.code == 200) {
    return Post.fromJson(response.data);
  } else {
    throw Exception("Failed to fetch post");
  }
}

Future<Post> createPost(
  String title,
  String content,
  String authorUsername,
) async {
  final rawResponse = await http
      .post(
        Uri.parse("${AppConfig.apiUrl}/post"),
        body: jsonEncode({
          "title": title,
          "content": content,
          "author_username": authorUsername
        }),
      )
      .timeout(
        const Duration(seconds: 5),
      );

  final Map parseResponse = json.decode(rawResponse.body);
  final response = APIResponse.fromJson(parseResponse);

  if (response.code == 200) {
    return response.data;
  } else {
    throw Exception("Failed to create post");
  }
}

Future<Post> updatePost(
  String id,
  String title,
  String content,
) async {
  final rawResponse = await http
      .patch(
        Uri.parse("${AppConfig.apiUrl}/post/$id"),
        body: jsonEncode({"title": title, "content": content}),
      )
      .timeout(
        const Duration(seconds: 5),
      );

  final Map parseResponse = json.decode(rawResponse.body);
  final response = APIResponse.fromJson(parseResponse);

  if (response.code == 200) {
    return response.data;
  } else {
    throw Exception("Failed to update post");
  }
}

Future<Post> deletePost(
  String id,
) async {
  final rawResponse = await http
      .delete(
        Uri.parse("${AppConfig.apiUrl}/post/$id"),
      )
      .timeout(
        const Duration(seconds: 5),
      );

  final Map parseResponse = json.decode(rawResponse.body);
  final response = APIResponse.fromJson(parseResponse);

  if (response.code == 200) {
    return response.data;
  } else {
    throw Exception("Failed to delete post");
  }
}
