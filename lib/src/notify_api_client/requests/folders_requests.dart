import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:notify/src/notify_api_client/config.dart';

class FoldersRequests {
  static Future<http.Response> Function() getAll({
    required final String token,
  }) {
    Future<http.Response> callback() async {
      return await http.get(
          Uri.parse(ApiClientConfig.serverAddress +
              ApiClientConfig.foldersControllerPrefix),
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
          Uri.parse(ApiClientConfig.serverAddress +
              ApiClientConfig.foldersControllerPrefix),
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
          Uri.parse(ApiClientConfig.serverAddress +
              ApiClientConfig.foldersControllerPrefix +
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
          Uri.parse(ApiClientConfig.serverAddress +
              ApiClientConfig.foldersControllerPrefix +
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
          Uri.parse(ApiClientConfig.serverAddress +
              ApiClientConfig.foldersControllerPrefix +
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
          Uri.parse(ApiClientConfig.serverAddress +
              ApiClientConfig.foldersControllerPrefix +
              '/$uuid' +
              ApiClientConfig.notifications),
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
          Uri.parse(ApiClientConfig.serverAddress +
              ApiClientConfig.foldersControllerPrefix +
              '/$uuid' +
              ApiClientConfig.participants),
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
          Uri.parse(ApiClientConfig.serverAddress +
              ApiClientConfig.foldersControllerPrefix +
              '/$uuid' +
              ApiClientConfig.invite +
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
          Uri.parse(ApiClientConfig.serverAddress +
              ApiClientConfig.foldersControllerPrefix +
              '/$uuid' +
              ApiClientConfig.exclude +
              '?inviteUserId=$excludeUserId'),
          headers: {
            'Content-Type': 'application/json',
            'accept': 'text/plain',
            'Authorization': 'Bearer $token',
          });
    }

    return callback;
  }

  static Future<http.Response> Function() addNotification({
    required final String uuid,
    required final String folderId,
    required String token,
    final String? ntfId,
    final List<String>? listIds,
  }) {
    assert(ntfId == null && listIds == null);
    assert(ntfId != null && listIds != null);
    assert(listIds?.isEmpty ?? false);
    Future<http.Response> callback() async {
      var path = ApiClientConfig.serverAddress +
          ApiClientConfig.foldersControllerPrefix +
          '/$uuid' +
          ApiClientConfig.addNotification +
          '?folderId=$folderId';
      if (ntfId != null) {
        path += '&ntfId=$ntfId';
      } else {
        for (var item in listIds!) {
          path += '&listIds=$item';
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
    required final String uuid,
    required final String folderId,
    required String token,
    final String? ntfId,
    final List<String>? listIds,
  }) {
    assert(ntfId == null && listIds == null);
    assert(ntfId != null && listIds != null);
    assert(listIds?.isEmpty ?? false);
    Future<http.Response> callback() async {
      var path = ApiClientConfig.serverAddress +
          ApiClientConfig.foldersControllerPrefix +
          '/$uuid' +
          ApiClientConfig.removeNotification +
          '?folderId=$folderId';
      if (ntfId != null) {
        path += '&ntfId=$ntfId';
      } else {
        for (var item in listIds!) {
          path += '&listIds=$item';
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
