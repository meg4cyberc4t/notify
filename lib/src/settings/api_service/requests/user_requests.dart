import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter/widgets.dart';
import 'package:notify/src/settings/api_service/config.dart';

class UserResponses {
  static Future<http.Response> Function() post({
    required final String firstname,
    required final String lastname,
    required final Color color,
    required final String status,
    required final String token,
  }) {
    Future<http.Response> callback() async {
      return await http.post(
          Uri.parse(ApiServiceConfig.serverAddress +
              ApiServiceConfig.userControllerPrefix),
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
          Uri.parse(ApiServiceConfig.serverAddress +
              ApiServiceConfig.userControllerPrefix),
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
          Uri.parse(ApiServiceConfig.serverAddress +
              ApiServiceConfig.userControllerPrefix),
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
            ApiServiceConfig.serverAddress + ApiServiceConfig.subscriptions,
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
            ApiServiceConfig.serverAddress + ApiServiceConfig.subscribers,
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
          Uri.parse(ApiServiceConfig.serverAddress +
              ApiServiceConfig.userControllerPrefix +
              ApiServiceConfig.changeSubscription +
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
