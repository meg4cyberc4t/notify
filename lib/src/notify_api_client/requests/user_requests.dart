import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter/widgets.dart';
import 'package:notify/src/notify_api_client/config.dart';

class UserResponses {
  // post
  static Future<http.Response> Function() post({
    required final String firstname,
    required final String lastname,
    required final Color color,
    required final String token,
  }) {
    ('Create!');
    Future<http.Response> callback() async {
      return await http.post(
          Uri.parse(ApiClientConfig.serverAddress +
              ApiClientConfig.userControllerPrefix),
          body: jsonEncode({
            'firstname': firstname,
            'lastname': lastname,
            'color': color.value,
          }),
          encoding: Encoding.getByName('utf-8'),
          headers: {
            'Content-Type': 'application/json',
            'accept': 'text/plain',
            'Authorization': 'Bearer $token',
          });
    }

    return callback;
  }

  static Future<http.Response> Function() get({
    required final String token,
  }) {
    Future<http.Response> callback() {
      return http.get(
          Uri.parse(ApiClientConfig.serverAddress +
              ApiClientConfig.userControllerPrefix),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          });
    }

    return callback;
  }
}
