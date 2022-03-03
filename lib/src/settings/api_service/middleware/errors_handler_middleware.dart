import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:notify/src/settings/api_service/middleware/api_service_exception.dart';

Future<http.Response> errorsHandlerMiddlware({
  required Future<http.Response> Function() callback,
}) async {
  http.Response res = await callback();
  if (res.statusCode >= 400) {
    debugPrint('res: ${res.body.toString()} : ${res.statusCode.toString()}');
    throw ApiServiceException(
      statusCode: res.statusCode,
      message: res.body,
    );
  }
  return res;
}
