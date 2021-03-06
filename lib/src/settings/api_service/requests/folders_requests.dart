import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:notify/src/settings/api_service/config.dart';

class FoldersRequests {
  static Future<http.Response> Function() getAll({
    required final String token,
  }) {
    Future<http.Response> callback() async {
      return await http.get(
          Uri.parse(ApiServiceConfig.serverAddress +
              ApiServiceConfig.foldersControllerPrefix),
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
    required String token,
  }) {
    Future<http.Response> callback() async {
      return await http.post(
          Uri.parse(ApiServiceConfig.serverAddress +
              ApiServiceConfig.foldersControllerPrefix),
          body: jsonEncode({
            'title': title,
            'description': description,
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
              ApiServiceConfig.foldersControllerPrefix +
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
              ApiServiceConfig.foldersControllerPrefix +
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
    required final String token,
  }) {
    Future<http.Response> callback() async {
      return await http.put(
          Uri.parse(ApiServiceConfig.serverAddress +
              ApiServiceConfig.foldersControllerPrefix +
              '/$uuid'),
          body: jsonEncode({
            'title': title,
            'description': description,
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

  static Future<http.Response> Function() byIdNotifications({
    required final String uuid,
    required final String token,
  }) {
    Future<http.Response> callback() async {
      return await http.get(
          Uri.parse(ApiServiceConfig.serverAddress +
              ApiServiceConfig.foldersControllerPrefix +
              '/$uuid' +
              ApiServiceConfig.notifications),
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
              ApiServiceConfig.foldersControllerPrefix +
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
              ApiServiceConfig.foldersControllerPrefix +
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
              ApiServiceConfig.foldersControllerPrefix +
              '/$uuid' +
              ApiServiceConfig.exclude +
              '?excludeUserId=$excludeUserId'),
          headers: {
            'Content-Type': 'application/json',
            'accept': 'text/plain',
            'Authorization': 'Bearer $token',
          });
    }

    return callback;
  }

  static Future<http.Response> Function() addNotification({
    required final String folderId,
    required String token,
    required final List<String> ntfIds,
  }) {
    assert(ntfIds.isNotEmpty);
    Future<http.Response> callback() async {
      var path = ApiServiceConfig.serverAddress +
          ApiServiceConfig.foldersControllerPrefix +
          '/$folderId' +
          ApiServiceConfig.addNotification +
          '?notificationIds=';
      for (var i = 0; i < ntfIds.length; i++) {
        path += ntfIds[i];
        if (i != ntfIds.length - 1) {
          path += '&notificationIds=';
        }
      }
      return await http.post(Uri.parse(path), headers: {
        'Content-Type': 'application/json',
        'accept': 'text/plain',
        'Authorization': 'Bearer $token',
      });
    }

    return callback;
  }

  static Future<http.Response> Function() removeNotification({
    required final String folderId,
    required List<String> ntfIds,
    required final String token,
  }) {
    Future<http.Response> callback() async {
      var path = ApiServiceConfig.serverAddress +
          ApiServiceConfig.foldersControllerPrefix +
          '/$folderId' +
          ApiServiceConfig.removeNotification +
          '?notificationIds=';
      for (var i = 0; i < ntfIds.length; i++) {
        path += ntfIds[i];
        if (i != ntfIds.length - 1) {
          path += '&notificationIds=';
        }
      }
      return await http.post(Uri.parse(path), headers: {
        'Content-Type': 'application/json',
        'accept': 'text/plain',
        'Authorization': 'Bearer $token',
      });
    }

    return callback;
  }
}
