import 'package:http/http.dart' as http;
import 'package:notify/src/notify_api_client/config.dart';

class SearchResponses {
  static Future<http.Response> Function() fromUsers({
    required final String token,
  }) {
    Future<http.Response> callback() async {
      return await http.get(
          Uri.parse(ApiClientConfig.serverAddress +
              ApiClientConfig.searchControllerPrefix +
              ApiClientConfig.fromUsers),
          headers: {
            'Content-Type': 'application/json',
            'accept': 'text/plain',
            'Authorization': 'Bearer $token',
          });
    }

    return callback;
  }

  static Future<http.Response> Function() fromNotifications({
    required final String token,
  }) {
    Future<http.Response> callback() async {
      return await http.get(
          Uri.parse(ApiClientConfig.serverAddress +
              ApiClientConfig.searchControllerPrefix +
              ApiClientConfig.fromNotifications),
          headers: {
            'Content-Type': 'application/json',
            'accept': 'text/plain',
            'Authorization': 'Bearer $token',
          });
    }

    return callback;
  }

  static Future<http.Response> Function() fromFolders({
    required final String token,
  }) {
    Future<http.Response> callback() async {
      return await http.get(
          Uri.parse(ApiClientConfig.serverAddress +
              ApiClientConfig.searchControllerPrefix +
              ApiClientConfig.fromFolders),
          headers: {
            'Content-Type': 'application/json',
            'accept': 'text/plain',
            'Authorization': 'Bearer $token',
          });
    }

    return callback;
  }
}
