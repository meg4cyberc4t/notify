import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:notify/src/settings/api_service/middleware/notify_api_client_exception.dart';

Future<http.Response> errorsHandlerMiddlware({
  required Future<http.Response> Function() callback,
}) async {
  http.Response res = await callback();
  if (res.statusCode >= 400) {
    debugPrint('res: ${res.toString()}');
    throw NotifyApiClientException(
      statusCode: res.statusCode,
      message: res.body,
    );
  }
  return res;
}
