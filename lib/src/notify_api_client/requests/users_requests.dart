import 'package:http/http.dart' as http;
import 'package:notify/src/notify_api_client/config.dart';

class UsersResponses {
  static Future<http.Response> Function() get({
    required final String uuid,
    required final String token,
  }) {
    Future<http.Response> callback() {
      return http.get(
          Uri.parse(ApiClientConfig.serverAddress +
              ApiClientConfig.usersControllerPrefix +
              '/$uuid'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          });
    }

    return callback;
  }

  static Future<http.Response> Function() subscribtions({
    required final String uuid,
    required final String token,
  }) {
    Future<http.Response> callback() {
      return http.get(
          Uri.parse(ApiClientConfig.serverAddress +
              ApiClientConfig.usersControllerPrefix +
              '/$uuid' +
              ApiClientConfig.subscribtions),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          });
    }

    return callback;
  }

  static Future<http.Response> Function() subscribers({
    required final String uuid,
    required final String token,
  }) {
    Future<http.Response> callback() {
      return http.get(
          Uri.parse(ApiClientConfig.serverAddress +
              ApiClientConfig.usersControllerPrefix +
              '/$uuid' +
              ApiClientConfig.subscribers),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          });
    }

    return callback;
  }
}
