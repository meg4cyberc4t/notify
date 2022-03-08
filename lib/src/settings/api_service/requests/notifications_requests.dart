import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:notify/src/models/repeat_mode.dart';
import 'package:notify/src/settings/api_service/config.dart';

class NotificationsResponses {
  static Future<http.Response> Function() getAll({
    required final String token,
  }) {
    Future<http.Response> callback() async {
      return await http.get(
          Uri.parse(ApiServiceConfig.serverAddress +
              ApiServiceConfig.notificationsControllerPrefix),
          headers: {
            'Content-Type': 'application/json',
            'accept': 'text/plain',
            'Authorization': 'Bearer $token',
          });
    }

    return callback;
  }

  static Future<http.Response> Function() post({
    required String title,
    required String description,
    required RepeatMode repeatMode,
    required DateTime deadline,
    required bool imporant,
    required final String token,
  }) {
    Future<http.Response> callback() async {
      return await http.post(
          Uri.parse(ApiServiceConfig.serverAddress +
              ApiServiceConfig.notificationsControllerPrefix),
          body: jsonEncode({
            'title': title,
            'description': description,
            'deadline': deadline.toIso8601String(),
            'important': imporant,
            'repeat_mode': repeatMode.index,
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

  static Future<http.Response> Function() getById({
    required final String uuid,
    required final String token,
  }) {
    Future<http.Response> callback() async {
      return await http.get(
          Uri.parse(ApiServiceConfig.serverAddress +
              ApiServiceConfig.notificationsControllerPrefix +
              '/$uuid'),
          headers: {
            'Content-Type': 'application/json',
            'accept': 'text/plain',
            'Authorization': 'Bearer $token',
          });
    }

    return callback;
  }

  static Future<http.Response> Function() delete({
    required final String uuid,
    required final String token,
  }) {
    Future<http.Response> callback() async {
      return await http.delete(
          Uri.parse(ApiServiceConfig.serverAddress +
              ApiServiceConfig.notificationsControllerPrefix +
              '/$uuid'),
          headers: {
            'Content-Type': 'application/json',
            'accept': 'text/plain',
            'Authorization': 'Bearer $token',
          });
    }

    return callback;
  }

  static Future<http.Response> Function() put({
    required String title,
    required String description,
    required String uuid,
    required RepeatMode repeatMode,
    required DateTime deadline,
    required bool imporant,
    required final String token,
  }) {
    Future<http.Response> callback() async {
      return await http.put(
          Uri.parse(ApiServiceConfig.serverAddress +
              ApiServiceConfig.notificationsControllerPrefix +
              '/$uuid'),
          body: jsonEncode({
            'title': title,
            'description': description,
            'deadline': deadline.toIso8601String(),
            'important': imporant,
            'repeat_mode': repeatMode.index,
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

  static Future<http.Response> Function() byIdParticipants({
    required final String uuid,
    required final String token,
  }) {
    Future<http.Response> callback() async {
      return await http.get(
          Uri.parse(ApiServiceConfig.serverAddress +
              ApiServiceConfig.notificationsControllerPrefix +
              '/$uuid' +
              ApiServiceConfig.participants),
          headers: {
            'Content-Type': 'application/json',
            'accept': 'text/plain',
            'Authorization': 'Bearer $token',
          });
    }

    return callback;
  }

  static Future<http.Response> Function() invite({
    required final String uuid,
    required final String inviteUserId,
    required final String token,
  }) {
    Future<http.Response> callback() async {
      return await http.post(
          Uri.parse(ApiServiceConfig.serverAddress +
              ApiServiceConfig.notificationsControllerPrefix +
              '/$uuid' +
              ApiServiceConfig.invite +
              '?inviteUserId=$inviteUserId'),
          headers: {
            'Content-Type': 'application/json',
            'accept': 'text/plain',
            'Authorization': 'Bearer $token',
          });
    }

    return callback;
  }

  static Future<http.Response> Function() exclude({
    required final String uuid,
    required final String excludeUserId,
    required final String token,
  }) {
    Future<http.Response> callback() async {
      return await http.post(
          Uri.parse(ApiServiceConfig.serverAddress +
              ApiServiceConfig.notificationsControllerPrefix +
              '/$uuid' +
              ApiServiceConfig.exclude +
              '?inviteUserId=$excludeUserId'),
          headers: {
            'Content-Type': 'application/json',
            'accept': 'text/plain',
            'Authorization': 'Bearer $token',
          });
    }

    return callback;
  }
}
