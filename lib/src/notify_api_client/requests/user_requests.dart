import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:notify/src/notify_api_client/config.dart';

class UserResponses {
  static Future<http.Response> Function() post({
    required final String firstname,
    required final String lastname,
    required final Color color,
    String? status,
    required final String token,
  }) {
    if (status == null) {
      final DateTime dtn = DateTime.now();
      status = 'Hello! I have been using notify since '
          '${DateFormat.MMMM().format(dtn)} '
          '${dtn.day}, ${dtn.year}!';
    }
    Future<http.Response> callback() async {
      return await http.post(
          Uri.parse(ApiClientConfig.serverAddress +
              ApiClientConfig.userControllerPrefix),
          body: jsonEncode({
            'firstname': firstname,
            'lastname': lastname,
            'status': status,
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

  static Future<http.Response> Function() put({
    required final String firstname,
    required final String lastname,
    required final String status,
    required final Color color,
    required final String token,
  }) {
    Future<http.Response> callback() async {
      return await http.put(
          Uri.parse(ApiClientConfig.serverAddress +
              ApiClientConfig.userControllerPrefix),
          body: jsonEncode({
            'firstname': firstname,
            'lastname': lastname,
            'status': status,
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

  static Future<http.Response> Function() subscriptions({
    required final String token,
  }) {
    Future<http.Response> callback() {
      return http.get(
          Uri.parse(
            ApiClientConfig.serverAddress + ApiClientConfig.subscribtions,
          ),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          });
    }

    return callback;
  }

  static Future<http.Response> Function() subscribers({
    required final String token,
  }) {
    Future<http.Response> callback() {
      return http.get(
          Uri.parse(
            ApiClientConfig.serverAddress + ApiClientConfig.subscribers,
          ),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          });
    }

    return callback;
  }

  static Future<http.Response> Function() changeSubscription({
    required final String uuid,
    required final String token,
  }) {
    Future<http.Response> callback() async {
      return await http.post(
          Uri.parse(ApiClientConfig.serverAddress +
              ApiClientConfig.userControllerPrefix +
              ApiClientConfig.changeSubscription +
              '/$uuid'),
          encoding: Encoding.getByName('utf-8'),
          headers: {
            'Content-Type': 'application/json',
            'accept': 'text/plain',
            'Authorization': 'Bearer $token',
          });
    }

    return callback;
  }
}
