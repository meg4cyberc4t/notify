import 'package:http/http.dart' as http;
import 'package:notify/src/notify_api_client/config.dart';

class SearchResponses {
  static Future<http.Response> Function() fromUsers({
    required final String pattern,
    required final int? limit,
    required final int? offset,
    required final String token,
  }) {
    Future<http.Response> callback() async {
      String path = ApiClientConfig.serverAddress +
          ApiClientConfig.searchControllerPrefix +
          ApiClientConfig.fromUsers +
          '/?pattern=$pattern';
      if (limit != null) {
        path += '&limit=$limit';
      }
      if (offset != null) {
        path += '&offset=$offset';
      }
      return await http.get(Uri.parse(path), headers: {
        'Content-Type': 'application/json',
        'accept': 'text/plain',
        'Authorization': 'Bearer $token',
      });
    }

    return callback;
  }

  static Future<http.Response> Function() fromNotifications({
    required final String pattern,
    required final int? limit,
    required final int? offset,
    required final String token,
  }) {
    Future<http.Response> callback() async {
      String path = ApiClientConfig.serverAddress +
          ApiClientConfig.searchControllerPrefix +
          ApiClientConfig.fromNotifications +
          '/?pattern=$pattern';
      if (limit != null) {
        path += '&limit=$limit';
      }
      if (offset != null) {
        path += '&offset=$offset';
      }
      return await http.get(Uri.parse(path), headers: {
        'Content-Type': 'application/json',
        'accept': 'text/plain',
        'Authorization': 'Bearer $token',
      });
    }

    return callback;
  }

  static Future<http.Response> Function() fromFolders({
    required final String pattern,
    required final int? limit,
    required final int? offset,
    required final String token,
  }) {
    Future<http.Response> callback() async {
      String path = ApiClientConfig.serverAddress +
          ApiClientConfig.searchControllerPrefix +
          ApiClientConfig.fromFolders +
          '/?pattern=$pattern';
      if (limit != null) {
        path += '&limit=$limit';
      }
      if (offset != null) {
        path += '&offset=$offset';
      }
      return await http.get(Uri.parse(path), headers: {
        'Content-Type': 'application/json',
        'accept': 'text/plain',
        'Authorization': 'Bearer $token',
      });
    }

    return callback;
  }
}
