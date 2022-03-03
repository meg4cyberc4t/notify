import 'package:http/http.dart' as http;
import 'package:notify/src/settings/api_service/config.dart';

class UsersResponses {
  static Future<http.Response> Function() get({
    required final String uuid,
    required final String token,
  }) {
    Future<http.Response> callback() {
      return http.get(
          Uri.parse(ApiServiceConfig.serverAddress +
              ApiServiceConfig.usersControllerPrefix +
              '/$uuid'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          });
    }

    return callback;
  }

  static Future<http.Response> Function() subscriptions({
    required final String uuid,
    required final String token,
  }) {
    Future<http.Response> callback() {
      return http.get(
          Uri.parse(ApiServiceConfig.serverAddress +
              ApiServiceConfig.usersControllerPrefix +
              '/$uuid' +
              ApiServiceConfig.subscriptions),
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
          Uri.parse(ApiServiceConfig.serverAddress +
              ApiServiceConfig.usersControllerPrefix +
              '/$uuid' +
              ApiServiceConfig.subscribers),
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
    Future<http.Response> callback() {
      return http.post(
          Uri.parse(ApiServiceConfig.serverAddress +
              ApiServiceConfig.usersControllerPrefix +
              '/$uuid' +
              ApiServiceConfig.changeSubscription),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          });
    }

    return callback;
  }
}
